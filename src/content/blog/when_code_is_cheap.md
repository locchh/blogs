---
title: "When Code Is Cheap"
description: "Notes on software development when code is cheap."
pubDate: "2026-10-20"
author: "locchh"
draft: true
---

**Thesis:** when code is cheap, the cost moves from *writing* code to *deciding* what to build and *checking* what was built.

## Understand the business problem

- Users know what they want, not what their problem is. Building the wrong thing fast is now the expensive mistake, so framing the problem, and saying no, is the core skill.

- The real solution is rarely the framework or the app service. It's the part that is hard to change later: the data model, the boundaries between systems, who owns what, and the business rules. Tools can be swapped; those can't.

## Do high-level things

- Spend your attention on decisions that are hard to undo. Let agents make the cheap, throwaway parts: UI drafts, glue code, prototypes. Design top-down (workflow → UI → logic → data), build bottom-up (data → logic → UI), in thin slices.

- Work items are now the agent's input. An SRS, user story, or backlog task with clear acceptance criteria is something an agent can build and you can check. Bugs, change requests, and incidents are the signal that the spec was wrong.

- Open question: sprints assumed building was the slow part. If review and decisions are now the slow part, should we plan around them instead? (agile or waterfall, the bottleneck has moved).

## Continuous learning (LinkedIn, Facebook, arXiv, GitHub, etc.)

- Tools change fast; problems and patterns don't. Learn the core idea, the architecture, how the code is written, and you can judge the next ten similar tools without trying them all.

- Pick what to learn with a checklist: what it does, core idea, cost, license, does it fit my need, and only then stars and popularity. The useful core often doesn't look fancy.

- Practice a little every day: one small question, like designing an AWS architecture in 10–15 minutes. You can't work on a large codebase daily, but small practice adds up, and it doubles as interview prep.

## Check the progress, not just the bill

- Most teams track cost, time, token burn, and ticket burndown, and talk about governance and transparency. Few check whether the output is right. Verify the intermediate output (specs, code, tests, docs) with automated checks, and keep human judgment for the decisions that matter.

## An AI application engineer today has two core jobs

- Make the agent system work longer, durable, efficient, and powerful. One key part: make the agent's target verifiable. Only then can you make the work shorter and cheaper, and prove the result stayed the same.

- Build the context system around it: Jira, OneDrive, Slack, Teams, Azure DevOps, etc. The information the agent gets must be consistent, on time, and just right.

  The context system (with memory and knowledge base) grows with the organization, and the hard part changes at each level:

  - Solo dev: the repo, a CLAUDE.md or AGENTS.md, a folder of notes. Hard part: the discipline to write things down.

  - Small business: a few shared tools (Slack, Drive, Jira). Hard part: knowledge lives in people's heads, so you need one shared source of truth.

  - Manufacturer with 1,000 people: office tools plus ERP, machine data, and SOPs, often on paper or scans. Hard part: the documents say one thing and the factory floor does another, and many workers aren't at a desk.

  - Enterprise: many teams, many tools. Hard part: permissions. The agent must see only what the person asking is allowed to see, and pick the right version among many copies.

  - Corporate (many business units): each unit has its own systems and its own meaning for the same word ("customer", "order"). Hard part: shared meaning across units.

  - Global corporate: many languages, regions, and laws. Hard part: data must stay where the law says it must, and context must work across languages and time zones.

  The pattern: the amount of data grows, but the real change is the hard problem. It moves from discipline → shared truth → the gap between documents and reality → permissions → shared meaning → law and language.

## Extra thought: LLM intelligence still feels different from human intelligence

- Tao's point made me think about something beyond software development. In the discussion around [OpenAI's bulk release of math papers](https://en.wikipedia.org/wiki/OpenAI_bulk_release_of_mathematical_papers), he argues that solving problems can leave a field "less fertile" if people move on without developing the understanding, methods, questions, and community that usually grow around a solution. His concern is about the incentives around AI use. [Source](https://officechai.com/ai/terence-tao-hints-openai-wasnt-behaving-responsibly-by-simultaneously-releasing-300-math-proofs-says-its-making-math-less-fertile/).

- My own reflection, not Tao's claim: when I read or work on something, questions sometimes appear without anyone asking me to produce them. Something bothers me, connects to an old idea, or makes me wonder "what if?" I may keep thinking about it after the task is finished. That curiosity is part of what I mean by human intelligence.

- An LLM can solve a difficult problem and generate useful follow-up questions. But those outputs alone don't tell me whether anything matters to it beyond the task we gave it. Asking a model to act curious can produce good questions; it doesn't establish that the model has curiosity of its own. That's the difference I still wonder about: solving the question in front of you, and finding something you want to understand even after nobody is asking.

## Extra thought: a domain-specific language for agents

- Natural language is a rich input. A vocabulary and grammar let us express facts, logic, relationships, and ideas nobody has written before. That flexibility helps models connect ideas and produce useful, sometimes beautiful things. But the same language carries assumptions, biases, contradictions, fiction, and lies. Learning from it doesn't automatically teach a model which claims to trust. This is part of the problem, not a complete explanation of hallucination.

- An autonomous agent's main job is to solve problems and act. Conversation is useful when working with people, but it doesn't have to be the representation for every step inside the system. My question: could an agent learn and operate directly through a language built for its domain?

- By a **domain-specific language (DSL)**, I mean domain concepts with defined meanings, operations, types, and constraints. Mathematics has formulas and proof steps. A machine has states and allowed transitions. A robot has sensor readings, positions, velocities, and control signals. These representations can express a great deal within their domain without carrying all the ambiguity of everyday conversation. [DSL background](https://www.jetbrains.com/help/mps/mps-faq.html).

- The model could still be probabilistic. The input would simply leave less for it to guess. Compare "the machine seems too hot" with a temperature of `105°C`, an operating limit of `90°C`, and a sensor marked valid. The latter makes the measurement and threshold explicit. Choosing an action may still require more context, but the agent doesn't also have to infer what the speaker means by "too hot".

- This is more than asking an LLM to return JSON. A JSON field can still contain ambiguous prose or an unsupported claim. I am thinking about the representation the agent learns from and uses to reason: observations separated from assumptions, explicit units and uncertainty, and actions whose requirements and effects can be checked. Natural language could connect human intentions to that system.

- A terminology note: meaning that depends on context is different from **context-sensitive grammar** in formal language theory. Some natural-language constructions go beyond context-free grammars, but that doesn't establish that natural language requires unrestricted grammars. My concern here is implicit meaning and ambiguity, rather than its position in the Chomsky hierarchy. [Grammar background](https://www.eecs.harvard.edu/shieber/Biblio/Papers/shieber85.pdf).

- A DSL wouldn't remove false data, bad assumptions, or model errors. It could make some of them easier to detect before execution. The tradeoff is what the language leaves out: an agent may encounter a situation its domain language cannot express. It needs a way to represent the unknown or ask for help.

- Open question: can we preserve enough expressive power for new combinations and useful reasoning, while making meaning more explicit and actions easier to verify? That is a hypothesis to test, not a claim that changing the language makes the model reliable.

## References

- [Plan for AI adoption](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan) - Microsoft's guidance on turning business goals into an AI adoption plan.

- [Microsoft AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/) - A framework for matching business needs to Microsoft AI technologies.

- [Agentic AI Business Solutions Architect certification](https://learn.microsoft.com/vi-vn/credentials/certifications/agentic-ai-business-solutions-architect/) - Microsoft's certification outline for architects of AI business solutions; Vietnamese page.

- [Nobody should type code by hand anymore. Here's what's left.](https://ghuntley.com/agency/) - Geoffrey Huntley's discussion of vision, verification, and agency in software development.

- [Software doesn't need to be readable anymore. It needs to be explainable.](https://ghuntley.com/readable/) - Geoffrey Huntley's argument for rethinking software around agents and human explanation.

- [OpenAI bulk release of mathematical papers](https://en.wikipedia.org/wiki/OpenAI_bulk_release_of_mathematical_papers) - Background on the release and the debate over verification and understanding.

- [Tao's critique of mass AI problem solving](https://officechai.com/ai/terence-tao-hints-openai-wasnt-behaving-responsibly-by-simultaneously-releasing-300-math-proofs-says-its-making-math-less-fertile/) - OfficeChai's account of Tao's concerns about incentives and mathematical community building.

- [MPS FAQ: domain-specific languages](https://www.jetbrains.com/help/mps/mps-faq.html) - An introduction to DSLs, language constraints, and domain-specific notation.

- [Evidence Against the Context-Freeness of Natural Language](https://www.eecs.harvard.edu/shieber/Biblio/Papers/shieber85.pdf) - Stuart Shieber's research on natural-language constructions beyond context-free grammars.
