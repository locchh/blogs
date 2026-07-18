# CLAUDE.md

This is a personal technical blog by **locchh**, built with Astro. Posts live in `src/content/blog/*.md`. This file is the standing guidance for working on it.

## Writing Style

The blog is written by a non-native English speaker for a wide audience. Keep the prose **simple and easy to read**, without losing meaning or the author's voice.

- **Plain words over fancy ones.** Pick the simplest word that keeps the meaning — e.g. "essential" not "load-bearing", "the extreme version" not "the reductio", "paid once and reused" not "amortized", "broken down" not "stratified". Avoid rare or academic vocabulary.
- **Short sentences, one idea each.** Break long, winding sentences and chains of em-dashes into plain sequences.
- **Simplify the language, not the substance.** Never drop an idea, example, or citation just to make something shorter. Every point in the original must survive.
- **Keep the voice.** First person, direct, honest, a little informal. Keep the **bold key terms**, the one-line "Lesson"/rule takeaways, and the rhetorical questions. Simpler must never mean blander.
- **Don't over-name tools.** Cite only the few names that anchor a claim. Avoid version numbers, benchmark metrics, and vendor trivia — they age fast and clutter the argument.

**When editing an existing post, do NOT touch:** the frontmatter, `mermaid` blocks, other code blocks and inline `code`, quoted text (keep quotes verbatim), links and their URLs, or table structure. You may simplify the words inside a table cell, but keep every row, column, and link.

## Blog Mechanics

- **Mermaid renders in the browser, not at build time.** `npm run build` does **not** catch diagram syntax errors — a broken diagram only shows as an error glyph on the live page. Before publishing a post that has diagrams, validate them with a headless mermaid `parse`/`render` pass.
- **Drafts.** `draft: true` in the frontmatter keeps a post committed but off the site and the RSS feed. Use it for anything unreviewed; flip to `draft: false` to publish. The schema lives in `src/content.config.ts` (`title`, `description`, `pubDate` required; `author` and `tags` are allowed but ignored).
- **Commits.** Match the repo convention: `docs(blog): <lowercase summary>` with a short body, and keep distinct changes in separate commits.
