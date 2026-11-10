#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
output="${1:-$skill_dir/dist/workbuddy-gongwen-pandoc-docx.zip}"
stage="$(mktemp -d "${TMPDIR:-/tmp}/gongwen-pandoc.XXXXXX")"
trap 'rm -rf "$stage"' EXIT

mkdir -p "$(dirname -- "$output")"
rm -f "$output"
cp "$skill_dir/SKILL.md" "$stage/"
cp -R "$skill_dir/assets" "$skill_dir/scripts" "$stage/"
find "$stage/scripts" -type d -name __pycache__ -prune -exec rm -rf {} +
find "$stage/scripts" -type f -name '*.pyc' -delete
(cd "$stage" && zip -qr "$output" SKILL.md assets scripts)
unzip -t "$output" >/dev/null
printf 'Created WorkBuddy package: %s\n' "$output"
