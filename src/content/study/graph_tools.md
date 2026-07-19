|                | graphify                                              | Understand-Anything                    | GitNexus                                     |
|----------------|-------------------------------------------------------|----------------------------------------|----------------------------------------------|
| Language       | Python lib + skill                                    | TypeScript monorepo (plugin)           | TypeScript monorepo (CLI/MCP + web)          |
| Extraction     | tree-sitter (code) + LLM subagents (everything else)  | LLM agents + web-tree-sitter (WASM)    | Pure static analysis, no LLM in the analyzer |
| Graph store    | NetworkX (in-memory) → JSON                           | JSON file (knowledge-graph.json)       | LadybugDB (embedded graph DB, Cypher)        |
| Primary output | `graph.html` + `GRAPH_REPORT.md` + `graph.json`             | `.understand-anything`, `knowledge-graph.json`   | `.gitnexus` + `.claude/skills/gitnexus/*`  |
| Scope          | code, docs, PDFs, images, video, DBs                  | code + docs + LLM-wiki knowledge bases | code only, 16 languages, deep                |
| Sophistication | broad & pragmatic                                     | LLM-rich, presentation-focused         | deepest static resolution                    |


## [graphify — broad ingestion, simple pipeline](https://github.com/safishamsi/graphify)

A 7-stage linear pipeline of pure functions, no shared state:

`detect → extract → build_graph → cluster → analyze → report → export`

- Extraction is hybrid. Code goes through deterministic tree-sitter (`extract.py`) producing `{nodes, edges}` with explicit per-edge confidence labels (`EXTRACTED` / `INFERRED` / `AMBIGUOUS`). Non-code (PDFs, images, video via `transcribe.py`/faster-whisper, Postgres/SCIP/cargo via `*_introspect.py`) is handled by Claude Code subagents through the skill — `llm.py` is only the fallback API path for non-Claude environments.
- Graph is NetworkX, built with 3-layer dedup (within-file `seen_ids` → idempotent `add_node` → skill-level semantic merge). Semantic nodes intentionally overwrite AST nodes for richer labels.
- The "intelligence" (god-node detection, surprises, suggested questions) lives in `analyze.py`; output is browser HTML + a markdown report.
- Its differentiator is ingestion breadth — it'll graph a YouTube video or a database schema, not just source.


## [Understand-Anything — LLM agents → teaching dashboard](https://github.com/Egonex-AI/Understand-Anything)

A multi-agent pipeline where each agent writes intermediate JSON to `.understand-anything/intermediate/` (kept off the LLM context) and a final step assembles `knowledge-graph.json`:

`project-scanner → file-analyzer → architecture-analyzer → tour-builder → graph-reviewer`
`                               (+ domain-analyzer, article-analyzer)`

- Extraction leans on LLM agents for plain-English summaries, architectural layering (API/Service/Data/UI), business-domain flows, and guided tours — static analysis (web-tree-sitter WASM) is the scaffold, the LLM adds meaning.
- The product is the React Flow dashboard: persona-adaptive UI, layer visualization, fuzzy + semantic search, diff impact. Its stated goal is pedagogy ("quietly teaches you how every piece fits"), not a precise call graph.
- Also graphs non-code knowledge bases (Karpathy-pattern LLM wikis) into clustered idea graphs.


## [GitNexus — deepest static resolution, no LLM](https://github.com/abhigyanpatwari/GitNexus)

The most engineered. A 14-phase DAG (Kahn-sorted, typed deps, single mutable `KnowledgeGraph` accumulator) builds the graph entirely from static analysis:

```
scan → structure → [markdown, cobol] → parse → [routes, tools, orm]
  → crossFile → scopeResolution → pruneLocalSymbols → mro → communities → processes
```

- No LLM in the analyzer — correctness comes from a real scope-resolution pipeline: 16 languages → one unified schema (44 node types, 21 relation types) via a `LanguageProvider`/`ScopeResolver` contract. It does 3-tier import resolution, MRO (C3/first-wins/ruby-mixin), overload disambiguation by arity+type-hash, and optional CFG/PDG/taint analysis (`--pdg`).
- Persisted to LadybugDB (embedded, Cypher-queryable, single `CodeRelation` edge table). Adds embeddings (arctic-embed-xs, 384D) + hybrid BM25/vector search (RRF).
- Exposes everything as MCP tools (`impact`, `context`, `trace`, `detect_changes`, `rename`, cross-repo `@group` routing) — built to be an agent's safe-refactoring backend, enforced via `CLAUDE.md` "run impact before editing" rules.
- Scales to the Linux kernel via a worker pool that serializes `ParsedFile`s to a disk-backed store (tree-sitter native buffers aren't GC-reclaimable).

Quickstart:

```bash
# Install
npm install -g gitnexus

# Analyze
npx gitnexus analyze

# MCP
# macOS / Linux
claude mcp add gitnexus -- npx -y gitnexus@latest mcp

# Windows
claude mcp add gitnexus -- cmd /c npx -y gitnexus@latest mcp
```
