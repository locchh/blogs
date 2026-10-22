---
title: "When Code Is Cheap"
description: "Notes on software development when code is cheap."
pubDate: "2026-10-20"
author: "locchh"
draft: true
---

**Thesis:** when code is cheap, the cost moves from *writing* code to *deciding* what to build and *checking* what was built.

- Understand the business problem

    - Users know what they want, not what their problem is. Building the wrong thing fast is now the expensive mistake, so framing the problem, and saying no, is the core skill

    - The real solution is rarely the framework or the app service. It's the part that is hard to change later: the data model, the boundaries between systems, who owns what, and the business rules. Tools can be swapped; those can't

- Do high-level things

    - Spend your attention on decisions that are hard to undo. Let agents make the cheap, throwaway parts: UI drafts, glue code, prototypes. Design top-down (workflow → UI → logic → data), build bottom-up (data → logic → UI), in thin slices

    - Work items are now the agent's input. An SRS, user story, or backlog task with clear acceptance criteria is something an agent can build and you can check. Bugs, change requests, and incidents are the signal that the spec was wrong

    - Open question: sprints assumed building was the slow part. If review and decisions are now the slow part, should we plan around them instead? (agile or waterfall, the bottleneck has moved)

- Continuous learning (LinkedIn, Facebook, arXiv, GitHub, etc.)

    - Tools change fast; problems and patterns don't. Learn the core idea, the architecture, how the code is written, and you can judge the next ten similar tools without trying them all

    - Pick what to learn with a checklist: what it does, core idea, cost, license, does it fit my need, and only then stars and popularity. The useful core often doesn't look fancy

    - Practice a little every day: one small question, like designing an AWS architecture in 10–15 minutes. You can't work on a large codebase daily, but small practice adds up, and it doubles as interview prep

- Check the work, not just the bill

    - Most teams track cost, time, token burn, and ticket burndown, and talk about governance and transparency. Few check whether the output is right. Verify the intermediate output (specs, code, tests, docs) with automated checks, and keep human judgment for the decisions that matter

    - An AI application engineer today has two core jobs:

        - Make the agent system work longer, durable, efficient, and powerful. One key part: make the agent's target verifiable. Only then can you make the work shorter and cheaper, and prove the result stayed the same

        - Build the context system around it: Jira, OneDrive, Slack, Teams, Azure DevOps, etc. The information the agent gets must be consistent, on time, and just right

            - The context system (with memory and knowledge base) grows with the organization, and the hard part changes at each level:

            - Solo dev: the repo, a CLAUDE.md or AGENTS.md, a folder of notes. Hard part: the discipline to write things down

            - Small business: a few shared tools (Slack, Drive, Jira). Hard part: knowledge lives in people's heads, so you need one shared source of truth

            - Manufacturer with 1,000 people: office tools plus ERP, machine data, and SOPs, often on paper or scans. Hard part: the documents say one thing and the factory floor does another, and many workers aren't at a desk

            - Enterprise: many teams, many tools. Hard part: permissions. The agent must see only what the person asking is allowed to see, and pick the right version among many copies

            - Corporate (many business units): each unit has its own systems and its own meaning for the same word ("customer", "order"). Hard part: shared meaning across units

            - Global corporate: many languages, regions, and laws. Hard part: data must stay where the law says it must, and context must work across languages and time zones

            - The pattern: the amount of data grows, but the real change is the hard problem. It moves from discipline → shared truth → the gap between documents and reality → permissions → shared meaning → law and language

    - Example: OpenAI's bulk release of 722 AI-written math papers (Oct 2026). Proofs were cheap, checking was not: some Lean proofs proved weaker claims, papers were withdrawn within a day, and experts carry the review load. Terence Tao: AI should serve human understanding. https://en.wikipedia.org/wiki/OpenAI_bulk_release_of_mathematical_papers

        - Tao's point: mass AI solving leaves math "less fertile". The answers exist, but the people who move on don't do the follow-up work (new methods, new questions, seminars) that a hard problem usually sparks. He blames the incentive, not the tool. https://officechai.com/ai/terence-tao-hints-openai-wasnt-behaving-responsibly-by-simultaneously-releasing-300-math-proofs-says-its-making-math-less-fertile/

        - My speculation (not Tao's): a model works from patterns it has seen, so it can solve a lot without anything sparking inside it. It doesn't ask "what if?" on its own. When it asks a question, the question is an output, because asking was the task. A human is different: when we read, questions spark even when we aren't trying. So the follow-up questions still have to come from us


https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan

https://microsoft.github.io/Microsoft-AI-Decision-Framework/

https://learn.microsoft.com/vi-vn/credentials/certifications/agentic-ai-business-solutions-architect/

https://ghuntley.com/agency/

https://ghuntley.com/readable/
