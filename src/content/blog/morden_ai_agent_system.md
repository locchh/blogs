---
title: "Modern AI Agent System"
description: "Notes on memory, orchestration, routing, and monitoring for AI agents."
pubDate: "2026-10-20"
author: "locchh"
draft: true
---

## The building blocks

- Memory system and memory hub: [XERJ](https://xerj.org/).

- Agent hub: [Claude Code Templates](https://www.aitmpl.com/).

- Orchestration system: [OpenRig](https://openrig.dev/).

- Routing system: [ccflare](https://ccflare.com/).

- Monitoring system.

## Do we still need a human in the loop?

- HITL is only needed when the target is vague. If the agent can see and check the result itself (steps a, b, c, d are done, the math problem is solved), why do we need a human in the loop?

- To be autonomous, the target must be clear and verifiable.

- Measure autonomy with two things: cost (tokens consumed) and verified results.

- Many companies aim for autonomy with goals like "increase sales 100%". That's a moving target: it can't be checked in time, or traced to the agent. Break the goal into targets the agent can verify (reply to every lead in 5 minutes, follow up every stale deal). The human owns the goal; the agent owns the targets.

- So the point: make your work result verifiable, more precisely.

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
