#!/usr/bin/env bash
set -e

PYTHON_BIN="${PYTHON_BIN:-python3}"

echo "Syncing code graph..."
graphify update .

echo "Linking Markdown files (0 tokens)..."
"$PYTHON_BIN" - << 'PYEOF'
import json
import re
import sys
from pathlib import Path

gp = Path("graphify-out/graph.json")
if not gp.exists():
    print("Error: graphify-out/graph.json not found. Run graphify-init.sh first.")
    sys.exit(1)

data = json.loads(gp.read_text(encoding="utf-8"))
nodes = data.get("nodes", [])
links_key = "links" if "links" in data else "edges"
links = data.get(links_key, [])

existing_ids = {n["id"] for n in nodes}
existing_links = {(l["source"], l["target"], l.get("relation")) for l in links}
targets = {n.get("label", "").lower(): n["id"] for n in nodes if len(n.get("label", "")) > 3}
ignore_dirs = {"node_modules", ".git", ".venv", "venv", "dist", "build", "graphify-out", ".next"}

def add_link(src, dst, rel):
    key = (src, dst, rel)
    if key not in existing_links:
        links.append({"source": src, "target": dst, "relation": rel})
        existing_links.add(key)

for md in [p for p in Path(".").rglob("*.md") if not any(k in ignore_dirs for k in p.parts)]:
    did = f"doc: {md}"
    txt = md.read_text(encoding="utf-8", errors="ignore")
    if did not in existing_ids:
        nodes.append({
            "id": did,
            "label": md.name,
            "type": "documentation",
            "source_file": str(md),
            "community": 999,
        })
        existing_ids.add(did)

    for _, title in re.findall(r"^(#{1,3})\s+(.+)$", txt, flags=re.M)[:30]:
        clean_title = title.strip()
        sid = f"doc_sec:{md}:{clean_title[:40]}"
        if sid not in existing_ids:
            nodes.append({
                "id": sid,
                "label": f"{md.stem}: {clean_title}",
                "type": "doc_section",
                "source_file": str(md),
                "community": 999,
            })
            existing_ids.add(sid)
        add_link(did, sid, "contains_section")

    txt_lower = txt.lower()
    for t_name, t_id in targets.items():
        if t_name in txt_lower and t_id != did:
            add_link(did, t_id, "documents_or_references")

data["nodes"] = nodes
data[links_key] = links
gp.write_text(json.dumps(data, indent=2), encoding="utf-8")
print("Markdown files linked into graph.json at 0 token cost.")
PYEOF

echo "Global sync complete."
