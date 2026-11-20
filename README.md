# llm-workflow-utils

A collection of lightweight, zero-token CLI utilities for AI coding agent workflows (Antigravity, Claude Code, Cursor, etc.).

## Included Tools

### 1. Zero-Token Graphify Automation (`graphify/`)
- **`graphify-init.sh`**: Initializes a repository (git, Antigravity integration, git hooks) and builds the initial `graphify-out/graph.json` and `GRAPH_REPORT.md` locally without spending LLM tokens.
- **`graphify-sync.sh`**: Runs `graphify update .` and automatically indexes/links all project Markdown files and their headings (`#`–`###`) into `graph.json` at **0 token cost** (with automatic link deduplication).

> **Tip:** Override the Python binary if needed (e.g., inside a virtualenv or specific framework path):
> ```bash
> PYTHON_BIN=/path/to/python3 ./graphify/graphify-sync.sh
> ```

### 2. PDF to Markdown Converter (`pdf-to-md/`)
- **`pdf2md.py`**: Converts PDF documents of any size into clean, LLM-ready Markdown (preserving headings, tables, and structure) using `pymupdf4llm`—ideal for feeding docs into Graphify or agent context windows.

Install dependency:
```bash
pip install -r pdf-to-md/requirements.txt
```

Usage: 
```bash
python3 pdf-to-md/pdf2md.py input.pdf output.md
```

## Installation

```bash
git clone https://github.com/AdvisingDesert/llm-workflow-utils.git
cd llm-workflow-utils
```

## Recommended Shell Aliases
Add these aliases to your `~/.zshrc` (macOS) or `~/.bashrc` (Linux) to run the tools from any project directory:

```bash
alias graphify-init="/path/to/llm-workflow-utils/graphify/graphify-init.sh"
alias graphify-sync="/path/to/llm-workflow-utils/graphify/graphify-sync.sh"
alias pdf2md="python3 /path/to/llm-workflow-utils/pdf-to-md/pdf2md.py"
```

Reload your shell:

```bash
source ~/.zshrc   # or ~/.bashrc
```

## License

MIT