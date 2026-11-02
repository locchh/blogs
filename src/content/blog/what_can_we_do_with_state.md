---
title: "What Can We Do With State?"
description: "The characteristics of state, and what we can do with it."
pubDate: "2026-10-28"
author: "locchh"
tags: ["state", "agent-architecture", "2026"]
draft: true
---

I think the state of the object or a work can be hidden from what we can see. And what is see can be not true or don't reflect the real state underneath.

- ***Seen state versus real state.** An agent never holds the real state, only a belief about it ([Kaelbling, Littman & Cassandra 1998](https://people.smp.uq.edu.au/YoniNazarathy/Control4406_2014/resources/KaelblingLittmanCassandra1998.pdf), POMDP belief state). Even the model's reasoning text can hide what really drove its answer ([Turpin et al. 2023](https://arxiv.org/abs/2305.04388)). Insight: treat every status as an estimate, and record where it came from.*

I am also curious about these questions:

- The characteristics of state, and what manipulations we can do with it?
  - ***The verbs of state.** Read, write, fork, merge, snapshot, rollback, replay. Each verb needs a different guarantee. For merge, link back to [State Engineering](/blogs/blog/state-engineering/) instead of repeating it.*

- How does state transition from one step to the next, and what triggers each move?
  - ***What triggers a transition.** An event, a guard condition, a timer, or a new observation ([Harel 1987, statecharts](https://www.inf.ed.ac.uk/teaching/courses/seoc/2006_2007/resources/statecharts.pdf): states with hierarchy, concurrency, communication). Insight: a move without a named trigger is only an agent's opinion. This echoes "demote by dependency, never by opinion" in State Engineering.*

- How we can maintain state of work cross sessions, agents, and machines?
  - ***One state across sessions, agents, and machines.** No one can read a distributed system all at one instant. [Chandy & Lamport 1985](https://www.cs.princeton.edu/courses/archive/fall17/cos418/papers/chandy_lamport.pdf) record a global state that may never have existed at one moment. It is still consistent with the order of messages, and that is enough for checkpoints.*

- Snapshot and replay: can we save state, roll it back, and run it again?
  - ***Snapshot and replay with an unpredictable worker.** You can't re-run an LLM and get the same output twice. Durable execution ([Temporal](https://docs.temporal.io/dev-guide/python/durable-execution)) records each call's result and replays the history instead of calling again. Insight: replay the record, not the model. Rollback is cheap for files (git) and hard for side effects like a sent email.*

- ***Personal thought, an open question.** How can an agent notice that its belief has drifted from the real state before someone else does?*
