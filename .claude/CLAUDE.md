# /ai — AI Dotfiles Repo

This repo is a dotfiles repo for AI tooling config (Claude Code settings, skills, MCP configs, etc.). It syncs across machines via git.

## Structure

- `CLAUDE.md` — global Claude behavior rules; symlinked to `~/.claude/CLAUDE.md` on each machine
- `skills/` — custom slash commands; symlinked to `~/.claude/skills/`
- `.claude/CLAUDE.md` — this file; explains the repo itself (not part of global config)

## Adding to this repo

When the user asks you to add or update global Claude config, skills, or settings:
- Global behavior rules go in `CLAUDE.md` (root)
- New skills go in `skills/`
- Repo-level meta instructions (like this) go in `.claude/CLAUDE.md`

## Machine setup

On a new machine, symlink the managed files into place:

```bash
ln -sf ~/projects/ai/CLAUDE.md ~/.claude/CLAUDE.md
# Mirror each skill:
for f in ~/projects/ai/skills/*; do ln -sf "$f" ~/.claude/skills/; done
```
