# How `/understand` Works — Pipeline Reference

A general description of the `/understand` analysis pipeline. It runs the **same way for
any codebase** — only the inputs and the resulting numbers (file counts, languages,
batches, layer names) change. This document describes the mechanics: the phases, the
scripts/tools/agents used at each step, and the outputs and how they're used.

> The pipeline is defined by the skill's `SKILL.md` inside the installed plugin
> (`<PLUGIN_ROOT>/skills/understand/`). Everything below is driven by that definition.

---

## Key conventions

| Term | Meaning |
|---|---|
| `PROJECT_ROOT` | The repo being analyzed (a directory arg, or the current working dir) |
| `PLUGIN_ROOT` | The installed plugin dir — holds `packages/`, agent defs, bundled scripts |
| `SKILL_DIR` | `<PLUGIN_ROOT>/skills/understand/` — holds the `.mjs` / `.py` pipeline scripts |
| Subagents | Dispatched via the `Agent` tool using `understand-anything:*` types (each carries its own agent definition) |
| Output dir | `<PROJECT_ROOT>/.understand-anything/` — graph, config, fingerprints, metadata |

**Tools the orchestrator uses across all phases:** `Bash` (git, pnpm, node, python3, file ops),
`Write`/`Read` (scratch scripts, context), `Agent` (subagent dispatch), `AskUserQuestion` (gates).
No `Workflow` orchestration is required — phases are driven step-by-step, with file-analysis
fanned out in concurrent waves.

---

## Phase 0 — Pre-flight

**Goal:** resolve roots, decide full vs. incremental, make sure the engine is built, gather context.

| Step | Tool / Command | Usage | Output |
|---|---|---|---|
| Worktree + commit | `Bash`: `git rev-parse --git-common-dir` / `--git-dir` / `HEAD` | If inside a git *worktree*, redirect output to the main repo (worktrees are ephemeral); capture commit hash for change detection | Resolved `PROJECT_ROOT`, commit hash |
| State check | `Bash`: check `knowledge-graph.json`, `meta.json`, subdomain graphs | Decide **full** (no graph / `--full`), **incremental** (changed files), or **review-only** | Decision |
| Build engine | `Bash`: `pnpm install` + `pnpm --filter @…/core build` in `PLUGIN_ROOT` | Later scripts import the core analysis package; build once if `dist/` is missing | `packages/core/dist/` |
| Dirs + trash purge | `Bash`: `mkdir -p .understand-anything/{intermediate,tmp}`; purge `.trash-*` older than 7 days | Scratch space; reclaim delayed-purge trash | Dirs |
| Language config | `Bash`: write `outputLanguage` to `config.json` | `--language` flag, else stored preference, else detect from conversation (English → silent) | `config.json` |
| Context collection | `Bash`/`Read`: README excerpt (3000 chars), package manifest, `find -maxdepth 2` tree, entry-point detection | Feeds scanner / architecture / tour with authoritative project context | `$README_CONTENT`, `$MANIFEST`, `$DIR_TREE`, `$ENTRY_POINT` |

**Incremental path:** `git diff <lastCommit>..HEAD --name-only` lists changed files; only those are re-analyzed.

---

## Phase 0.5 — Ignore configuration

**Goal:** create `.understandignore` and let the user trim what gets analyzed.

- `Bash` runs an inline `node -e` generator (from `SKILL.md`) that reads `.gitignore`,
  dedupes against built-in defaults, and lists detected dirs (`tests/`, `docs/`, …) and
  test-file patterns as commented suggestions.
- **Gate:** the orchestrator reports the file and **waits for user confirmation** before scanning.

**Output:** `.understand-anything/.understandignore` (user-editable, persists for future runs).

---

## Phase 1 — SCAN

**Goal:** discover every file, detect languages/frameworks, build an import map.

- **Agent:** `understand-anything:project-scanner` (via `Agent`).
- The agent internally runs the bundled **`scan-project.mjs`** + import-map extraction (these depend on `core/dist`).
- Injected context: README excerpt, manifest, layout notes, language directive.

**Output:** `intermediate/scan-result.json` — file list with `fileCategory` (code/config/docs/infra/data/script/markup),
languages, frameworks, complexity estimate, and `importMap` (pre-resolved internal imports per file).

**Gate (>100 files):** the orchestrator warns about cost/time and may use `AskUserQuestion`
to let the user scope down (subdirectory, exclude docs, etc.) before proceeding.

---

## Phase 1.5 — BATCH

**Goal:** group files into semantically cohesive analysis batches.

- **Script:** `Bash`: `node <SKILL_DIR>/compute-batches.mjs <PROJECT_ROOT>`
- **Usage:** reads `scan-result.json`, runs Louvain community detection over the import graph,
  splits oversized communities, consolidates singletons, and attaches per-batch
  `batchImportData` + `neighborMap` (cross-batch neighbors with exported symbols).

**Output:** `intermediate/batches.json`. Typical warnings: oversized communities split via
alphabetical chunking; high-fan-in files trimmed to a neighbor cap. (Captured into `$PHASE_WARNINGS`.)

---

## Phase 2 — ANALYZE

**Goal:** turn each batch into graph nodes + edges, then merge into one graph.

- **Agent:** `understand-anything:file-analyzer` — **one dispatch per batch**, run in
  **waves of up to 5 concurrent** (`Agent` tool, multiple calls in one message).
- Each agent internally runs the bundled **`extract-structure.mjs`** (tree-sitter for code,
  specialized parsers for non-code) for deterministic structure, then adds LLM-generated
  summaries, tags, complexity, and semantic edges.
- Each agent reads its batch slice (`files`, `batchImportData`, `neighborMap`) — either inline
  in the prompt or, for large batches, **self-loaded from `batches.json` by `batchIndex`** to
  keep prompts small. Output naming is strict: `batch-<i>.json`, or `batch-<i>-part-<k>.json`
  when an agent splits a large batch (the merge regex only recognizes those names).

**Outputs:** `intermediate/batch-*.json` (raw per-batch nodes/edges).

**Merge:** `Bash`: `python3 <SKILL_DIR>/merge-batch-graphs.py <PROJECT_ROOT>`
- Combines all batch files; normalizes node IDs and complexity values; rewrites edge refs;
  dedupes nodes/edges; drops dangling edges; canonicalizes `tested_by` direction
  (production → test) and tags tested production nodes; optionally recovers missing import edges.
- **Output:** `intermediate/assembled-graph.json`. Its stderr report feeds the next phase.

> Note: invoke with whichever interpreter exists (`python3` is common; `python` may be absent).

---

## Phase 3 — ASSEMBLE REVIEW

**Goal:** sanity-check the merged graph against the batches and the import map.

- **Agent:** `understand-anything:assemble-reviewer`.
- Receives the merge-script report; uses `scan-result.json`'s `importMap` to verify cross-batch
  edges and recover obvious omissions; reports dropped/recovered counts and referential integrity.

**Output:** `intermediate/assemble-review.json` (notes added to `$PHASE_WARNINGS`).

---

## Phase 4 — ARCHITECTURE

**Goal:** assign **every file-level node to exactly one architectural layer**.

| Step | Tool | Usage |
|---|---|---|
| Build input | `Bash` `node -e` | Extract file-level nodes (`file/config/document/service/pipeline/table/schema/resource/endpoint`), import edges, and all edges → an input JSON |
| Context injection | `Bash` `ls` | Read matching `languages/<lang>.md` + `frameworks/<fw>.md` from `SKILL_DIR` (skip missing); read `locales/<lang>.md` if output language ≠ `en` |
| Analyze | **Agent** `understand-anything:architecture-analyzer` | Assign all nodes to layers using directory structure + imports as evidence |
| Normalize | `Bash` `node -e` | Unwrap `{layers:[…]}` envelope, rename `nodes`→`nodeIds`, synthesize `layer:<kebab>` IDs, prefix bare paths (`file:`…), drop dangling refs, check for duplicate/unassigned |

**Output:** `intermediate/layers.json` → normalized layer array (`id`, `name`, `description`, `nodeIds`).

> Common fix: sub-file nodes (e.g. CI **`step:`** job nodes of type `pipeline`) can be left
> unassigned by the analyzer — fold them into the appropriate layer so the validator passes.

---

## Phase 5 — TOUR

**Goal:** generate a guided learning tour through the codebase.

| Step | Tool | Usage |
|---|---|---|
| Build input | `Bash` `node -e` | file-level nodes + layers + all edges → input JSON; pass README + detected entry point |
| Generate | **Agent** `understand-anything:tour-builder` | Build an ordered, README-aligned narrative (overview → entry point → core → periphery), with optional `languageLesson` per step |
| Normalize | `Bash` `node -e` | Unwrap envelope, rename legacy fields (`nodesToInspect`→`nodeIds`, `whyItMatters`→`description`), prefix bare paths, drop dangling, sort by `order` |

**Output:** `intermediate/tour.json` → normalized step array (`order`, `title`, `description`, `nodeIds`).

---

## Phase 6 — REVIEW

**Goal:** assemble the full `KnowledgeGraph` and validate it.

1. `Bash` `node -e` wraps nodes/edges/layers/tour with a `project` metadata block
   (name, languages, frameworks, `analyzedAt`, `gitCommitHash`).
2. **Default path:** `Write` an inline `tmp/ua-inline-validate.cjs` (from `SKILL.md`), then
   `Bash` run it. It checks required node fields, duplicate IDs, dangling edges, every
   file node in exactly one layer, valid tour/layer refs, orphan-node warnings, and emits stats.
   - **`--review` path:** dispatch `understand-anything:graph-reviewer` for a full LLM audit instead.
3. **Output:** `intermediate/review.json`. Auto-fix dangling edges / missing fields; if issues
   remain, save anyway with warnings and skip dashboard auto-launch.

Orphan-node warnings (nodes with no edges — common for standalone docs/config) are **non-blocking**.

---

## Phase 7 — SAVE

**Goal:** persist the graph, create the incremental baseline, write metadata, clean up, launch.

| Step | Tool / Command | Usage | Output |
|---|---|---|---|
| Write graph | `Bash`: `cp assembled-graph.json knowledge-graph.json` | The final artifact | **`.understand-anything/knowledge-graph.json`** |
| Fingerprint baseline | `Bash`: `node <SKILL_DIR>/build-fingerprints.mjs <input.json>` | **Must succeed before `meta.json`** — basis for incremental auto-updates; without it every future commit escalates to a full rebuild | `fingerprints.json` |
| Metadata | `Bash` `node -e` | Record `lastAnalyzedAt`, commit hash, version, `analyzedFiles` | `meta.json` |
| Cleanup | `Bash`: move scratch into `.trash-<ts>` (not `rm -rf`), **preserve `scan-result.json`** | `scan-result.json` lets future incrementals skip Phase 1; delayed-trash avoids tripping destructive-action gates | `intermediate/` keeps only `scan-result.json` |
| Launch dashboard | `Bash`: `pnpm install` in `packages/dashboard`, then background `GRAPH_DIR=<root> npx vite --host 127.0.0.1` | Visualize the graph; print the **tokenized URL** (`?token=…` is required by the access gate) | Dev server + URL |

Dashboard auto-launches **only if** final validation passed.

---

## Tools / agents / scripts (index)

**Built-in tools:** `Bash`, `Write`, `Read`, `Agent`, `AskUserQuestion`.

**Subagents** (`understand-anything:*`, dispatched via `Agent`):

| Agent | Phase | Role |
|---|---|---|
| `project-scanner` | 1 | File discovery, language/framework detection, import map |
| `file-analyzer` (×N batches) | 2 | Per-batch structural + semantic node/edge extraction |
| `assemble-reviewer` | 3 | Cross-check merged graph vs. batches + import map |
| `architecture-analyzer` | 4 | Layer assignment |
| `tour-builder` | 5 | Guided tour generation |
| `graph-reviewer` | 6 (`--review` only) | Full LLM validation |

**Bundled pipeline scripts** (in `SKILL_DIR`):

| Script | Phase | Run by |
|---|---|---|
| `scan-project.mjs` (+ import-map extraction) | 1 | project-scanner |
| `compute-batches.mjs` | 1.5 | orchestrator |
| `extract-structure.mjs` | 2 | each file-analyzer |
| `merge-batch-graphs.py` | 2 | orchestrator (`python3`) |
| `build-fingerprints.mjs` | 7 | orchestrator |

---

## Output artifacts and their usage

| File | Phase | Purpose / downstream use |
|---|---|---|
| `config.json` | 0 | Persisted `outputLanguage` — prevents re-prompting |
| `.understandignore` | 0.5 | User-editable exclusion list for future scans |
| `intermediate/scan-result.json` | 1 | File inventory + import map; **preserved** so incrementals skip Phase 1 |
| `intermediate/batches.json` | 1.5 | Per-batch file lists + import/neighbor data for analyzers |
| `intermediate/batch-*.json` | 2 | Raw per-batch nodes/edges (moved to `.trash-*` after save) |
| `intermediate/assembled-graph.json` | 2–6 | Merged + reviewed + metadata-wrapped graph (→ `.trash-*`) |
| `intermediate/layers.json` / `tour.json` | 4/5 | Raw layer/tour output pre-normalization (→ `.trash-*`) |
| `intermediate/review.json` | 6 | Validation report (→ `.trash-*`) |
| **`knowledge-graph.json`** | 7 | **Primary artifact** — powers the dashboard and all `/understand-*` commands |
| `fingerprints.json` | 7 | Structural baseline for incremental auto-updates |
| `meta.json` | 7 | Last-analyzed commit/timestamp — drives full-vs-incremental next run |

---

## Things that commonly need attention (any repo)

1. **Build the core engine first** — bundled scripts import `@…/core`; build if `dist/` is missing.
   Beware masking install failures by piping `pnpm install` through `tail` (the non-zero exit is lost).
2. **`>100` files** — surface cost/time and offer to scope (subdir, exclude docs/tests).
3. **Large batches** — file-analyzers split into `-part-<k>.json`; keep the exact naming or the merge drops them.
4. **Python interpreter** — use `python3` when `python` isn't on PATH.
5. **Unassigned sub-file nodes** — assign stray `step:`/`pipeline` (or similar) nodes to a layer so validation passes.
6. **Fingerprints before metadata** — never write `meta.json` if `build-fingerprints.mjs` failed.
