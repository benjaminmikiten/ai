# Personal LLM Wiki
I maintain a Karpathy-style LLM Wiki at ~/Documents/Obsidian. It contains:

```
raw/ — immutable source documents (articles, papers, repos, datasets)
wiki/ — LLM-generated markdown pages (concepts, entities, source summaries, comparisons)
wiki/index.md — the master catalog; always read this first when navigating the wiki
wiki/log.md — append-only operation log
.claude/skills/ — slash commands for /wiki-ingest, /wiki-query, /wiki-lint
```

The full schema is in `~/Documents/Obsidian/CLAUDE.md.` Read it if you're about to do wiki work — it defines page types, frontmatter conventions, and the ingest/query/lint workflows.

## Always involve the wiki for these
When I'm asking about anything research-flavored or topical (a concept, a person, a paper, a comparison, a "what do I know about X" question), or when the conversation produces durable knowledge worth keeping:

1. Before answering from your training data, check whether the wiki already has relevant pages. Read ~/Documents/Obsidian/wiki/index.md first; then follow [[wikilinks]] to the relevant pages.
2. Ground your answer in the wiki when it has the material. Cite with [[wikilinks]] and (when useful) the underlying raw/ source path.
3. If the wiki doesn't cover it, say so explicitly. Don't fabricate. Suggest what source I could add to raw/ to close the gap, and offer to log it under "Open questions" in wiki/index.md.
4. If the conversation produces a useful synthesis (a comparison, a new concept summary, a connection across sources), offer to file it as a new wiki page using ~/Documents/Obsidian/templates/. Wait for my approval — don't file unilaterally.
5. If I drop a new file into raw/, offer to run the ingest workflow (see ~/Documents/Obsidian/.claude/skills/wiki-ingest.md).

## When NOT to push wiki involvement

* One-off coding questions and debugging
* Casual conversation, scheduling, quick factual lookups unrelated to my research interests
* Tasks in other projects with their own CLAUDE.md

Use judgment. The wiki is for compounding knowledge, not a chore to perform on every message.

## Working in the wiki vault
When operating inside `~/Documents/Obsidian` (i.e. it's the project root for the session), defer to that vault's own CLAUDE.md for the schema and hard rules. The instructions here are the cross-project "remember the wiki exists" reminder.
