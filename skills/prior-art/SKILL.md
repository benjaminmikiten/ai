---
name: "prior-art"
description: "Use when the user has worked out an idea, framework, plan or strategy and wants to know whether it re-describes an existing concept, theory, law or practice, or what adjacent ideas could extend it."
---

# Prior Art

The user has explored a problem, found its boundaries, and has a working model of what makes it tick: its frames, levers and tensions. Your job is backwards research: find out whether that model already exists under another name, and what existing concepts, theories, laws, practices or systems it could borrow from or plug into.

The value is threefold: a recognized name makes the idea easier to communicate and defend; existing literature brings known failure modes, critiques and tooling for free; and whatever is left over after the prior art is accounted for is the user's genuinely novel contribution.

## Core principle: search by mechanism, not vocabulary

Prior art rarely shares the user's words. An idea described in terms of sales comp plans may be Goodhart's law; an idea about team boundaries may be Conway's law; an idea about cheaper AI usage driving more total spend may be the Jevons paradox. Searching with the user's domain nouns finds their own domain. Searching with the abstract mechanism finds the economists, biologists and engineers who named it decades ago. So the first step is always to strip the idea down to its structure.

## Workflow

### 1. Distill a structural brief

From the conversation, document or notes, pull out:
- The problem and the actors involved
- The mechanism: what causes what
- The levers: what can be changed, and what changing them does
- The tensions or tradeoffs
- Boundary conditions: where the idea stops holding
- What the user believes is new about it

Write the mechanism twice: once in the user's terms, and once with all domain nouns removed (e.g. "an agent optimizing a proxy measure drifts away from the goal the measure stood for"). The abstract version drives the search.

If the idea is too fuzzy to state a mechanism, ask at most two questions. Otherwise proceed and show the brief in the output so the user can correct it.

### 2. Generate candidates broadly

Start from your own knowledge and deliberately cross fields. Consider at least these lenses, and include candidates from at least three fields outside the user's own domain:
- Economics, game theory, incentive design
- Systems thinking, cybernetics, control theory
- Organizational design, management science, sociology
- Software engineering and architecture (patterns, distributed systems)
- Decision science and cognitive psychology
- Biology, ecology, evolution
- Law, governance, political science
- Design, HCI, pattern languages
- Military strategy
- Statistics, epistemology, philosophy of science
- Physical engineering metaphors (feedback, friction, load, resonance)

Look for several kinds of prior art: named laws, effects and heuristics; formal theories and frameworks; established practices and methods; design patterns; historical precedents and case studies; and well-known critiques of the idea.

Then use web search to find what you don't already know. Phrase queries as the mechanism, and try "term for when...", "what is it called when...", and "[mechanism] theory" forms. Aim for 8 to 15 raw candidates before filtering.

### 3. Verify every candidate you present

Inventing a plausible-sounding eponymous law is the main way this skill fails. For every candidate you intend to present, confirm by search that it exists under that name, who originated it and roughly when, and find one good link (the original paper or book, or a reliable hub such as Wikipedia or the Stanford Encyclopedia of Philosophy). Drop what you can't verify, or label it clearly as unverified.

Where a popular business framework repackages an older idea, name the original and point to it.

### 4. Map the fit

For each surviving candidate, map elements explicitly: the user's piece corresponds to the concept's piece. Then classify:
- **Same thing**: every core element maps and the mechanism matches. The user has re-described it.
- **Special case / generalization**: the user's idea is an instance of a broader theory, or a broader version of a narrower one.
- **Strong analogy**: same structure, different domain. Borrowable, with care.
- **Neighbor**: shares a lever or tension but not the core mechanism.

Always state where the mapping breaks. A breakpoint is either a place the analogy shouldn't be trusted, or a place where the user's idea is genuinely new. Say which.

### 5. Extract leverage

For the strongest matches, spell out what adopting them buys:
- Vocabulary others already recognize
- Known failure modes and critiques
- Existing tools, metrics, methods or templates
- Predictions the theory makes that the user hasn't considered (test the user's idea against these)
- What to read next

## Output

1. **Verdict** (2 to 3 sentences): re-description of X; a novel synthesis of X and Y; or mostly new territory with these neighbors. Be honest in both directions. Don't flatter novelty and don't force a match. "No strong precedent found" is a valid answer.
2. **What I searched for**: the abstract mechanism in 2 to 4 lines, so the user can correct the framing.
3. **Matches**, ranked by fit, typically 3 to 7. For each: name (originator, year), fit label, one-line gist, the key element mapping, where it breaks, what it gives the user, and a link.
4. **Worth borrowing**: 2 or 3 concrete moves the user could make with this prior art.
5. **Novel residue**: what remains that none of the prior art covers.

Keep it tight. Scale depth to the request: a "quick check" gets the top 3 matches with verification; a full run gets the whole workflow.

## Saving as a note

If the user asks to save the result, or is working in a markdown knowledge base (such as an Obsidian vault or a git repo of markdown notes), write it as a markdown note:
- Frontmatter with title, date, status (draft), and nested tags (e.g. `prior-art`, plus a topic tag)
- `[[Wikilinks]]` for each matched concept, so they can become their own notes later
- Sources listed at the bottom

Follow the repo's conventions for AI-authored content. If the repo expects AI changes as pull requests, open a branch and PR rather than committing to main.

## Guardrails

- Verify before presenting. Never invent names, originators, dates or citations.
- Prefer canonical and primary sources over listicles and pop-business summaries.
- Mark confidence where it is low.
- The user's framing may be wrong in places. If the prior art shows a known flaw in their reasoning, say so plainly; that is one of the most useful things this skill can do.