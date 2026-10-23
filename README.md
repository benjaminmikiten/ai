# ai

My AI dotfiles: the Claude skills and config I use across machines and apps. It's public so people can see how I work with AI and take what's useful.

The repo does two jobs at once. It's a **plugin marketplace**, so the skills install into the Claude app (web, desktop, mobile) and Claude Code from one place. It's also a **dotfiles repo**, so my global `CLAUDE.md` follows me between machines. [docs/pattern.md](docs/pattern.md) explains why it's split that way.

## Skills

All skills live in [`skills/`](skills) and ship as one plugin, `skills`, so they're invoked as `/skills:<name>`.

| Skill | What it does |
|---|---|
| [prior-art](skills/prior-art) | Checks whether an idea you've worked out already exists as a named concept, law, theory or practice, and what adjacent ideas could extend it. |
| [interview-me](skills/interview-me) | Interviews you about a topic, one question at a time, and exports a rich source document for an article. |
| [draft-post](skills/draft-post) | Turns that interview into a post draft in your voice, following a `VOICE.md` style guide. |
| [llm-council](skills/llm-council) | Five persona subagents answer a question independently, blind-review each other, and a chairman synthesizes a recommendation. |

Each skill's README covers what it's for and what I've used it on.

## Install

**Claude app and Claude Code, all at once.** In claude.ai or the desktop app, go to **Customize > Plugins > Add > Add marketplace**, enter `benjaminmikiten/ai`, and add the `skills` plugin. It's saved to your account, so it also syncs into Claude Code sessions signed in to the same account. Turn on **Sync automatically** to pick up new commits.

**Claude Code only:**

```
/plugin marketplace add benjaminmikiten/ai
/plugin install skills@benjaminmikiten
```

**Any agent that reads skills:** each skill is a plain folder with a `SKILL.md`. Copy the folder into your agent's skills directory.

**My own machines:** `setup.sh` symlinks `CLAUDE.md` into `~/.claude/`, along with each skill. If the plugin is installed too, the skills show up twice (`/prior-art` and `/skills:prior-art`), so use one or the other for skills.

## Layout

```
.claude-plugin/marketplace.json   catalog: one plugin, "skills", sourced from the repo root
.claude-plugin/plugin.json        the plugin's manifest
skills/<name>/SKILL.md            one folder per skill, picked up automatically
skills/<name>/README.md           what it's for, and what I've used it on
CLAUDE.md                         my global Claude instructions (dotfiles layer)
setup.sh                          symlinks CLAUDE.md and skills into ~/.claude
docs/pattern.md                   the marketplace + dotfiles pattern, explained
```

## Related

Not mine, but I use it alongside these: Matt Pocock's grill-me skill, for stress-testing a decision until every branch is settled. interview-me borrows its relentlessness and points it at writing instead.
