---
title: "When Code Is Cheap"
description: "An agent writes the first version in twenty minutes. The question on a senior's desk is no longer how to build it, but whether a project should use AI at all, and what it will cost to own. Seven questions I ask before saying yes."
pubDate: "2026-10-24"
updatedDate: "2026-10-28"
author: "locchh"
draft: false
---

A feature that used to take an afternoon now takes an agent twenty minutes. For a few years that was my problem to enjoy. Now it is a different problem. People bring me a project and ask whether we should put AI in it. I have to say yes or no, and then live with the answer.

Fred Brooks saw this coming in 1986. In [No Silver Bullet](https://worrydream.com/refs/Brooks_1986_-_No_Silver_Bullet.pdf) he split software work into the **essence**, the ideas and rules a program must get right, and the **accident**, the labor of typing those ideas into a machine. Then he said which part is hard: "the specification, design, and testing of this conceptual construct, not the labor of representing it." Agents made the labor cheap. The essence is now the whole job. And the first piece of it is the one he called hardest: "deciding precisely what to build."

Below are the seven questions I ask before I say yes to AI in a project. Each one has a reason from the fundamentals, and each one has a reason from Microsoft's own guidance for people who make this decision. I keep the list short because I want to use it, not admire it.

## 1. What is the problem, before AI?

Microsoft's [planning guide](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan) opens with a sentence I wish every request came with: start with business problems, and look for where results miss expectations "before you consider AI at all."

Most requests arrive as a solution. Someone asks for a chatbot because a chatbot is the solution they can picture. Go and watch the work first. Maybe staff cannot find the answer. Maybe they find it in seconds and then wait a day for a manager's approval. A chatbot fixes one of those and does nothing for the other. The people doing the work know where the delay is. Our job is to go and look with them.

Then measure the work as it is today: how long each case takes, how many are finished, how many come back. Without that number there is nothing to compare against later, and every result will look like success.

> **Lesson:** describe the delay or the loss before you describe the tool. If you cannot name what gets better, you are not ready to build.

## 2. Does it need AI at all, and does something already exist?

The [Microsoft AI Decision Framework](https://microsoft.github.io/Microsoft-AI-Decision-Framework/) has a rule I now repeat in every meeting: ["never lead with a product."](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html) Result first, then the situation, then how the system should behave. The technology comes last.

It also asks a checkpoint question before any of that: does this need an agent? If the steps are fixed and the input is structured, ordinary code is cheaper and more reliable. If people just need to find a document, that is search. And for numbers, the [scenarios page](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/scenarios.html) is blunt: "if the problem has a numerically correct answer, an LLM is the wrong tool for producing it." A model is good at reading messy input. It is not a calculator and not a database.

Then it gives a ladder: use something that exists, configure it, extend it, and build only at the top. The honest part is the rule for climbing. You must be able to explain why each rung below failed. If you cannot, you are not building because you need to. You are building because building got cheap. One more line from the same page is worth keeping: "Audition the soloist before you hire the orchestra." One agent with good tools, before any talk of several.

> **Lesson:** explain why plain code, search, and an existing product all failed before you fund a model.

## 3. What will it cost to own, not to build?

Here is the trap inside the word "cheap." In 1865 the economist William Jevons watched steam engines become far more efficient while everyone around him expected England to burn less coal. It burned more, and he explained why: cheaper coal found more uses. His line still applies: ["It is a confusion of ideas to suppose that the economical use of fuel is equivalent to diminished consumption."](https://en.wikipedia.org/wiki/Jevons_paradox)

Code behaves like coal. When a feature costs twenty minutes, we ask for twenty features, and every one still has to be read, run, kept working, and understood. Dijkstra said in 1988 that we count lines of code [on the wrong side of the ledger](https://www.cs.utexas.edu/~EWD/transcriptions/EWD10xx/EWD1036.html): they are not "lines produced" but "lines spent." The framework's [capability model](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/capability-model.html) puts it in four words: "Building got cheap. Owning didn't."

The same page pictures every agent as a coin. One side is the demo: visible, interactive, easy to show in a meeting. The other side runs in the background with nobody at the keyboard, and that side is what changes the operating cost. The demo gets the project approved. The other side is what you own. So I budget the two separately, and I include the cost of checking the output, because a metered system quietly tempts you to measure less.

The number I want is simple: the total cost of one outcome that met the agreed standard, with the checking and the fixing included. Count only the cases that met the standard. Keep the rejected and unfinished ones visible, or dropping the hard cases will make the average look good. And remember that staff time freed by AI is capacity, not cash. It becomes a saving only if spending actually falls, or if someone names what the freed hours will now do.

> **Lesson:** price the side of the coin nobody watches. Cost per good outcome, checking included.

## 4. How much may it do alone, and who answers for it?

The capability model separates three levels of trust: the system **recommends**, it **acts within set limits**, or it **owns the outcome**. The line between the first two is where accountability changes hands, and that line is the real design decision. The page says it in one sentence: "Capability is a demo. Authority is a liability."

So I decide, per action, what the system may do. Reading can be logged. Writing needs a person to confirm. Anything destructive needs approval through a separate channel, from someone who owns the process. Drafting a reply to a customer and sending it are different jobs, and I treat them as different jobs. Every production duty gets a [named owner](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/evaluation-criteria.html): one for the business result and one for keeping the service alive. The decision page gives the test I use at the end: "An agent you cannot see, attribute, or switch off is not in production."

None of this is a limit on the technology. It is how the project survives its first bad week. AI informs. Humans commit.

> **Lesson:** decide which actions it may take alone, which need a person, and who is named when it goes wrong. Before launch, not after.

## 5. Who will check the output, and is that capacity planned?

Dijkstra, 1969: ["Testing shows the presence, not the absence of bugs."](https://en.wikiquote.org/wiki/Edsger_W._Dijkstra) That was true when a human wrote every line. It matters more now, because an agent can pass every check we thought to write and still miss the reason the ticket exists. The scenarios page says it in one breath: "Generation got cheap. Verification did not." Geoffrey Huntley, asked [what is left](https://ghuntley.com/agency/) when nobody types code by hand, answers: vision, verification, and agency. Two of the three are about checking.

My test for "done" is simple: the next person can do their job with the output. Say we build a tool that summarizes support tickets. The summaries are clear and complete. Then an engineer notices one left out the customer's software version and mixed up a fix that was tried with one that was only suggested. So they reread the whole conversation. We shipped a feature, and the workflow gained one more document to check. So "done" is decided by whoever receives the output, not by whoever produces it. Build the proof there, with the receiver, on real cases.

Then plan the checking as work, with people and hours. If an agent opens forty changes a day and the team can honestly review ten, the extra thirty are a pile going stale in a queue. I did that arithmetic in [Through a Senior's Eyes](/blogs/blog/through_a_seniors_eyes/): more workers do not make the one person who decides any faster.

And watch for the slow failure. Diane Vaughan studied the Challenger disaster and named it the [normalization of deviance](https://en.wikipedia.org/wiki/Normalization_of_deviance): each time a check is skipped and nothing goes wrong, skipping becomes a little more normal. An agent that has been right ten times is the perfect setup. The eleventh review is the one you will want to skip.

> **Lesson:** define done by what the next person can do with it. Budget the review. Keep reviewing after it has been right ten times.

## 6. Who will understand it in a year?

In 1985 Peter Naur wrote [Programming as Theory Building](https://pages.cs.wisc.edu/~remzi/Naur.pdf). His claim is that the program is not the code. It is the **theory** in the heads of the people who built it: the knowledge that lets them explain it and change it without breaking it. Then the definition I cannot forget: "The death of a program happens when the programmer team possessing its theory is dissolved." A dead program keeps running. You find out when someone asks for a change and nobody can answer.

When an agent writes the code, nobody holds the theory by default. Geoffrey Huntley argues that software [no longer needs to be readable, only explainable](https://ghuntley.com/readable/) by a model on demand. I think that is half right. An explanation on request is useful. It is not a person who understands the system and answers for it. The instruction files we now write for agents, a CLAUDE.md or an AGENTS.md, are the theory partly written down: what the system is for, which decisions were made and why, which source wins when two disagree. That is the most valuable document a team can write today. It is still not the whole theory. Someone has to hold the rest, and that person's time is part of the cost in question 3.

> **Lesson:** name the person who will still understand this system in a year, and give them the time to keep understanding it.

## 7. How will we know it worked?

If AI made the work cheaper, we should be able to show where the time went. Usually we cannot, because we trust how it feels.

In early 2025, [METR](https://arxiv.org/abs/2507.09089) randomly assigned real tasks to experienced open-source developers, with and without AI. They finished about a fifth slower with AI. They believed they had been about a fifth faster. Same people, same work, opposite numbers. In its [February 2026 update](https://metr.org/blog/2026-02-24-uplift-update/), METR says developers likely get more help from AI than they did in early 2025, but its new numbers still show no clear speedup, and it calls its own data "only very weak evidence."

The other side exists too. A study of over five thousand [customer support workers](https://arxiv.org/abs/2304.11771) found AI help raised issues resolved per hour, with the gain going mostly to the newest workers. So for individuals AI can be a leveler. For teams, [DORA's 2025 report](https://dora.dev/research/2025/dora-report/) calls it an amplifier: a strong system gets stronger, a weak one is exposed. The two findings do not agree, and that is the point.

None of these is a number to paste into a business case. Together they are one instruction: measure in your own setting. Decide before the pilot what would make you expand it, change it, or stop it. Compare similar cases with and without the tool. Look at the slow cases, not just the average. Give delayed failures time to appear. A good demo is a reason to keep testing, not a permission to roll out.

> **Lesson:** faster is a measurement, not a mood. Write down what "stop" looks like before you start.

## The list, to come back to

| Question | What I want to see before I say yes |
| --- | --- |
| What is the problem, before AI? | The delay or loss, named and measured as it is today |
| Does it need AI, and does something exist? | Why plain code, search, and an existing product each failed |
| What will it cost to own? | Cost per good outcome, checking included, build and run budgeted apart |
| How much may it do alone? | Which actions need a person, and the named owners |
| Who checks it? | Done defined by the receiver, and review hours planned |
| Who understands it in a year? | A named person, with time, and the theory written down |
| How will we know it worked? | A comparison planned in advance, with a stop condition |

**When code is cheap, the senior's job is to pay for what stayed expensive: deciding, owning, checking, and understanding.** Brooks described that job in 1986. The agent just made it impossible to hide behind the typing.

## Two questions I cannot answer yet

The practical list above leaves me with two questions about intelligence itself.

### Is curiosity part of intelligence?

This month an AI lab [released 722 papers](https://en.wikipedia.org/wiki/OpenAI_bulk_release_of_mathematical_papers) claiming results on major open problems in mathematics. Three were withdrawn within a day, and experts expect checking the rest to take months. The same week, Terence Tao gave a talk he had planned long before, [Math 2.0](https://terrytao.wordpress.com/2026/10/10/math-2-0/). It is not about whether these proofs are correct. He describes the present as shaped by "the excessive emphasis on automated solving of open problems by AI," and he asks for a future where AI is used to support the mathematical community and the understanding that connects mathematics to the real world. His [slides](https://teorth.github.io/tao-web/slides/math-2-0-caltech-2026.pdf) pose a thought experiment: an AI finds a cancer cure that passes its clinical trial and comes with a machine-checked certificate, but nobody knows how it was found. Would you want at least one human expert who understands the mechanism, even partially, before the injection? That is Naur's question again, asked about a whole field.

His concern made me notice something about my own work. When I read or build something, questions show up that nobody asked for. Something bothers me, connects to an old idea, or makes me wonder what happens if I change an assumption. I keep thinking about it after the task is done. That is part of what I mean by human intelligence.

A model can solve a hard problem and produce good follow-up questions. Asking it to act curious produces more of them. But those outputs alone do not tell me whether it has curiosity of its own. What could I observe that would separate producing useful questions from wanting to understand something when nobody is asking? **I do not know how to test that yet.**

### What could an agent learn from, besides language?

Natural language is a rich input. A vocabulary and a grammar let us express facts, logic, relationships, and ideas nobody has written before. The same input carries assumptions, biases, contradictions, fiction, and lies. Could another kind of input keep the expressive power while making some of those problems easier to handle? I have not decided what form it should take, or whether it should look like a language at all.

An agent's job is to solve problems and act. Conversation helps it work with people. But what would help it learn about the problems themselves and the effects of its actions? Mathematics, machine states, sensor readings, and interaction with an environment give me places to look. Would such an input need something like vocabulary and grammar? How would it carry context or uncertainty? Would it help with errors and made-up answers? **What kind of input could support an agent's ability to learn, reason, and discover?** I am still exploring the question.

## References

- Microsoft, [Plan for AI adoption](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ai/plan). Start with business problems before considering AI; measure readiness; run a focused proof of concept.
- Microsoft AI Decision Framework: [overview](https://microsoft.github.io/Microsoft-AI-Decision-Framework/), [decision method](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/decision-framework.html) ("never lead with a product", the ladder), [capability model](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/capability-model.html) (the coin, the three levels of trust), [scenarios](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/scenarios.html) ("Generation got cheap. Verification did not."), [evaluation criteria](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/evaluation-criteria.html) (cost of owning, action risk, named owners), and [engineering with agents](https://microsoft.github.io/Microsoft-AI-Decision-Framework/docs/agentic-engineering.html).
- Microsoft, [Agentic AI Business Solutions Architect certification](https://learn.microsoft.com/en-us/credentials/certifications/agentic-ai-business-solutions-architect/). The role puts measuring results, monitoring, and return on investment beside architecture.
- Fred Brooks, [No Silver Bullet: Essence and Accident in Software Engineering](https://worrydream.com/refs/Brooks_1986_-_No_Silver_Bullet.pdf) (1986).
- William Stanley Jevons, [The Coal Question](https://en.wikipedia.org/wiki/Jevons_paradox) (1865). Efficiency raises consumption.
- Edsger Dijkstra, [On the cruelty of really teaching computing science](https://www.cs.utexas.edu/~EWD/transcriptions/EWD10xx/EWD1036.html) (1988). "Lines spent."
- Edsger Dijkstra, ["Testing shows the presence, not the absence of bugs"](https://en.wikiquote.org/wiki/Edsger_W._Dijkstra) (1969 NATO conference report; restated in Notes on Structured Programming, 1970).
- Peter Naur, [Programming as Theory Building](https://pages.cs.wisc.edu/~remzi/Naur.pdf) (1985).
- Diane Vaughan, [The Challenger Launch Decision](https://en.wikipedia.org/wiki/Normalization_of_deviance) (1996). Normalization of deviance.
- Geoffrey Huntley, [Nobody should type code by hand anymore. Here's what's left.](https://ghuntley.com/agency/) Vision, verification, and agency. I only had access to the public part of this essay.
- Geoffrey Huntley, [Software doesn't need to be readable anymore. It needs to be explainable.](https://ghuntley.com/readable/)
- Terence Tao, [Math 2.0](https://terrytao.wordpress.com/2026/10/10/math-2-0/) (October 2026), with the [slides](https://teorth.github.io/tao-web/slides/math-2-0-caltech-2026.pdf). Tao's own framing of his talk.
- [OpenAI bulk release of mathematical papers](https://en.wikipedia.org/wiki/OpenAI_bulk_release_of_mathematical_papers). Background on the release and the debate around it.
- Brynjolfsson, Li, and Raymond, [Generative AI at Work](https://arxiv.org/abs/2304.11771). Customer support; gains concentrated in the newest workers.
- METR, [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity](https://arxiv.org/abs/2507.09089), with its [February 2026 update](https://metr.org/blog/2026-02-24-uplift-update/).
- [DORA: State of AI-assisted Software Development 2025](https://dora.dev/research/2025/dora-report/). AI as an amplifier.
