# my_claude_configuration

My personal Claude Code setup, so every laptop gets the same environment.

## New laptop

```powershell
git clone https://github.com/sduprey/my_claude_configuration.git ; cd my_claude_configuration
.\sync.ps1 import
claude   # accepts the plugin install prompt from settings.json
```

`import` backs up whatever is in `~/.claude` to `~/.claude/backups/sync-<date>` first.

## Changed something? Save it

```powershell
.\sync.ps1 export
git add -A ; git commit -m "update config" ; git push
```

## What's in here

| Path | What |
|------|------|
| `claude/settings.json` | Model, enabled plugins, plugin marketplaces |
| `claude/skills/` | Personal skills (`find-skills`) |
| `claude/CLAUDE.md`, `agents/`, `commands/`, `keybindings.json` | Synced too, once they exist |

### Plugins

| Plugin | Marketplace |
|--------|-------------|
| `ponytail` | https://github.com/DietrichGebert/ponytail.git |
| *(marketplace only)* | `claude-plugins-official` - https://github.com/anthropics/claude-plugins-official.git |

Org plugins (engineering, data, keyrus-*, etc.) and connectors come from the claude.ai organisation when you sign in - they are not stored here.

## Never committed

`.credentials.json`, sessions, projects, history, caches - `sync.ps1` only copies the files listed above.
