#!/usr/bin/env bash
#
# INSTALL.sh - Symlink this repo's config files into the target editor's
# user config directory, and (optionally) install the extension list.
#
# Usage:
#   ./INSTALL.sh [--os linux|windows] [--platform vscode|vscodium|antigravity] [--skip-extensions]
#
# Defaults: --os linux --platform vscode
#
set -euo pipefail

OS="linux"
PLATFORM="vscode"
SKIP_EXTENSIONS=false

usage() {
  cat <<EOF
Usage: $0 [--os linux|windows] [--platform vscode|vscodium|antigravity] [--skip-extensions]

Options:
  --os OS              Target OS: linux (default) or windows
  --platform PLATFORM  Target editor: vscode (default), vscodium, or antigravity
  --skip-extensions     Do not install extensions from vscode-extensions.list
  -h, --help            Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --os)
      OS="$2"
      shift 2
      ;;
    --os=*)
      OS="${1#*=}"
      shift
      ;;
    --platform)
      PLATFORM="$2"
      shift 2
      ;;
    --platform=*)
      PLATFORM="${1#*=}"
      shift
      ;;
    --skip-extensions)
      SKIP_EXTENSIONS=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

case "$OS" in
  linux|windows) ;;
  *)
    echo "Error: --os must be 'linux' or 'windows' (got '$OS')" >&2
    exit 1
    ;;
esac

case "$PLATFORM" in
  vscode)
    APP_DIR_NAME="Code"
    BIN_NAME="code"
    ;;
  vscodium)
    APP_DIR_NAME="VSCodium"
    BIN_NAME="codium"
    ;;
  antigravity)
    APP_DIR_NAME="Antigravity"
    BIN_NAME="antigravity"
    ;;
  *)
    echo "Error: --platform must be one of 'vscode', 'vscodium', 'antigravity' (got '$PLATFORM')" >&2
    exit 1
    ;;
esac

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve the target User config directory for the given OS/platform.
resolve_config_dir() {
  if [[ "$OS" == "linux" ]]; then
    echo "$HOME/.config/$APP_DIR_NAME/User"
  else
    # Windows: config lives under %APPDATA%\<App>\User.
    local appdata=""
    if [[ -n "${APPDATA:-}" ]]; then
      if command -v cygpath >/dev/null 2>&1; then
        appdata="$(cygpath -u "$APPDATA")"
      else
        appdata="$APPDATA"
      fi
    elif [[ -n "${USERPROFILE:-}" ]]; then
      local userprofile="$USERPROFILE"
      if command -v cygpath >/dev/null 2>&1; then
        userprofile="$(cygpath -u "$USERPROFILE")"
      fi
      appdata="$userprofile/AppData/Roaming"
    else
      echo "Error: could not determine APPDATA/USERPROFILE for Windows install." >&2
      exit 1
    fi
    echo "$appdata/$APP_DIR_NAME/User"
  fi
}

CONFIG_DIR="$(resolve_config_dir)"

echo "Repo dir:    $REPO_DIR"
echo "OS:          $OS"
echo "Platform:    $PLATFORM ($BIN_NAME)"
echo "Config dir:  $CONFIG_DIR"
echo

mkdir -p "$CONFIG_DIR"

link_file() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    echo "Skipping $src (not found)"
    return
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      echo "Already linked: $dest"
      return
    fi
    local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing $dest -> $backup"
    mv "$dest" "$backup"
  fi

  ln -sf "$src" "$dest"
  echo "Linked $dest -> $src"
}

link_file "$REPO_DIR/settings.json" "$CONFIG_DIR/settings.json"
link_file "$REPO_DIR/keybindings.json" "$CONFIG_DIR/keybindings.json"

if [[ "$SKIP_EXTENSIONS" == "false" ]]; then
  if command -v "$BIN_NAME" >/dev/null 2>&1; then
    echo
    echo "Installing extensions from vscode-extensions.list using '$BIN_NAME'..."
    while IFS= read -r extension || [[ -n "$extension" ]]; do
      extension="$(echo "$extension" | tr -d '\r')"
      [[ -z "$extension" ]] && continue
      "$BIN_NAME" --install-extension "$extension"
    done < "$REPO_DIR/vscode-extensions.list"
  else
    echo
    echo "Warning: '$BIN_NAME' command not found on PATH; skipping extension install." >&2
    echo "Enable it via the command palette: Shell Command: Install '$BIN_NAME' command in PATH" >&2
  fi
fi

echo
echo "Done."
