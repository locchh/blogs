---
title: "When Code Is Cheap"
description: "An agent writes the first version in twenty minutes. The question on a senior's desk is no longer how to build it, but whether a project should use AI at all, what it will cost to own, how to pilot it, and how to keep it safe and good. Eleven questions with the sources to go deeper, how they apply to five kinds of delivery work, and two personal notes."
pubDate: "2026-10-24"
updatedDate: "2026-10-28"
author: "locchh"
draft: false
---

A feature that used to take an afternoon now takes an agent twenty minutes. That speed does not remove the hard question. It moves it. A senior is no longer asked how to build the feature. They are asked whether the project should use AI at all, and whoever decides has to live with the answer.

Fred Brooks saw this coming in 1986. In [No Silver Bullet](https://worrydream.com/refs/Brooks_1986_-_No_Silver_Bullet.pdf) he split software work into the **essence**, the ideas and rules a program must get right, and the **accident**, the labor of typing those ideas into a machine. Then he said which part is hard: "the specification, design, and testing of this conceptual construct, not the labor of representing it." Agents made the labor cheap, so the essence is now the whole job. And the first piece of it is the one he called hardest: "deciding precisely what to build."

<div align="center">

```mermaid
graph LR
    F["Building a feature"] --> A["Accident<br/>typing, syntax, build, glue code"]
    F --> E["Essence<br/>deciding what to build, design, checking, owning"]
    A --> A2["Got cheap<br/>an agent does it in minutes"]
    E --> E2["Did not get cheap<br/>still a person's job"]
```

</div>

This post breaks that job into eleven questions to ask before and after saying yes to AI in a project. Each question has a reason from the fundamentals of our field and a reason from Microsoft's own guidance for people who make this decision, with links to go deeper. It is meant to be used, not admired. If you only have five minutes, read the table near the end. After the questions, the post applies them to five kinds of delivery work. It ends with personal notes on the work left for the people who build, and two questions I cannot answer yet.

<div align="center">

```mermaid
graph LR
    P1["Before you say yes<br/>1. the problem<br/>2. does it need AI?<br/>3. shape and complexity<br/>4. hard to undo"] --> P2["Counting the cost<br/>5. cost to own"]
    P2 --> P3["Running the pilot<br/>6. the pilot<br/>7. did it work?"]
    P3 --> P4["Controlling risk<br/>8. authority<br/>9. safety"]
    P4 --> P5["Controlling quality<br/>10. who checks<br/>11. after launch"]
```

</div>

One honesty note before the list. Two kinds of Microsoft sources appear here. The [Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/strategy), the [Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/ai/), and the [Agents hub](https://learn.microsoft.com/en-us/agents/) are official documentation. The [Microsoft AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/) is a practitioner's guide published on Microsoft's GitHub. It says itself that Microsoft's AI products change weekly and that production decisions should be checked against official sources. I quote it because its sentences are the sharpest, and I say which is which.

## Before you say yes

The first four questions decide whether there is a project at all. They move from the problem, to whether AI is the right tool for it, to the shape the solution should take, to the decisions that will be expensive to change later.

### 1. What is the problem, before AI?

Microsoft's [planning guide](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan) opens with a sentence every request should come with: start with business problems, and look for where results miss expectations "before you consider AI at all."

Most requests arrive as a solution instead. Someone asks for a chatbot because a chatbot is the solution they can picture. Users know what they want, but they rarely know what their problem is. So go and watch the work first. Maybe staff cannot find the answer. Maybe they find it in seconds and then wait a day for a manager's approval. A chatbot fixes the first and does nothing for the second. Only the people doing the work know which one they have.

Once the problem is clear, measure the work as it is today: how long each case takes, how many are finished, how many come back. Without that number there is nothing to compare against later, and every result will look like success. The [business plan guidance for agents](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai-agents/business-strategy-plan) says the same thing in one line: record today's performance to create a baseline, before any development begins.

> **Lesson:** describe the delay or the loss before you describe the tool. If you cannot name what gets better, you are not ready to build.

Go deeper:

- [Plan for AI adoption](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan). Argues for a fixed order: business problems first, then use cases, then an honest look at the skills and data you actually have.
- [Business plan for AI agents](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai-agents/business-strategy-plan). Says when not to use an agent, gives a way to score candidate ideas, and shows how to record the baseline.
- [AI adoption overview](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/strategy). Puts the executive question plainly: where AI creates value, and whether that value justifies the investment.

### 2. Does it need AI at all, and does something already exist?

A clear problem still does not mean AI is the answer. The Decision Framework has a rule worth repeating in every meeting: ["never lead with a product."](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html) Describe the result first, then the situation, then how the system should behave. The technology comes last.

It also asks a checkpoint question before any of that: does this need an agent? If the steps are fixed and the input is structured, ordinary code is cheaper and more reliable. If people just need to find a document, that is search. For numbers, the [scenarios page](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/scenarios.html) is blunt about language models, or an LLM in its words: "if the problem has a numerically correct answer, an LLM is the wrong tool for producing it." A model is good at reading messy input. It is not a calculator and not a database. Microsoft's official [agent business plan](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai-agents/business-strategy-plan) draws the same line from the other side: agents earn their place when the task needs multistep decisions, many tools in a flexible order, or messy input that must be interpreted.

Even when AI is justified, building your own is the last step, not the first. The framework describes a ladder, roughly: use something that exists, configure it, extend it, and build only at the top. The honest part is the rule for climbing. You must be able to explain why each rung below failed. If you cannot, you are not building because you need to. You are building because building got cheap.

<div align="center">

```mermaid
graph BT
    U["Use what already exists"] --> C["Configure it"]
    C --> X["Extend it"]
    X --> B["Build your own"]
    R["The rule for climbing:<br/>explain why the rung below failed"] -.-> C
    R -.-> X
    R -.-> B
```

</div>

> **Lesson:** explain why plain code, search, and an existing product all failed before you fund a model.

Go deeper:

- [Decision method](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html). Walks through the intake questions, the ladder, and nine questions that sort a problem before any product is named.
- [Scenarios](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/scenarios.html). Eleven common situations, each with the signal that tells you which way to go.
- [AI agent adoption](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai-agents/). Gives Microsoft's official definitions of the three agent types: productivity, action, and automation.

### 3. What shape should it take, and how hard is it?

Once the answer to question 2 is yes, the next mistake is to build the most impressive shape. Anthropic's guide to [building effective agents](https://www.anthropic.com/engineering/building-effective-agents) puts the rule plainly: "we recommend finding the simplest solution possible, and only increasing complexity when needed." It adds: "This might mean not building agentic systems at all." Microsoft's [Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns) says the same in its own words: "Use the lowest level of complexity that reliably meets your requirements."

Before choosing a shape, split the request three ways: the work the model will own, the work existing systems already own, and the work people must keep. Anthropic's architect course for partners, [Claude Platform Solution Design](https://anthropic-partners.skilljar.com/path/claude-certified-architect-professional/claude-platform-solution-design), starts there. The model's share usually turns out smaller than the request suggests. Its public outline adds a second check. When an answer depends on the current state of a system, such as a ticket's status or an order in flight, ask the system directly. Searching a copy of last week's documents gives an answer that was true last week.

With the model's share known, pick the shape. The same course names three, and each costs more than the last.

| Shape | What decides the next step | Good for | What it costs you |
| --- | --- | --- | --- |
| Augmented call | Nothing. One model call, with retrieval, examples, or a tool | Classify, summarize, translate, extract, draft | A prompt, a test set, and a check on the output |
| Workflow | Your code. Anthropic: "systems where LLMs and tools are orchestrated through predefined code paths" | Fixed steps where some need language: triage, reports, release notes | All of the above, plus the code path and a check between steps |
| Agent | The model. It chooses its own steps and tools | Open-ended work where the number of steps cannot be known in advance | All of the above, plus iteration limits, tool permissions, tracing, and a harder test set |

Inside the agent row there is one more step up. Microsoft calls a single agent with tools "often the right default for enterprise use cases." Several agents are justified only when one agent cannot cope because of prompt size, too many tools, or separate security boundaries. If the agents talk in a shared thread, the same page suggests keeping it to three or fewer. The Decision Framework puts the whole rule in one line: "Audition the soloist before you hire the orchestra." Try one agent with good tools before anyone talks about several.

The shape says who decides the next step. It does not say how hard the work is, and that is what sets the evidence you need before launch. The Decision Framework's [evaluation criteria](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/evaluation-criteria.html) sort work into four tiers, and each tier lists the evidence it needs before going live. To place a project in a tier, ask six quick questions and let the hardest answer decide. That last rule is my addition, not the page's. It rests on a simple fact: a system is as hard as its hardest part.

1. **Steps:** are they fixed, or discovered along the way?
2. **Blast radius:** does it only read, write records, or do something that cannot be undone?
3. **Reach:** how many systems, owners, and security boundaries does it cross?
4. **Checking:** can a machine tell whether the result is right? A test suite, a matching total, or the old system's behavior all count. If only a person can tell, the review hours in question 10 grow.
5. **Drift:** how often do the inputs or the right answer change?
6. **Owners:** who will run it? A team that builds in a low-code tool and a team that runs CI/CD and an on-call rotation are different owners, and the tier must match the team.

| Tier | Typical shape | Example | Evidence before it goes live | Usual time to production |
| --- | --- | --- | --- | --- |
| 1. Informational | Augmented call with retrieval | Answer questions from documents, with sources | Citations are right, results are trimmed to what the asker may see, content is fresh | Days |
| 2. Transactional | Workflow | Classify a request and update a record | Safe to run twice, can be rolled back, someone approves, every action is logged | Weeks |
| 3. Reasoning | Single agent with tools | Investigate an incident and propose a cause | Tools are called correctly, a failed run can resume, there is a latency budget and a test pass threshold | Weeks to months |
| 4. Autonomous | Bounded agent or several agents | Run a multi-step change across systems with little supervision | Written limits on autonomy, isolation, stop conditions, escalation, tracing end to end | Months |

The time column comes from the same page, with a fair warning: "Products are anchors, not clocks." The data and the approvals decide the date, not the tool.

**Borrow a reference architecture instead of inventing one.** Most requests match a shape that someone has already drawn, tested, and written failure notes for. The map below names the common cases and where each is written up.

| If the problem looks like | Start from | Written up in |
| --- | --- | --- |
| Answer questions from a body of documents | Retrieval with citations and permission trimming | [Baseline Foundry chat reference architecture](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/architecture/baseline-microsoft-foundry-chat) |
| Sort incoming requests to the right handler | Routing | [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents) |
| A fixed sequence of steps, some of them language | Prompt chaining with checks between steps, or sequential orchestration | Anthropic guide; [Azure orchestration patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns) |
| Produce something, then check it against criteria | Evaluator-optimizer, also called maker-checker | Both of the above |
| Many independent pieces, or several lenses on one input | Parallelization or orchestrator-workers, with an outside judge | Both of the above |
| Investigate something open-ended | Single agent with tools, an iteration limit, and a person who approves the conclusion | Azure orchestration patterns |
| The right specialist only becomes clear partway through | Handoff | Azure orchestration patterns |
| Work that crosses security or ownership boundaries | Several agents, one identity each, with written handoffs | Azure orchestration patterns; question 9 |

The same Azure page lists eight common mistakes, and three of them are mismatches. One is a complex pattern where a simple sequence would do. Another is adding agents that do not specialize in anything. The third is a pattern that does not fit the work: a fixed pattern for work that is really open-ended, or a free-form agent for work that is really fixed.

> **Lesson:** split the request before you shape it, choose the lowest shape that works, let the hardest of the six answers set the tier, and borrow an architecture someone has already tested.

Go deeper:

- [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents). Anthropic, 2024. Makes the case for the simplest solution, describes the augmented model and five workflow patterns, and says when an agent is worth its cost.
- [AI agent orchestration patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns). Lays out three levels of complexity, five orchestration patterns, when to avoid each one, and a list of common mistakes.
- [Evaluation criteria](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/evaluation-criteria.html). Defines the four complexity tiers, the evidence each needs, the team profiles that fit them, and the time to production.

### 4. Which decisions will be hard to undo?

The shape chosen in question 3 can be changed later. Other decisions cannot, at least not cheaply. The real solution is rarely the framework or the hosting service. It is the data model, the boundaries between systems, who owns what, and the business rules. Tools can be swapped. Those cannot.

David Parnas said this in 1972, in the paper that gave us [information hiding](https://en.wikipedia.org/wiki/Information_hiding). Split a system around the design decisions most likely to change. Hide each one behind a stable boundary. Then changing one decision does not force everything else to change. It is still the best guide to where a senior's attention should go. Spend it on decisions that are hard to undo. Let the agent produce the cheap, throwaway parts: screen drafts, glue code, prototypes.

A working order follows from this: design top-down and build bottom-up. Start the design from the business workflow, then the user's experience, then the logic, then the data. Build the other way, in thin slices: data, then logic, then screen, with enough real data and real connections to test where one piece hands work to the next. A working screen alone proves nothing.

When an agent builds those slices, the work item becomes its input. A user story or a task with clear acceptance criteria is something an agent can build and a person can check. So when the agent produces exactly what the ticket says and the result is useless, inspect the ticket, not the agent. Bugs, change requests, and incidents are the signal that the specification was wrong.

> **Lesson:** spend your attention on what is expensive to reverse. Let the agent spend its tokens on what is cheap to throw away.

Go deeper:

- [Information hiding](https://en.wikipedia.org/wiki/Information_hiding). Parnas, 1972. Explains why modules should be built around the decisions most likely to change, each hidden behind a stable interface.
- [Design principles for AI workloads](https://learn.microsoft.com/en-us/azure/well-architected/ai/design-principles). Microsoft's official principles for AI systems, grouped under reliability, security, cost, operations, and performance.
- [Grounding data design](https://learn.microsoft.com/en-us/azure/well-architected/ai/grounding-data-design). Covers how to prepare, index, and keep fresh the data an AI system answers from, and warns that changing an index later is expensive.

## Counting the cost of owning it

A yes to the first four questions still says nothing about money. The next question is the one most budgets get wrong, because they price the build and forget the years of running it.

### 5. What will it cost to own, not to build?

Here is the trap inside the word "cheap." In 1865 the economist William Jevons looked back at a century of steam engines that kept getting more efficient, while some experts expected better technology to make England burn less coal. It burned more, and he explained why: cheaper coal found more uses, and demand grew faster than efficiency. His line still applies: ["It is a confusion of ideas to suppose that the economical use of fuel is equivalent to diminished consumption."](https://en.wikipedia.org/wiki/Jevons_paradox)

Code behaves like coal. When a feature costs twenty minutes, we ask for twenty features, and every one still has to be read, run, kept working, and understood. Dijkstra said in 1988 that we count lines of code [on the wrong side of the ledger](https://www.cs.utexas.edu/~EWD/transcriptions/EWD10xx/EWD1036.html): they are not "lines produced" but "lines spent." The Decision Framework's [capability model](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/capability-model.html) puts it in two short sentences: "Building got cheap. Owning didn't."

The same page pictures every agent as a coin. One side is the demo: visible, interactive, easy to show in a meeting. The other side runs in the background with nobody at the keyboard, and that side is what changes the operating cost. The demo gets the project approved, but the other side is what you own, so budget the two separately. The [evaluation criteria](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/evaluation-criteria.html) page counts the cost of owning across licenses, usage, and engineering hours, and adds two warnings that are easy to miss. A system that charges per call quietly tempts you to test less, so budget the testing as its own line. And an agent in a loop can spend a month's budget in a few hours, so set spending caps before launch.

| The side you see | The side you own |
| --- | --- |
| The demo in the meeting | The job that runs with nobody at the keyboard |
| One happy case | The odd cases, retries, and exceptions |
| The cost to build | The cost to run: usage, checking, fixing, and the owner's time |
| "It works" | The cost of one outcome that met the standard |

The last row of that table is the number to aim for: the total cost of one outcome that met the agreed standard, with the checking and the fixing included. Count only the cases that met the standard. Keep the rejected and unfinished ones visible, or dropping the hard cases will make the average look good. To estimate that number, the official [design principles](https://learn.microsoft.com/en-us/azure/well-architected/ai/design-principles) name what drives it: how much data, how many questions, how much load at once, and the hidden cost of the services you depend on. One more correction belongs in every business case. Staff time freed by AI is capacity, not cash. It becomes a saving only if spending actually falls, or if someone names what the freed hours will now do.

> **Lesson:** price the side of the coin nobody watches. Cost per good outcome, checking included, build and run budgeted apart.

Go deeper:

- [Manage AI: costs](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/manage#manage-ai-costs). Official guidance on watching usage, setting thresholds, and sending budget alerts before a bill surprises anyone.
- [Design principles: cost](https://learn.microsoft.com/en-us/azure/well-architected/ai/design-principles#cost-optimization). Two rules in Microsoft's words: "Pay for what you intend to use." And: "Use what you pay for. Minimize waste."
- [Start at the Cheap End](/blogs/blog/start_at_the_cheap_end/). An earlier post on this blog that sorts the ways to make an agent cheaper and better by how much effort each takes, cheapest first.

## Running the pilot and measuring it

With the cost understood, the idea can meet real work. A pilot has to answer two questions in order: can it survive daily work, and did it make anything better?

### 6. How do we run the pilot?

A pilot is not a demo. A demo shows that something can work once. A pilot finds out what it costs to work every day. The official [planning guide](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan) gives a shape worth following: pick a high-value case that matches the skills you actually have, start with internal work that does not face customers, and use what the pilot teaches you to estimate the real timeline. It also says to add a buffer for learning and surprises.

The [agent business plan](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai-agents/business-strategy-plan) adds the rule that is the whole point of a pilot: "Pilot the hardest steps." If the agent succeeds there, the easy steps will follow. If you pilot the easy steps, you learn nothing you did not already know. The same page says to use business numbers to decide, at each stage, whether to go on or stop, and to make that choice "based on the data, not assumptions or optimism."

A choice based on data needs rules written before the data arrives. So before the pilot starts, write three things down: what result would make you expand, what would make you change the design, and what would make you stop. Before anyone looks at results, also decide which cases you test, how long you watch, and which failures you will not accept. Then run the pilot on real cases, including the awkward ones. Bring the people who will own it afterward into the room from the first week.

The Decision Framework's [implementation patterns](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/implementation-patterns.html) make one more point. Most real systems start in one shape and move to another as the requirements settle, so plan the move. A pilot that cannot grow into the real thing teaches you less than it seems.

> **Lesson:** pilot the hardest step, on real cases, with the stop condition written before you start.

Go deeper:

- [Plan for AI adoption: proof of concept](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan#create-ai-proof-of-concepts). Explains how to pick the first case, why to start internal, and how to turn pilot results into an estimate.
- [Business plan for AI agents: success metrics](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai-agents/business-strategy-plan#define-success-metrics). Shows where to place decision gates between stages, and how to keep measuring after launch.
- [Implementation patterns](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/implementation-patterns.html). Describes the common starting shapes and the signals that tell you it is time to move to the next one.

### 7. How will we know it worked?

If AI made the work cheaper, we should be able to show where the time went. Usually we cannot, because we trust how it feels.

In early 2025, [METR](https://arxiv.org/abs/2507.09089) randomly assigned real tasks to experienced open-source developers, with and without AI. They finished about a fifth slower with AI. They believed they had been about a fifth faster. Same people, same work, opposite numbers. In its [February 2026 update](https://metr.org/blog/2026-02-24-uplift-update/), METR says developers likely get more help from AI than they did in early 2025, but its own data cannot yet say how much. Other studies find real gains, but only for some people and some organizations, as the table below shows.

| Study | Who was measured | What it found | What I take from it |
| --- | --- | --- | --- |
| [METR, early 2025](https://arxiv.org/abs/2507.09089) | Experienced open-source developers on their own projects, tasks assigned at random | About a fifth slower with AI, while believing they were a fifth faster | Feelings are not measurement |
| [METR, February 2026](https://metr.org/blog/2026-02-24-uplift-update/) | A larger group, same design | Leans toward a speedup, but too noisy to be sure: "only very weak evidence" | When people refuse to work without AI, the measurement itself breaks |
| [Generative AI at Work](https://arxiv.org/abs/2304.11771) | Over five thousand customer support workers | More issues resolved per hour, with the gain mostly for the newest workers | For individuals, AI can be a leveler |
| [DORA 2025](https://dora.dev/research/2025/dora-report/) | Software organizations | AI amplifies what is already there: a strong system gets stronger, a weak one is exposed | For teams, the system around the tool decides the result |

None of these is a number to paste into a business case. The studies do not agree, and that is the point. Together they give one instruction: measure in your own setting. Compare against the baseline from question 1, using similar cases with and without the tool. Look at the slow cases, not just the average. Give delayed failures time to appear. Count total human effort, time to the final outcome, quality failures, and cost. One habit matters more than the rest. Most teams track cost, time, token use, and tickets closed, but few check whether the output is right. Check the progress, not just the bill.

> **Lesson:** faster is a measurement, not a mood. If you cannot show where the saved time went, you have not saved it yet.

Go deeper:

- [Govern AI: monitor risks](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/govern#4-monitor-ai-organizational-risks). An official measurement plan that combines numbers with what users and reviewers report.
- [Agent evaluation checklist](https://learn.microsoft.com/en-us/agents/agent-evaluation/evaluation-checklist). Walks through four stages, from a first test set to continuous evaluation, and sets the test for success: you can answer with specifics "instead of saying: 'The agent seems okay.'"
- [DORA 2025](https://dora.dev/research/2025/dora-report/). The full report behind the table row. Beyond the amplifier finding, it describes the team and organization practices that decide whether AI helps.

## Controlling risk: authority and safety

A pilot that works raises the next question: how far should the system be trusted once it is live? Risk comes in two parts. One is authority, meaning what the system may do on its own. The other is safety, meaning what it can reach and how it can be attacked.

### 8. How much may it do alone, and who answers for it?

The capability model separates three levels of trust: the system **recommends**, it **acts within set limits**, or it **owns the outcome**. The line between the first two is where accountability changes hands, and that line is the real design decision. The page says it in one sentence: "Capability is a demo. Authority is a liability."

The official [agent governance guide](https://learn.microsoft.com/en-us/agents/center-of-excellence/govern-agents-risk) draws the same line and gives it a name: the assist-to-execute line. An agent that drafts a reply assists a person who stays in charge. An agent that sends the reply, updates a record, or moves money makes a change in a system the business treats as the truth. The guide's rule is short: "Sort every agent by what it does, not by how impressive it looks." It then sets three risk tiers, and each tier adds controls to the one before it.

| Risk tier | What the agent does | What it needs before it ships |
| --- | --- | --- |
| Low | Summarizes, drafts, or searches for one person or a small team | A named owner, basic monitoring, a release checklist |
| Medium | Answers domain questions or runs an internal service where a wrong answer misleads people | All of the above, plus an expert who confirms the answers, monitoring of the knowledge it reads, and a formal gate before going live |
| High | Sits in a core process, faces customers, or takes consequential actions | All of the above, plus a process owner, a security and responsible-AI review, written decision rights on what it may decide alone, an incident plan, and a regular review |

The tier sets the controls for the whole agent. Inside it, decide per action what the system may do. Reading can be logged. Writing needs a person to confirm. Anything destructive needs approval through a separate channel, from someone who owns the process. The Decision Framework asks for a [named owner](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/evaluation-criteria.html) for every production duty. A useful split is two owners: one for the business result and one for keeping the service alive. The Decision Framework's [decision method](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html) page gives the final test: "An agent you cannot see, attribute, or switch off is not in production."

<div align="center">

```mermaid
graph LR
    subgraph Assist
        R1["Recommends<br/>drafts, summarizes, suggests"]
    end
    subgraph Execute
        R2["Acts within set limits<br/>updates a record, sends a reply"] --> R3["Owns the outcome<br/>decides and acts alone"]
    end
    R1 -- "accountability changes hands here" --> R2
    R1 --- L1["Read: log it"]
    R2 --- L2["Write: a person confirms"]
    R3 --- L3["Destructive: separate approval<br/>from the process owner"]
```

</div>

Owners need rules to work inside, and that is where leadership comes in. The official [strategy page](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/strategy) keeps it to three moves. Leaders say what AI is for and how they will measure it. One central group writes the rules that apply to everyone, so each team does not invent its own. Everyone gets access, plus training, because the people doing the work are the ones who will spot where AI helps.

The [Center of Excellence guide](https://learn.microsoft.com/en-us/agents/center-of-excellence/) names the three ways that central group fails: the gatekeeper who reviews everything and enables nothing, the ghost that exists on paper only, and the perfectionist who will not let anyone ship until governance is complete. The same guide's [risk page](https://learn.microsoft.com/en-us/agents/center-of-excellence/govern-agents-risk) answers all three: "Governance is never finished. Compliance is continuous." Publish the guardrails, let teams build inside them, and refine as you learn.

None of this limits the technology. It is how the project survives its first bad week. AI informs. Humans commit.

> **Lesson:** decide which actions it may take alone, which need a person, and who is named when it goes wrong. Before launch, not after.

Go deeper:

- [Govern agents by risk](https://learn.microsoft.com/en-us/agents/center-of-excellence/govern-agents-risk). Sets out the three risk tiers and the controls each one needs, in plain words.
- [Capability model: the agent framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/capability-model.html). Defines the three levels of trust (recommend, act within bounds, own the outcome) and shows where accountability moves between them. It also lists the five parts of any agent: model, instructions, retrieval, actions, memory.
- [Establish an AI Center of Excellence](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/center-of-excellence). Covers who sets standards, who runs pilots, and when the central group should step back to an advisory role.
- [Responsible AI policies](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/responsible-ai-policies). Explains how to tell users they are talking to AI, and how to let them challenge a decision.

### 9. How do we keep it safe?

For safety, the oldest security rule still carries the most weight. In 1974 Jerome Saltzer wrote that every program and every privileged user should operate with the [least amount of privilege necessary](https://en.wikipedia.org/wiki/Principle_of_least_privilege). An agent is a program that acts on behalf of a person, so it must see only what that person may see, and do only what that person may do. The Decision Framework's decision method page separates two things that get confused: an agent's attribution, meaning who it acts for, and its data access, meaning what it may reach. They are different problems, and both need solving.

Least privilege limits the damage. The next step is to know the attacks. Microsoft's official [security guidance](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/secure) starts with the list of attacks you already defend against. It then checks that list against the AI-specific attack catalogs kept by [MITRE ATLAS](https://atlas.mitre.org/) and the [OWASP generative AI project](https://genai.owasp.org/). The new attacks have names worth learning. In prompt injection, a document or a message the agent reads carries instructions it was never meant to follow. In data leakage, sensitive data escapes through the answer itself. In model inversion, an attacker pulls training data back out of the model. The page's advice is to red-team the system, meaning attack it on purpose before someone else does, and to repeat that as models and usage change.

A manager does not need every attack name. They need answers to four questions, which turn the final test from question 8 into checks. Is there an inventory of every agent, with an owner? Does each agent have its own identity, so an action can be traced to it? Are the data boundaries written down, so the agent cannot reach what the requesting person cannot? Who can switch it off, and how fast? The [governance page](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/govern) turns Microsoft's six responsible-AI principles into six risk questions, shown below. The accountability one is the sharpest: where could it be unclear who is responsible?

| Principle | The question to ask about this project |
| --- | --- |
| Privacy and security | Where could it handle sensitive data, or be attacked through what it reads? |
| Reliability and safety | When could it fail to work safely, or give an answer nobody should trust? |
| Fairness | How could it treat some people worse than others? |
| Inclusiveness | Who could be left out by how it is built or used? |
| Transparency | Which of its decisions would a user find hard to understand? |
| Accountability | Where is it unclear who is responsible? |

The business plan page has the line that closes this conversation: "If you can't name the risks, you can't manage them." Pause until you can.

> **Lesson:** least privilege, an identity per agent, a written data boundary, and a switch someone is allowed to pull. Name the risks or do not ship.

Go deeper:

- [Secure AI](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/secure). Official steps for finding threats, drawing data boundaries, red teaming, and responding to incidents.
- [Govern AI](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/govern). Builds a risk assessment on the NIST AI Risk Management Framework and turns the six principles into the risk questions above.
- [Responsible AI in workloads](https://learn.microsoft.com/en-us/azure/well-architected/ai/responsible-ai). Covers content safety on the way in and out, ways for users to give feedback and contest a decision, and escape hatches for agents.

## Controlling quality: checking and drift

Risk controls stop the system from doing harm. They do not make its output good. Quality also has two parts: someone has to check the output before it is trusted, and someone has to notice when it slowly gets worse.

### 10. Who checks the output, and is that capacity planned?

Dijkstra, 1969: ["Testing shows the presence, not the absence of bugs."](https://en.wikiquote.org/wiki/Edsger_W._Dijkstra) That was true when a human wrote every line. It matters more now, because an agent can pass every check we thought to write and still miss the reason the ticket exists. The Decision Framework's scenarios page says it in one breath: "Generation got cheap. Verification did not." Geoffrey Huntley, asked [what is left](https://ghuntley.com/agency/) when nobody types code by hand, answers: vision, verification, and agency. Two of the three are about checking.

So what counts as checked? The test for "done" is simple: the next person can do their job with the output. Say we build a tool that summarizes support tickets. The summaries are clear and complete. Then an engineer notices one left out the customer's software version and mixed up a fix that was tried with one that was only suggested, so they reread the whole conversation. We shipped a feature, and the workflow gained one more document to check. "Done" is decided by whoever receives the output, not by whoever produces it. Build the proof there, with the receiver, on real cases.

The official [evaluation checklist](https://learn.microsoft.com/en-us/agents/agent-evaluation/evaluation-checklist) turns this into steps a team can follow. Start with one test case per key scenario, each with a prompt, an expected answer where one exists, and a written rule for what passes. Run it, record the pass rate and the version, and dig into every failure: is the test wrong, or is the agent wrong? Then widen the set to cover rephrased questions, edge cases, and the things the agent must refuse. Because outputs vary, run the set several times and aim for a realistic pass rate rather than a perfect one. The checklist suggests 80 to 90 percent, set by what the business needs.

The Well-Architected [testing page](https://learn.microsoft.com/en-us/azure/well-architected/ai/test) adds a distinction that is easy to blur: evaluation finds the best model during development, and testing checks the whole system every time anything changes. Both need trusted examples checked by humans. The page calls the evaluation set the golden dataset, and it advises keeping the two sets separate.

A test set does not run its own reviews, so plan the checking as work, with people and hours. If an agent opens forty changes a day and the team can honestly review ten, the extra thirty are a pile going stale in a queue. [Through a Senior's Eyes](/blogs/blog/through_a_seniors_eyes/) works through the same arithmetic: more workers do not make the one person who decides any faster. Sprints assumed building was the slow part. If review and decisions are now the slow part, plan the sprint around what the team can finish and check, not around how much the agent can generate.

Even a well-staffed review can fail slowly. Diane Vaughan studied the Challenger disaster and named the [normalization of deviance](https://en.wikipedia.org/wiki/Normalization_of_deviance): each time a check is skipped and nothing goes wrong, skipping becomes a little more normal. An agent that has been right ten times is the perfect setup, and the eleventh review is the one you will want to skip. The Decision Framework's page on [engineering with agents](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/agentic-engineering.html) names the same risk and reduces the whole debate to one question: "can you prove it works?"

> **Lesson:** define done by what the next person can do with it. Budget the review. Keep reviewing after it has been right ten times.

Go deeper:

- [Test and evaluate AI workloads](https://learn.microsoft.com/en-us/azure/well-architected/ai/test). Separates evaluation from testing, explains golden datasets, and shows how to test agents that call tools.
- [Engineering with agents](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/agentic-engineering.html). Argues for verification over reading code, and shows how to split review when no engineer is in the loop.
- [Software should be explainable, not readable](https://ghuntley.com/readable/). Huntley argues that types and checks should push back on bad output, and that "porting is easy when the end result is easy to verify."

### 11. How do we keep it good after launch?

Reviews are not the only thing that decays slowly. Meir Lehman, with Laszlo Belady, began writing down in 1974 what every operations team learns the hard way. His first law: a system that is used must be continually adapted, or it becomes [progressively less satisfactory](https://en.wikipedia.org/wiki/Lehman%27s_laws_of_software_evolution). By 1996 the list had grown to eight laws, and the seventh says a system's quality will appear to decline unless it is rigorously maintained. He was writing about ordinary software. AI systems obey his laws faster, because the world the model learned from keeps moving and the model does not.

The Well-Architected [testing page](https://learn.microsoft.com/en-us/azure/well-architected/ai/test) names the two ways this happens. In data drift, the inputs change, so a model trained on last year's cases misreads this year's. In concept drift, the world changes, so the right answer changes while the model keeps giving the old one. Either way, the system that passed its pilot is slowly becoming a different system.

So launch is where the measuring starts, not where it ends. The official [management guide](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/manage) asks for four things. Know what good looked like at launch. Keep the golden dataset current and rerun it on a schedule. Make every new model version pass a check before it reaches production. Keep a calendar of model retirement dates so a vendor change does not surprise you. The [evaluation checklist](https://learn.microsoft.com/en-us/agents/agent-evaluation/evaluation-checklist) lists the events that should trigger a full rerun of the test set: a model change, a major update to the knowledge the agent reads, a new tool or connection, and any production incident. Microsoft's [observability guidance](https://learn.microsoft.com/en-us/azure/foundry/concepts/observability) adds checking a sample of real production answers and scheduled red teaming, so you find the drift before the users do.

<div align="center">

```mermaid
graph LR
    T["Build a test set<br/>one case per key scenario"] --> B["Record a baseline<br/>pass rate and version"]
    B --> W["Widen it<br/>rephrasings, edge cases, refusals"]
    W --> L["Launch<br/>sample real traffic"]
    L --> E["A trigger fires<br/>model change, knowledge update,<br/>new tool, incident,<br/>and my addition: a rejection"]
    E --> T
```

</div>

That list of triggers needs one more entry: a rejection. The receiving step needs a way to reject the output, with a reason such as a missing version, an unsupported conclusion, the wrong customer, or a stale policy. Those reasons should travel back to the step that produced the output. A rejection is the cheapest signal of drift you will ever get. The people who use the system need the same power: a one-click way to say the answer was wrong, and a real way to contest a decision that affected them.

> **Lesson:** the system you launched is not the system you will be running in a year. Rerun the tests on every change, and listen to the rejections.

Go deeper:

- [Manage AI](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/manage). The official operating list: baselines, golden datasets, quality gates, retirement dates, cost alerts, and recovery drills.
- [Observability in generative AI](https://learn.microsoft.com/en-us/azure/foundry/concepts/observability). How to evaluate, monitor, and trace a generative AI system across its whole life.
- [Operations for AI workloads](https://learn.microsoft.com/en-us/azure/well-architected/ai/operations) and [MLOps and GenAIOps](https://learn.microsoft.com/en-us/azure/well-architected/ai/mlops-genaiops). Describe the routine work of running a model in production: deploying, monitoring, and updating it.

## All eleven questions on one page

Here are the eleven questions together, with what to see before saying yes to each.

| Question | What I want to see before I say yes |
| --- | --- |
| 1. What is the problem, before AI? | The delay or loss, named and measured as it is today |
| 2. Does it need AI, and does something exist? | Why plain code, search, and an existing product each failed |
| 3. What shape, and how hard? | The lowest shape that works, the tier set by the hardest answer, and a reference architecture to start from |
| 4. Which decisions are hard to undo? | Data meaning, boundaries, owners, and rules decided by people, not by the agent |
| 5. What will it cost to own? | Cost per good outcome, checking included, build and run budgeted apart |
| 6. How do we run the pilot? | The hardest step, on real cases, with expand, change, and stop conditions written first |
| 7. How will we know it worked? | A comparison planned in advance, and output checked, not just the bill |
| 8. How much may it do alone? | Which actions need a person, the risk tier, and the named owners |
| 9. How do we keep it safe? | Least privilege, an identity per agent, a written data boundary, a switch |
| 10. Who checks it? | Done defined by the receiver, a test set, and review hours planned |
| 11. How do we keep it good? | Tests rerun on every change, drift watched, rejections fed back |

**When code is cheap, the senior's job is to pay for what stayed expensive: deciding, owning, checking, and understanding.** Brooks described that job in 1986. The agent just made it impossible to hide behind the typing.

## Applying the questions to five kinds of delivery work

The eleven questions stay the same from project to project. Their answers do not, especially in software services, where a vendor builds for a customer and the same work can be sold in different ways. A dedicated team billed by the hour, a maintenance contract, a fixed-bid project, a migration, and a sales pursuit each get a different answer to the question that decides the rest: **when AI saves an hour, who keeps it?** Whoever keeps the saving is the one who wants to measure it. Whoever carries the risk is the one who has to check the output.

What follows is a general pattern. No customer, project, or person is named, and no real contract numbers are used.

### Five ways delivery work is sold

If you have only built products, these words may be new. Here is each one in plain terms, with the flow of work it usually follows. A dedicated team sells effort. Maintenance sells a running system. A fixed bid sells a result, and a migration sells a safe move to a new platform. Presales sells a promise.

**A dedicated team billed by time** is often called an ODC, an offshore development center. The vendor keeps a stable team that works only for one customer, often for years. The customer sets priorities from its backlog, much as it would for its own staff, and pays by hours or by headcount at an agreed rate. This is time and materials: the customer buys effort, not a result. The team gets work, delivers it in short cycles, and reports the hours.

<div align="center">

```mermaid
graph LR
    B["Customer backlog"] --> P["Plan the sprint<br/>with the customer"]
    P --> D["Design, code, test"]
    D --> R["Review and demo"]
    R --> A["Customer accepts"]
    A --> T["Timesheet or headcount<br/>invoiced monthly"]
    R -- "changes" --> D
```

</div>

**Maintenance and support**, often called AMS for application maintenance and support, keeps a system running after it goes live. The work arrives as tickets: questions, incidents, and small change requests. A service agreement fixes how fast each kind must be answered and solved. Support is usually split into three levels. **Level 1, the service desk,** receives every request, sorts it, answers known questions from a knowledge base, and passes on what it cannot solve. **Level 2, application support,** investigates incidents in logs and data, finds a workaround, records the known error, and decides whether code must change. **Level 3, development,** changes the code through impact analysis, design, fix, test, and release, and the customer's change requests land here too.

<div align="center">

```mermaid
graph LR
    U["User or customer"] --> L1["Level 1<br/>receive, sort,<br/>answer known questions"]
    L1 -- "solved" --> C["Close the ticket"]
    L1 -- "escalate" --> L2["Level 2<br/>investigate logs,<br/>find a workaround"]
    L2 -- "solved" --> C
    L2 -- "needs a code change" --> L3["Level 3<br/>impact analysis, fix,<br/>test, release"]
    L3 --> C
    C --> K["Update the knowledge base<br/>and known errors"]
    K -.-> L1
```

</div>

**A fixed-bid project**, fixed price and fixed scope, builds an agreed scope for one agreed price and date. The vendor estimates up front and carries the risk: if the work takes longer, the vendor pays the difference. Anything outside the scope becomes a change request with its own price. The work usually follows the familiar sequence of requirements, basic design, detailed design, code, unit test, integration and system test, and acceptance, with a review gate at each step.

<div align="center">

```mermaid
graph LR
    S["Agree scope,<br/>estimate, price"] --> RQ["Requirements"]
    RQ --> BD["Basic design"]
    BD --> DD["Detailed design"]
    DD --> CD["Code and unit test"]
    CD --> IT["Integration and<br/>system test"]
    IT --> UA["Customer acceptance"]
    UA --> W["Warranty, then<br/>usually maintenance"]
    CR["Change request<br/>priced separately"] -.-> RQ
```

</div>

**A migration** moves an old system to a new platform, language, or architecture while the business keeps running on it. The old system is the specification: whatever it does today, including behavior nobody wrote down, the new one must do or deliberately drop. The work runs in units, and each unit is translated, proven to behave like the old one, and switched over. The old system is retired only once the new one has held up in production.

<div align="center">

```mermaid
graph LR
    AS["Assess the old system<br/>and its business rules"] --> ST["Choose a strategy<br/>per component"]
    ST --> SQ["Split into units<br/>and order them"]
    SQ --> TR["Translate one unit"]
    TR --> VE{"Behaves like<br/>the old one?"}
    VE -- "no" --> TR
    VE -- "yes" --> CO["Switch traffic<br/>to the new unit"]
    CO --> SQ
    CO --> RE["Retire the old system<br/>once stable"]
```

</div>

**Business development and presales** is the work before a contract exists. It finds an opportunity, understands the customer's problem, shapes a solution, estimates it, and writes the proposal. For AI work it often starts with a discovery workshop and a small proof of concept. The output is a promise, which is why it needs the most care.

<div align="center">

```mermaid
graph LR
    O["Opportunity"] --> DI["Discovery<br/>the customer's real problem"]
    DI --> SO["Shape a solution<br/>and a delivery model"]
    SO --> ES["Estimate and price"]
    ES --> PR["Proposal and demo<br/>or proof of concept"]
    PR --> NE["Negotiate"]
    NE --> CT["Contract, then<br/>one of the four above"]
```

</div>

The last box matters. Presales decides which of the other four a project becomes, so a promise made there is inherited by everything after it.

### The five side by side

| | Dedicated team, billed by time | Maintenance and support | Fixed-bid project | Migration of an old system | Business development and presales |
| --- | --- | --- | --- | --- | --- |
| **How it is paid** | Hours or headcount, at a rate | A monthly fee with service levels, sometimes per ticket | One price for an agreed scope | One price per project or per wave of units | Cost of sale, paid by the deals that close |
| **Who keeps the saved hour** | The customer, through fewer billed hours, unless the contract changes | It depends on the contract | The vendor, who also carries the risk | Mostly the vendor | The vendor |
| **Where AI helps most** | Code, tests, documents, translation | Sorting tickets, answering from known fixes, investigating, small fixes | Estimation, design drafts, code, test generation | Reading old code, translating units, generating tests, reverse documentation | Discovery, proposal drafts, answers to requirements, demos |
| **Biggest risk** | Nobody has a reason to measure, and each customer allows different tools | The agent reads text written by outsiders, and the team slowly stops understanding the system | Promising savings in the price before they are proven, and scope that grows because "AI is fast" | Code that compiles but behaves differently, and a new system nobody understands | Promising savings you cannot prove, and customer documents pasted into tools |
| **Questions that weigh most** | 1, 7, 9 | 2, 9, 10, 11 | 5, 6, 10 | 3, 4, 10 | 1, 7 |

Two patterns come out of that table. First, **the more a machine can check the output, the more work AI can safely take.** A migration has an old system to compare against, so it can use the most. Presales has no test suite for a promise, so it should use the least without a person in the loop. Second, **the activities share their foundations.** One knowledge layer with permissions, workflows for fixed steps, a coding loop with an independent checker, and a way to watch production serve all five. Build those once and each activity is a configuration, not a new project. The sections below take the five in turn.

### Dedicated teams billed by time

The trap here is simple. If the customer pays for hours, every hour AI saves is an hour nobody bills. The vendor has no reason to measure, and the customer has no proof to ask for a better deal. Most teams do use AI, but "not measured yet" is their most common status. Question 7 is the bottleneck, not the tool.

The way out starts with the work, not the contract. **Split the work before you change the price.** Some tasks are repetitive, and their output can be counted. Some are semi-structured and can be measured through engineering signals. Some are exploratory, and their outcome cannot be defined in advance. Only the first kind can move to pricing by outcome. Saying openly that exploratory work stays on hours is what makes the other definitions believable.

Then **measure in the shadow before you change anything.** Keep invoicing as today and calculate in parallel what the new model would have charged. That gives the comparison question 7 asks for, at no risk to either side. When the numbers hold, move one step at a time, from committed capacity to shared savings to outcome pricing, and gate each step with data from the one before. Write the way back in advance too, for example a return to hours after two quarters of missed targets. That is question 6 applied to a contract.

Pricing is not the only thing that can stall a team. Each customer's AI policy is the data boundary: one customer allows code, another allows only documents you send them, a third allows nothing yet. Keep that list per project and check it before every new tool (question 9). And budget the tool quota as a cost of owning, because teams stall when credits run out mid-month. That belongs in question 5, not in a complaint.

### Maintenance and support

Maintenance is where AI should pay first, because the outcome is already countable: a ticket closed to the agreed standard. The closed tickets are also a free test set. Mask the personal data in a year of closed tickets and you have a golden dataset of real cases with known answers, ready for question 10. The same history gives a safe pilot for the hardest step. Replay impact analysis on closed change requests and compare the agent's list of affected parts with what actually changed. It is internal, cheap, and it tests the part that matters (question 6).

Not every step needs a model. Sorting tickets is a workflow, and so is the monthly service report, whose numbers must come from a query, never from a model. That is the rule from question 2. Where a model does help, define done where its work lands. For sorting, done means the ticket was not re-routed. For an answer, it means the customer did not ask again. For an investigation, it means the real cause was in the agent's top three. Those are the receiver-side measures from question 10.

The tickets that make a good test set are also the main risk, because every ticket is untrusted input. Customer emails, logs, and attachments are exactly where a hidden instruction can enter, so agents that read them start read-only, and every write needs a person (questions 8 and 9). A second risk is quieter: the team slowly stops understanding the system. Maintenance is where the theory of a program lives. Peter Naur used that word for the understanding in people's heads that lets them change a program safely (see the personal notes below). If an agent writes most fixes, ask each fix to explain why, not only what, and rotate people through the hard modules.

### Fixed-bid projects

Here the vendor keeps the saving and also carries the risk, so the questions about cost and checking come first. **Price only the savings a pilot has proven.** Everything else is a forecast and should be written as one, with its assumptions, a confidence level, and a trigger for re-estimating. A price cut based on an unproven saving is a loss the vendor pays for later.

The estimate itself needs three lines: building the AI support, running it, and the human hours to review and fix its output. The third line is the one most often forgotten, and it is where a good-looking productivity number turns into a late milestone (questions 5 and 10). It is also why the review queue belongs on the project dashboard. The first sign of trouble is not a slow agent. It is a growing pile of output nobody has checked.

Two older lessons still apply. Jevons applies to scope: when the customer hears how fast the agent is, more features appear, and every out-of-scope request still goes through a change request. Naur applies to the end of the contract. A fixed-bid project usually ends in warranty or maintenance, so name who will hold the theory after delivery. If nobody understands the code the agent wrote, the warranty is where the saving is paid back.

### Migrating an old system

Migration looks like the perfect AI job: a large amount of mechanical translation. [Migration is a harness](/blogs/blog/migration_is_a_harness/) argues that the naive version, legacy code in and modern system out, fails. What works is a loop built around the model. Before that loop runs, each component needs its own decision: rehost, replatform, refactor, replace, retire, or retain. Different components get different answers, and that is healthy.

**The judge comes first.** Because the old system is the specification, correct means behaving like it. That behavior can be captured as an inventory of business rules, golden outputs, recorded user flows, or a harness that runs old and new through the same surface and compares them. Anthropic's [code migration kit](https://github.com/anthropics/code-migration-kit-with-claude-code) puts it in one line: "No judge, no exit condition." This is question 10 in its strongest form.

The order of work follows question 4. Move the data before the logic: settle the data model first, then grow the new system around the old one through seams, unit by unit, as in [Martin Fowler's strangler fig](https://martinfowler.com/bliki/StranglerFigApplication.html). The first unit is the easiest one, because its job is to prove the pipeline and the judge, not the hard cases. Inside each unit, separate the one who writes from the one who checks. A planner hands out one unit at a time. An orchestrator runs a generator and an independent evaluator until the unit passes. Each passing unit becomes one commit, so a failed attempt is a clean reset away. The public [Bun port to Rust](https://bun.com/blog/bun-in-rust) used the same shape at a million lines, with reviewers that saw only the diff and were told to find what was wrong.

When failures repeat, fix the process, not the file. A failure seen once gets a fix. A failure seen three times means a rule is wrong, so change the rule and regenerate what it touched.

Cost is counted against the judge too: per unit proven equal, not per line produced. Then match the model to the role: a cheaper model that needs five loops per unit costs more than a capable one that needs one (question 5). The last risk is the one the code cannot show: **modern legacy**. Code-only modernization can produce a new system that nobody understands, which iSAQB calls a [real risk](https://www.isaqb.org/blog/ai-agents-dont-modernize-legacy-code-on-their-own). The understanding has to migrate too.

### Business development and presales

Presales is the one activity where the output cannot be tested before the customer reads it, so the questions about honesty matter most. **Sell the questions, not the tool.** The strongest offer is often not a tool at all. A discovery workshop that answers questions 1 to 4 with the customer is worth more than a demo, and it is the start of a project you can actually deliver.

Every claim in a proposal needs your own measurement behind it. Do not paste a study's number into a proposal as a promise, because question 7 shows the studies disagree. Show what you measured in your own delivery, with and without the tool. The same goes for people: selling AI-augmented engineers at a higher rate needs proof of how they check AI output, not a certificate that they used it. Governance is evidence too. A customer who is asked to move from hours to outcomes needs to see how the vendor measures, reviews, and switches things off. Dashboards and review discipline are what make outcome pricing believable.

Finally, keep customer material inside the boundary. Requirement documents and source code shared during a pursuit fall under question 9 like any other data. Drafting a proposal is a tier 1 task in the terms of question 3, but the documents it reads may not be.

### The same eleven questions, five answers

| Question | Dedicated team | Maintenance | Fixed bid | Migration | Presales |
| --- | --- | --- | --- | --- | --- |
| 1. The problem | Where hours go today | Where tickets wait | Where rework comes from | What the old system really does | What the customer actually loses |
| 3. Shape and tier | Augmented calls and workflows, tiers 1 to 2 | Workflows for sorting and reports, one agent for investigation, tiers 1 to 3 | Workflows and a checked coding loop, tiers 2 to 3 | Orchestrator, workers, outside judge, tier 3 | Augmented calls, tier 1 |
| 5. Cost to own | Tool quota and review hours | Cost per ticket closed to standard | Build, run, and review as three lines | Cost per unit proven equal | Time per proposal |
| 6. The pilot | Shadow billing on one team | Replay closed tickets and change requests | One module, priced only after proof | The easiest unit first, to build the pipeline | One discovery workshop |
| 7. Did it work | Effort per task and throughput, with and without the tool on similar tasks | Tickets closed to standard, time to resolve, reopens, re-routes, repeat questions, root cause in the top three | Cost per function, rework, escaped defects, the review queue | Units converted and proven to behave like the old ones, loops per unit | Time to a proposal, win rate, proposals backed by own data |
| 8. Authority | Suggests; people commit | Reads freely, writes with a person | Opens changes; people merge | Commits only what the judge passed | Drafts; people send |
| 10. Who checks | Reviewer hours in the plan | The receiver at the next level | Review queue as a metric | The judge and an independent evaluator | A person who signs each claim |

> **Lesson:** ask who keeps the saved hour before you ask which tool. The answer tells you who will measure, who must check, and how much of the work AI can safely carry.

## Personal notes on the work that is left

I think there are two common kinds of work today: building the agent system, and building the context system around it. They are the shared foundations the five kinds of delivery work stand on: a loop with an independent checker, and one knowledge layer with permissions. The eleven questions are the job of whoever signs off on a project. These two notes are about the people who build those foundations, and how they keep up. They lean on older thinkers than the Microsoft pages.

### Two kinds of work: the agent system and the context system

The first kind, the agent system, is about making the agent itself handle more of the task. That means four things: it runs longer without stopping, it survives failures, it spends less for the same result, and it takes on harder work. All four depend on something that has to come first: a target the agent can be checked against. Without a check, a longer run is just a longer way to be wrong, and a cheaper run cannot show that it still gives the same result. With a check, you can cut the steps and the cost, and prove the result stayed the same. This is an old discipline under a new name. Martin Fowler's [Refactoring](https://martinfowler.com/books/refactoring.html) (1999) describes refactoring as a series of small behavior-preserving transformations. Only a test can tell you the behavior was preserved. Making an agent faster or cheaper is a refactoring of the work itself. The test set from question 10 is what makes it safe.

The second kind of work is building the **context system**. The information the agent gets must be consistent, current, relevant, and just enough. It must also stay inside what the person asking may see, the rule from question 9. Connecting the tools, such as the issue tracker, the chat, and the document store, is only the starting point. The hard part is knowing where each fact came from, when it was valid, and which version applies. The model does not fix bad data. It combines what it is given, and it is very good at that, so most of the engineering is in what it is given. The model is the part you can rent. The context is the part nobody can sell you.

A context system also grows with the organization, and the hard problem changes at each step:

| Setting | Where the context lives | The hard part |
| --- | --- | --- |
| Solo developer | The repository, an instruction file, a folder of notes | The discipline to write things down |
| Small business | A few shared tools: chat, documents, an issue tracker | Knowledge lives in people's heads, so you need one shared truth |
| Manufacturer with a thousand people | Office tools plus the plant systems, machine data, and procedures, often on paper | The documents say one thing and the factory floor does another |
| Enterprise | Many teams, many tools, many copies | Permissions: the agent must see only what the asking person may see, and pick the right version |
| Company with several business units | Each unit's own systems and its own meaning for the same word | Shared meaning: does "customer" mean the same thing everywhere? |
| Global company | Many languages, regions, and laws | Data must stay where the law says, and meaning must survive translation |

The amount of data grows down that table, but that is not the real change. The hard problem moves: from discipline, to shared truth, to the gap between documents and reality, to permissions, to shared meaning, to law and language. Adding more documents to a search index does not settle any of those.

Under every row of that table sits one more layer of context, and no tool holds it. In 1985 Peter Naur wrote [Programming as Theory Building](https://pages.cs.wisc.edu/~remzi/Naur.pdf). His claim is that the program is not the code. It is the **theory** in the heads of the people who built it: the knowledge that lets them explain it and change it without breaking it. Then comes his sharpest line: "The death of a program happens when the programmer team possessing its theory is dissolved." A dead program keeps running. You find out when someone asks for a change and nobody can answer.

When an agent writes the code, nobody holds the theory by default. Geoffrey Huntley argues that software [no longer needs to be readable, only explainable](https://ghuntley.com/readable/) by a model on demand. I think that is half right. An explanation on request is useful, but it is not a person who understands the system and answers for it. The instruction files we now write for agents, a CLAUDE.md or an AGENTS.md, are the theory partly written down: what the system is for, which decisions were made and why, which source wins when two disagree. That is where the context system and the theory meet. It makes these files the most valuable documents a team can write today. They are still not the whole theory.

Michael Polanyi explained why in 1966, in [The Tacit Dimension](https://en.wikipedia.org/wiki/Tacit_knowledge): "we can know more than we can tell." You recognize a face without being able to say how. A senior knows which module is fragile and cannot write the full reason down. Every instruction file holds the part of the theory that could be told. The part that could not is still in someone's head, and it is often the part that matters when the system breaks. Someone has to hold it, and that person's time is part of the cost in question 5.

> **Lesson:** give the agent a target it can be checked against before you make it run longer or cheaper. Write the theory down, for the agent and for the next person. Name the person who will still understand the system in a year, and give them time to keep understanding it.

Go deeper:

- [Programming as Theory Building](https://pages.cs.wisc.edu/~remzi/Naur.pdf). Naur, 1985. Argues that a program lives in the understanding of the people who built it, which is why documentation alone cannot keep it alive.
- [The Tacit Dimension](https://en.wikipedia.org/wiki/Tacit_knowledge). Polanyi, 1966. Explains why the written theory is always smaller than the one in the head.
- [How to Build a Knowledgebase](/blogs/blog/how_to_build_knowledgebase/). An earlier post on this blog about why storing documents is not the same as having knowledge.

### How do we keep learning?

Both kinds of work run on tools that change every month. Problems and patterns do not. Learn the core idea behind a tool, how it is built, and where it stops working. Then you can judge the next ten tools built on the same idea without trying them all.

Choosing what to learn needs a checklist, in this order: what it does, the core idea, the cost, the license, whether it fits a need you actually have, and only then how popular it is. The useful core often does not look fancy. Learning it then needs a little practice every day: one small question for ten to fifteen minutes, such as sketching a system design for a requirement you have not seen before. Nobody can work on a large codebase every day, but small practice adds up. It also prepares you for the interviews and reviews where someone asks you to think out loud.

Sources can come from anywhere: professional networks, paper feeds, repositories, release notes. The rule is to follow the links before trusting the summary, because several posts copying one announcement are still one source. An earlier post on this blog, [How to learn?](/blogs/blog/how_to_learn/), puts it in one line: **qualify what you learn before you learn it.**

Why so little, so often? Richard Hamming answered that in 1986, in a talk called [You and Your Research](https://www.cs.virginia.edu/~robins/YouAndYourResearch.html). He had spent years at Bell Labs watching which scientists did work that lasted, and asking why most did not. One of his answers had nothing to do with talent. He passed on a line from his colleague Hendrik Bode: "Knowledge and productivity are like compound interest." Hamming's example: of two people with about the same ability, the one who works ten percent more will more than twice outproduce the other. Over a career the gap keeps growing, because each thing you understand makes the next one cheaper to learn.

Agents raise the interest rate. They can summarize anything in seconds, so the only thing that still compounds is your own understanding. The danger is accepting the summary without doing the work of understanding. Hamming also noticed that the people who worked with the door open got interrupted more, but "occasionally" picked up clues about what might be important. He said he could not prove cause and effect, only a good correlation with doing important work. That is a good reason to read widely and keep the door open, as long as the fifteen minutes still happen.

> **Lesson:** learn the idea, not the tool. Check the source before you learn from it. Fifteen minutes a day beats a long list of names you recognize.

Go deeper:

- [You and Your Research](https://www.cs.virginia.edu/~robins/YouAndYourResearch.html). Hamming, 1986. The full talk behind compound interest, open doors, and choosing important problems.
- [Through a Senior's Eyes](/blogs/blog/through_a_seniors_eyes/). An earlier post on this blog about what changes in how a senior sees a problem, rather than what they know.

## Two questions I cannot answer yet

Both notes rest on things I cannot prove yet. The learning note treats the urge to understand as a human strength. The context-system note assumes the agent is fed in natural language. So two questions remain: is curiosity part of intelligence, and could an agent work in a language built for its domain?

### Is curiosity part of intelligence?

In October 2026, an AI lab [released 722 papers](https://en.wikipedia.org/wiki/OpenAI_bulk_release_of_mathematical_papers) claiming results on major open problems in mathematics. Three were withdrawn within a day, and experts expect checking the rest to take months. The same week, Terence Tao gave a talk he had planned long before, [Math 2.0](https://terrytao.wordpress.com/2026/10/10/math-2-0/). It is not about whether these proofs are correct. He describes the present as shaped by "the excessive emphasis on automated solving of open problems by AI." He asks for a future where AI is used to support the mathematical community and the understanding that connects mathematics to the real world. In his [living summary of his views on AI](https://teorth.github.io/tao-web/ai-views.html), and in [earlier remarks reported secondhand](https://officechai.com/ai/terence-tao-hints-openai-wasnt-behaving-responsibly-by-simultaneously-releasing-300-math-proofs-says-its-making-math-less-fertile/), he worries that mass solving leaves a field "much less fertile": the answers exist, but nobody does the follow-up work that a hard problem usually sparks. His complaint is about the incentives around AI, not the tool.

His [slides](https://teorth.github.io/tao-web/slides/math-2-0-caltech-2026.pdf) pose a thought experiment: an AI finds a cancer cure that passes its clinical trial and comes with a machine-checked certificate, but nobody knows how it was found. Would you want at least one human expert who understands the mechanism, even partially, before the injection? That is Naur's question again, asked about a whole field.

Tao's concern points at something people do without being asked. When a person reads or builds something, questions show up that nobody assigned. Something bothers them, connects to an old idea, or makes them wonder what happens if an assumption changes. They keep thinking about it after the task is done. That is part of what I mean by human intelligence.

A model can solve a hard problem and produce good follow-up questions. Asking it to act curious produces more of them. But those outputs alone do not tell me whether anything matters to it beyond the task we gave it.

The question is also harder than it looks, because curiosity can already be built as a reward. Around 1990, Jürgen Schmidhuber described [artificial curiosity](https://people.idsia.ch/~juergen/artificial-curiosity-since-1990.html): a learning system rewarded for finding what its own model of the world cannot yet predict, and later for how fast its predictions improve. Systems built this way explore without being told where to look. So the test cannot be whether a machine seeks out the unknown. It has to separate solving the question in front of you from finding something you want to understand even after nobody is asking. What could I observe that would tell the two apart? **I do not know how to test that yet.**

### Could an agent work in a language built for its domain?

Natural language is a rich input. A vocabulary and a grammar let us express facts, logic, relationships, and ideas nobody has written before. That flexibility helps models connect ideas and produce useful, sometimes beautiful things. But the same language carries assumptions, biases, contradictions, fiction, and lies, and learning from it does not by itself teach a model which claims to trust. This is part of the hallucination problem, not a complete explanation of it.

An autonomous agent's main job is to solve problems and act. Conversation helps when it works with people, but it does not have to be the representation for every step inside the system. So my question is this: could an agent learn and operate directly through a language built for its domain?

By a **domain-specific language (DSL)**, I mean domain concepts with defined meanings, operations, types, and constraints. Mathematics has formulas and proof steps. A machine has states and allowed transitions. A robot has sensor readings, positions, velocities, and control signals. An agent acting in an environment also gets the effects of its own actions as input. Each of these can express a great deal within its domain without carrying all the ambiguity of everyday conversation. JetBrains' [MPS FAQ](https://www.jetbrains.com/help/mps/mps-faq.html) gives a short introduction to how such languages define their concepts and the rules that constrain them.

The model could still be probabilistic. The input would simply leave less for it to guess. Compare "the machine seems too hot" with a reading of 105°C against an operating limit of 90°C, from a sensor marked valid. The second makes the measurement and the threshold explicit. Choosing an action may still need more context, but the agent no longer has to guess what the speaker meant by "too hot."

One terminology note, because the words are easy to confuse. Meaning that depends on context is not the same as a **context-sensitive grammar** in formal language theory. Stuart Shieber showed in 1985 that some natural-language constructions go [beyond context-free grammars](https://www.eecs.harvard.edu/shieber/Biblio/Papers/shieber85.pdf), but that does not mean natural language needs unrestricted grammars. My concern is implicit meaning and ambiguity, not where language sits in the Chomsky hierarchy.

A DSL is also more than asking a model to return JSON. A JSON field can still hold ambiguous prose or an unsupported claim. I mean the representation the agent learns from and reasons with: observations kept apart from assumptions, explicit units and uncertainty, and actions whose requirements and effects can be checked before they run. Natural language would still connect human intentions to that system.

The DSL idea itself is old, and so is its cost. In the 1600s Leibniz dreamed of a [universal symbolic language](https://en.wikipedia.org/wiki/Characteristica_universalis) in which a dispute could be settled by calculation instead of argument. Three centuries later, the [expert systems](https://en.wikipedia.org/wiki/Expert_system) of the 1980s tried a smaller version: domain knowledge written down as explicit rules. They were precise inside their vocabulary and brittle the moment a case fell outside it. A DSL for agents would face the same trade: what the language leaves out, the agent cannot handle. So it needs a way to represent the unknown or to ask for help.

A DSL also would not remove false data, bad assumptions, or model errors. It could make some of them easier to catch before an action runs.

So the open question is whether we can keep enough expressive power for new combinations and useful reasoning, while making meaning explicit and actions easier to check. **Could a language like that support an agent's ability to learn, reason, and discover?** I treat the DSL idea as a hypothesis to test, not a claim that changing the language makes a model reliable.

## References

**Microsoft, official guidance**

- Cloud Adoption Framework for AI, Microsoft's official path from AI strategy to running AI in production: [strategy](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/strategy), [plan](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan), [ready](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/ready), [govern](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/govern), [secure](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/secure), [manage](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/manage), [responsible AI policies](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/responsible-ai-policies), and [AI Center of Excellence](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/center-of-excellence).
- Cloud Adoption Framework for AI agents, the same path applied to agents, including when not to use one: [overview](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai-agents/) and [business plan](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai-agents/business-strategy-plan).
- Well-Architected Framework for AI workloads, Microsoft's design and operating principles for a single AI system: [overview](https://learn.microsoft.com/en-us/azure/well-architected/ai/), [design principles](https://learn.microsoft.com/en-us/azure/well-architected/ai/design-principles), [testing and evaluation](https://learn.microsoft.com/en-us/azure/well-architected/ai/test), [responsible AI](https://learn.microsoft.com/en-us/azure/well-architected/ai/responsible-ai), [operations](https://learn.microsoft.com/en-us/azure/well-architected/ai/operations), and [MLOps and GenAIOps](https://learn.microsoft.com/en-us/azure/well-architected/ai/mlops-genaiops).
- Agents hub, Microsoft's guidance for evaluating and governing agents across an organization: [overview](https://learn.microsoft.com/en-us/agents/), [agent evaluation checklist](https://learn.microsoft.com/en-us/agents/agent-evaluation/evaluation-checklist), [agentic Center of Excellence](https://learn.microsoft.com/en-us/agents/center-of-excellence/), and [govern agents by risk](https://learn.microsoft.com/en-us/agents/center-of-excellence/govern-agents-risk).
- [Observability in generative AI](https://learn.microsoft.com/en-us/azure/foundry/concepts/observability), on evaluating, monitoring, and tracing a running system, and [red teaming for language model applications](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/red-teaming), on attacking your own system before others do.
- Azure Architecture Center: [AI agent orchestration patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns), the levels of complexity and the patterns between them, and the [baseline Foundry chat reference architecture](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/architecture/baseline-microsoft-foundry-chat), a tested design for answering questions from documents.
- [Responsible AI principles and approach](https://www.microsoft.com/en-us/ai/principles-and-approach). The six principles behind the risk questions in question 9.

**Microsoft AI Decision Framework** (a practitioner's guide on Microsoft's GitHub; verify against the official pages above)

- [Overview](https://microsoft.github.io/Microsoft-AI-Decision-Framework/), [capability model](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/capability-model.html), [decision method](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html), [scenarios](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/scenarios.html), [evaluation criteria](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/evaluation-criteria.html), [implementation patterns](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/implementation-patterns.html), [quick reference](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/quick-reference.html), and [engineering with agents](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/agentic-engineering.html). Together they cover how to sort a problem before naming a product, the trust levels of an agent, the complexity tiers, and how to verify agent-written code.

**Outside Microsoft**

- Anthropic, [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents) (2024). The augmented model, five workflow patterns, and when an agent is worth it.
- Anthropic, [Claude Platform Solution Design](https://anthropic-partners.skilljar.com/path/claude-certified-architect-professional/claude-platform-solution-design), part of the Claude Certified Architect partner course. The four decisions before a build: what the model owns, the shape, the reference architecture, and the model and context strategy. I used only its public outline; the lessons need a sign-in.
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework), [MITRE ATLAS](https://atlas.mitre.org/), and the [OWASP generative AI project](https://genai.owasp.org/). The risk management framework and the attack catalogs that the Microsoft governance and security pages build on.

**Fundamentals**

- Fred Brooks, [No Silver Bullet: Essence and Accident in Software Engineering](https://worrydream.com/refs/Brooks_1986_-_No_Silver_Bullet.pdf) (1986). The hard part of software is deciding what to build, not typing it.
- David Parnas, [On the Criteria To Be Used in Decomposing Systems into Modules](https://en.wikipedia.org/wiki/Information_hiding) (1972). Build each module around a decision likely to change, and hide that decision behind a stable interface.
- William Stanley Jevons, [The Coal Question](https://en.wikipedia.org/wiki/Jevons_paradox) (1865). Efficiency raises consumption.
- Jerome Saltzer, [least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege) (1974), developed with Michael Schroeder in "The Protection of Information in Computer Systems" (1975). Give every program and user only the access the job needs.
- Meir Lehman, [laws of software evolution](https://en.wikipedia.org/wiki/Lehman%27s_laws_of_software_evolution) (with Laszlo Belady, from 1974; eight laws by 1996). Law I, continuing change; law VII, declining quality.
- Edsger Dijkstra, [On the cruelty of really teaching computing science](https://www.cs.utexas.edu/~EWD/transcriptions/EWD10xx/EWD1036.html) (1988). Code belongs on the cost side of the ledger: "lines spent."
- Edsger Dijkstra, ["Testing shows the presence, not the absence of bugs"](https://en.wikiquote.org/wiki/Edsger_W._Dijkstra) (said at the 1969 NATO conference, report published 1970; also in Notes on Structured Programming, first circulated 1969).
- Martin Fowler, [Refactoring](https://martinfowler.com/books/refactoring.html) (1999). Improving code through small behavior-preserving transformations.
- Peter Naur, [Programming as Theory Building](https://pages.cs.wisc.edu/~remzi/Naur.pdf) (1985). A program lives in the understanding of the people who built it; documentation alone cannot carry it.
- Michael Polanyi, [The Tacit Dimension](https://en.wikipedia.org/wiki/Tacit_knowledge) (1966). "We can know more than we can tell."
- Richard Hamming, [You and Your Research](https://www.cs.virginia.edu/~robins/YouAndYourResearch.html) (1986). Knowledge as compound interest, a line he credits to Hendrik Bode.
- Diane Vaughan, [The Challenger Launch Decision](https://en.wikipedia.org/wiki/Normalization_of_deviance) (1996). How small accepted deviations became normal before the Challenger disaster.

**Studies on productivity**

- METR, [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity](https://arxiv.org/abs/2507.09089), with its [February 2026 update](https://metr.org/blog/2026-02-24-uplift-update/). Developers felt faster and were slower; the update leans toward a speedup but cannot say how much.
- Brynjolfsson, Li, and Raymond, [Generative AI at Work](https://arxiv.org/abs/2304.11771). Customer support; gains concentrated in the newest workers.
- [DORA: State of AI-assisted Software Development 2025](https://dora.dev/research/2025/dora-report/). AI as an amplifier of the system around it.

**Migration**

- [Migration is a harness](/blogs/blog/migration_is_a_harness/). An earlier post on this blog about the loop around the model: planner, orchestrator, generator, evaluator, and one commit per verified unit.
- Anthropic, [code migration kit with Claude Code](https://github.com/anthropics/code-migration-kit-with-claude-code). Rulebook, judge, and queues on disk. "No judge, no exit condition."
- Martin Fowler, [Strangler Fig Application](https://martinfowler.com/bliki/StranglerFigApplication.html). Grow the new system around the old one.
- Jarred Sumner, [Bun in Rust](https://bun.com/blog/bun-in-rust). A million-line port with implementer agents, adversarial reviewers, and the test suite as judge.
- Markus Harrer, [AI agents don't modernize legacy code on their own](https://www.isaqb.org/blog/ai-agents-dont-modernize-legacy-code-on-their-own) (iSAQB). Seams, characterization tests, and fitness functions as guardrails.

**Agents, understanding, and curiosity**

- Geoffrey Huntley, [Nobody should type code by hand anymore. Here's what's left.](https://ghuntley.com/agency/) Vision, verification, and agency. I only had access to the public part of this essay.
- Geoffrey Huntley, [Software doesn't need to be readable anymore. It needs to be explainable.](https://ghuntley.com/readable/) The argument that a model can explain code on demand, so humans no longer need to read it.
- Terence Tao, [Math 2.0](https://terrytao.wordpress.com/2026/10/10/math-2-0/) (October 2026), with the [slides](https://teorth.github.io/tao-web/slides/math-2-0-caltech-2026.pdf). Tao's own framing of his talk, including the cancer-cure thought experiment.
- Terence Tao, [living summary of his views on AI](https://teorth.github.io/tao-web/ai-views.html). His own wording on proof abundance and "less fertile" fields.
- [Tao's critique of mass AI problem solving](https://officechai.com/ai/terence-tao-hints-openai-wasnt-behaving-responsibly-by-simultaneously-releasing-300-math-proofs-says-its-making-math-less-fertile/). Secondhand reporting of his "harvesting" remark: solving problems in bulk leaves fields less fertile.
- [OpenAI bulk release of mathematical papers](https://en.wikipedia.org/wiki/OpenAI_bulk_release_of_mathematical_papers). Background on the release and the debate around it.
- Jürgen Schmidhuber, [Artificial curiosity since 1990](https://people.idsia.ch/~juergen/artificial-curiosity-since-1990.html). His own history of agents rewarded for what their world model cannot yet predict, and later for learning progress.

**A language for agents**

- JetBrains, [MPS FAQ: domain-specific languages](https://www.jetbrains.com/help/mps/mps-faq.html). An introduction to DSLs, language constraints, and domain-specific notation.
- Stuart Shieber, [Evidence Against the Context-Freeness of Natural Language](https://www.eecs.harvard.edu/shieber/Biblio/Papers/shieber85.pdf) (1985). Natural-language constructions that go beyond context-free grammars.
- [Characteristica universalis](https://en.wikipedia.org/wiki/Characteristica_universalis). Leibniz's plan for a universal symbolic language in which reasoning becomes calculation.
- [Expert systems](https://en.wikipedia.org/wiki/Expert_system). The 1980s attempt to write domain knowledge as explicit rules, with its strengths and its limits.
