---
name: llm-council
description: Run the LLM Council adversarial advisory technique — five persona subagents independently answer a question, blind-review each other's answers, and a chairman subagent synthesizes a final recommendation. Use when the user invokes /llm-council or asks for a multi-perspective adversarial review of a plan, decision, or question.
---

# /llm-council

Run the persona-prompting variant of the LLM Council technique (`~/wiki/wiki/concepts/llm-council-persona-prompting.md`) against the user's question. Five distinct persona subagents answer independently, blind-review each other's answers, and a chairman subagent synthesizes a final recommendation. This is a single-model technique (all subagents are Claude via the `Agent` tool) — not the multi-model variant.

Invoked as `/llm-council "<question>"`. If no question is given, ask the user for one before proceeding.

## Personas

Use these five role definitions verbatim in every Stage 1 and Stage 2 prompt:

1. **Contrarian** — looks for failure points. Assume the plan fails; work backward to find why.
2. **Assumption-ripper** — challenges the premises the user walked in with. Identify unstated assumptions and test whether they hold.
3. **Expansionist** — hunts for missed upside. What bigger opportunity is being left on the table?
4. **Outsider** — asks naive, industry-agnostic questions that turn out to be revealing. Assume no domain context; ask what an intelligent newcomer would ask.
5. **Executor** — focuses only on immediate next steps. What happens Monday morning, concretely?

## Stage 1 — First Opinions

Fire 5 `Agent` tool calls in a single message (5 tool-use blocks, all in parallel), `subagent_type: general-purpose`, one per persona above. Each call's prompt must contain:

- The user's question/context verbatim.
- That persona's role definition (from the list above).
- This exact instruction appended: "Do not use any tools. Reason only from the question and context given here. Answer in your persona's voice and priorities."

Collect the 5 outputs into `{persona_name: answer_text}`. If any single call fails or errors, retry that call once. If it still fails, proceed without that persona's contribution — record that this persona's Stage 1 answer is missing; carry that gap forward into Stage 2 (skip generating a Stage 2 critique *from* that persona, but still include its Stage 1 answer as one of the anonymized responses reviewed by the other 4 *if it succeeded* — only omit it if Stage 1 itself failed) and into the final output (see Error handling).

## Stage 2 — Review (blind)

Fire 5 more `Agent` tool calls in a single message (5 tool-use blocks, all in parallel), `subagent_type: general-purpose`, one per persona again (skip any persona whose Stage 1 call failed twice — see Error handling). Each call's prompt must contain:

- The original question.
- That persona's role definition (same text as Stage 1 — it critiques through its own lens).
- The *other* 4 personas' Stage 1 answers, anonymized: labeled `Response A`, `Response B`, `Response C`, `Response D` in a fixed but arbitrary order. Do not include persona names anywhere in this prompt. The persona reviewing must never see its own Stage 1 answer among the four — exclude it before anonymizing and labeling.
- This exact instruction appended: "Critique each of the 4 responses from your persona's angle — where do they fail, what's missing, what would you push back on. No tools."

Collect the outputs into `{persona_name: critique_text}`. Apply the same retry-once-then-proceed-without rule as Stage 1 (see Error handling).

## Stage 3 — Final Response (chairman)

One `Agent` tool call, `subagent_type: general-purpose`, no tools. The prompt must contain:

- The original question.
- All available Stage 1 answers, labeled by **persona name** (not anonymized — the chairman needs full context, unlike Stage 2 reviewers).
- All available Stage 2 critiques, labeled by **persona name**.
- Explicit notes for any persona whose Stage 1 and/or Stage 2 contribution is missing due to repeated failure (see Error handling) — the chairman should acknowledge the gap rather than silently synthesizing around it.
- This exact instruction appended: "Synthesize a single final recommendation with concrete next steps. Explicitly note where the personas agreed, where they conflicted, and how you resolved the conflict."

If this call fails, retry once. If it still fails after the retry, do not silently return nothing — report the chairman failure to the user directly, and still present the Stage 1 and Stage 2 outputs (skip the "Final Recommendation" section of the output format below in this case).

## Output format

Present directly in the conversation (no automatic file write):

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
### Expansionist
...
### Outsider
...
### Executor
...
</details>

<details>
<summary>Appendix: Stage 2 — Reviews</summary>

### Contrarian's review
...
### Assumption-ripper's review
...
### Expansionist's review
...
### Outsider's review
...
### Executor's review
...
</details>
```

Note any persona gaps inline where that persona's section would otherwise appear, e.g. "*Outsider's review unavailable — subagent call failed twice.*"

After presenting the output, ask the user: "Want me to save this to a file?"

- If yes: write the full transcript (chairman synthesis + both appendices, in the same markdown structure shown above) to `~/wiki/raw/notes/YYYY-MM-DD-<slug>-council.md`, using today's date and a kebab-case slug derived from the question. Follow the `raw/notes/` convention in `~/wiki/CLAUDE.md` (things worth remembering with no external document behind them).
- This write is the only action taken — do NOT run `/wiki-ingest` automatically. If the user wants the transcript folded into the wiki proper, that's a separate, explicit step they need to request.
- If no: do nothing further.

## Error handling

- Any single Stage 1 or Stage 2 `Agent` call that fails or errors: retry once. If it still fails, proceed without that persona's contribution for that stage. Note the gap explicitly in the final output (both in the chairman's context per Stage 3 above, and in the relevant appendix section per Output format above). Never block the whole run on one failed call.
- The chairman call itself failing: retry once, then report the failure to the user directly. Still show whatever Stage 1/2 outputs succeeded — a partial result beats no result.

## Out of scope

- Multi-model variant (different LLM backends) — see `~/wiki/wiki/concepts/llm-council.md`, not implemented here.
- Tool access for persona subagents — personas reason only over what's given to them in their prompt, never web search or file reads.
- Automatic `/wiki-ingest` after saving a transcript — stays a manual, explicit step the user must request separately.
- Validating whether this technique reduces sycophantic endorsement — a research question, not something this skill measures.
