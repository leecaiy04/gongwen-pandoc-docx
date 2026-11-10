#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if command -v python3 >/dev/null 2>&1; then
  exec python3 "$script_dir/markdown-to-gongwen-docx.py" "$@"
fi
if command -v python >/dev/null 2>&1; then
  exec python "$script_dir/markdown-to-gongwen-docx.py" "$@"
fi
if command -v node >/dev/null 2>&1; then
  exec node "$script_dir/markdown-to-gongwen-docx.mjs" "$@"
fi

echo "需要 Python 3 或 Node.js 运行转换器，并且需要安装 Pandoc。" >&2
exit 127
