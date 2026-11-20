#!/usr/bin/env python3
import os
import sys

try:
    import pymupdf4llm
except ImportError:
    print("Error: missing dependency. Run: pip install pymupdf4llm")
    sys.exit(1)


def main():
    if len(sys.argv) < 3:
        print("Usage: python3 pdf2md.py <input.pdf> <output.md>")
        sys.exit(1)

    source_path = os.path.abspath(sys.argv[1])
    dest_path = os.path.abspath(sys.argv[2])

    if not os.path.exists(source_path):
        print(f"Error: file not found: {source_path}")
        sys.exit(1)

    print(f"Converting {source_path}...")
    try:
        md_text = pymupdf4llm.to_markdown(source_path)
        with open(dest_path, "w", encoding="utf-8") as f:
            f.write(md_text)
        print(f"Done. Markdown saved to: {dest_path}")
    except Exception as e:
        print(f"Conversion failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
