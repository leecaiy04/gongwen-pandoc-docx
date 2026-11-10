#!/usr/bin/env bash
set -euo pipefail

skill_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
skill_name="gongwen-pandoc-docx"
target=""
force=false
link=false

usage() {
  cat <<'EOF'
Usage: scripts/install.sh --target codex|workbuddy [--force] [--link]

Copies this skill into the target application's user skill directory.
--link creates a symbolic link instead, which is useful for local development.
--force replaces an existing skill with the same name.
EOF
}

while (($#)); do
  case "$1" in
    --target) shift; target="${1:?missing target name}" ;;
    --force) force=true ;;
    --link) link=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

case "$target" in
  codex) target_root="${CODEX_HOME:-$HOME/.codex}/skills" ;;
  workbuddy) target_root="$HOME/.workbuddy/skills" ;;
  *) usage >&2; exit 2 ;;
esac

destination="$target_root/$skill_name"
mkdir -p "$target_root"
if [[ -e "$destination" || -L "$destination" ]]; then
  if [[ "$force" != true ]]; then
    printf 'Already exists: %s. Review it, then rerun with --force if replacement is intended.\n' "$destination" >&2
    exit 3
  fi
  rm -rf "$destination"
fi

if [[ "$link" == true ]]; then
  ln -s "$skill_dir" "$destination"
else
  mkdir -p "$destination"
  cp "$skill_dir/SKILL.md" "$destination/"
  cp -R "$skill_dir/assets" "$skill_dir/scripts" "$destination/"
  find "$destination/scripts" -type d -name __pycache__ -prune -exec rm -rf {} +
  find "$destination/scripts" -type f -name '*.pyc' -delete
fi

test -f "$destination/SKILL.md"
printf 'Installed: %s -> %s\n' "$target" "$destination"
