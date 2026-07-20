# /llm-council — Design

**Date:** 2026-07-19
**Status:** Approved

## Overview

A Claude Code skill implementing the "LLM Council" adversarial advisory technique: five distinct persona subagents independently answer a question, blind-review each other's answers, and a chairman subagent synthesizes a final recommendation. Invoked as `/llm-council "<question>"`.

Origin and rationale are documented in the wiki: `~/wiki/wiki/concepts/llm-council-persona-prompting.md` (the technique) and `~/wiki/wiki/concepts/ai-sycophancy.md` (the problem it's meant to counteract — untested claim, this implementation doesn't validate it, just makes the technique usable).

## Scope

Persona-prompting variant only (one model, five roles via subagents) — not the multi-model variant (`~/wiki/wiki/concepts/llm-council.md`), which would need non-Claude API credentials and is out of scope here.

## Architecture

Single-file instructions skill, no code — same pattern as `wiki-query`. Lives at `~/projects/ai/skills/llm-council/SKILL.md`, auto-registered via the existing `benjaminmikiten` marketplace (`~/projects/ai/.claude-plugin/marketplace.json`, plugin `skills`, source `./`).

The skill's body is a sequence of instructions for the invoking Claude Code session to follow, orchestrating the `Agent` tool. There's no separate runtime — the session itself is the orchestrator.

## Flow

### Stage 1 — First Opinions

Fire 5 `Agent` tool calls in parallel (single message, 5 tool-use blocks), `subagent_type: general-purpose`, one per persona. Each call's prompt contains:

- The user's question/context verbatim.
- The persona's role definition (below).
- An explicit instruction: "Do not use any tools. Reason only from the question and context given here. Answer in your persona's voice and priorities."

Collect 5 labeled outputs: `{persona_name: answer_text}`.

**Persona role definitions** (verbatim from `llm-council-persona-prompting.md`, reused so the skill and the wiki page stay consistent):

1. **Contrarian** — looks for failure points. Assume the plan fails; work backward to find why.
2. **Assumption-ripper** — challenges the premises the user walked in with. Identify unstated assumptions and test whether they hold.
3. **Expansionist** — hunts for missed upside. What bigger opportunity is being left on the table?
4. **Outsider** — asks naive, industry-agnostic questions that turn out to be revealing. Assume no domain context; ask what an intelligent newcomer would ask.
5. **Executor** — focuses only on immediate next steps. What happens Monday morning, concretely?

### Stage 2 — Review (blind)

Fire 5 more parallel `Agent` calls, one per persona again. Each call's prompt contains:

- The original question.
- The persona's role definition (same as Stage 1 — it critiques through its own lens).
- The other 4 personas' Stage 1 answers, **anonymized**: labeled `Response A`–`D` in a fixed but arbitrary order, with no persona names attached. (The persona reviewing never sees its own answer among the four.)
- Instruction: critique each of the 4 responses from your persona's angle — where do they fail, what's missing, what would you push back on. No tools.

Collect 5 outputs: `{persona_name: critique_text}`.

### Stage 3 — Final Response (chairman)

One `Agent` call, `subagent_type: general-purpose`, no tools. Prompt contains:

- The original question.
- All 5 Stage 1 answers, labeled by persona name (not anonymized here — the chairman needs full context).
- All 5 Stage 2 critiques, labeled by persona name.
- Instruction: synthesize a single final recommendation with concrete next steps, explicitly noting where the personas agreed, where they conflicted, and how the conflict was resolved.

## Output

Presented directly in the conversation (no automatic file write):

```markdown
## Final Recommendation (Chairman)
<synthesis + next steps>

---
<details>
<summary>Appendix: Stage 1 — First Opinions</summary>

### Contrarian
...
### Assumption-ripper
...
(etc.)
</details>

<details>
<summary>Appendix: Stage 2 — Reviews</summary>
...
</details>
```

After presenting, ask: "Want me to save this to a file?" If yes, write the full transcript (chairman synthesis + both appendices) to `~/wiki/raw/notes/YYYY-MM-DD-<slug>-council.md`, following the existing `raw/notes/` convention (things worth remembering with no external document behind them). This only writes the file — it does not run `/wiki-ingest`; that remains a separate, explicit step if the user wants it folded into the wiki proper.

## Error handling

If any single `Agent` call in Stage 1 or Stage 2 fails or errors: retry once. If it still fails, proceed without that persona's contribution, and note the gap explicitly in the final output (both in the chairman's synthesis context and in the appendix, e.g. "Outsider's review unavailable — subagent call failed twice"). Do not block the whole run on one failed call.

If the chairman call itself fails: retry once, then report the failure to the user directly rather than silently returning nothing — Stage 1/2 outputs are still worth showing even without a synthesized verdict.

## Out of scope

- Multi-model variant (different LLM backends) — separate future skill if ever built, per `~/wiki/wiki/concepts/llm-council.md`.
- Tool access for personas (web search, file reads) — explicitly excluded per design decision; personas reason only over what's given to them.
- Automatic `/wiki-ingest` after saving a transcript — stays a manual, explicit step.
- Validating whether this technique actually reduces sycophantic endorsement — that's a research question tracked as an open question in the wiki, not something this skill measures.
