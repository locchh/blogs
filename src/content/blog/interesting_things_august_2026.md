---
title: "Interesting Things I Found — Aug 2026"
description: "Six finds this month — a computer made of state, a document intake, an agent-native QA, a self-updating wiki, a manager for agent fleets, and an agent that refines its own harness. Plus a late postscript: four tools from one vendor trying to staff the whole column at once. The theme: the org chart around the coding agent is filling in, seat by seat."
pubDate: "2026-08-06"
author: "locchh"
tags: ["ai-agents", "tooling", "sandbox", "testing", "documentation", "multi-agent", "security", "openai", "2026"]
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

---

## Postscript: one vendor, the whole column

The six above were written first. Then four more crossed my desk — three new, one I went back for — all from the same place, and they make the opposite point. Everyone above fills **one seat**. OpenAI is staffing the **whole column** at once: the worker, the reviewer, the kit for building your own team, and the meter that counts what they all spend. One of them is even the thing the other six were all *around* — the agent itself.

- **[codex](https://github.com/openai/codex)** — **the worker.** A coding agent that runs on your own machine: terminal, editor, or a desktop app. I'm not here for the agent part. I'm here for how it handles permission, because that's two dials you set once in a config file instead of a decision you make in a panic at 2am. The **sandbox** dial has three settings: read-only (look, don't touch), workspace-write (the default — read anything, write inside the workspace, run local commands there, network restricted by default), and full access (the walls come down). The **approvals** dial is separate: ask before any untrusted command, ask only when the agent needs out of the sandbox, or never ask. And the walls are enforced by the operating system, not by asking the model nicely. Apache-2.0. Honest note: you sign in with a ChatGPT plan or bring an API key, so the agent is open but the brain is rented. *Best for:* a local agent where "what is it allowed to do" is a setting, not a hope.
- **[codex-security](https://github.com/openai/codex-security)** — **the security reviewer.** Point it at a repo and it hunts for vulnerabilities, checks the ones it finds, and proposes fixes — *finding, validating, and fixing*, not just flagging. Two details I liked. **Deep mode** runs several workers and keeps going until a few rounds turn up nothing new, so it stops when the well runs dry instead of at a fixed count. And `scans compare` matches findings between two scans **by root cause**, so you get new, persisting, reopened, and resolved — a vulnerability diff across versions, which is the thing you actually want in CI. You can also hand it a folder of security notes to share across every repo it scans. CLI and TypeScript SDK, Apache-2.0, and it will happily drive a rival's model through a third-party provider. Honest notes: some requests need approval through their **Trusted Access for Cyber** program, so this isn't install-and-go. And the README is unusually blunt about its own blind spot — "Missing findings remain unknown when coverage is incomplete or their original location was not reviewed." A clean scan is not a clean bill of health. *Best for:* the seat next to the QA — one agent writes the code, another reads it for the ways it can be abused.
- **[openai-agents-python](https://github.com/openai/openai-agents-python)** — **the staffing kit.** If the tools above are seats, this is how you build one yourself, and it stays small on purpose. An **agent** is a model with instructions, tools, and guardrails. A **handoff** passes the conversation to a more specialized agent, and an agent can also be wrapped as a plain tool for another agent to call. **Guardrails** check what goes in and what comes out. **Sessions** carry history between runs so you stop re-pasting it. **Tracing** records every run so you can see where it went wrong. It also ships **sandbox agents** that work inside a container from a manifest — hand it a git repo and let it read around for a while — plus realtime and voice agents. It doesn't lock you to OpenAI's models; it talks to a hundred others. MIT. *Best for:* building your own org chart instead of buying somebody else's.
- **[tiktoken](https://github.com/openai/tiktoken)** — **the ruler.** Not a seat, and not new — it has been the tokenizer for OpenAI's models for years. It's here because I'm picking it back up, and the reason is sitting one section above. Tool #6 gives its agent turn, token, and time budgets. The fleet manager logs cost per run. Every one of those counts *after* the money is gone. tiktoken counts **before**: give it text and an encoding, get the exact token count, and you can price a prompt, cap a context window, and size a chunk before anything is sent. Worth knowing what BPE actually buys you here: it's reversible and lossless, it works on text it has never seen, and it compresses — about **4 bytes per token** on average. That average is the back-of-envelope every budget starts from. There's a small educational module that shows you the merge steps as they happen, and a plugin hook for registering your own encoding. MIT. *Best for:* turning "tokens" from a line on an invoice into a number you set in advance — [starting at the cheap end](/blogs/blog/start_at_the_cheap_end/) only works if you can read the price tag.

Four tools, one vendor: the worker, the reviewer, the kit, and the meter. The six above say the org chart is filling in from all directions. These four say something sharper — that the whole chart is worth owning, and at least one company is betting on it. I don't think that bet is wrong. I do think it's the reason to keep every seat swappable. The model was always the rented part; try not to rent the whole floor.
