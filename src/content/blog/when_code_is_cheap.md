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


https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan

https://microsoft.github.io/Microsoft-AI-Decision-Framework/

https://ghuntley.com/agency/

https://ghuntley.com/readable/
