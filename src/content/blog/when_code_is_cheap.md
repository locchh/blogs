---
title: "When Code Is Cheap"
description: "AI output is useful when the next step can use it. How to validate handoffs, measure real savings, and build a learning loop for new technology."
pubDate: "2026-10-24"
author: "locchh"
draft: false
---

Imagine a team builds an AI tool to summarize support tickets. The summaries arrive in seconds. They read well. The demo looks good.

Then a support engineer tries to use one. The summary left out the customer's software version. It mixed a proposed fix with something the customer had already tried. The engineer opens the original conversation and reads it again.

The tool produced its output. The next person still has the same work to do, plus one more document to check.

This is the question I keep coming back to when people ask whether AI will save money or improve productivity: **what happens after the output is produced?**

When code is cheap, we can build more things. But the expensive work moves toward deciding what deserves to exist, checking whether it works, and making sure someone can actually use the result.

## The next step is part of the specification

We often describe an application by what it can do. It can summarize documents, generate code, answer questions, or create reports. Those are capabilities. A business needs to know what those capabilities make possible.

A ticket summary should help an engineer choose the next diagnostic step. A specification should help a developer build the intended behavior. A report should help someone make a decision. Their quality depends partly on the work that follows them.

| Output | A check inside the current step | A check at the next step |
| --- | --- | --- |
| Ticket summary | Clear writing; required sections present | Can the engineer choose a useful diagnostic step without reconstructing the whole conversation? |
| Feature specification | Complete template; no obvious contradictions | Can a developer build it and a tester distinguish correct behavior from an incorrect interpretation? |
| Generated code | Compiles; component tests pass | Does it preserve the behavior its callers need, and work in the real user journey? |
| Technology digest | Recent links; readable summaries | Can the team decide what deserves an experiment, with evidence for that decision? |

The checks in the middle column matter. They catch real defects. But they cannot establish the result in the last column by themselves.

I would separate three questions: **was it produced, could the next step use it, and did the whole workflow improve?** A summary can pass the first and fail the second. It can pass both while the customer still waits three days because the support queue is understaffed.

This is familiar ground in integration testing and thinking about a whole system. AI makes it easier to forget, because producing a convincing intermediate result has become so easy.

**Lesson: define an output together with the work it must enable.**

## Work backward from the person who receives it

For the support tool, I would begin with an engineer doing real ticket triage. What information do they look for? What omission forces them to start over? What could send them down the wrong path?

The answers become requirements. Preserve the environment and version. Separate observed symptoms from guesses. Distinguish attempted fixes from suggestions. Link important claims to the source messages. Make missing information visible.

Then test the handoff. Give an engineer the summary and access to its evidence. Observe whether they can choose an appropriate next action, how long that takes, and what they need to repair. Compare with the existing process on similar cases. Keep a sample for which an experienced reviewer has checked the important facts and reasonable next actions.

There is a difference between opening a source to verify a key fact and reopening every source because the summary cannot be trusted. Record both. Otherwise, we might reward a tool for reducing source checks by encouraging people to trust it blindly.

The receiving step also needs a way to reject the output: missing version, unsupported conclusion, wrong customer, stale policy. Those reasons should travel back to the step that produced it. A rejection is useful evidence for the next improvement.

If another agent receives the summary, the same principle applies. A second model saying it looks good is weak evidence. Test whether it can perform the intended task, and check its action against the source facts and business rules. Both agents can share the same misunderstanding.

For each handoff, I want five things written down:

1. Who or what receives the output.
2. What that receiver needs to do with it.
3. What evidence supports accepting it.
4. When it must be rejected, corrected, or escalated.
5. How we will discover a failure that appears later.

The fifth one matters. A reply can be accepted today and cause a reopened ticket tomorrow. A migration can pass staging and fail at month-end. Choose an observation period that fits the work. Keep local checks, checks at the handoff, and checks on the final outcome. Each answers a different question.

## An AI project is also a management decision

The technical question is whether the system can do the task. The management question is whether changing the task improves the operation enough to justify building and maintaining the system.

Microsoft's [AI adoption planning guide](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan) starts with business problems, then use cases, and then an assessment of skills, data, and infrastructure. The [Microsoft AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/) also puts outcomes before products. I would turn that into a project plan like this.

**First, describe the delay or loss.** A user may ask for a chatbot because that is the solution they can picture. Investigate what happens around the request. Perhaps staff cannot find an answer. Perhaps they find it quickly but wait for approval. A chatbot addresses those situations very differently. Users bring essential knowledge of their work; our job is to explore the problem with them.

**Second, measure the current workflow.** For support, record time spent reading, investigating, reviewing, waiting, and correcting mistakes. Count resolved cases and reopened cases. Include awkward cases and exceptions. Decide what a completed outcome means before changing the process.

**Third, choose the smallest useful intervention.** A better search filter, a form that collects missing information, or a fixed rule might solve the problem. AI earns its place where interpreting varied input is useful enough to justify its uncertainty and operating cost. Compare configuring an existing product with building something custom.

**Fourth, fund a complete pilot.** Include integration, evaluation, staff training, and support after launch. Name the business owner who accepts the outcome and the technical owner who keeps the service working. Microsoft's [business solutions architect certification outline](https://learn.microsoft.com/vi-vn/credentials/certifications/agentic-ai-business-solutions-architect/) includes business success measures, operational monitoring, and ROI analysis alongside architecture. Those responsibilities belong in the project from the beginning.

**Fifth, decide in advance what would make us expand, revise, or stop.** For example, the pilot might require less total handling time while keeping the existing quality standard and reopening rate. Specify the sample, observation period, and unacceptable failures before looking at the results. The exact thresholds depend on the business. A good demo is evidence to keep investigating, not automatic permission to roll out everywhere.

The workflow boundary matters here too. Drafting a suggested reply and sending it to a customer are different responsibilities. Decide which actions the system can take, which require review, and who handles exceptions. The work still needs an owner when it leaves the demo.

## Count the work that moves somewhere else

AI may save the person who requests an output time while costing the person who receives it more time. A developer finishes faster; a reviewer gets a much larger change. A manager generates a report instantly; three analysts spend an afternoon correcting it.

I want to count that transfer before claiming a saving.

Here is an **illustrative cost model**, using invented numbers. Assume 1,000 support cases reach the same resolution standard each month. Labor is valued at $30 per hour. Today each case takes 12 minutes of total human work, including checking and corrections. That is $6,000 of labor capacity a month.

Suppose an AI system costs $12,000 to build and integrate. Spread that cost over 12 months for this comparison. Model and infrastructure usage cost $1,000 a month, and routine operation costs another $500. Human handling time includes checking, exceptions, and later corrections, across everyone involved.

| Monthly cost for the same 1,000 resolved cases | Current process | AI: 5 human minutes per case | AI: 9 human minutes per case |
| --- | --- | --- | --- |
| Human handling | $6,000 | $2,500 | $4,500 |
| Model and infrastructure usage | $0 | $1,000 | $1,000 |
| Routine operation | $0 | $500 | $500 |
| Build cost spread over 12 months | $0 | $1,000 | $1,000 |
| **Total** | **$6,000** | **$5,000** | **$7,000** |

In one case, AI saves $1,000 a month on this basis. In the other, it costs $1,000 more. Both can have the same impressive generation speed. The difference is the human work left around the output.

This simplified comparison holds resolution quality and volume constant. It assumes other costs are unchanged and includes routine corrections in handling time. A real budget must also account for training, transition work, unusual incidents, and the consequences of errors. If quality changes, put that change beside the cost; a cheaper process producing worse outcomes is a different proposal.

Also, released staff time is capacity. It becomes a cash saving only if spending actually falls, such as reduced overtime or avoided hiring. It can instead support more customers or better service. Say which benefit the project is claiming, and show where the released time goes.

The useful measure is **total cost per validated outcome**. Include failed attempts, retries, review, and recovery in the cost. Include only outcomes that meet the agreed standard in the count. Report the share of incoming cases that reached that standard alongside the unit cost, and keep rejected and unfinished cases visible. Otherwise, dropping difficult work can make the average look better. The Decision Framework's [evaluation criteria](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/evaluation-criteria.html) similarly includes engineering effort and ongoing consumption in ownership cost.

## Productivity needs evidence from your own workflow

There is evidence of real gains. In the revised paper [Generative AI at Work](https://arxiv.org/abs/2304.11771), researchers studied 5,172 customer support agents. AI assistance increased issues resolved per hour by 15% on average, with different effects across experience levels. That is a useful result tied to a particular task and setting.

There is also evidence that expectations can mislead us. [METR's early-2025 study](https://arxiv.org/abs/2507.09089) randomized AI access across 246 tasks completed by 16 experienced open-source developers. AI access increased completion time by 19%, even though participants believed it had helped. This describes those tools, developers, and repositories at that time. In its [February 2026 update](https://metr.org/blog/2026-02-24-uplift-update/), METR reported signals of improvement but explained that selection effects and time-measurement problems made the newer estimate unreliable.

These studies do not provide a universal percentage to paste into a business case. They give us a reason to measure, including when everyone feels faster. [DORA's 2025 report](https://dora.dev/research/2025/dora-report/) makes a related organizational point: AI amplifies existing strengths and weaknesses, so returns depend on the system around the tools.

For a pilot, compare similar work with and without assistance where practical. Random assignment gives a stronger comparison than asking volunteers to choose their easiest tasks. Record case difficulty, user experience, and the model and workflow versions. A before-and-after comparison can still help, but staff changes, seasonal demand, and a different mix of cases can explain part of the result.

Track total human effort, elapsed time to the final outcome, quality failures, and cost. Look at slow cases as well as the average. Set a review date, but also require enough completed cases and enough time for delayed failures to appear. If the evidence is thin, extend or narrow the claim.

Watch the queue after the automated step. If an agent creates forty changes a day and the team can review ten, more generation does not increase delivery. Work piles up. Keep changes small, limit unfinished work, and improve the constrained step. The time saved writing code might be best spent helping review and integration.

That also changes planning. Sprints can still provide a useful rhythm. But if decisions and review are the constraint, filling the sprint with more implementation tasks will not fix it. Plan around what the team can finish and validate.

## What developers should spend their attention on

Geoffrey Huntley's [essay on agency](https://ghuntley.com/agency/) emphasizes vision and verification as more coding becomes automated. I take that as a useful challenge, without assuming every team has already reached the same level of automation.

Spend attention on decisions that shape everything downstream: the data model, system boundaries, ownership, and business rules. These can change, but changing them often forces many other things to change. A UI draft or small prototype is usually cheaper to throw away.

Start from the business workflow and the user's experience. Work out the logic and data they require. Then build a thin path through the system, with enough real data and integration to exercise the handoffs. A working screen alone cannot prove that path.

A work item is itself an input to the next step. An SRS, user story, or bug report should carry the intended outcome, relevant context, acceptance criteria, and examples of failure. If an agent produces exactly what the ticket says and the result is unusable, inspect the ticket too. Bugs and incidents may reveal a missing rule, an implementation defect, or an assumption that no longer holds.

Huntley's [essay on explainable software](https://ghuntley.com/readable/) asks what changes when agents become major users of programming tools. My practical test is whether the people responsible for a system can investigate and safely change it. An explanation helps, but its claims still need to match the running behavior.

An AI application engineer has two connected jobs. Build an execution system that can keep working: tools, saved state, bounded retries, useful checks, and recovery. Then build the context system that supplies what the work needs. Make success observable before optimizing token use or run time. I explored the order of those optimizations in [Start at the Cheap End](/blogs/blog/start_at_the_cheap_end/).

## Context is an organizational problem

Connecting Jira, OneDrive, Slack, Teams, and a repository gives an agent access to information. Someone still has to decide which information is current, what it means, and who is allowed to use it.

The difficult part changes as the organization grows. These are examples of what I would investigate, rather than a fixed maturity ladder.

| Setting | Context the work may need | The question I would ask first |
| --- | --- | --- |
| Solo developer | Repository, AGENTS.md or CLAUDE.md, notes | Are important decisions written down and kept current? |
| Small business | Shared documents, chat, issue tracker | Which source wins when people and tools disagree? |
| Manufacturer with 1,000 people | ERP, machine data, SOPs, paper records | Do the documents match the factory floor, including work done away from a desk? |
| Enterprise | Many teams, versions, and access rules | Can the agent find the right version using the requesting person's permissions? |
| Company with several business units | Separate systems and definitions | Does “customer” or “order” mean the same thing across the units involved? |
| Global company | Regional systems, languages, and time zones | Can the workflow respect data-location requirements and preserve meaning across regions? |

The same failure can cross several boundaries. A correct answer from an obsolete policy is still wrong for today's decision. A document that one employee can read may be unavailable to another. Every connector should preserve enough source, version, and access information for the receiving step to judge what it got.

This is why context work needs business owners as well as engineers. A retrieval system can find two conflicting policies. It cannot settle who has authority to change the policy just by retrieving more text.

## Build a learning loop that ends in a decision

Developers face a similar input problem with new technology. LinkedIn, Facebook, arXiv, GitHub, and newsletters supply more discoveries than anyone can investigate. A daily AI summary can make that pile easier to read while leaving us with the same unanswered question: what should we do with it?

I would build a small learning loop around the team's actual problems. This is a proposed mechanism, rather than a system I am claiming to have deployed.

**Keep a short list of questions.** For example: our retrieval misses facts inside tables; agent runs become expensive after many turns; deployment takes too much manual work. Add constraints such as license, data access, budget, and available hardware. This gives the search a purpose beyond finding whatever is popular.

**Collect on a schedule.** A daily job can read a maintained list of release feeds, repository releases, and research searches related to those questions. Store the original URL, publication date, retrieval date, and the question it might help answer. Social posts can point to a discovery; follow them to the underlying release, paper, documentation, or code. Record a failed fetch as missing evidence.

**Check and filter before summarizing.** Group repeated announcements about the same release. Separate an author's claim from an independently reproduced result. Check the license and project status in the primary source. Treat stars and attention as discovery signals. Keep source content separate from the instructions controlling the collector, so a retrieved page cannot redefine its job.

**Produce a few decision cards.** Each card should explain what changed, which current problem it might help, the core mechanism, the evidence, likely costs, and what remains unknown. End with a proposed action: ignore, watch, or run one bounded experiment. “No relevant change this week” is a useful output. It saves the receiving developer from inventing work to justify the digest.

For example, an illustrative card might say: a parser's release notes claim better extraction of table cells; our unresolved problem is losing the relationship between a number and its column header. Link the exact release and its evidence. Propose a one-hour test on thirty of our documents, comparing the current parser and the candidate. The receiving developer now has a question to test, rather than another tool name to research. The claim stays marked unverified until the experiment provides evidence.

**Test one candidate against the existing approach.** Reserve time during the working week. For the table-retrieval problem, use representative documents and questions with checked answers. Compare answer quality, missing evidence, response time, and cost. Set a time and spend limit. A ten-minute daily exercise can build familiarity; a larger adoption decision needs stronger evidence than that exercise provides.

**Save the decision and revisit it when something changes.** Record the problem, source and version, experiment, result, and why the team adopted, deferred, or rejected it. Let a relevant release or a new failure reopen the question. Track previously seen candidates so the collector does not recommend the same rejected idea every week without new evidence.

This can start with a scheduled script, a small source list, and a shared folder of experiment notes. Run collection daily, review a shortlist weekly, and set aside one protected experiment slot. Assign someone to maintain the source list and someone to make the adoption decision; in a small team that may be the same person. Add infrastructure when the workflow needs it. Automating collection helps us stay aware; doing and explaining the experiment is where understanding grows.

The collector should be evaluated like the support tool. Did its cards lead to useful experiments? Did it repeatedly recommend irrelevant things? Audit a sample of rejected items too, or we will never notice what the filter missed. An experiment that shows a popular tool is a poor fit can save weeks of adoption work.

The output of learning should make the next decision better. Counting links read or tools installed misses that result. I made a related point in [How to learn?](/blogs/blog/how_to_learn/): qualify the source before investing in the lesson.

## Keep the knowledge that lets us do the next thing

This connects to a concern outside software. In [Math 2.0](https://terrytao.wordpress.com/2026/10/10/math-2-0/), Terence Tao calls for AI use that sustains mathematical understanding and the mathematical community. My own connection to engineering is that producing a result and developing the ability to build on it are different achievements.

A team may ship code while losing the understanding needed to operate it. A developer may finish an experiment while leaving no record of why it failed. The next person inherits the artifact and has to reconstruct the reasoning.

Keep the decisions, evidence, limitations, and unanswered questions with the result. This gives the next person somewhere to start. It also leaves room for the curiosity I still associate with human intelligence: something bothers us, connects to an old idea, and keeps us thinking after the assigned task ends. A model can produce useful follow-up questions, but that output alone does not settle whether it has curiosity of its own.

There is another open question I want to keep open: **what kind of input could support an agent's ability to learn, reason, and discover?** Natural language has vocabulary and grammar that let us express relationships and ideas nobody has written before. It also carries assumptions, biases, contradictions, fiction, and lies. Could another kind of input preserve useful expressive power while making some of those problems easier to handle?

For an agent whose job is to solve problems and act, what input would help it learn about actions and their consequences? Mathematics, machine states, sensor readings, and interaction with an environment give me places to look. I have not decided what form such an input should take. Would it need something like vocabulary and grammar? How would it carry context or uncertainty? What new relationships could a model discover? Whether changing the input would help with errors or hallucination is also a question to investigate.

For today's projects, we can already change where we look for proof. Follow the output into the work that uses it. Count the effort there. Follow that work to the outcome the business wanted.

Before building the next AI feature, I would ask the person receiving its result: **what would this need to give you so that you could actually move forward?**

## References

The original reading behind these notes, plus the research used to test the productivity argument:

- [Plan for AI adoption](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan) — Microsoft's guidance on business use cases, readiness, skills, and planning.
- [Microsoft AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/) — Outcome-led technology selection; its [evaluation criteria](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/evaluation-criteria.html) cover ownership costs and operational responsibilities.
- [Agentic AI Business Solutions Architect certification](https://learn.microsoft.com/vi-vn/credentials/certifications/agentic-ai-business-solutions-architect/) — Microsoft's role outline, including business measures, monitoring, and ROI analysis; Vietnamese page.
- [Nobody should type code by hand anymore. Here's what's left.](https://ghuntley.com/agency/) — Huntley's argument about vision, verification, and agency. This article draws on the publicly accessible portion.
- [Software doesn't need to be readable anymore. It needs to be explainable.](https://ghuntley.com/readable/) — Huntley's argument about designing software and tools for agents.
- [OpenAI bulk release of mathematical papers](https://en.wikipedia.org/wiki/OpenAI_bulk_release_of_mathematical_papers) — Background reading on the release and debate; the discussion above uses Tao's own account for his position.
- [Tao's critique of mass AI problem solving](https://officechai.com/ai/terence-tao-hints-openai-wasnt-behaving-responsibly-by-simultaneously-releasing-300-math-proofs-says-its-making-math-less-fertile/) — Secondary reporting from the original reading list.
- [Math 2.0](https://terrytao.wordpress.com/2026/10/10/math-2-0/) — Tao's own introduction to his talk about AI, mathematical understanding, and community.
- [Generative AI at Work](https://arxiv.org/abs/2304.11771) — Brynjolfsson, Li, and Raymond; the revised paper reports 15% more issues resolved per hour on average in its customer-support setting.
- [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity](https://arxiv.org/abs/2507.09089) — METR's randomized study; read alongside its [February 2026 measurement update](https://metr.org/blog/2026-02-24-uplift-update/).
- [DORA: State of AI-assisted Software Development 2025](https://dora.dev/research/2025/dora-report/) — Organizational context for understanding AI adoption and its effects.
