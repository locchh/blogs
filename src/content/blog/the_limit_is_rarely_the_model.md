---
title: "The Limit Is Rarely the Model"
description: "What a coding-agent team actually spends its time and tokens on, and the loop that finds it."
pubDate: "2026-11-07"
author: "locchh"
tags: ["ai-agent", "codex", "harness", "2026"]
draft: false
---

We run a team of coding agents in a timed contest: a 40-minute match, about ten backlog items released in waves, graded by hidden tests and evidence checks. One orchestrator (Codex CLI) spawns workers as subagents in its own session, and a helper (an MCP server we wrote) claims items, prepares a git worktree per worker, integrates and submits.

In one day of practice the same model went from **834 to 1000 points**, from **~380 to ~279 credit** per match, and from a last submission at **minute 38.9 to 31.8**. We never changed the model. Every gain came from what surrounds it.

This post is the corrected version of an earlier one. That one said "the system around the model matters" and stopped there. This one shows **where, in a real CLI, the time and tokens go**, and **the loop we use to find the next thing to fix** without fooling ourselves.

## 1. Two formulas

Everything below hangs on two products:

- **time of an item** = waiting for a worker + **steps × seconds per step** + tool waits + hand-off hold
- **credit** = Σ over sessions of **steps × context per step** (+ output)

A *step* is one model round trip. In Codex CLI, a step resends the whole conversation: system prompt, tool schemas, every earlier tool output. Most of it is cached (cheap per token, but not free) and only the new part is full price. In our runs **about 95 % of all tokens were cached context resent step after step**. So credit is mostly *steps × context*, and so is time.

That gives exactly two kinds of improvement:

1. **Remove steps or shrink context.** These change the factors.
2. **Shorten a wait between steps.** These help once and don't compound.

Most of our early fixes were the second kind. More on that below.

## 2. What the CLI does that you don't see

The earlier post blamed "the pack" in general terms. Here are the concrete mechanisms, each measured.

**An approval reviewer re-reads the whole conversation for every tool call that isn't marked read-only.** With the `auto_review` policy, every MCP call without `readOnlyHint` is shown to a guardian model together with the caller's transcript. Our helper's tools had no annotations, so even "read a file" was reviewed. In one run the **reviewer used 53 % of the credit**. Honest annotations (read-only, remote write, destructive) cut that to 13 %. Making the orchestrator's wait call genuinely read-only (moving its side effects to a background watcher) cut the reviewer from **26 to 4.3 credit**.

**A code cell yields after 30 seconds unless told otherwise.** Workers act through exec cells (JavaScript that calls tools). A cell running a test suite returns control to the model after ~30 s, and the model spends a step asking "is it done?". The fix was a one-line pragma (`yield_time_ms`), plus helpers that wait for the result themselves. Status polls went from **86 to 27** in one match.

**The player sends preparation and the game into one session.** We checked the session files of a real match: the preparation frame (install, baseline tests, codebase map) and the game frame arrive in the **same** orchestrator session. In the arena the orchestrator started the game with **53K tokens of preparation history** and grew to a median of **95K**, resent on all 116 game steps. That isn't the model thinking; it's luggage.

**The orchestrator woke up for nothing.** Of its 41 waits in one match, **17 returned with no change** (timeouts) and 8 more with nothing to act on. Each wake is a full step at ~95K context. The orchestrator also messaged workers 19 times and integrated or submitted 7 items by hand, work the helper was already doing.

**Workers rediscovered their own state, one shell command at a time.** In the same match, 41 % of worker steps were raw shell commands. Classified one by one: **108 of 362 asked for something the helper already knew** (`git status`, the shared notes, the evidence folder, whether the dev server is up). **59 more just waited on their own long command** (`sleep`, `tail log`). That's about **29 % of all worker steps** with nothing to do with the bug.

**A "network idle" wait that never fires.** Screenshots waited for the page to go network-idle before capturing. A dev server keeps a live-reload connection open, so it never goes idle and **every one of 62 screenshots** burned the full 8-second timeout.

None of these is the model being slow or wrong. On the same day **every code fix the model wrote passed independent hidden tests** (18/18, 24/24, 70/70 and so on).

## 3. Bubbles and the wave

After five practice runs we had a long list of fixes, each worth a minute or a few credit: the screenshot wait, a slot reservation, a second-opinion hold, a refused hand-off. Scores rose, and it felt like progress.

Then the decomposition showed that **steps per worker (~70) and context per step (~45K) had not moved from run 3 to run 5.** Every fix had shortened a wait *around* the steps. We had been popping bubbles on the surface while the wave underneath stayed the same.

The wave turned out to be three structural causes:

| Cause | Evidence | Kind of fix |
|---|---|---|
| Workers rediscover state step by step | 29 % of worker steps | put the state in every tool reply; let shell calls wait for their own command |
| The orchestrator is a language model doing a scheduler's job, history attached | 116 game steps at 95K context; 25 of 41 wakes needless | wake only when it must act; let a subagent do preparation so only its summary stays |
| Shared failures are owned by whoever asks first | the first owner was an item with an 18-minute deadline; ownership moved four times; the last item lost 7.7 minutes | a rule about who can own a failure, decided once |

Each of these removes steps or context rather than a wait. That's the difference between a bubble and a wave, and it's easy to miss when every bubble fix produces a visible gain.

## 4. The loop that finds the next fix

We stopped trusting our own explanations. Here is the loop, and why each part exists.

### 4.1 An arena that pushes back

A good idea is a guess until something you can't argue with tests it. We built a practice copy of the contest:

- **A mock game server** that replays a recorded exam: the same codebase, waves on the clock, the same company tools (knowledge base, test data, production logs).
- **Grading the way the real grader does it:** exact answers by code; the submitted commit replayed with the organizers' files restored (scenario tests, full suite, typecheck); evidence and hidden tests judged by **independent grader agents that never see the team's code**. They write their own hidden tests from the criteria and check them against the unfixed code first.
- **Replays run one at a time.** Seven in parallel on eight cores gave two false failures (database tests under load). We found that out the hard way.
- **The team is stopped as soon as every item is submitted.** The real grader counts the last submission time, and an idle orchestrator only burns credit.

### 4.2 Deep review before any fix, enforced

After each finished run a script (`deep.py`) prints the decomposition: credit and steps per session (orchestrator preparation against game), context, seconds per step, what the steps were spent on (kit calls, raw shell by kind), tool waits, each item's critical path, and how ownership moved.

A written method turns the numbers into a review: decompose before listing, ask *why* until the answer is about how the team is built, then propose changes that remove steps or context.

The part that made it stick is a **hook**. A project-level Claude Code hook runs on every prompt and at the end of every turn. While a finished run has no deep review on disk, it adds a reminder to the context, and it **blocks the end of the turn** until the review is written. The operator agent (also a model) can't skip straight to "here's a quick fix" any more. That matters because, as the earlier post noted, agents stop at the first answer that sounds finished.

### 4.3 Split the real backlog: labs on the worst items

A full match costs ~280 credit and ~45 minutes, and it mixes ten items, waves and slot waits, so one change's effect drowns in noise. Instead:

1. **Free counterfactuals first.** Before spending anything, test each cause against the last run's own files: does the helper really hold the answers to those shell commands? Why did each wait return? Would a simpler ownership rule alone have prevented every move? This killed one of our proposals (a dedicated "fixer" worker) in favour of a one-line rule.
2. **Pick the item that hurts most.** `deep.py` ranks items by critical path and credit. That's the item to put in the lab, not a random one.
3. **A one-item lab.** A script cuts the exam down to that item, revealed at minute 0, with the same codebase, grading and tools. One run costs **~45 credit and ~15 minutes**, against ~280 and ~45 for a match, and answers one question cleanly. (About a third of that is preparation; reusing one preparation across lab runs is the next saving.)
4. **A control in the same conditions.** The lab runs the old pack once and the new pack twice on the same item.

### 4.4 Bars that respect noise

The same item varies **15–20 % in steps** between runs. A 10 % "improvement" is indistinguishable from luck. So:

- **Lab bar:** a change enters the pack only if its target factor moves **≥ 25 %** on the same item, in two runs.
- **Pack bar:** one full match must hit all three targets at once (here: 1000 points, ≤ 250 credit, last submission ≤ last wave + 5 minutes).
- **Two-exam rule:** a change must help on two different exams and hurt none. A third exam is built by a red-team agent on a codebase the team has never seen, with deliberate traps: a short deadline, a nine-file change, an outdated knowledge-base revision ranked first in search, a toast covering a button, a flaky test, a merge conflict, a log search whose obvious query hides the answer. Practising on one exam forever teaches you that exam.

### 4.5 A lessons file

The operator agent keeps a short lessons file it reads every session. Three entries so far: *"outside our control" is where to start digging*; *every step forward came from a push*; and *bubbles and the wave*. The hook enforces the third.

## 5. The evidence, run by run

Same exam, same model (`gpt-6-sol`), same machine; only the team's code changed.

| Run | Pack | Points | Credit | Last submission | What changed |
|---|---|---|---|---|---|
| 1 | 3.2.0 | 280 graded, cut off by quota | ~617 | 30.8 (6/10) | first arena run |
| 3 | 3.3.1 | 834 | ~380 | 38.9 | tool annotations: reviewer 53 % → 13 % |
| 4 | 3.3.3 | 990 | 305 | 33.8 | conflicts resolved by the helper; ownership by scope; time box made final; orchestrator not woken by its own submissions |
| 5 | 3.3.4 | **1000** | **279** | **31.8** | scenario test first and fail fast; one long wait instead of polls; screenshots on a logged-in session; read-only wait call; finished second opinions end their job |

Inside run 5 against run 4: waiting on checks fell from 24 to 6.5 worker-minutes, the reviewer from 26 to 4.3 credit, and the tail item from minute 33.8 to 24.3. The factors (steps, context) did not move; that's the wave the next version goes after, in the lab first.

## 6. What this saves

Per question asked, the loop is far cheaper than "run a match and see":

- **Free counterfactuals** answer "is this cause real?" for zero tokens.
- **A one-item lab** answers "does this change work?" for ~45 credit instead of ~280, in a third of the time, with less noise.
- **A full match** is spent only to confirm a pack that already passed its labs.
- **Stopping the team at the last submission** saves the idle tail of every practice match.

And inside a match, the structural fixes save on every step: removing ~29 % of worker steps and most of the orchestrator's wake-ups is worth more than any single wait we shortened.

## 7. Takeaways

1. **Write the formula down.** Time ≈ steps × seconds per step; credit ≈ steps × context. If a fix changes neither factor, it's a bubble.
2. **Read the CLI, not just the model.** Approval review, cell yields, session reuse, idle waits and proxies all charge per step, and none of them shows up as "the model is slow".
3. **Measure the team's own logs before guessing.** Classify every shell command and every wake-up. The honest numbers are usually smaller than the first estimate, and more useful.
4. **Make the checker un-arguable,** and keep the graders blind to your code.
5. **Split the backlog.** Test changes on the worst item in a lab, with a control, against a bar above the noise.
6. **Force the deep look.** A hook that blocks "done" until the review exists works better than a promise to be thorough.

The limit is rarely the model. It's usually somewhere you haven't measured yet.
