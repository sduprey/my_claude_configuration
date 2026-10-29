#!/usr/bin/env bash
# Sync personal Claude Code config between this repo and ~/.claude (macOS / Linux)
#   ./sync.sh export   -> copy this laptop's config into the repo
#   ./sync.sh import   -> install the repo's config on this laptop (backs up first)
set -euo pipefail

case "${1:-}" in export|import) ;; *) echo "usage: $0 export|import" >&2; exit 1 ;; esac

claude="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
repo="$(cd "$(dirname "$0")" && pwd)/claude"
# Only hand-written config. Never .credentials.json, sessions, projects, caches.
items="settings.json CLAUDE.md keybindings.json skills agents commands"

if [ "$1" = export ]; then from=$claude; to=$repo; else from=$repo; to=$claude; fi

if [ "$1" = import ]; then
  backup="$claude/backups/sync-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup"
  for i in $items; do
    if [ -e "$claude/$i" ]; then cp -R "$claude/$i" "$backup/"; fi
  done
  echo "Backup: $backup"
fi

mkdir -p "$to"
for i in $items; do
  src="$from/$i"
  [ -e "$src" ] || continue
  if [ -d "$src" ]; then
    # copy children so an existing dir is merged, not nested; skills/synced is claude.ai-managed
    mkdir -p "$to/$i"
    for child in "$src"/*; do
      if [ -e "$child" ] && [ "$(basename "$child")" != synced ]; then cp -R "$child" "$to/$i/"; fi
    done
  else
    cp "$src" "$to/$i"
  fi
  echo "$1 $i"
done

if [ "$1" = import ]; then
  printf "\nDone. Start 'claude' - it will offer to install the plugins listed in settings.json.\n"
fi
