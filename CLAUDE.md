# CLAUDE.md

This is a personal technical blog by **locchh**, built with Astro. Posts live in `src/content/blog/*.md`. This file is the standing guidance for working on it.

## Writing Style

The blog is written by a non-native English speaker for a wide audience. Keep the prose **simple and easy to read**, without losing meaning or the author's voice.

- **Plain words over fancy ones.** Pick the simplest word that keeps the meaning — e.g. "essential" not "load-bearing", "the extreme version" not "the reductio", "paid once and reused" not "amortized", "broken down" not "stratified". Avoid rare or academic vocabulary.
- **Short sentences, one idea each.** Break long, winding sentences and chains of em-dashes into plain sequences.
- **Simplify the language, not the substance.** Never drop an idea, example, or citation just to make something shorter. Every point in the original must survive.
- **Keep the voice.** First person, direct, honest, a little informal. Keep the **bold key terms**, the one-line "Lesson"/rule takeaways, and the rhetorical questions. Simpler must never mean blander.
- **Don't over-name tools.** Cite only the few names that anchor a claim. Avoid version numbers, benchmark metrics, and vendor trivia — they age fast and clutter the argument.

## Structure and Argument

The main body of a post must read as **one argument**, not a stack of notes. Course outlines, docs, and research dumps are raw material. Never publish them in their original order or shape. The one exception is a **personal thought**, which may stand alone (see below).

- **Sentences link and stay on the section's topic.** Each sentence follows from the one before it, and each one serves the topic the section heading promises. Each paragraph picks up where the last one ended. If a sentence belongs to another topic, move it to the section where it belongs. This holds in every section, personal thoughts included.
- **Argument sections link to each other.** In the main argument, each H2 opens by picking up the previous section, so no part can be read as a stand-alone note.
- **Order by how the reader meets the work.** Example: a project's lifecycle, or a build as it grows. Never follow the order of the source course or document.
- **Argue, don't list.** Bullets and tables support an argument; they never replace it. A section that is a string of facts needs its "why". A recap that only repeats facts is not an argument.
- **One home per point.** Say each idea, story, definition, and table once, in the section where it belongs, and refer back to it elsewhere. Before finishing, search for the same point in two places and merge them.
- **Land a real insight in every argument section.** State it plainly: the non-obvious, useful line a reader keeps (e.g. "before you start building, decide how you will judge it"). Put it where it leads the section, not buried in the middle.
- **Leave the reader asking "what will I do?", not "what was this about?"** A post motivates only when the reader turns it into their own next move. So start from a problem the reader already feels, give one idea that changes how they see it, and end the argument with one first step they could take this week, small enough to picture. A personal thought is the exception: it may end on an open question.
- **Headings show the structure.** Read alone and in order, the H2/H3 titles of the argument should outline the post. Personal-thought headings sit outside that outline. A title is never one bare word and never a full sentence, and never uses a "Part 1." style prefix. Keep post titles short, with no subtitle after a colon.
- **Every link says what the source says.** Name the claim or content next to the link. References are annotated markdown links that each say what the source argues or contains. Never leave a bare URL or a title-only entry.
- **Never use yourself as the example.** First-person opinion ("I think") is fine. First-person anecdotes ("I once sat in a review", "people bring me a project", "my job now") are not. Use a composite third-person story instead.
- **History must earn its place.** Add an old computer-science anchor only where deleting it would weaken the argument. Verify every date, quote, and attribution against the primary source before using it.
- **Check the numbers.** Recompute every derived figure (ratios, percentages, "N times") before publishing, and trace every quote to the source it is credited to.

**Personal thoughts may stand alone.** Sometimes the author adds a personal thought: an opinion, a reflection, or an open question that sits beside the argument, not inside it. Examples: "My Thoughts" in `why_model_hallucinate.md` and "Two questions I cannot answer yet" in `when_code_is_cheap.md`. A personal thought does not need to link to the sections around it, so never add a forced bridge sentence to tie it in. Give it its own heading that shows it is personal, and usually place it after the main argument. It may end on an honest open question instead of a "Lesson" line. Never cut it, merge it into the argument, or number it into a list of steps. It is still an opinion, not a story about the author (see "Never use yourself as the example").

**Process for a new or rewritten post.** Write an outline first: the H2/H3 titles with one line of purpose each. Mark each personal thought in the outline as personal. For a rewrite, add a cut/move list (old location → new home) so no idea is dropped by accident. After drafting each section, have a sub-agent review it against this file. Reviewers must not flag a personal thought for missing links to other sections. Review the whole post again when it is finished. For a rewrite, that review also checks with a script that every original quote and URL survives.

**When editing an existing post, do NOT touch:** the frontmatter, `mermaid` blocks, other code blocks and inline `code`, quoted text (keep quotes verbatim), links and their URLs, table structure, or the place of a personal thought in the post. You may simplify the words inside a table cell or a personal thought, but keep every row, column, link, and idea.

## Clarity Check Before Publishing

A post can be correct and still confuse. Reviews that ask "is this number right?" miss it, because the number *is* right. In November 2026 a published post set "finished all five items in 30 minutes" beside "50 minutes of worker time", and a reader asked how 50 minutes fit in 30. The post never said that one was clock time and the other was time summed over workers running side by side. So every post gets a second kind of review, which asks: **could a newcomer misread this?**

**Rules for the text:**

- **Every number says what it measures.** State its unit and scope: per step, per item, per worker, or in total; median or total; clock time or summed time; and which run or job it comes from.
- **Never set two different measures side by side without saying how they differ.** Prefer the measure a reader can picture (time per item, from arrival to hand-in) over an aggregate.
- **Every percentage and "N times" names its base.** "35% fewer tokens" must say fewer than what.
- **Define a term before its first use**, in one plain clause. This covers both the post's own words (job, pack, slot, hand-off, evidence) and outside jargon.
- **Name the thing, not "it" or "the run".** Once a post has two runs, two scales, or two kinds of agent, give each a name and keep using it.
- **Explain why** whenever the reader will ask "why?": why this setup, why this job, why the comparison is fair, and what else changed with it.
- **A claim must follow from what is shown.** If two statements seem to contradict each other, fix one of them or explain the difference.
- **Check sources that may have changed since you read them.** A sentence based on an older document can turn false. A post once said the practice setup "had no approval reviewer" after the setup had added it back.

**Process:** before a post goes from `draft: true` to `draft: false`, and again before any later edit of a published post is committed:

1. Run a **newcomer read**: a fresh sub-agent that did not write the post. It reads the post as a smart reader who knows nothing about the project, and lists every number, term, reference, or claim that reader could misunderstand, with a plain rewrite for each. It may check facts against the sources, but its job is confusion, not correctness.
2. Fix every finding, or note why it is not a problem.
3. Stamp the post: `scripts/clarity-stamp.sh src/content/blog/<post>.md`. The stamp records the file's content hash in `.claude/clarity/`.

**The gate.** A project hook (`.claude/settings.json` → `scripts/clarity-gate.sh`) blocks any `git commit` that includes a published post whose stamp is missing or older than its last edit. Drafts are not gated. Any edit after the stamp means a new newcomer read before the commit can go through. In a true emergency, start the command with `CLARITY_SKIP=1` and do the read right after.

## Blog Mechanics

- **Mermaid renders in the browser, not at build time.** `npm run build` does **not** catch diagram syntax errors — a broken diagram only shows as an error glyph on the live page. Before publishing a post that has diagrams, validate them with a headless mermaid `parse`/`render` pass.
- **Drafts.** `draft: true` in the frontmatter keeps a post committed but off the site and the RSS feed. Use it for anything unreviewed; flip to `draft: false` to publish. The schema lives in `src/content.config.ts` (`title`, `description`, `pubDate` required; `author` and `tags` are allowed but ignored).
- **Commits.** Match the repo convention: `docs(blog): <lowercase summary>` with a short body, and keep distinct changes in separate commits.
