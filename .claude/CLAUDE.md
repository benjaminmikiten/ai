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

Alternatively, install `skills/` as a plugin (see below) instead of running `setup.sh` — `CLAUDE.md` still needs the manual symlink either way, since plugins have no mechanism to inject into the global `CLAUDE.md`.

## Plugin marketplace

This repo doubles as a Claude Code plugin marketplace (`.claude-plugin/marketplace.json` + `.claude-plugin/plugin.json` at repo root). It publishes one plugin, `skills`, whose source is the repo root, so anything dropped under `skills/<name>/SKILL.md` is picked up automatically — no manifest edits needed.

To install on any machine:

```
/plugin marketplace add benjaminmikiten/ai
/plugin install skills@benjaminmikiten
```

Run `claude plugin validate .` from the repo root after editing either manifest.

## Conventions for skills

- Keep skills here generic: no references to private repos, task trackers or personal style. Where a skill needs taste, it reads a file the user owns (e.g. `draft-post` reads the user's `VOICE.md`). Personal plumbing goes in a private marketplace instead.
- Give each skill a `README.md` with a "What I've used it on" log. My website's skills page is built from these.
- Leave `version` out of `plugin.json`, so installs track commits and a push to `main` is a release. See `docs/pattern.md`.
