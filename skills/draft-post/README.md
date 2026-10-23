# draft-post

`/skills:draft-post` as a plugin, or `/draft-post` with `setup.sh`.

Turns the source document from [interview-me](../interview-me) into a draft. It decides what it's making before writing a word: new post or an update to an existing one, the single strongest thesis, the register (essay, narrative or guide), and a length set by the material, not the interview.

Rules it holds to:

- It **never invents**. Anything the post needs that the interview lacks becomes a visible `TODO:`.
- It **translates spoken into written**: cuts filler and circling, keeps phrasings with character.
- It runs a **cut pass** after drafting.
- **Editor's notes** (register choice, what got cut, TODOs, claims to verify) go in the pull request or reply, never in the post.

**Setup:** a `VOICE.md` at the root of your content repo or vault, describing how your writing should sound. The skill stops if it can't find one, because a draft in a generic voice costs more to fix than it saves. A starting template is in [references/VOICE.template.md](references/VOICE.template.md).

## What I've used it on

<!-- Add a line per post, newest first:
- YYYY-MM: [post title](https://b.mktn.io/...) (essay / narrative / guide)
-->
