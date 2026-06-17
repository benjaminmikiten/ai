#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR/skills"

link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backing up $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  linked $dst → $src"
}

echo "Setting up Claude config..."

link "$REPO/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

for skill in "$REPO/skills"/*; do
  [ -e "$skill" ] && link "$skill" "$CLAUDE_DIR/skills/$(basename "$skill")"
done

echo "Done."
