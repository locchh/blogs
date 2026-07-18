---
title: "You can't fork yourself"
description: "The brain isn't sequential — it's parallel hardware with one serial seat. Why focus is a count, not a skill, and how to work with agents that can fork when you can't."
pubDate: "2026-07-17"
author: "locchh"
tags: ["attention", "cognitive-science", "ai-agent", "focus", "collaboration"]
draft: false
---

I can cook dinner while listening to music. I cannot read while I code. That small, stupid fact bothered me for a week, because it breaks the story I'd been telling myself — that I'm bad at multitasking, that focus is a muscle I never trained hard enough. If focus were a muscle, cooking-and-music would be just as impossible as reading-and-coding. It isn't. So the muscle story is wrong, and something more interesting is going on.

Here's what set it off. I'd been running AI agents the way the tools now let you — spawn a handful, let them work in parallel, come back and collect the results. The machine juggles sixteen tasks without breaking a sweat. I sat in the middle of it and watched my own head fill up and stall at *two*. The obvious question — *why can the agent do this and I can't?* — has an obvious answer that turns out to be completely backwards.

## Your brain is not sequential

The usual way people put it is "brains are serial, computers are parallel." It's exactly upside down.

The brain is the most parallel machine we know of. Eighty-six billion neurons firing at once; Hebb's cell assemblies lighting up in parallel; the whole visual field processed everywhere-at-once before you're aware of any of it. Nothing about the *hardware* is sequential. What's sequential is the thin stream that comes out the top — the one voice narrating, the single train of thought, the thing you experience as "paying attention."

Cognitive science has a name for that stream. [Global Workspace Theory](https://pmc.ncbi.nlm.nih.gov/articles/PMC8770991/) (Bernard Baars, 1988; later given a neural home by Stanislas Dehaene) says consciousness is a *serial broadcast* picked out of a huge amount of parallel, unconscious processing. In Dehaene's words: among the millions of signals crossing the brain unconsciously, *one* is picked because it matters to your current goal, then made available to all your decision systems at once. Parallel hardware; serial spotlight.

```mermaid
graph TD
    subgraph PAR["Parallel substrate — unconscious, always on"]
        p1["vision"]
        p2["language"]
        p3["motor plans"]
        p4["memory recall"]
        p5["..."]
    end
    PAR -->|"one coalition wins ignition"| GW["Global workspace<br/>(the serial seat)"]
    GW -->|"broadcast"| ACT["A single coherent<br/>thought / decision / action"]
```

So the real shape is **parallel hardware → one serial seat**. And the agent, it turns out, is the *mirror image*: many parallel workers → one serial orchestrator that collects and decides. Neither is purely serial or purely parallel. The whole question is *where each one puts its single seat* — and why.

## Why the stream is serial (and why that's a feature)

The seat isn't serial because evolution ran out of neurons. It's serial for three reasons, and none of them is a flaw to fix:

- **One body.** You have one mouth, one pair of hands, one *next action*. You cannot turn left and right at once. Your output has to come one step at a time, because the thing it controls is single. And the thought behind the action lines up one step at a time to match.
- **One coherent self to protect.** The workspace's job is to force all the parallel options to collapse into *one* winning state you can act on and defend. Working memory is famously tiny — Nelson Cowan puts it at about [four chunks](https://en.wikipedia.org/wiki/The_Magical_Number_Seven,_Plus_or_Minus_Two), not the seven most people remember from Miller. That tiny size isn't a bug in the seat. It *is* the seat: a bottleneck narrow enough to guarantee a single answer.
- **Coherence is serial by nature.** Hebb's *phase sequence* — one cell assembly firing the next, in order — *is* a train of thought exactly because it runs in order. (I wrote about this in [how to build a knowledge base](/blogs/blog/how_to_build_knowledgebase/).) Fire every assembly at once and you don't get faster thinking. You get a seizure.

The lab version of this is the **central bottleneck**. [Harold Pashler's](https://laplab.ucsd.edu/articles/Pashler_PB1994.pdf) work on the *psychological refractory period* shows that when two tasks both need the central stage that picks a response, the second one *waits* for the first. Even when you tell people to treat both tasks as equally important, the waiting is still there. It's built into the machinery, not a habit you can coach away. There is one central stage, and it serves one customer at a time.

So the serial seat is **essential**. It's the price of staying coherent, not a sign the brain is short on power.

## It was never focus — it was channels

Back to the onions. Why *can* I cook to music but not read while coding? Because "attention" is not one thing. [Christopher Wickens' Multiple Resource Theory](https://interruptions.net/literature/Wickens-HF08.pdf) says you don't have a single pool of attention but *several*. They split by sense (seeing vs. hearing), by kind of information (verbal vs. spatial), and by response (hands vs. voice). Two tasks get in each other's way based on how much they pull from the *same* pool. Sharing time between tasks is easy when the pools are separate, and brutal when they collide.

| task pair | resources each demands | verdict |
|---|---|---|
| cook + music | motor/spatial + passive auditory — mostly automatic | coexist ✓ |
| walk + talk | motor + verbal | coexist ✓ |
| read + code | the central verbal-symbolic reasoner — both | collide ✗ |
| code + code (two problems) | the central verbal-symbolic reasoner — both | collide ✗ |

Read across it and the pattern is plain. Cooking and music hit two different, cheap, half-automatic channels. Reading and coding both demand the *one* channel that matters for knowledge work: the central symbolic reasoner — the part that reads meaning, holds a model in your head, and reasons forward. Two hands reaching for one tool. One wins; the other drops.

So the thing we have exactly one of isn't "attention" in general — it's **one central symbolic reasoner**. Everything on the edges, everything we've drilled until it runs on its own, we do in bulk all day long. The single reasoner is the only resource we can neither copy nor push into the background. And — hold this thought — it's exactly the resource an AI agent can copy.

## Focus is a count, not a skill

This reframes the whole self-improvement project. You don't "lose focus" because your willpower is weak. You lose it because two System-2 tasks are competing for the single reasoner, and no amount of grit adds a second one. Focus was never a muscle. **It's a count problem, and the count is one.**

There is exactly one way a human ever *appears* to add a reasoner, and it's not by trying harder — it's by making part of the work stop needing one. [Schneider and Shiffrin (1977)](https://psych.indiana.edu/documents/shiffrin-and-schneider-1977.pdf) drew the line between *controlled* processing (one step at a time, limited in how much it holds, eats the central channel) and *automatic* processing (built by steady practice, runs without using up the seat). Practice doesn't strengthen focus. It *kicks a task out of the seat entirely*. I said the same thing in [how to learn](/blogs/blog/how_to_learn/) without knowing the citation: "type the syntax enough times and your hands stop asking your brain for permission… that frees your attention for the problem instead of the keystrokes." That's automaticity pushing typing out of the reasoner, so the reasoner is free for the *problem*. But the problem itself — reading the meaning, making the decision — never leaves the seat. That core is the single seat, and it stays single forever.

And here's the part that should end the "just multitask" fantasy for good: switching between System-2 tasks isn't free. It's *expensive, and you can measure it*. Sophie Leroy named the cost **attention residue** — when you switch from A to B, part of your attention stays stuck on A, for [20 minutes or more](https://get-alfred.ai/blog/attention-residue), and people who switch mid-task do 30–40% worse on the next one. Gloria Mark's field work puts the recovery at [23 minutes and 15 seconds](https://nimea.app/en/blog/focus-and-interruptions) to get back to the same depth after a single interruption — while knowledge workers get interrupted every few minutes. Do the math and most people never reach full depth at all. The seat isn't just single. It's also *slow to sit back down*. Every switch pays a tax, in a currency you can't earn back.

## What the agent does instead — it forks

Now put the agent next to you and the difference snaps into focus. When a system "runs sixteen tasks at once," that is not one mind holding sixteen things. It's sixteen minds each holding *one* — sixteen fresh context windows, kept apart, each running a single thread, each dying when its one job is done. Every single agent in the swarm runs the same **WIP = 1** discipline a focused human does. The parallel work happens *between* agents, never *inside* one.

Anthropic's own [multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system) is the clean example: a lead agent plans, spawns three-to-five subagents *in parallel*, each with its own goal and its own context, and then pulls the results together. It beat the single-agent version by 90%. A spawned subagent isn't a spare hand or a background song — it's a **second full reasoner**. That's the entire difference, put as plainly as it will go:

> An agent can `fork()` a second reasoner. You have exactly one, and it does not copy.

The machine's ceiling isn't attention — it's silicon. As one engineer who ran a twenty-agent swarm for a year put it, "[my ceiling stopped being attention and became hardware; the machine taps out before I do](https://zachwills.net/i-managed-a-swarm-of-20-ai-agents-for-a-week-here-are-the-8-rules-i-learned/)." Your ceiling is the seat. Its ceiling is `min(16, cores − 2)`. Those are different games.

But notice what the swarm does at the end: it *goes serial again*. The lead agent, the orchestrator, is a single decision-maker working one step at a time. It doesn't hold sixteen tasks in mind. It holds one: coordinate, wait, merge. The parallel work buys speed on the *doing*. The *deciding* collapses back to one seat, because deciding is the one thing that never runs in parallel. (I made this argument from the other side in [migration is a harness](/blogs/blog/migration_is_a_harness/): parallel generator-and-evaluator loops, but a single orchestrator that commits. And in the knowledge-base post: "merging is just a big write" — join two graphs without a reasoning step and you keep both contradictory facts, so the agent flips a coin at answer time. Remove the serial seat and you get contradictions.)

## The bottleneck flipped

This is where the small personal puzzle becomes the industry's whole 2026 story. When the agents got fast and forkable, the limit didn't disappear — it *moved*. It moved onto you.

The reports all say the same thing in different words. "[The bottleneck has moved from writing code to reading it.](https://www.developersdigest.tech/blog/ai-coding-agents-review-queues)" A developer with an agent opens more PRs per day than any human review queue can keep up with, and [review capacity doesn't scale](https://dev.to/code-board/the-review-bottleneck-why-more-ai-code-means-slower-teams-in-2026-1e5n). The merge conflicts and the review backlog aren't signs the agents are failing — they're signs the agents are *succeeding faster than one human seat can pull the work together*. The bottleneck isn't the AI. It's the single reasoner trying to coordinate a flood of them.

Which means the seat you have exactly one of is now the scarcest resource in the whole system. The interesting question stops being "how do I focus harder" and becomes "**where do I spend the one seat I have?**"

## The strategy: be the orchestrator, not the swarm

The trap is to try to be the swarm — to sit in the middle of sixteen agents and personally track all sixteen. That's asking your one central reasoner to do the one thing it simply cannot do, and paying the 23-minute switch tax on every jump between them. You'll burn out by lunch and pull nothing together.

The move is to do what the swarm already does with its lead agent: **stop being a worker, become the orchestrator.** Cybernetics has the cleanest statement of why. Ashby's *Law of Requisite Variety* — "[only variety can absorb variety](https://www.thoughtworks.com/en-us/insights/blog/generative-ai/cybernetics-and-human-on-the-loop-in-agentic-coding)" — means that to keep up with a system that can do many different things, you need to be able to do just as many. Put plainly: a single human seat can't match sixteen parallel workers head-on. The only response is to *step up a level*: stop reviewing every line, and start steering the system that produces the lines. Human-in-the-loop becomes human-*on*-the-loop, or, as the same piece warns, "we'll become a fracture point."

Here's the playbook I've landed on — every rule is really the same rule, *protect the single seat and spend it only where it's irreplaceable*:

```mermaid
graph TD
    You(["👤 You — the one seat"]) -->|"amplify: encode<br/>rules, policies, context"| Sys
    Sys["Agent swarm<br/>(forked reasoners, WIP=1 each)"] -->|"work in parallel"| Out["Outputs, metrics, diffs"]
    Out -->|"attenuate: dashboards,<br/>alert on threshold only"| Gate{"Needs judgment?"}
    Gate -->|"no — evaluable in code"| Auto["Auto-verify: tests,<br/>schema, lint, format"]
    Gate -->|"yes — irreversible or<br/>ambiguous"| You
    Auto -.->|"only exceptions surface"| You
```

- **Amplify, then attenuate.** *Amplify* your judgment outward by writing it down once — decision rules, policies, a `CLAUDE.md`, a domain knowledge base — so the agents carry your intent without you repeating it. Then *attenuate*, or filter down, what comes back: roll it up into dashboards, and get alerted only when something crosses a limit, so your seat sees the exceptions and not everything. (Both terms are Ashby's, via Thoughtworks.)
- **Automate what can be evaluated; interrupt only for judgment.** Anything a test, a schema check, or a linter can decide should never touch your seat. Save the human interrupt for the two things a check can't do: the *irreversible* call and the *unclear* one. This is the same gate as [migration's](/blogs/blog/migration_is_a_harness/) "AI informs, humans commit". The human steps in twice — to set strategy and to sign off — not sixteen times.
- **Manage orchestrators, not agents.** Don't watch twenty workers. Run one or two long-running orchestrator threads that hold the plan and hand out the work. One human seat can hold *one* orchestrator's context. It cannot hold twenty workers'. Match how wide you fan out to the seat, not to the machine.
- **Run your own WIP = 1, and batch to defend it.** The switch tax is real, and it's twenty-three minutes. So don't switch back and forth — *batch*. Review one agent's output all the way to done, then the next. Give the seat one thing at a time, the same discipline you give each subagent, because you fall under the exact same law they do. Cal Newport's first principle of [slow productivity](https://www.youtube.com/watch?v=0HMjTxKRbaI) is this same rule from the other direction: *do fewer things* never meant *accomplish fewer things*. It means do fewer *at once*, so more of the day goes to finishing what you started instead of paying off attention residue. Fewer at once finishes more.
- **Pace the seat — it runs on biology, not silicon.** The swarm runs flat out around the clock because its ceiling is hardware. Yours is a nervous system. Newport calls the state that constant switching produces "exhausting and frustrating". Burnout isn't a character flaw. It's what happens when a biological seat tries to run as constantly as silicon does. His second principle, a *natural pace*, is the fix: busy days and quiet days, busy seasons and quiet seasons. Humans worked in seasons for a hundred thousand years before knowledge work pretended otherwise. The swarm's uptime is not the standard you should match. A seat that rests decides better than a seat that runs flat out, and deciding is the only thing the seat is for.
- **Externalize state so a switch is cheap to recover.** Your half-finished thinking lives in working memory, which is easy to wipe, and a switch overwrites it. Write it down — a plan, a progress file, a commit — so when you *do* sit back down, you reload from disk instead of from a faded memory. The swarm survives dead sessions this way, and so can you.

The thread running through all of it: you can run *search*, generation, and review in parallel — hand those to forks. You cannot run *understanding* in parallel, because understanding is the act of collapsing many parallel options into one coherent structure, and that collapse can only happen one step at a time. That collapse is what your one seat is *for*. Spend it there and nowhere else.

## What the seat is worth now

For most of the history of this work, the bottleneck was making the thing — writing the code, drawing the design, producing the output. The seat spent most of its time *producing*. That era is closing. Production forks now. It runs sixteen-wide on hardware that taps out before you do.

And the way we *measure* the work breaks at the same moment. Newport's [diagnosis](https://www.youtube.com/watch?v=0HMjTxKRbaI) is that knowledge work never had a real way to measure productivity — no Model-Ts-per-hour-of-work — so we fell back on **pseudo-productivity**: "visible activity as a crude proxy for useful effort." Look busy, answer fast, be seen active in the chat. An agent swarm is the extreme version of that stand-in: it produces unlimited visible activity — commits, PRs, messages, around the clock — none of it evidence of anything. The moment activity becomes free, activity becomes worthless as a signal, and the only measure left standing is the one [*Slow Productivity*](https://calnewport.com/) argues we should have been using all along: the quality of what actually ships over time. Which is exactly the seat's product, and nobody else's.

I should have seen this coming, because I ended [coding today](/blogs/blog/coding_today/) with Jevons paradox — efficiency doesn't shrink demand, it explodes it — and then grumbled that AI hadn't freed my day, it had filled it with more review, more testing, more pressure to deliver. I didn't see then that the paradox has an *address*: the exploded demand lands on the seat. That's the burnout mechanism in one sentence — production went parallel, integration stayed serial, and the serial part is a person.

What's left for the one seat is exactly what never forked: judgment, taste, the merge, the irreversible decision — and, quietly the highest-value job in a swarm, [deciding what *not* to build](https://zachwills.net/i-managed-a-swarm-of-20-ai-agents-for-a-week-here-are-the-8-rules-i-learned/). Those were always the senior parts of the job. Now they're the *only* parts that are scarce, because everything else got cheap. The bottleneck flipping isn't bad news. It's the market raising the price of your attention — *if* you move it off the work a fork can do and onto the work only a single, coherent, accountable reasoner can.

> **The lesson:** focus isn't a skill you were failing to train — it's a resource you have exactly one unit of, and it does not copy. The AI's whole trick is that it can `fork()` a reasoner and you can't. So stop trying to be the swarm. Be the thing the swarm can't be: the one seat that decides. Automate what can be checked, batch what needs thought, run at your pace and not the swarm's, encode your judgment so it scales without you — and save the seat for the collapse from many to one. That was always the job. Now it's the *whole* job.

You can't fork yourself. Good. It means the one thing you do — reconcile the parallel world into a single decision someone can be held to — is the one thing that stayed rare.
