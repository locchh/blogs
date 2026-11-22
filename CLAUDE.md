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

## One Thread From Start to End

A post is read from top to bottom, like a thread. Splitting text into headings, lists, tables, and diagrams makes it easier to scan, but it can also cut the thread: in November 2026 three reworked posts had good pieces whose titles and paragraphs "are likely not related to each other". Structure must carry the argument, never chop it up.

- **The headings alone tell the story.** Read only the H2 and H3 titles, in order. They must read as one line of thought, where each title follows from the one before it: a question and then its answer, a problem and then its fix, a step and then the next step. If a title could be moved elsewhere without anyone noticing, it is a label, not a step. Rewrite it.
- **A title says what the section claims or answers**, not just its topic. Prefer "Why a pilot fails without a named owner" to "Ownership". Sibling titles use the same grammar, so the reader sees they are parallel.
- **Every section opens with a link back.** Its first sentence picks up the last point of the section before it, and says why this section comes next. Its last sentence leaves the question that the next section answers.
- **Every paragraph opens by picking up the previous one.** Use the plain linking words a reader needs: so, but, because, then, that is why, for example. A paragraph that could be deleted without the next one noticing does not belong, or it is in the wrong place.
- **Every sentence follows from the one before it.** Repeat the key word of the last sentence, or point back to it with "this" plus a noun ("this gap", "that rule"). Never start a new subject without saying how it connects.
- **Lists, tables, and diagrams sit inside the thread.** One sentence leads in and says what the reader should look for. One sentence leads out and says what it means for the argument. Never put two lists, tables, or diagrams back to back without prose between them.
- **Every example is tied to its point at both ends.** A post may have many examples, but each one opens by naming the claim it tests, in the words of the paragraph before ("That is the trap in one real case:"), and closes by saying what it proved and handing over to the next point ("So the rule had not changed; what enforced it had."). The closing sentence must not just repeat the opening one. An example that a reader could move to another section without noticing is not tied to anything.
- **Show each example in an example box**, so the reader sees where the argument stops and the example starts. The opening sentence stays above the box, the closing sentence below it, and the story goes inside:

  ```
  <div class="example">

  **Example · A 180-lawyer law firm**

  The story, in normal markdown.

  </div>
  ```

  Box only a worked case: one situation followed through several of the post's decisions, like a firm whose goal, constraints and design are walked through together. Use few boxes, a handful per post at most, or the box stops meaning anything. A short story that proves one sentence (a failure, an anecdote, a before-and-after) stays in the text as a normal paragraph, tied to its point at both ends. So do a hypothetical, a checklist, and a general description.

  Keep the blank lines, or the markdown inside will not render. A case gets a box inside the section it proves, not an H3 of its own. Keep mermaid diagrams outside the box. The style lives in `src/styles/global.css` (`.example`).
- **No orphan sections.** A section that only holds reference material (a table of terms, a checklist) and does not move the argument goes to the end of the post, or out.
- **Cut what is off the thread.** If a part does not serve the one question the post answers, cut it or move it to another post, even when it is correct and well written.

**The thread test, before publishing.** (1) Read only the titles: do they tell the whole argument in order? (2) Read only the first sentence of each section: does each one connect to the section before? (3) Pick any three paragraphs and try to swap them: if nothing breaks, they are notes, not a thread.

## No Walls of Text

A post can argue well and still be hard to read. In November 2026 three long posts had to be reworked because they were "quite plain text and hard to read" and "quite verbose": about 47,000 words with five diagrams between them, and paragraphs of 150 to 270 words. Never publish a post in that shape again.

- **Draw every process.** A process, workflow, loop, decision, pipeline, lifecycle, or split of roles gets a mermaid diagram. Aim for at least one diagram per H2, and put one short sentence before each diagram saying what it shows. Never draw a diagram that only repeats a list.
- **A diagram needs a flow. Pairs go in a table.** Draw a diagram only when its arrows mean something: one step leads to the next, a decision branches, a loop comes back. If every arrow only joins a label to its description (problem and fix, step and file, part and what it does), or one root fans out to a flat list, it is a table drawn as boxes. In November 2026 five such diagrams in four posts were turned into tables. The test: if you can delete the arrows and nothing is lost, use a table. A diagram that repeats the table beside it goes too. This rule beats "one diagram per H2": a section with no process gets a table, not a forced diagram.
- **Keep paragraphs short.** No paragraph over about 80 words. One idea each.
- **Show parallel items as a list or a table**, with a lead sentence that states the point. Criteria, options, steps, and risks are parallel items. The list supports the argument and never replaces it.
- **Be direct.** Say each point once, in short sentences. Cut openers, hedges, bridges that say nothing, and prose that only restates the table or diagram beside it. A recap is two or three rule lines, not a second telling of the section.
- **Write short from the start.** Cutting later is hard: once every sentence carries a fact, a rewrite removes only about 15 percent without dropping content. So decide what a section must say before drafting it, and leave the rest out.

**Check before publishing.** Count the words, the diagrams, and the longest paragraph in each section. A section with several hundred words, no diagram, table, or list, and a paragraph over 80 words is a wall of text. Fix it before the clarity check.

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
- **Dense posts.** `dense: true` in the frontmatter renders a post with smaller type on a wider page, with compact tables (16px text, a 1040px column, tables at about 13px). Use it for a post with tables of five or more columns or many long cells, where the default layout makes the tables scroll sideways. The styles live in `src/styles/global.css` (`main.dense`) and the page width in `src/layouts/BlogPost.astro`.
- **Commits.** Match the repo convention: `docs(blog): <lowercase summary>` with a short body, and keep distinct changes in separate commits.
