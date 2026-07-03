# Agent Memory Tools — Comparative Study

A deep look at six persistent-memory frameworks for AI agents, with side-by-side
tables on **features**, **architecture**, and **mechanisms**, followed by the contrasts
that actually separate them.

## The six tools

- **[claude-mem](https://github.com/thedotmack/claude-mem)** — persistent memory for
  Claude Code via lifecycle hooks; SQLite+FTS5 + Chroma; progressive disclosure for
  ~10× token savings on recall.
- **[mem0](https://github.com/mem0ai/mem0)** — multi-tier (user/session/agent) memory
  with hybrid vector + BM25 + entity-linking retrieval and a two-phase extract→update
  pipeline.
- **[cognee](https://github.com/topoteretes/cognee)** — graph + vector hybrid with
  ontology grounding and a remember–recall–forget–improve control loop.
- **[zep](https://github.com/getzep/zep)** — context-engineering platform built on
  **Graphiti**, a temporal knowledge graph with bi-temporal facts (`valid_at` /
  `invalid_at`).
- **[letta](https://github.com/letta-ai/letta)** — MemGPT successor; OS-style tiered
  memory (core/archival/recall) that the agent self-edits via tool calls.
- **[engram](https://github.com/Gentleman-Programming/engram)** — single Go binary,
  local-first, MCP-accessible persistent memory for coding agents (SQLite + FTS5).

## 1. Features

| Tool | Primary use | Storage location | Interface / integration | Multimodal | License/model |
|---|---|---|---|---|---|
| **claude-mem** | Cross-session memory for Claude Code & CLI agents | Local SQLite + Chroma; Bun worker on `:37777` | Lifecycle **hooks** + `mem-search` skill + web viewer | Text/tool-use observations | Open source |
| **mem0** | General agent memory layer | Library, self-hosted server, or managed **cloud** | Python/TS SDK, REST, MCP; LangGraph/CrewAI | Text (+ some multimodal) | OSS core + paid platform |
| **cognee** | "Memory control plane" / knowledge infra | Relational + vector + graph; cloud or self-host | Python SDK, MCP, Claude Code plugin | Multimodal ingestion | OSS + Cognee Cloud |
| **zep** | Production context-engineering platform | Managed cloud (Graphiti graph DB) | Python/TS/Go SDK; `thread.add`/`graph.add` | Chat, business data, docs, emails | Commercial (OSS Graphiti core) |
| **letta** | Stateful self-improving agents (full runtime) | Server + Postgres; cloud or self-host | Letta Code CLI + REST/Python/TS API | Text; tools/web | OSS (Apache) + cloud |
| **engram** | Local-first memory for *any* coding agent | Single SQLite file `~/.engram/engram.db` | **MCP** + HTTP + CLI + TUI (19 tools) | Text observations | OSS, single Go binary |

## 2. Architecture

| Tool | Memory model | Datastores | Indexing / search backbone | Notable structural unit |
|---|---|---|---|---|
| **claude-mem** | Flat session→observation→summary log | **SQLite + FTS5** + **Chroma** | Hybrid keyword + semantic | "Observation" (compressed tool-use event) |
| **mem0** | **4-tier**: conversation → session (`run_id`) → user (`user_id`) → org | Vector store (+ optional **graph store**) | Vector + **BM25** + entity-linking, fused | "Memory" (extracted fact) |
| **cognee** | **3-tier hybrid**: relational + vector + graph | Relational (provenance) + vector + graph DB | Vector similarity + graph traversal; auto-routing | **DataPoint** → node; Tasks→Pipelines |
| **zep / Graphiti** | **Temporal knowledge graph** (entities=nodes, facts=edges) | Graph DB: Neo4j / FalkorDB / Kuzu / Neptune + OpenSearch | **Hybrid**: semantic + BM25 + graph-distance rerank | "Episode" (provenance) → entity/edge triplets |
| **letta** | **OS-style tiers**: core (in-context) vs external (archival + recall) | Postgres + vector (pgvector) | Archival = embedding search; recall = conversation search | **Memory block** (label/description/value/limit) |
| **engram** | Flat observation store, agent-agnostic | **SQLite + FTS5**, single file | Full-text search; optional cloud replica | "Observation" (title/type/metadata) |

## 3. Mechanisms

| Tool | Write / extraction | Update & conflict handling | Recall | Token-efficiency trick |
|---|---|---|---|---|
| **claude-mem** | `PostToolUse` captures raw observations → LLM **compresses to summaries** at `Stop`/`SessionEnd` | Append-only log of summaries | `SessionStart` queries DB+Chroma, injects matching summaries | **Progressive disclosure**: search → timeline → get_observations ≈ **10×** savings |
| **mem0** | **Two-phase**: LLM extracts facts → LLM chooses **ADD / UPDATE / DELETE / NOOP** vs existing (`infer=False` stores verbatim) | Conflict resolution — "latest truth wins"; temporal reasoning | Vector + BM25 + entity-link scores **fused**; tiers ranked (user first) | Extract-then-store compresses raw turns into compact facts |
| **cognee** | **Cognify**: parse → chunk → extract entities/relations → build graph; **ontology (RDF/XML)** grounding | `Forget` at item/dataset/user scope; `Improve` enriches & promotes session→permanent | `Recall` with **auto-routing** (vector vs graph); Node Sets for scoping | Graph connections reduce redundant re-embedding |
| **zep / Graphiti** | **Incremental**: each `episode` → LLM extracts entities & fact-edges (prescribed *or* learned ontology) | **Bi-temporal**: edges carry `valid_at`/`invalid_at`; newer facts **invalidate (not delete)** older — history kept | `graph.search` / `thread.get_user_context` returns pre-built **Context Block** | Pre-assembled context block; <200ms, no LLM at query time |
| **letta** | Agent **self-edits** via tools: `core_memory_append/replace`, archival insert | Agent decides rewrites; eviction when a block hits its char **`limit`**; "sleep-time" agents reorganize offline | Core blocks **always in context** (XML-prepended); archival/recall via search tools + **heartbeat** loop | Tiered paging: hot facts in-context, cold facts to archival |
| **engram** | Agent explicitly **saves** observations via MCP tools | Conflict-detection tools; git export/import merges across machines | FTS5 full-text search via MCP `search` | Single-binary local search; no embedding/LLM overhead by default |

## Key contrasts

- **Graph vs flat** — cognee and zep/Graphiti are genuine knowledge graphs (relationships
  are first-class); mem0 and letta are graph-*optional*; claude-mem and engram are flat
  log + full-text stores (simpler, local, no LLM at recall).
- **Who edits memory** — *the agent itself* (letta, MemGPT model) vs a *background LLM
  pipeline* (mem0/cognee/zep) vs *mechanical capture by hooks/tool calls* (claude-mem/engram).
- **Temporal handling** — only **zep/Graphiti** has true bi-temporal fact invalidation;
  mem0 does lighter "latest-truth-wins" conflict resolution.
- **Closest to a Claude-native stack** — **claude-mem** and **engram** mirror the Claude
  Code model (hooks + local SQLite + observation files). Graph systems (cognee/zep) are
  the architectural step *up* for relationship-aware recall.

---

See [hebb.md](hebb.md) for the Hebbian theory these tools loosely descend from, and
[README.md](README.md) for the full link collection (foundations, harness engineering,
code-as-knowledge-graph, research, Claude-native primitives).
