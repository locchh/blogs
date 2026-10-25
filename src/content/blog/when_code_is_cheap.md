---
title: "When Code Is Cheap"
description: "When implementation gets cheaper, where should developers move? Toward problem framing, lasting design decisions, proof, delivery, and learning that improves the next project."
pubDate: "2026-10-24"
author: "locchh"
draft: false
---

When writing the first version of a feature takes an afternoon, we plan around that afternoon. We estimate the coding, choose a framework, and assign the implementation.

Now imagine an agent can produce that first version in twenty minutes. What should the developer do with the time that was released?

There is an easy answer: ask it to build more features. But somebody still has to decide which features matter, settle the business rules, check the behavior, integrate the changes, and keep the result working. Faster implementation does not make those jobs disappear.

That is the spirit of **when code is cheap**. The developer's attention moves toward the work that decides whether the code is worth having.

I mean cheaper to produce and revise, rather than free to trust or operate. The size of the saving varies by task and team. But wherever implementation becomes cheaper, the useful question changes: **which part of the work now deserves more of my judgment?**

My answer is to move closer to the problem, the lasting design decisions, the evidence, and the people who use the result. Here is what that means in practice.

## Move toward choosing the right problem

Cheaper implementation makes it easier to build the wrong thing quickly. Choosing the problem deserves more attention because the cost of trying a solution has fallen, while the cost of pursuing an irrelevant goal can still be months of everyone's work.

A developer can move upstream: observe the workflow, ask why the request exists, and help define the result before the ticket becomes an instruction to an agent. This brings engineering into the management decision about what deserves investment.

Microsoft's [AI adoption planning guide](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan) starts with business problems, then use cases, and then an assessment of skills, data, and infrastructure. The [Microsoft AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/) also puts outcomes before products. For a developer taking more responsibility for the outcome, I would turn that into a project plan like this.

**First, describe the delay or loss.** A user may ask for a chatbot because that is the solution they can picture. Investigate what happens around the request. Perhaps staff cannot find an answer. Perhaps they find it quickly but wait for approval. A chatbot addresses those situations very differently. Users bring essential knowledge of their work; our job is to explore the problem with them.

**Second, measure the current workflow.** For support, record time spent reading, investigating, reviewing, waiting, and correcting mistakes. Count resolved cases and reopened cases. Include awkward cases and exceptions. Decide what a completed outcome means before changing the process.

**Third, choose the smallest useful intervention.** A better search filter, a form that collects missing information, or a fixed rule might solve the problem. AI earns its place where interpreting varied input is useful enough to justify its uncertainty and operating cost. Compare configuring an existing product with building something custom.

**Fourth, fund a complete pilot.** Include integration, evaluation, staff training, and support after launch. Name the business owner who accepts the outcome and the technical owner who keeps the service working. Microsoft's [business solutions architect certification outline](https://learn.microsoft.com/vi-vn/credentials/certifications/agentic-ai-business-solutions-architect/) includes business success measures, operational monitoring, and ROI analysis alongside architecture. Those responsibilities belong in the project from the beginning.

**Fifth, decide in advance what would make us expand, revise, or stop.** For example, the pilot might require less total handling time while keeping the existing quality standard and reopening rate. Specify the sample, observation period, and unacceptable failures before looking at the results. The exact thresholds depend on the business. A good demo is evidence to keep investigating, not automatic permission to roll out everywhere.

The workflow boundary matters here too. Drafting a suggested reply and sending it to a customer are different responsibilities. Decide which actions the system can take, which require review, and who handles exceptions. The work still needs an owner when it leaves the demo.

The shift is practical: spend some of the time saved implementing a request on finding out whether it is the right request. That investigation can end with a smaller feature, a different workflow, or a decision to leave the system alone.

## Move toward decisions that outlive the code

Geoffrey Huntley's [essay on agency](https://ghuntley.com/agency/) emphasizes vision and verification as more coding becomes automated. I take that as a useful challenge, without assuming every team has already reached the same level of automation.

When we can generate several implementations cheaply, the particular implementation becomes easier to replace. Spend more attention on decisions that shape everything downstream: the data model, system boundaries, ownership, and business rules. These can change, but changing them often forces many other things to change. A UI draft or small prototype is usually cheaper to throw away.

Start from the business workflow and the user's experience. Work out the logic and data they require. Then build a thin path through the system, with enough real data and integration to exercise the handoffs. A working screen alone cannot prove that path.

A work item is itself an input to the next step. An SRS, user story, or bug report should carry the intended outcome, relevant context, acceptance criteria, and examples of failure. If an agent produces exactly what the ticket says and the result is unusable, inspect the ticket too. Bugs and incidents may reveal a missing rule, an implementation defect, or an assumption that no longer holds.

Huntley's [essay on explainable software](https://ghuntley.com/readable/) asks what changes when agents become major users of programming tools. My practical test is whether the people responsible for a system can investigate and safely change it. An explanation helps, but its claims still need to match the running behavior.

Use cheaper code to buy evidence. Build two small prototypes when they would answer a design question better than a long debate. Check them against the same real workflow. Throw away the one that loses. Keep the data and business boundaries clear enough that a disposable prototype does not quietly become a permanent dependency.

The developer's contribution is choosing what the experiment needs to teach us, then making the decision from what happened. Generating three alternatives is easy compared with knowing which tradeoff the business can live with.

## Move toward defining and proving done

As implementation speeds up, deciding what counts as finished becomes a larger part of the developer's job. An agent can satisfy the wording of a ticket while missing the reason the ticket exists.

Imagine we use that new speed to build a support-ticket summarizer. It produces clear summaries in seconds. Then a support engineer finds that a summary omitted the customer's software version and mixed an attempted fix with a suggestion. They reread the whole conversation. We built the feature quickly, but the workflow gained another document to check.

**The next step is part of the specification.**

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

This is a concrete place for a developer to move: work with the receiver to define acceptance, build checks that exercise the handoff, and follow failures back into the specification. Cheap code makes the iteration faster. It does not choose the right evidence for us.

## Move toward the economics of the whole project

Once writing the code gets cheaper, coding hours tell us less about whether the project is worthwhile. A developer needs to see the work and cost around the implementation, including what other people inherit.

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

Bring these numbers into the design discussion. A more expensive model might be worthwhile if it removes substantial review work. A simpler form might beat both model choices. The engineering decision is about the whole cost of a useful result.

## Move toward measuring the improvement

If we claim coding has become cheaper in our project, we should be able to show where the time went. Producing code quickly is one observation. Shipping a useful change with less total effort is the result we need to establish.

There is evidence of real gains. In the revised paper [Generative AI at Work](https://arxiv.org/abs/2304.11771), researchers studied 5,172 customer support agents. AI assistance increased issues resolved per hour by 15% on average, with different effects across experience levels. That is a useful result tied to a particular task and setting.

There is also evidence that expectations can mislead us. [METR's early-2025 study](https://arxiv.org/abs/2507.09089) randomized AI access across 246 tasks completed by 16 experienced open-source developers. AI access increased completion time by 19%, even though participants believed it had helped. This describes those tools, developers, and repositories at that time. In its [February 2026 update](https://metr.org/blog/2026-02-24-uplift-update/), METR reported signals of improvement but explained that selection effects and time-measurement problems made the newer estimate unreliable.

These studies do not provide a universal percentage to paste into a business case. They give us a reason to measure, including when everyone feels faster. [DORA's 2025 report](https://dora.dev/research/2025/dora-report/) makes a related organizational point: AI amplifies existing strengths and weaknesses, so returns depend on the system around the tools.

For a pilot, compare similar work with and without assistance where practical. Random assignment gives a stronger comparison than asking volunteers to choose their easiest tasks. Record case difficulty, user experience, and the model and workflow versions. A before-and-after comparison can still help, but staff changes, seasonal demand, and a different mix of cases can explain part of the result.

Track total human effort, elapsed time to the final outcome, quality failures, and cost. Look at slow cases as well as the average. Set a review date, but also require enough completed cases and enough time for delayed failures to appear. If the evidence is thin, extend or narrow the claim.

For a developer, this means helping build the measurement as well as the feature. Keep the comparison repeatable so that the next model, prompt, or workflow change has to earn its place against the same standard.

## Move toward improving the delivery system

When implementation is the slowest step, speeding it up can help the whole team. Once another step becomes slower, the best use of a developer's time changes again.

Watch the queue after the automated step. If an agent creates forty changes a day and the team can review ten, more generation does not increase delivery. Work piles up. Keep changes small, limit unfinished work, and improve the constrained step. The time saved writing code might be best spent helping review and integration.

That also changes planning. Sprints can still provide a useful rhythm. But if decisions and review are the constraint, filling the sprint with more implementation tasks will not fix it. Plan around what the team can finish and validate.

An AI application engineer has two connected jobs. Build an execution system that can keep working: tools, saved state, bounded retries, useful checks, and recovery. Then build the context system that supplies what the work needs. Make success observable before optimizing token use or run time. I explored the order of those optimizations in [Start at the Cheap End](/blogs/blog/start_at_the_cheap_end/).

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

These are engineering tasks worth moving toward: make the workflow easier to finish, give the agent reliable context, and make failures recoverable. A faster generator needs a delivery system that can use what it produces.

## Move toward learning that improves the next project

Cheaper implementation also changes how we learn. We can use small experiments to investigate a new idea sooner, then spend more attention on its mechanism, limits, and fit. Learning another tool's syntax is only part of that work.

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

**Keep some of the saved time for understanding.** A cheaper implementation can be a chance to investigate why something works, explain a decision to a teammate, or pursue a question that the next ticket will never ask.

This connects to a concern outside software. In [Math 2.0](https://terrytao.wordpress.com/2026/10/10/math-2-0/), Terence Tao calls for AI use that sustains mathematical understanding and the mathematical community. My own connection to engineering is that producing a result and developing the ability to build on it are different achievements.

A team may ship code while losing the understanding needed to operate it. A developer may finish an experiment while leaving no record of why it failed. The next person inherits the artifact and has to reconstruct the reasoning.

Keep the decisions, evidence, limitations, and unanswered questions with the result. This gives the next person somewhere to start. When an agent can draft the next implementation quickly, our understanding is what helps us judge whether to use it, adapt it, or throw it away.

The time saved coding gives us room to build that understanding. Make it part of the work: explain what the prototype taught us, document the decision, and leave the next developer able to challenge it.

## Put the saved time somewhere useful

On the next feature, I would start by writing down the business result and the person or system that receives the output. Then I would identify the decisions that would be costly to reverse: data meaning, ownership, boundaries, and business rules.

I would let an agent draft the parts that are easy to replace, while I prepare the examples and checks that tell us whether the result is useful. I would review a thin path through the real workflow before asking it to generate more.

Afterward, I would look for the new delay. Is the team waiting on review, missing context, an unclear decision, or deployment? That is where I would spend the next hour saved by faster coding. I would also keep one bounded learning experiment in the week, with its result written down.

This does not require every developer to become a manager. It requires us to take responsibility for more of the chain our code belongs to.

**When code is cheap, move toward the decisions that make it useful.** Choose the problem, shape the durable parts, prove the result through the work that uses it next, and help the team deliver it.

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
