#!/usr/bin/env bash
set -euo pipefail

proxy=""

usage() {
  cat <<'EOF'
Usage: scripts/github-login.sh [--proxy http://host:port]

Installs GitHub CLI into ~/.local/share/gongwen-pandoc-docx/bin when needed,
then starts GitHub's browser/device authentication and configures Git HTTPS.
EOF
}

while (($#)); do
  case "$1" in
    --proxy) shift; proxy="${1:?missing proxy URL}" ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ -n "$proxy" ]]; then
  export HTTPS_PROXY="$proxy"
  export HTTP_PROXY="$proxy"
fi

gh_bin="$(command -v gh || true)"
if [[ -z "$gh_bin" ]]; then
  case "$(uname -s):$(uname -m)" in
    Linux:x86_64) gh_arch="amd64" ;;
    Linux:aarch64|Linux:arm64) gh_arch="arm64" ;;
    *) printf 'Unsupported platform: %s %s\n' "$(uname -s)" "$(uname -m)" >&2; exit 1 ;;
  esac

  command -v curl >/dev/null 2>&1 || { echo 'curl is required to install GitHub CLI.' >&2; exit 127; }
  command -v python3 >/dev/null 2>&1 || { echo 'Python 3 is required to select the GitHub CLI download.' >&2; exit 127; }
  command -v tar >/dev/null 2>&1 || { echo 'tar is required to install GitHub CLI.' >&2; exit 127; }

  release_json="$(curl --fail --silent --show-error --location https://api.github.com/repos/cli/cli/releases/latest)"
  asset_url="$(python3 -c '
import json, sys
arch = sys.argv[1]
release = json.load(sys.stdin)
suffix = f"_linux_{arch}.tar.gz"
for asset in release.get("assets", []):
    if asset.get("name", "").endswith(suffix):
        print(asset["browser_download_url"])
        break
else:
    raise SystemExit(f"No Linux {arch} GitHub CLI asset found")
' "$gh_arch" <<<"$release_json")"

  install_dir="${XDG_DATA_HOME:-$HOME/.local/share}/gongwen-pandoc-docx/bin"
  temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/gh-cli.XXXXXX")"
  trap 'rm -rf "$temp_dir"' EXIT
  curl --fail --silent --show-error --location "$asset_url" --output "$temp_dir/gh.tar.gz"
  tar -xzf "$temp_dir/gh.tar.gz" -C "$temp_dir"
  downloaded_gh="$(find "$temp_dir" -type f -path '*/bin/gh' -print -quit)"
  test -n "$downloaded_gh"
  mkdir -p "$install_dir"
  install -m 0755 "$downloaded_gh" "$install_dir/gh"
  gh_bin="$install_dir/gh"
  printf 'Installed GitHub CLI: %s\n' "$gh_bin"
fi

"$gh_bin" auth login --hostname github.com --git-protocol https --web
"$gh_bin" auth setup-git
"$gh_bin" auth status
