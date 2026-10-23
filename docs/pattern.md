# One repo, every surface

How this repo is set up, and why. The short version: **a public GitHub repo laid out as a Claude plugin marketplace is both the showcase and the install source.** Add it to your Claude account once, and the same skills run in the Claude app on your phone, in the desktop app, and in Claude Code, with no copying between them.

## The problem

I write skills for two reasons that pull in different directions:

- **Use.** I want to call them wherever I am: the Claude app on my phone, Claude Code at a terminal, a session I'm steering remotely.
- **Show.** I want them public, so people can see how I work with AI and take what's useful.

The obvious approaches each give up one of those. Skills saved straight to a Claude account are usable everywhere but invisible to anyone else. Skills in a repo's `.claude/skills/` folder are visible but only load when Claude Code runs in that repo. Keeping both in sync by hand means they drift.

## The pattern

Put the skills in a git repo with a marketplace manifest, and install from the repo.

```
.claude-plugin/marketplace.json   the catalog: lists each plugin and where it lives
.claude-plugin/plugin.json        the plugin's manifest
skills/<name>/SKILL.md            one folder per skill
```

This repo publishes a single plugin, `skills`, whose source is the repo root, so any folder dropped under `skills/` ships without a manifest edit.

A **plugin** bundles skills (and optionally commands, agents, hooks and MCP connectors) into one installable unit. A **marketplace** is just a repo with a catalog of plugins. Nothing here needs a server or a build step.

### How it reaches each surface

| Surface | How the skills get there |
|---|---|
| Claude app: web, desktop, mobile | Add the marketplace once under **Customize > Plugins > Add > Add marketplace**, then add its plugins. They're saved to the account, so every app signed in to it has them. |
| Claude Code (terminal, desktop, IDE) | Plugins on your claude.ai account sync down as `<plugin>@synced` each time Claude Code starts while signed in to that account. Or install directly with `claude plugin marketplace add` and `claude plugin install`. |
| Remote Control | Runs on your own machine, so it's the same as Claude Code there. |
| Claude Code cloud sessions | Don't load plugins installed on your machine or listed in a repo's settings. Check what's available in your cloud environment before relying on a skill there. |
| Other agents | Each skill is a plain folder with a `SKILL.md`, so it can be copied into any agent that reads skills. |

### Updates

Publishing is a push to `main`.

- In the Claude app, a marketplace added from github.com can be set to **Sync automatically**.
- In Claude Code, a plugin with **no `version` field** gets the commit SHA as its version, so every commit is a new version. Pinning `"version": "0.1.0"` holds every install on that copy until the string changes, however many commits land. This repo leaves `version` out on purpose, which is why `claude plugin validate` warns about it.

The validator in Claude Code checks the manifests: `claude plugin validate .` from the repo root.

## Decisions in this repo

**One plugin for now.** Plugin skills are invoked as `/<plugin>:<skill>`, so everything here is `/skills:<name>`. If the collection grows, splitting by theme (`/writing:interview-me`, `/thinking:prior-art`) reads better, at the cost of changing install IDs.

**Generic in public, personal in private.** New skills here are written to know nothing about my repos, my task tracker or my style. Where a skill needs taste, the taste lives in a file the *user* owns: `draft-post` reads the user's `VOICE.md` rather than containing my voice. Skills that encode my own plumbing (which Linear project, which branch names, which grocery store) live in a second, private marketplace with the same layout. Private GitHub repos work as marketplaces once the Claude GitHub App has access.

**The repo is the source of truth.** Skills saved directly to an account and skills installed from a marketplace are separate copies, and they drift. Once a skill moves here, remove the account-level copy. Changes after that come through the repo, as commits or pull requests, the same way the rest of my writing does.

**The website is derived, not maintained.** Each skill's README has a "What I've used it on" log. A page on my site can be built from this repo at deploy time, so listing a skill publicly and using it are the same act.

## Where an umbrella repo fits

A related pattern: an **umbrella repo** whose root holds a `CLAUDE.md` and shared skills, with every project nested underneath. It works because Claude Code loads `CLAUDE.md` from the working directory *and every directory above it*, so a project inside the umbrella inherits the root's instructions.

It's a good pattern, but it's a filesystem trick. It only exists where Claude Code is running on that folder tree. The Claude app on a phone never sees it, and a cloud session clones one repository, not your umbrella.

The difference is the one between a dotfiles directory and a package registry:

| | Umbrella repo | Plugin marketplace |
|---|---|---|
| Like | A dotfiles directory | A package registry |
| Reaches | Claude Code sessions inside that folder tree | Every surface signed in to your account |
| Good for | Conventions across your local projects | How you work, wherever you are |
| Cost | Nested repos (submodules or ignored clones) | A manifest file per plugin |

This repo is both, on purpose:

- **Marketplace layer:** `skills/` plus the manifests. Reaches every surface.
- **Dotfiles layer:** the root `CLAUDE.md`, symlinked into `~/.claude/` by `setup.sh`. A plugin can't write to the global `CLAUDE.md`, so instructions that should apply in every Claude Code session on a machine still travel this way.

`setup.sh` can also symlink the skills, which is handy offline, but don't combine that with the installed plugin on the same machine: you'd get every skill twice.

So I split by reach:

- **Behavior I want everywhere** → skills, in a marketplace.
- **Conventions for code on one machine** → a short `CLAUDE.md`. For one person, `~/.claude/CLAUDE.md` already *is* an umbrella for every project on that machine, with no nesting required.

At company scale, the cross-surface version of an umbrella is an organization marketplace: on Team and Enterprise plans, an admin can sync the organization's plugins from a repository and make them available, installed by default, or required for members.

## References

- [Plugins on claude.ai](https://claude.com/docs/plugins/overview)
- [Install and manage plugins in Claude Code](https://code.claude.com/docs/en/plugins/install)
- [Create a marketplace](https://code.claude.com/docs/en/plugins/create-marketplace)
- [Plugin loading reference](https://code.claude.com/docs/en/plugins/loading) (synced plugins, how versions are computed)
- [How Claude Code loads CLAUDE.md](https://code.claude.com/docs/en/memory)
