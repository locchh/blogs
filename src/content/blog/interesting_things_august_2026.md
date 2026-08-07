---
title: "Interesting Things I Found — Aug 2026"
description: "Six finds this month — a computer made of state, a document intake, an agent-native QA, a self-updating wiki, a manager for agent fleets, and an agent that refines its own harness. The theme: the org chart around the coding agent is filling in, seat by seat."
pubDate: "2026-08-06"
author: "locchh"
tags: ["ai-agents", "tooling", "sandbox", "testing", "documentation", "multi-agent", "2026"]
draft: false
---

[Last month](/blogs/blog/interesting_things_july_2026/) I walked through fourteen tools and said the theme was learning to *operate* the agent stack. Three weeks later the theme has moved again. This batch is smaller — six finds — and none of them is really about the agent itself. They're about everything **around** it. Think of the seats around a programmer on a real team: the machine they work on, the clerk who preps their inputs, the QA who checks their output, the tech writer, the manager, and the one colleague who never forgets anything. Every one of those seats is getting an agent-native replacement.

Six tools, six seats.

---

## 1. The machine — a computer made of state

- **[cloudflare/computer](https://github.com/cloudflare/computer)** — Cloudflare's preview of a virtual computer for agents, and the design is the interesting part. The filesystem isn't a disk — it's **authoritative state in SQLite**, living in a Durable Object. Execution then *attaches to the state*, through whichever backend fits: a full Linux container that sees the files as a FUSE mount, a Bash shell in an isolate, or a JavaScript isolate — one entry point picks the backend for you. Usually we think of it the other way: a machine exists, and state lives on it. Here the state is the durable thing and the computer is the visitor — which is [this blog's whole argument about work](/blogs/blog/state-engineering/), rebuilt as infrastructure. Honest note: it's marked **preview only**, APIs unstable, explicitly not for production. *Best for:* prototypes today — and a preview of where agent runtimes are heading.

---

## 2. The intake — documents the model can eat

- **[anydoc](https://github.com/firecrawl/anydoc)** — from the Firecrawl team: Word, PowerPoint, Excel, OpenDocument, RTF, EPUB, CSV, and PDF, all converted to clean Markdown. The design choice that matters: every format parses into **one shared document model** and renders through one serializer, so a fix for one format improves all of them. It keeps the structure that usually gets mangled — merged table cells, nested lists, footnotes, speaker notes — detects formats by file signature instead of trusting the extension, and it's pure Rust with median conversions under a few milliseconds. MIT, with Node, Python, WASM, and Rust bindings, and it ships as an agent skill for Claude Code and Cursor. Limits: no encrypted files, no image-only PDFs. *Best for:* the boring, essential first step of every knowledge pipeline — the meal prep before the model eats.

---

## 3. The QA — the empty seat gets filled

- **[TestSprite](https://www.testsprite.com/)** — July's post ended on [opentest](/blogs/blog/interesting_things_july_2026/), a pre-AI testing framework I included to mark a hole: agents write unit tests all day, but end-to-end functional testing had no agent-native shape. I called it *the empty seat at the table*. This is what someone sitting down in it looks like. Point TestSprite at your **live, running app** — it explores it, plans tests, and drives a real browser or hits the real API, no mocks. When something fails it returns a **failure bundle**: a machine-readable package of failing steps, screenshots, DOM snapshots, and a suggested fix, built for a coding agent to consume and repair its own work. Passing tests persist, so coverage grows with each round. It comes as a web app, a CLI (Apache 2.0), an MCP server for Claude Code and Cursor, and CI hooks. Honest notes: the platform itself is a hosted product with paid plans, and it needs a live app to point at. *Best for:* closing the loop — one agent writes, a different thing checks.

---

## 4. The tech writer — a wiki that keeps itself current

- **[openwiki](https://github.com/langchain-ai/openwiki)** — from LangChain: a CLI where an agent reads your codebase and writes an interlinked Markdown wiki — then **keeps it current**. On scheduled CI runs it detects what changed and opens documentation PRs, so the docs rot at the speed of your review queue instead of silently. There's a personal-wiki mode too, with connectors for Notion, Slack, Gmail, and the like, plus an interactive graph visualizer over the whole thing. Two details I liked: it validates its own mermaid diagrams before shipping them (a chore I still do by hand for this blog), and the docs are honest that `.openwikiignore` stops the agent *reading* a path but can't stop it *inferring* the topic from elsewhere. MIT, and already widely used. Caveat: the visualizer loads libraries from a public CDN, so it's not fully offline. *Best for:* documentation that maintains itself — [a knowledge base that reorganizes in the background](/blogs/blog/how_to_build_knowledgebase/), applied to docs.

---

## 5. The manager — agents as teammates

- **[multica](https://github.com/multica-ai/multica)** — an open-source workspace that treats coding agents as **teammates instead of terminals**. Assign a GitHub or GitLab issue to an agent; a daemon on your own machine (or your cloud box) spawns the agent CLI — it supports twenty-plus, so no vendor lock-in; the work comes back as a pull request linked to the issue, with every tool call, command, and cost logged per run. Squads mix humans and agents, solved problems become reusable playbooks, and human review gates stand between agent output and anything shipping — [the seat that needs a watcher](/blogs/blog/the_seat_needs_a_watcher/), built into the org chart. Self-hosted over Docker or Kubernetes with Postgres, plus web, desktop, and iOS clients. Honest notes: it's Apache 2.0 *with additional terms* on self-hosting and commercial use — read the LICENSE — and you bring your own authenticated agent CLIs. *Best for:* running a fleet of agents the way you'd run a team.

---

## 6. The colleague who never forgets — an agent that carries its own state

- **[prime-agent](https://github.com/PrimeIntellect-ai/prime-agent)** — Prime Intellect's open-source agent for long-running work, and the one in this batch closest to this blog's obsessions. Two ideas stand out. First, the **RLM** (recursive language model) design: *context as variables*. Subagents aren't prompts pasted into a window — they're function calls, `rlm(...)`, that return results programmatically into a persistent Python environment. Second, the **continual harness**: prompts, memories, and skills stored as durable state that survives the session, with a `/refine` command that improves the harness *from the evidence of its own runs*. Add a background daemon (sessions persist when you disconnect and can be reattached) and autonomous mode with turn, token, and time budgets, and you get an agent built for work that outlives a terminal window. That `/refine` loop is the closest shipped thing I've seen to last month's evolver idea — the agent's own logs becoming lasting improvements. Their own caveat, stated plainly in the README: it is **not a security sandbox** — it executes model-generated Python with your user's permissions. Which is exactly the problem tool #1 exists to solve. The batch closes its own loop. *Best for:* long-horizon tasks, and for watching where harness-as-state is going.

---

## The org chart fills in

Line them up and it reads like a team roster: a machine, an intake clerk, a QA, a tech writer, a manager, and one colleague who never forgets. No single tool here is the story. The story is that the **org chart around the coding agent is filling in, seat by seat** — and that two of the seats (the computer made of state, the harness carried as state) are converging on the same idea from opposite ends of the stack.

I keep writing that the model is the rented part and the system around it is the job. This month, the job got listings.
