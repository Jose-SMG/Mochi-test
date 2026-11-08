#!/usr/bin/env bash
# Install only the independent community preview, never official Coucou.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
[[ "$(uname -s)" == Darwin ]] || { echo 'Requires macOS and Xcode.' >&2; exit 1; }
bash "$ROOT/scripts/build-mochi-macos.sh"
APP="$ROOT/build/mochi-xcode/Build/Products/Debug/Coucou Community.app"
ID=io.github.jose-smg.mochistudio.preview
ACTUAL=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP/Contents/Info.plist")
[[ "$ACTUAL" == "$ID" ]] || { echo 'Unexpected bundle identifier.' >&2; exit 1; }
TARGET="$HOME/Applications/Coucou Community.app"
if [[ -e "$TARGET" ]]; then
  EXISTING=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$TARGET/Contents/Info.plist")
  [[ "$EXISTING" == "$ID" ]] || { echo 'Destination belongs to another application.' >&2; exit 1; }
  osascript -e 'tell application id "io.github.jose-smg.mochistudio.preview" to quit' >/dev/null 2>&1 || true
fi
mkdir -p "$HOME/Applications"
ditto "$APP" "$TARGET"
open "$TARGET"
