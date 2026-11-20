#!/usr/bin/env bash
set -e

PYTHON_BIN="${PYTHON_BIN:-python3}"

echo "Initializing zero-token Graphify graph for: $(basename "$PWD")"
[ ! -d .git ] && git init
graphify antigravity install
graphify hook install

"$PYTHON_BIN" - << 'PYEOF'
from pathlib import Path
from graphify.detect import detect
from graphify.extract import extract, collect_files
from graphify.build import build_from_json
from graphify.cluster import cluster, score_all
from graphify.analyze import god_nodes, surprising_connections, suggest_questions
from graphify.report import generate
from graphify.export import to_json

out = Path("graphify-out")
out.mkdir(exist_ok=True)
det = detect(Path("."))
code_files = [p for f in det.get("files", {}).get("code", []) for p in collect_files(Path(f))]

if code_files:
    G = build_from_json(extract(code_files))
    comm = cluster(G)
    labels = {cid: f"Community {cid}" for cid in comm}
    rep = generate(
        G,
        comm,
        score_all(G, comm),
        labels,
        god_nodes(G),
        surprising_connections(G, comm),
        det,
        {"input": 0, "output": 0},
        ".",
        suggested_questions=suggest_questions(G, comm, labels),
    )
    (out / "GRAPH_REPORT.md").write_text(rep, encoding="utf-8")
    to_json(G, comm, str(out / "graph.json"))
    print(f"Graph ready in graphify-out/ ({G.number_of_nodes()} nodes, {G.number_of_edges()} edges)")
else:
    print("No code files found in this directory.")
PYEOF
