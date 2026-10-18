---
title: "Interesting Things I Found — Sep 2026"
description: "Seventeen finds, and the biggest story is a new kind of model: one that doesn't talk, it decides. Several teams shipped the same idea at about the same time, the fast 'System One' brain beside the slow reasoning one. Plus a harness that learns, a memory that forgets, models that read bytes, and the machines, searches, and teams around them."
pubDate: "2026-10-18"
author: "locchh"
tags: ["ai-agents", "decision-models", "system-one", "harness", "memory", "retrieval", "sandbox", "tooling", "2026"]
draft: false
---

[Last month](/blogs/blog/interesting_things_august_2026/) I said the org chart around the coding agent was filling in, seat by seat. This month something different happened. Several teams shipped **the same new kind of model**, and it isn't an agent at all. It doesn't write. It doesn't chat. It looks at a situation, looks at the options you give it, and **picks one**, with a probability attached.

Most of them use the same name for it: **System One**. It's the old idea from psychology. You have a fast, cheap, gut-feeling brain for quick judgments, and a slow, careful one for hard thinking. For three years we've used the slow brain for everything, even for questions like "is this a billing complaint?" This month the fast brain showed up as a product.

So that's where this post starts. After that comes a harness that learns from its own runs, a memory that forgets on purpose, and models that read raw bytes. Then the machines, searches, and teams around all of it.

Seventeen links, six groups.

---

## 1. The fast brain — models that decide instead of talk

Six links in five entries here. The surprising part is how much they agree.

- **[CLM — Contrastive Language Models](https://github.com/Contrastive-LM/CLM)** — the most "under the hood" of the batch. CLM doesn't generate an answer. It **embeds the state and each candidate action separately**, then scores how well they match. A softmax over those scores gives you a distribution. Each encoder is a **frozen LLM backbone with a small trainable head** on top. Training is contrastive: pull the right state-action pairs together, push the wrong ones apart. Because states and actions are embedded apart, you can **cache** them. A state you've seen before is cheap to ask about again. It can also rank free-form candidates, like best-of-N answers or tool names. There's a script to fine-tune the heads on your own data. Code and weights are Apache 2.0. Honest notes: it's text-only, and the default context is short, so longer states get cut. The benchmark numbers are the project's own, and the scaling write-up lives in a blog post, not a peer-reviewed paper. *Best for:* seeing how a decision model is actually built.

- **[TypeSafe AI](https://docs.typesafe.ai/introduction)** and its **[agent skill](https://github.com/typesafe-ai/skills/blob/main/skills/typesafe-ai/SKILL.md)** — the product version of the same idea, built around their main model, **Jev**. You send **state** (your data, as text or JSON) and a list of **typed questions**. Three types cover most needs. **Choice** picks one from a set. **Noul** answers yes or no, as a probability. **Score** places the state on a scale you describe. Every question is answered in parallel and on its own, against the same state, so one question can't leak into another. Answers come back as values your code can branch on. No text, no parsing.

  The skill file is worth reading even if you never use the product. It's really **a design guide for this new kind of AI feature**. Work backward from what the app will *do*. Keep rules, math, and exact lookups in code, and ask the model only for the judgment. Ask one narrow question per dimension. Always include a no-match option, because the model can't pick an answer you didn't list. And one warning I liked: high confidence means the answers are concentrated on one option. It does **not** mean your whole workflow is right. So set thresholds on your own data. Honest note: the docs read like marketing. And when you split a decision into small questions, you have to write the logic that combines them yourself. *Best for:* turning a fragile prompt-and-parse step into a typed decision.

- **[Strands Decider](https://strandsagents.com/blog/introducing-strands-decider/)** — the open, local version. It's a small open-source decision model from the Strands team, with code, training data, and weights all published. The build is simple to explain. Take a pretrained LLM, **cut off the part that writes text**, and put a tiny "pointer head" in its place. That head scores each option you offer, all in one parallel pass. Because it can't write, it **always returns one of your options**. It can't wander off. The blog is honest about the trade: no coding, no chat, no summaries, and weaker than reasoning models on multi-step problems.

  The best part is the agent example. Before a tool runs, a small handler asks the decider two questions. *Are these arguments based on what the user actually said? Is it too early to call this tool?* Then it returns one of four actions: **Proceed**, **Deny**, **Confirm** (ask a human), or **Guide** (send feedback to the model instead of blocking). That's [the watcher I keep writing about](/blogs/blog/the_seat_needs_a_watcher/), small enough to run on a laptop. *Best for:* experiments, local guardrails, and cheap routing.

- **[OpenAI Decisions](https://developers.openai.com/api/docs/guides/decisions)** — and then the biggest vendor shipped one too. It's a new endpoint, in public beta. It takes text or images plus a list of questions, and returns typed answers. There are three question types: **predicate** (the probability that something is true), **choice**, and **score**. The guide's examples are everyday cases. Is this product photo damaged? Which department should get this complaint? How bad is this bug? You pay only for input. There's no output to pay for, because nothing is generated. Honest notes: it's beta, and it runs on a single model. The guide also says plainly that thresholds are **your** job. Test against labeled examples, and weigh the cost of a false yes against a false no. *Best for:* teams already on OpenAI who route, filter, or sort requests at volume.

- **[Jev-Mem](https://arxiv.org/pdf/2609.23986)** — a university paper that puts the fast brain *inside* an agent's memory. And it isn't just a similar name: it uses TypeSafe's Jev as its fast controller. Their complaint is this. Most agent memory systems ask a big, generating LLM how to file, find, and use every memory. So slow generation sits in the way of every memory operation. Jev-Mem splits the work in three. A **System-One control plane** handles the routine choices: what type of memory this is, where to send a query, how much to retrieve, when to stop searching. A structured graph holds the memories. And a **System-Two reasoning plane** is called **only** when an answer needs real thinking. They report better answers *and* much faster building and querying on their benchmark. Honest note: one benchmark, self-reported, and the abstract doesn't name what they compared against. *Best for:* a blueprint of the fast brain and the slow brain working as one system.

**The shared shape.** Put them side by side and they've ended up with almost the same interface. Look at the question types:

| | Yes / no | Pick one | Rate on a scale |
|---|---|---|---|
| TypeSafe | Noul | Choice | Score |
| OpenAI Decisions | predicate | choice | score |
| Strands Decider | noul | choice | *(not shown in the launch post)* |
| CLM | Noul | Choice | Score |

Part of this agreement has one source. CLM serves itself behind a TypeSafe-compatible API, Strands tests itself on JevBench (named after TypeSafe's model), and Jev-Mem is built on Jev. OpenAI uses the same three shapes too, and its guide doesn't mention the others. I can't tell if they got there alone or not. Either way, the biggest vendor shipped the same three building blocks. That's a strong hint these three are the right ones.

**Why it matters.** Most of what an agent does all day isn't hard thinking. It's small calls. Which tool? Is this safe? Is this relevant? Is it done? We've been paying the slow brain to make every one of them, and then paying again to turn its essay into a yes or no. Decision models make those calls **cheap, fast, always inside the options, and with a confidence number you can set a threshold on**. The reasoning model doesn't go away. It becomes **the one you call when the fast brain isn't sure**.

One honest caveat for the whole section, borrowed from a project in group 5. Cua's README says its own "System 1" label is **an engineering comparison, not a strict category**. That's the right attitude. These are not little brains. They're classifiers with a good interface. That's still a big deal.

---

## 2. The harness learns

- **[Harness Learning Enables Generalizable Test-Time Adaptation](https://arxiv.org/pdf/2609.35738)** — a paper that treats the harness as the thing to improve. An agent's behavior depends on the model *and* its harness. The harness is the program that decides when to call the model, which tools to use, and how information moves. Different tasks need different harnesses, but we mostly write one and leave it alone. Their idea: train a **proposer** model, with reinforcement learning, to **revise a solver's harness** using feedback from running it. The reward is how well the revised harness does. At test time, it keeps improving the harness on a brand-new task, **without changing any weights**. Harness edits do the job that weight updates do in normal training. The result that matters: the skill **carries over to tasks it never saw**, and a proposer trained on single revisions keeps improving over several rounds. Honest note: it was tested only on reasoning and multi-hop questions, and the gain from training on whole chains of revisions varies. *Best for:* anyone who suspects [migration is a harness](/blogs/blog/migration_is_a_harness/) problem, and wants proof the harness can learn.

- **[prime-agent](https://github.com/PrimeIntellect-ai/prime-agent)** — a revisit. I covered it [last month](/blogs/blog/interesting_things_august_2026/) for its recursive design and its continual harness. It's back because it's the **shipped, untrained version of the paper above**. Its `/refine` command reviews a run and makes small edits to the harness, each backed by evidence from that run. It edits the extra prompts, memories, and skill descriptions. It takes snapshots so you can roll back, and it never touches the base system prompt. The README also points to their own arXiv paper on the continual harness, and lists tools for long tasks: `/goal` objectives, heartbeats and schedules, and automatic compaction. The same warning still applies. It runs model-written Python with your permissions, and it is **not a sandbox**. *Best for:* trying harness learning today, by hand, before anyone trains it.

The paper learns *how* to edit a harness. The tool gives you the loop to do it. Put them together, and the [state I keep arguing for](/blogs/blog/state-engineering/) isn't just carried between runs anymore. It's **improved** between runs.

---

## 3. Finding things — memory, documents, code

- **[Selective Forgetting](https://arxiv.org/pdf/2608.28978)** — my favorite kind of paper: one that tests a popular belief and reports that it failed. The belief is that turning conversations into a **knowledge graph** of entities and relations gives an agent better long-term memory than plain vector search. They built exactly that. At the same retrieval budget, **the graph did worse than the flat baseline**. It did worst on questions about *what the assistant said earlier*. Breaking a turn into entities throws away the exact wording those questions need. Then the second half: a **forgetting** step. It prunes low-value nodes based on how recent they are, how often they're used, how connected they are, and how old they are. Pruning about a tenth of the graph cost almost nothing in answer quality. The authors are honest about the limits: one small extractor model, one benchmark, and the result is about *this* pipeline, not graph memory in general. *Best for:* a reality check. [Memory is not intelligence](/blogs/blog/memory_is_not_intelligence/), and structure is not understanding. Sometimes the raw text was the knowledge.

- **[PageIndex](https://github.com/VectifyAI/PageIndex)** — retrieval with **no vectors and no chunks**. It builds a tree index of each long document, like a table of contents. Then an LLM **reasons its way down the tree** to the right section. The core argument is short: *similarity is not relevance*. Two chunks can look alike, and only one answers your question. You get answers you can trace, with page references. Local mode runs on your machine with your own key. A cloud mode adds OCR, images, and finer citations. Honest notes: local mode needs text-based PDFs, many extras are cloud-only, and the benchmarks are the vendor's own, mostly simple lookup questions. *Best for:* long, structured professional documents like reports, filings, and manuals, where the layout already tells you where things are. Read it next to the paper above. Both say that **keeping the document's own shape** often beats cutting it into pieces. It's [the inference layer a knowledge base needs](/blogs/blog/how_to_build_knowledgebase/), done as a walk down a tree.

- **[tgrep](https://github.com/microsoft/tgrep)** — from Microsoft: grep, but with an index. It breaks every file into overlapping **three-character pieces (trigrams)**. A regex search then only opens files that *could* match, and checks those in parallel. Run it as a server and the index stays current while you work. Most flags copy ripgrep. It ships MCP tools and hooks for coding agents, and it already powers search inside GitHub's Copilot CLI. Why it matters for agents: an agent greps far more often than a person does. On a big repo, every slow grep costs time and tokens. Honest notes: patterns with no useful trigrams still scan everything, and the index can fall behind your edits. Big files and binary files are skipped by default, and the regex engine isn't PCRE2. MIT. *Best for:* agents working in large repos.

---

## 4. Below the token

- **[Breaking the Token Ceiling](https://arxiv.org/pdf/2609.12303)** — last month I picked tiktoken back up and called it [the ruler](/blogs/blog/interesting_things_august_2026/). This paper asks if we need the ruler at all. It compares small models that read **tokens** with ones that read **raw bytes**, both learning from a bigger teacher model (distillation). The problem is that the teacher speaks tokens. So they give two ways to turn a token model's predictions into byte predictions, one approximate and one exact. The finding is a crossover. Token models win early, then **level off**. Byte models start weaker, keep climbing, and **pass them** with more compute. Byte models also need less data: they match the distilled token model with about a sixth of it. And with only 256 possible bytes, the teacher's outputs are much cheaper to store. Honest notes: the biggest wins are **predicted** from scaling laws, not measured, and the models are small. *Best for:* a hint at [what comes after the transformer as we know it](/blogs/blog/what_comes_after_transformer/). Maybe it's not a new architecture. Maybe it's the end of the tokenizer.

---

## 5. Machines for agents

- **[forkd](https://github.com/deeplethe/forkd)** — `fork()` for agent sandboxes. Boot one parent microVM, load the runtime (Python, packages, even a model), and pause it. Then spawn children that **share the parent's memory, copy-on-write**, until they change something. Each child is a real Linux VM with hardware isolation, its own network, and a memory limit. It starts fast because nothing boots from cold. The feature that caught me is **BRANCH**. You pause a *running* sandbox mid-task, snapshot it, and fork from there. An agent at a fork in the road can **try both paths for real**. I wrote that [you can't fork yourself](/blogs/blog/you_cant_fork_yourself/). Your agents increasingly can, all the way down to the machine. Honest notes, all from the README: it's alpha and runs on one host only. Outgoing network traffic is **not** blocked by default, so bring your own firewall rules. Only memory is limited, there's no security audit yet, and snapshots don't move across CPU types. Apache 2.0. *Best for:* search, parallel tries, and RL rollouts where every branch needs a real machine.

- **[Cua](https://github.com/trycua/cua)** — computers that agents can use, in many pieces. There are full desktops for agents: local macOS VMs or Linux images, on your machine or your own cloud account. There's a driver that operates native apps and browsers, often in the background, without stealing your mouse. There's a VM manager for Apple Silicon, one SDK across several languages, and a benchmark that exports agent runs for training. Their idea of "computer-use 2.0" is an agent that moves between code, APIs, and the screen inside one task. It also ships **CUA-S1**: small models for fast, bounded computer-use decisions like filling in forms. That's group 1 again, showing up at the screen. Honest notes: the licenses are mixed (mostly MIT, some parts source-available, a few AGPL pieces). Several old packages are deprecated, one has known security issues, and CUA-S1 is an early research release. Read the notices before you install. *Best for:* agents that must use real desktop apps, not just APIs.

- **[llmfit](https://github.com/AlexsJones/llmfit)** — one command that looks at your CPU, RAM, GPU, and memory, and tells you **which open models will actually run well** on your machine. It scores each model on fit, estimated speed, quality, and context. It shows the inputs behind every estimate, so you can check it. You can benchmark your real speed, and your numbers replace the estimates. It has a terminal UI, a CLI, a web dashboard, a REST API, and JSON output for scripts and agents. MIT. Honest note: speeds are estimates from specs until you benchmark, and the community data is only as good as what people submit. *Best for:* [starting at the cheap end](/blogs/blog/start_at_the_cheap_end/). Before you rent a model, know what you can already run for free.

---

## 6. Teams and reach

- **[OpenRig](https://openrig.dev/)** — a self-hosted setup for a **long-lived team** of coding agents (Claude Code, Codex, and Pi together) on projects that run for weeks. You talk to **one lead agent**. It proposes a team, you approve it, and it hands work to specialists, tracks it, and reports back. Agents can message each other for quick questions, or take tasks from an **owned work queue**, so you always know who has what. A terminal dashboard shows where they need you. The idea I liked: specialists **keep what they learned**. So work goes to whoever already knows that part of the project, like on a real team. It's August's [fleet manager](/blogs/blog/interesting_things_august_2026/), but with long-lived colleagues instead of one-off runs. Honest notes: it's early (not yet 1.0), and it needs tmux and signed-in agent CLIs. The site doesn't state a license, so check the repo. The demos use staged output. *Best for:* one person running a small, long-lived agent team.

- **[REA — Reverse Engineer Anything](https://github.com/morluto/rea)** — one MCP server that lets an agent take software apart. It covers native binaries (through Ghidra, IDA, or Hopper), Electron and JavaScript apps, .NET, Android, websites, network and packet captures, firmware, WASM, smart-contract bytecode, and more. Analysis runs locally. Results come with **evidence and a list of unknowns**, not just a confident story. Setup registers it with the common coding agents. MIT, with clear rules: bring your own legal copies of commercial tools, and use it only on software you own or are allowed to examine. Honest notes: deep native analysis needs one of those heavy tools installed, and many targets need extra tools you supply. *Best for:* making software work together, security research, and understanding the black box you inherited.

---

## The fast brain and the slow brain

Line the groups up and one idea runs through most of them: **stop paying the slow brain for fast work**.

The decision models in group 1 are the clearest case. But once you look, it's everywhere. Jev-Mem keeps the reasoning model out of the memory's way. Cua has a small model for bounded clicks. tgrep stops an agent from reading every file to find one line. Selective Forgetting shows you can drop a tenth of a memory and barely notice. Even the harness paper fits: instead of a bigger model, it improves the cheaper program around it. Each one moves a routine judgment out of the expensive, open-ended model and into something smaller, faster, and **bounded**.

PageIndex is the honest exception. It spends *more* model thinking at search time, not less. But it fits the other half of the lesson: use the slow brain where judgment really matters, like deciding which section answers your question.

I keep saying the model is the rented part and the system around it is the job. This month added one more rule: **not every part of the system should be the big model**. Some of it should be a fast brain that says *yes, no, this one*. And it should know when to say *I'm not sure, ask the slow one*.

Here's the question I'll leave open: if the fast brain decides which calls reach the slow brain, who's really running the agent?
