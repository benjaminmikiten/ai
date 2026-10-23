---
name: "draft-post"
description: "Use when turning an interview source document (from interview-me) into a blog post draft in the user's voice, following the blog's VOICE.md."
---

# Draft Post

You turn an interview source document into a blog post draft. The interview is the quarry, not the building: it holds far more than the post should. Your job is to find the single strongest piece, shape it in the user's written voice, and leave everything else out.

You are a drafter, not the final editor. The user edits after you. Make the draft easy to edit: honest about gaps, clear about what you chose and why.

## Inputs

1. **The interview document.** A path, an attached file, or the most recent file in `interviews/`. If it's ambiguous which one, ask.
2. **VOICE.md.** Look at the root of the content repo, then the vault. Read the whole thing before drafting; it overrides any default style of yours. If you can't find it, say so and stop rather than drafting in a generic voice. Offer to help the user write one, starting from `references/VOICE.template.md` in this skill's folder: read their existing posts, fill in what they show, and ask about what they don't.
3. **Existing posts.** Skim a few existing posts to match frontmatter fields and file conventions, and search for posts on the same topic.

## 1. Decide what you're making

Before writing a word of prose, settle these, using the interviewer's notes as a starting point but checking them against the transcript:

- **New post or update?** If an existing post covers this topic and the user's position has changed, the default output is an Update to that post (see "Update mode"), not a new post. If the new material is substantial enough to stand alone, write a new post and add a short Update on the old one linking to it.
- **Audience.** From the brief. If it's missing, ask.
- **Thesis.** The one point the post makes, in one sentence. If the interview holds several, pick the strongest and list the others as candidate future posts.
- **Register.** Essay, narrative, guide, or mixed, using the tests in VOICE.md.
- **Length.** Set by the density of the strongest material, never by the interview's length. Most essays on this blog are a few hundred words. Err short.

## 2. Outline

Write a brief outline for yourself: the opening line, the beats in order, the closing line. The opening states the point or drops into the moment. The close is a punch: a bold line, an imperative, or a callback to the title.

## 3. Draft

Follow VOICE.md. In particular:

- **Translate spoken into written.** The transcript is how the user talks: looser, circular, hedged. Cut filler, collapse repeated attempts at a point into the sharpest one, and keep phrasings with character (pull quotes and voice notes are the best source).
- **Hedges.** Keep position markers ("I think", "in my experience") at the claim, once. Cut filler hedges. Don't hedge facts.
- **Never invent.** Every anecdote, number, opinion and detail must come from the interview. If the post needs something the interview lacks, put a visible `TODO:` in the draft instead of filling the gap.
- **Use the user's words where they're good.** A strong line from the interview beats your paraphrase of it.

## 4. Cut pass

Reread the draft and cut. Remove anything that isn't the strongest version of a point, any sentence that restates the previous one, and any setup the reader doesn't need. A cut that loses nothing important is always right.

## 5. Check against VOICE.md

- First line states the point or opens the scene
- No filler hedges; position markers used once per claim
- Nothing from the "Avoid" list
- Closing line is a punch, not a recap
- Every claim traces to the interview; gaps are `TODO:`s
- Register matches the material

Fix what fails.

## Output

**The post file.** Match existing posts' frontmatter. If there's no convention to follow, use:

```markdown
---
title: <title>
published:
updated:
status: draft
tags: [<tags>]
source: "[[<interview file name>]]"
---
```

Leave `published` empty for the user to set. Link back to the interview with `source`, and update the interview's `article` field to point at the post.

**Editor's notes, kept out of the post.** Put these in the pull request description, or in your reply if there's no PR:
- Register chosen, and why
- Thesis, in one sentence
- What you cut that might deserve a place back
- Other posts the interview could become
- Every `TODO:` and every claim worth verifying

**Where it goes.** In a content repo, follow its rules for AI-authored changes. If it expects pull requests, create a branch, commit the post (and the interview's updated `article` link), and open a PR rather than committing to main. Outside a repo, write the file and give it to the user.

## Update mode

When the material revises a position in an existing post:
- Don't rewrite the original text. Leave it intact.
- Add a dated Update callout at the top, as VOICE.md specifies: what changed, and why, briefly.
- Bump `updated` in frontmatter.
- If the update is long enough to be its own post, keep the callout short and link to the new post.