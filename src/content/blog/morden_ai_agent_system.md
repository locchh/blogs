---
title: "Modern AI Agent System"
description: "Notes on memory, orchestration, routing, and monitoring for AI agents."
pubDate: "2026-10-20"
author: "locchh"
draft: true
---

## The building blocks

I think we will analyze characteristics of each building blocks: why they need to exist in an mordern agent system But dont verbose

1. Memory system and memory hub: [XERJ](https://xerj.org/).

2. Agent hub: [Claude Code Templates](https://www.aitmpl.com/), [ECC](https://github.com/affaan-m/ecc)

3. Orchestration system: [OpenRig](https://openrig.dev/)

4.  LLM provider and rounting system: [ccflare](https://ccflare.com/)

5. Monitoring system [Langfuse](https://langfuse.com/), [OpenTelemetry](https://opentelemetry.io/)

6. Sandbox and specific runtime env like [GIBSON](https://offensivesec.org/GIBSON), or Phone testing like [Appium](https://appium.io/), or sandbox like [E2B](https://e2b.dev/)

## Do we still need a human in the loop?

- HITL is only needed when the target is vague. If the agent can see and check the result itself (steps a, b, c, d are done, the math problem is solved), why do we need a human in the loop?

- To be autonomous, the target must be clear and verifiable.

- Measure autonomy with two things: cost (tokens consumed) and verified results.

- Many companies aim for autonomy with goals like "increase sales 100%". That's a moving target: it can't be checked in time, or traced to the agent. Break the goal into targets the agent can verify (reply to every lead in 5 minutes, follow up every stale deal). The human owns the goal; the agent owns the targets.

- So the point: make your work result verifiable, more precisely.

- The unattended version of this: zero humans during the run, and the human's seat is between runs. We read the transcripts, edit the pack, change few things per run so each effect can be attributed, and play again. As the [migration post](/blogs/blog/migration_is_a_harness/) put it: you don't fix the code, you fix the process that produced it.

### How to distribute the work

Update env runtime to the mermaid and then this is not only about distrbute work for code, make it generic for other

- **A second agent bought zero time.** Items arrived slower than one agent finished them, so the finish time was set by arrival, not by how many agents worked. Old queueing arithmetic: more servers help only when the queue backs up. Sequential by default. Spawn a worker only when the open work will not fit before a deadline.

| When you do spawn | Rule |
| --- | --- |
| Isolation | own worktree, port, build cache, database |
| Brief | once and complete: item, worktree, deadline, evidence names |
| Report | only when done or blocked |
| Ownership | one agent commits, pushes, hands back |
| Roles | named profiles whose standing rules travel with them, not a generic worker |

### The fleet

Zoom out from one machine and the same pieces repeat.

```mermaid
flowchart TB
  subgraph PROV["providers"]
    BL["backlog server<br/>tasks, bugs, change requests, incidents"]
    SCM["source code platform<br/>repos, pull requests, CI as the checker"]
    LLM["model provider<br/>API, usage limits"]
    KB["knowledge base<br/>decisions, standards, test data"]
  end
  HUB["agent hub<br/>holds the packs, assigns items to machines,<br/>collects telemetry, where the human sits"]
  subgraph FLEET["local machines"]
    M1["machine 1<br/>supervisor + agent + sandbox"]
    M2["machine 2<br/>supervisor + agent + sandbox"]
    MN["machine n"]
  end
  BL -->|"open items"| HUB
  HUB -->|"install pack, assign item"| M1
  HUB --> M2
  HUB --> MN
  M1 -->|"telemetry"| HUB
  M1 -->|"clone, push"| SCM
  M1 -->|"calls"| LLM
  M1 -->|"rules, data"| KB
  SCM -->|"checker result"| BL
```

- **One hub, many machines.** The hub holds the packs, assigns one item to one machine, and collects every machine's log. Each machine runs one supervisor, one agent, one sandbox. The hub is also where the human sits, because the pack is edited from the logs. Three things stay outside and are rented: the backlog server, the source platform whose CI is the checker, and the model provider, whose usage limit ended two of our runs. This is the building-blocks list at the top of this post, drawn: the hub is orchestration, the routing system sits between the machines and the model provider, the knowledge base is memory, and the telemetry is monitoring.

## One harness doesn't fit all

- No. A harness is everything around the model: tools, state, the loop, the checks, the limits. Each kind of work needs its own.

| Harness for            | Tools                          | State it carries               | How it checks the work                    | Main risk                                 |
| ---------------------- | ------------------------------ | ------------------------------ | ----------------------------------------- | ----------------------------------------- |
| Coding agent           | Shell, editor, git, tests      | Repo, plan, task list          | Compiler, tests, linters (strong)         | Breaking code that works                  |
| Research agent         | Search, fetch, read PDFs       | Sources, notes, open questions | Citations, cross-checking sources (weak)  | Confident claims with no real source      |
| Back-office agent      | ERP, CRM, email, forms, Excel  | Case file, approval status     | Business rules, reconciliation, sign-off  | Actions you can't undo (payments, emails) |
| Support agent          | Ticketing, knowledge base, CRM | Customer history               | Resolution rate, policy rules             | Wrong promises to customers               |
| Data / analytics agent | SQL, notebooks, BI tools       | Schema, metric definitions     | Re-run the query, compare to known totals | A wrong number that looks right           |
| Ops / SRE agent        | Logs, metrics, deploy tools    | Incident timeline              | Health checks, rollback                   | Making an outage worse                    |

- Coding harnesses matured first because code has the strongest built-in checker: the compiler and tests say right away if it worked.

- Other harnesses are behind not because the models are worse, but because their work is harder to check.

- So: a harness is only as good as the checker you can build for its domain. Designing a new harness starts with one question: how does this agent know it's done, and done right?

## References

- [XERJ](https://xerj.org/) - Search and retrieval for the memory and knowledge layer.

- [Claude Code Templates](https://www.aitmpl.com/) - Reusable components for Claude Code workflows.

- [OpenRig](https://openrig.dev/) - Orchestration for teams of coding agents.

- [ccflare](https://ccflare.com/) - Routing for model requests.

- [Claude Code documentation](https://code.claude.com/docs/en/overview) - Overview of Anthropic's coding agent.

- [Codex documentation](https://developers.openai.com/codex) - Guides for OpenAI's coding agent.

- [GitHub Copilot documentation](https://docs.github.com/en/copilot) - Guides for GitHub's AI coding tools.

- [Copilot CLI overview](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview) - Using Copilot from the terminal.

- [OpenCode documentation](https://opencode.ai/docs) - Setup and usage guides for OpenCode.
