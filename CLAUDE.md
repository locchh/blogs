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

A post must read as **one argument**, not a stack of notes. Course outlines, docs, and research dumps are raw material. Never publish them in their original order or shape.

- **Connect everything.** Each sentence follows from the one before it. Each paragraph picks up where the last one ended. Each H2 opens by picking up the previous section, so no part can be read as a stand-alone note.
- **Order by how the reader meets the work.** Example: a project's lifecycle, or a build as it grows. Never follow the order of the source course or document.
- **Argue, don't list.** Bullets and tables support an argument; they never replace it. A section that is a string of facts needs its "why". A recap that only repeats facts is not an argument.
- **One home per point.** Say each idea, story, definition, and table once, in the section where it belongs, and refer back to it elsewhere. Before finishing, search for the same point in two places and merge them.
- **Land a real insight in every section.** State it plainly: the non-obvious, useful line a reader keeps (e.g. "before you start building, decide how you will judge it"). Put it where it leads the section, not buried in the middle.
- **Headings show the structure.** Read alone and in order, the H2/H3 titles should outline the post. A title is never one bare word and never a full sentence, and never uses a "Part 1." style prefix. Keep post titles short, with no subtitle after a colon.
- **Every link says what the source says.** Name the claim or content next to the link. References are annotated markdown links that each say what the source argues or contains. Never leave a bare URL or a title-only entry.
- **Never use yourself as the example.** First-person opinion ("I think") is fine. First-person anecdotes ("I once sat in a review", "people bring me a project", "my job now") are not. Use a composite third-person story instead.
- **History must earn its place.** Add an old computer-science anchor only where deleting it would weaken the argument. Verify every date, quote, and attribution against the primary source before using it.
- **Check the numbers.** Recompute every derived figure (ratios, percentages, "N times") before publishing, and trace every quote to the source it is credited to.

**Process for a new or rewritten post.** Write an outline first: the H2/H3 titles with one line of purpose each. For a rewrite, add a cut/move list (old location → new home) so no idea is dropped by accident. After drafting each section, have a sub-agent review it against this file. Review the whole post again when it is finished. For a rewrite, that review also checks with a script that every original quote and URL survives.

**When editing an existing post, do NOT touch:** the frontmatter, `mermaid` blocks, other code blocks and inline `code`, quoted text (keep quotes verbatim), links and their URLs, or table structure. You may simplify the words inside a table cell, but keep every row, column, and link.

## Blog Mechanics

- **Mermaid renders in the browser, not at build time.** `npm run build` does **not** catch diagram syntax errors — a broken diagram only shows as an error glyph on the live page. Before publishing a post that has diagrams, validate them with a headless mermaid `parse`/`render` pass.
- **Drafts.** `draft: true` in the frontmatter keeps a post committed but off the site and the RSS feed. Use it for anything unreviewed; flip to `draft: false` to publish. The schema lives in `src/content.config.ts` (`title`, `description`, `pubDate` required; `author` and `tags` are allowed but ignored).
- **Commits.** Match the repo convention: `docs(blog): <lowercase summary>` with a short body, and keep distinct changes in separate commits.
