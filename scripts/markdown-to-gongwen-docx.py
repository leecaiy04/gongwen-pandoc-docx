#!/usr/bin/env python3
"""Convert Markdown to DOCX using this skill's approved Word template."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description="将 Markdown 转换为公文 Word 文档")
    parser.add_argument("input", type=Path, help="输入 Markdown 文件")
    parser.add_argument("output", type=Path, help="输出 DOCX 文件")
    args = parser.parse_args()

    if not args.input.is_file():
        parser.error(f"输入文件不存在：{args.input}")
    pandoc = shutil.which("pandoc")
    if pandoc is None:
        parser.error("未找到 Pandoc。请先安装 Pandoc 并确保 pandoc 在 PATH 中。")

    skill_dir = Path(__file__).resolve().parents[1]
    command = [
        pandoc,
        str(args.input),
        "--from=markdown",
        "--to=docx",
        f"--reference-doc={skill_dir / 'assets' / 'gongwen-reference.docx'}",
        f"--lua-filter={skill_dir / 'scripts' / 'pandoc-gongwen.lua'}",
        f"--output={args.output}",
    ]
    return subprocess.run(command, check=False).returncode


if __name__ == "__main__":
    sys.exit(main())
