---
title: "Toward an Agent Fleet"
description: "Some thoughts about running a fleet of coding agents"
pubDate: "2026-11-23"
dense: true
author: "locchh"
tags: ["agent", "modern", "2027"]
---

## A contest where nobody may touch the machine

This year I joined a software engineering contest where the agents do the work. Each team builds a **team pack**: an orchestrator, its worker agents, and the tools and workflow around them. They get a real codebase and a backlog of items, and nobody may touch the machine during the match. A grader scores each item on the commit submitted, once. Ties go to the team that spent fewer model credits.

The codebases were TypeScript web apps of different sizes. Here are three of them.

| # | Codebase | Domain | Shape | Items |
| --- | --- | --- | --- | --- |
| 1 | A freelance project manager | CRM, boards, time tracking, invoices | One Next.js app with PostgreSQL | 12 |
| 2 | A personal finance app | Accounts, budgets, rules, bank imports | Mid-size monorepo with SQLite | 16 |
| 3 | A B2B commerce platform | Tiered pricing, tax, stock, shipping, returns | Large monorepo with NestJS and GraphQL | 17 |

The backlog mixed five kinds of task.

| # | Task | What it asks | Example |
| --- | --- | --- | --- |
| 1 | Bug | Fix one defect from a support ticket | A fully paid invoice still shows "partly paid" |
| 2 | Change request | Add or change a feature to a business standard, sometimes with a page | An aged-debt report |
| 3 | Production incident | Find the bad release in the logs, its first moment and its reach, then fix it. Short deadline, ranked by who submits first | Stock reserved beyond the order |
| 4 | Task | Compute or analyze from data, logs, or images, or write a test suite | Read the numbers off a voucher image |
| 5 | Heavy task | Audit a large dataset under stacked rules | Check four months of computed prices |

Nothing was scored on the team's word. The grader checked each item in one or more of these ways.

| # | Check | How the grader verifies it | Items (of 45) |
| --- | --- | --- | --- |
| 1 | Exact answer | Compares each field of the submitted answer, no AI | 40 |
| 2 | Replay and hidden tests | Reruns the checks the team reported as passing, plus hidden tests | 25 |
| 3 | Mutants | The team's tests must pass on correct code and fail on each broken copy | 11 |
| 4 | Incident fix | The incident's answers, plus a fix test and a no-regression test | 9 |
| 5 | Page and screenshot | A screenshot as evidence, and the page flow replayed | 6 |
| 6 | Script on second data | The team's script is rerun on a different dataset of the same kind | 6 |
| 7 | Organizers' tests | Their test suite runs on the team's code | 4 |

A wrong answer format scored zero for the whole item.

The diagram shows how one item travels, from the organizers' server to the team's machine and back to the grader.

```mermaid
flowchart TB
    subgraph SRV["Organizers' server"]
        GM["Game master<br/>match, waves, deadlines,<br/>scoreboard"]
        CT["Company tools<br/>knowledge base, test data,<br/>production logs"]
        GR["Grader"]
    end
    subgraph LOCAL["Team's machine"]
        PL["Player app from the organizers<br/>starts the orchestrator, watches<br/>for violations, counts tokens"]
        OR["Orchestrator"]
        WK["Workers"]
        HP["Helper tools<br/>from the team pack"]
        CO["Checkout of the codebase"]
    end
    REPO[("Team's repo")]

    GM -- "opens the match and each wave" --> PL
    PL -- "starts the game" --> OR
    OR -- "hands out items" --> WK
    WK -- "asks for data and logs" --> HP
    HP -- "calls the API" --> CT
    WK -- "code, tests, evidence, answers" --> CO
    HP -- "commit and push" --> REPO
    HP -- "submit: answers and commit" --> GM
    GM -- "the submitted commit" --> GR
    GR -- "checks out that commit" --> REPO
    GR -- "score per check" --> GM
```

So the grader sees only what was committed. Anything left in a temp folder on the team's machine does not exist for it.

## The pack: one orchestrator, many workers, and a helper in code

The pack is the only part a team builds. Mine is one orchestrator, three kinds of worker, and a helper that does everything a model should not have to remember. On disk it is a small folder with no dependencies.

```text
team-orchestrator-pack/
├── agents/                         # who each agent is. The agent runtime loads one file per agent it starts
│   ├── team-orchestrator.toml      # loaded when the player app starts the orchestrator
│   ├── team-feature-worker.toml    # loaded when the orchestrator spawns a worker for one item
│   ├── team-repo-scout.toml        # loaded when the orchestrator spawns a read-only second opinion
│   └── team-quality-checker.toml   # loaded when the orchestrator spawns a checker for a finished item
├── skills/                         # read by the orchestrator only, one per message from the player app
│   ├── game-preparation/SKILL.md   # on "prepare": clone, build, create the slots
│   ├── team-orchestrator/SKILL.md  # on "start": the loop during the match
│   └── team-recovery/SKILL.md      # on "resume": pick up after a restart
├── bin/                            # programs, started by the agent runtime or by the helper
│   ├── runtime-server.mjs          # the helper. The runtime starts it, and every agent calls its tools
│   └── browser-*.mjs               # run by the helper when a worker asks for a page check or a screenshot
├── src/                            # code the helper loads
│   ├── runtime-session.mjs         # the helper's own logic: server calls, hand-off gate, submit
│   ├── kit.mjs                     # sent by the helper to each worker, which runs it in its own cells
│   ├── worker-launcher.mjs         # the helper's record of each worker, and what the orchestrator must spawn or close
│   └── mutate.mjs                  # run by the helper when a worker asks to test its tests
├── config/
│   └── workers.json                # read by the helper at start: slots, time boxes, holds
├── contracts/                      # schemas the helper checks: a worker's result, a line of the progress log
├── docs/                           # read by every agent: the match card first, a playbook recipe when needed
├── tests/                          # run by me after each change to the pack, never during a match
└── scripts/install.mjs             # run by me once, before a match, to copy the pack into the workspace
```

The diagram shows the same files in use: who starts whom, and who calls what.

```mermaid
flowchart TB
    ME["Me, before the match<br/>install script, tests"] -- "installs the pack" --> PL["Player app"]
    PL -- "starts, with its profile" --> OR["Orchestrator<br/>reads one skill per message"]
    OR -- "its session starts" --> HP["Helper<br/>settings, schemas, gate"]
    OR -- "spawns, each with its profile" --> WK["Feature worker"]
    OR -- "spawns" --> SC["Scout"]
    OR -- "spawns" --> QC["Checker"]
    HP -- "sends the kit" --> WK
    WK -- "kit calls: read, test, hand off" --> HP
    SC -- "read-only calls" --> HP
    QC -- "verify calls" --> HP
    OR -- "wait, merge, submit calls" --> HP
    HP -- "runs" --> BR["Browser scripts<br/>page checks, screenshots"]
    HP -- "calls" --> SV["Organizers' server"]
```

So every agent talks to the outside only through the helper. That is the one place where the rules can be enforced in code.

The table says what each part does.

| # | Part | What it is | Its job |
| --- | --- | --- | --- |
| 1 | Orchestrator | One agent session, started by the player app | Reads the backlog, hands each item to a worker, merges, pushes, submits. It does not fix items itself |
| 2 | Workers | Subagents of that same session, in three profiles | A feature worker owns one item from brief to commit. A scout investigates read-only and gives a second opinion. A checker verifies a finished item |
| 3 | Slots | One git worktree per worker, with its own app, port, and database | Workers run side by side without touching each other's files or data |
| 4 | Helper | A small local tool server, in plain Node | Makes every call to the organizers' server, writes the progress log, checks each hand-off, submits. It keeps the credentials in memory only |
| 5 | Kit | A short JavaScript toolkit the helper serves to each worker | One call replaces several steps: read files, run the checks, start the app, take a screenshot, fill the answer, hand off |
| 6 | Skills | Three instruction files for the orchestrator | One for preparing the game, one for playing it, one for recovering after a restart |
| 7 | Prompts | One profile per agent, and a brief per item | The profile says what the agent may do. The brief carries the item, its slot, and a hand-off checklist |
| 8 | Config and contracts | One settings file, and two schemas | Switches for slots, time boxes, and holds. Schemas for a worker's result and for a progress event |

Three of those parts did most of the work.

**Warm workers.** A worker spawned when an item arrives starts late, because the orchestrator needs a turn to spawn it, and that turn can sit behind a context compaction. So the workers are spawned before the items and wait on the helper. In practice matches an item then reached its worker in about 20 seconds. Before, some waited over a minute.

**The kit.** A worker's steps were not too many, they were too slow. Each hand-written command with long paths is one more model request. The kit turns a sequence into one call, so the worker spends its requests on the item, not on plumbing.

**The hand-off gate.** A worker's word is not enough for the grader, so it is not enough for the helper either. On every hand-off the helper runs its own checks in code: is the evidence there, is the answer filled, does a fix come with a new test? A finding refuses the hand-off once, with the reason. Rules the model had to remember became rules the code enforces.

The diagram shows one item passing through the pack.

```mermaid
flowchart LR
    I["Item released"] --> W["Warm worker<br/>already waiting<br/>in its slot"]
    W --> K["Works through the kit<br/>read, fix, test, evidence"]
    K --> G{"Hand-off gate<br/>checks in code"}
    G -->|"Finding"| K
    G -->|"Clean"| M["Orchestrator merges<br/>and pushes"]
    M --> S["Helper submits<br/>answer and commit"]
    class G check
    classDef check fill:#fff4d6,stroke:#d9480f,stroke-width:2px
```

So the model does the thinking on the item, and code does the waiting, the checking, and the submitting.

### The timeline of the pack

The pack went from the organizers' empty sample to what you see above in about 70 versions over two weeks. Every change came from a real match or an arena run. We wrote down the lost points, traced them to the root cause, and fixed the pack in a way that works for any exam, never as a patch for one item.

Three forces kept coming back:

- **Following the rules.** The official environment allows only subagents inside the same session, so the whole worker design had to be rebuilt once.
- **Speed.** The target was to submit everything before minute 25 and an incident within a few minutes, because incidents are ranked by submission order.
- **Never scoring zero.** An item that runs out of time without a submission is worth 0 points.

Step by step, mechanical work moved from the agent, which costs steps and tokens and can forget, to the helper's code, which is fast, certain, and costs no credit.

| # | What we changed | The problem it solved |
| --- | --- | --- |
| 1 | Nothing yet. This is the sample pack the organizers give every team: a few instruction files and no program of our own | The starting point |
| 2 | We split the work between agents. One orchestrator agent reads the backlog and gives each item to a worker agent. Up to 5 workers run at the same time, each in its own copy of the code | A single agent that does the items one after another cannot finish the backlog in 40 minutes |
| 3 | We wrote a helper program and gave it the jobs an agent kept forgetting. It checks every finished item before accepting it: are the evidence files there, is the answer filled in? When new items open, it starts them and gives them to free workers by itself. It submits finished items by itself, even if the orchestrator has crashed. Just before the match ends, it submits whatever is done. We also keep one worker free for production incidents, and one shared notes file that every worker reads | In practice matches we lost points because finished items were never submitted, were submitted without evidence, or sat waiting for the orchestrator to act |
| 4 | We rebuilt how workers run. Before, the helper started each worker as a separate program. Now the orchestrator starts each worker inside its own session, as a subagent | The organizers' rules allow only subagents in the same session. Starting another agent program during a match is forbidden |
| 5 | We built our own copy of the contest, with a fake server and made-up exams, so we could run and score the pack any time. We also wrote the **kit**: a small set of functions a worker calls. One call reads files, another runs the tests, another takes a screenshot, another hands in the item. Before, the worker typed each shell command itself. And for an item whose answer is exact numbers, the helper now starts a second agent to compute the same answer separately, so the two can be compared | An item was slow because it took many steps, and each step is one request to the model. Most steps were not thinking. They were re-reading files and running commands |
| 6 | We put every fix that had proven itself in our test runs into one version. We moved to the strongest model the organizers allow. If that model answers "overloaded", workers switch to the next allowed model by themselves. And a screenshot is accepted as evidence only if it shows the expected value on the page | We needed a stable version for the real match. Once, an overloaded model had left a whole match stuck |
| 7 | We start the workers before any item exists, and they wait. These are the **warm workers**. When an incident opens, the helper gives it to a waiting worker within seconds. We limited how many tool calls a worker sends at once, because more than 128 at once crashes the session for every agent. When the organizers' server refuses a call for "too many requests", the helper waits and sends it again. Every agent first reads a one-page card that says what scores and what scores zero. And workers think at the highest effort level, which takes fewer steps | Incidents are ranked by who submits first. In real matches our incidents started late, and that was the main loss |
| 8 | The helper now watches every deadline. 240 seconds before an item's deadline, it hands in what the worker has proven so far. 75 seconds before, it submits the best version it holds. An incident is handed in as soon as its fix and its test pass, without the slower checks. Workers run their code on the organizers' official test data and keep the output as evidence. And every test must keep its data inside the committed code | In one match an item scored zero because it was handed in 1 second late. In another, a test read a file that the grader does not have, so it failed there |
| 9 | We told the workers they are racing other teams: do what the helper says at once, and hand in early. We removed steps that take time and earn no points, such as a full type check. We added two rules: zoom in to read numbers from a document image, and compute an answer with a script, not by hand. And we fixed our log search to match how the organizers' server really searches | The result: three practice matches in a row with every item submitted, then the official match at 779 of 1000, first of 8 teams |

The lesson after the official match sets the next step. The points still lost all sit where the agent must do by itself what the helper could do in code: gathering the data for an incident, judging its own test suite, and finding every rule in the knowledge base.

### The problems we hit

Now let me tell you which problems we hit on the way, and what each one cost.

| # | Problem | What happened | Root cause | Cost | Solution |
| --- | --- | --- | --- | --- | --- |
| 1 | A worker's "done" taken as fact | A worker built an invoice export. One invoice came out as "overdue" while the app's screen showed it as "sent". The worker saw the mismatch, wrote it into its record, and kept its own value | The export recomputed the status from today's date, as one knowledge-base rule suggests. The task wanted the status the app stores and shows. Nothing made the worker settle the conflict before handing off | 40 points, the only loss in a 960 match | A self-check before each hand-off: output against the screen, against the official test data, with fresh evidence. Later, a second agent computes exact answers on its own |
| 2 | Finished work never sent | Two items were right and never reached the grader. One had its answer at minute 21 and an 8-minute deadline. The other was done, merged, and held | For the first, the helper merged the commit, the push failed, and nothing retried it. For the second, one test failed once under load, so the gate passed the decision to the orchestrator. The orchestrator was down: the proxy had moved it to an account whose login was revoked | 190 points: 50 for the missed deadline, 140 for the held item | The helper retries a failed push, reruns once a suite that failed once, and hands waiting items to workers without the orchestrator |
| 3 | Credentials written to a file | At the start of a match the host's safety review refused the helper's first tool call. The team never started | The helper wrote the whole start message to a session file, password and API key included, and the tool's description said so | A whole match: 0 points | Credentials stay in memory and reach workers through their environment. The file holds only fields that are not secret |
| 4 | Fixes that broke their neighbours | Eight versions in a row never beat the one before them. On one day, two fixes each caused a new loss: one made preparation skip a login, the other made three places read "the log exists" as "the step finished" | Each change was judged only against its own target. Its unit tests were green because they covered the new code, not the code that reads what it changed | Days of work, and trust in each new version | One change per version, run twice on a graded run. Before a change, list every place that reads what it touches. A fresh reviewer reads the diff |
| 5 | The orchestrator's memory | A wave of four ordinary items opened, and their workers began 2 minutes 15 seconds later. An incident in the same wave reached its waiting worker in 24 seconds | Ordinary items needed an orchestrator turn to spawn a worker. That turn sat behind a 64-second context compaction, which fell exactly on the wave | Over 2 minutes on four items, in a 40-minute match | Every worker is spawned at the start and waits on the helper, as incident workers already did. An item goes straight to a waiting worker |
| 6 | One agent took the others down | The session's code host ended for every agent at once. Cells in flight were lost and every agent's kit was gone. Three times in one match | The host exits when one cell starts more than 128 tool calls at once. Incident workers were pulling 144, 192, or 320 log queries in parallel | Every running agent had to reload and redo its last step, on the incident waves | The kit puts every tool call of a cell through one queue, 32 in flight, 24 of them for bulk pulls |
| 7 | The organizers' rate limit | Two agents sent log searches one after another at the same time, and most were refused. A third agent's single call was refused too | The organizers limit a team's calls per time. The helper did not wait or try again, and the kit returned the refusal as if it were data | Broken cells and lost minutes on incidents, where rank is by who submits first | The helper waits as long as the refusal says and sends the call again, with one paced gate for all agents. The kit throws if it still fails |
| 8 | An item with a 15-minute deadline | The same kind of item lost points three matches in a row. First it was handed off 1 second after its deadline, with the page, report, and export built 9 minutes earlier. Then it went in half done. Then the worker's right answer came 9 seconds after the helper had closed its run | The item depended on another item's fix, which landed late. The worker committed nothing until the end. And the helper's last-minute hand-off ended the run, so the worker's better answer had no slot | 0 of 70, then 20, then 30 | Four minutes before a deadline the helper hands in what is proven by evidence and keeps the run open. The worker hands in again if it gets further |
| 9 | The pack's own procedure | Items spent minutes on steps no grader reads: a type check of whole packages, a test of the tests, a self-check round, long engineering records | The hand-off gate enforced the pack's procedure, not the item's grading section | Minutes per item, and rank on every item with a deadline | The gate blocks only what feeds a check in the item's grading. Everything else is a note, never a refusal |
| 10 | **Workers ignored the helper** | "Take the capture NOW" was sent at minute 1.5 and never done. Two incident workers recounted answers a second agent had already sent them. Others kept working after "time is up" | Stronger wording does not change what an agent does next. The agent follows its own plan and its built-in instructions first | The page cases of one item, and minutes on two incidents | What must happen is done by the helper itself: it takes the capture, and it hands in at the deadline mark |
| 11 | A test that passed only at home | A worker's test passed on my machine and failed on the grader's checkout, for the item that wrote it and for two others that ran the same suite | The test read its data from a folder that is never committed. The brief itself had pointed the worker at the helper's copy and said nothing about where test data must live | 31 points over three items, from one file | A test carries its own data inside the committed source |
| 12 | **Official match: incident answers late** | One worker wrote its fix in the first minute, then spent 5.2 minutes in a single log pull over a month, with no service filter. Another was inside a 115-second analysis when the helper handed in its empty template. One named the root cause in a message and never wrote it into the answer file | The worker gathers everything first and answers last, and no gathering step has a budget. What it knows lives only in its context. The log pull had been fixed two hours earlier, but tested only on six days of one service | 71 points on two incidents |  |
| 13 | **Official match: tests with no large-volume case** | The grader ran my test suites on code broken only for large inputs: hundreds of order lines, thousands of units, large amounts. The suites stayed green | The brief asked for one test per numbered rule, on typical input. The check that breaks code on purpose and expects a red test had been switched off for speed | 63 points over 7 items |  |
| 14 | **Official match: knowledge base read in part** | One worker saw 17 clearance items in the data and never searched "clearance". Another missed two sections of a work instruction: a request is handled once, and one office's requests are not handled at all | The worker stops searching once it has enough to compute. It reads what its first searches return, and the search returns only the best few articles | 68 points on two tasks |  |

The rows in bold are the ones we have not fixed. Row 10 is only partly fixed: the helper now does two things itself, but a worker can still ignore any other message. Rows 12 to 14 come from the official match, which ended at 779 of 1000, first of eight teams. They are the 202 points that were our own fault, and each has a fix written down but not yet built.

Read down the Fix column and one direction shows. A rule starts in a prompt, costs points, and moves into code.

### Six factors that helped us win

The official match had 17 items in 40 minutes. We submitted all 17, the last at minute 34, and scored **779 of 1000, first of 8 teams**, 12 points ahead of the second. It used 198 credit, with no violation recorded.

| # | Factor | Role | Supporting numbers from the official match |
| --- | --- | --- | --- |
| 1 | **Working in parallel** (9 worker slots, at most 10 threads) | Enough capacity to finish the whole backlog in time | 17 items submitted in 34 minutes. One after another, that cannot be done |
| 2 | **Warm workers** | Items and incidents reach a worker in seconds, without waiting for the orchestrator's turn | After wave 1, workers started within 0.2 to 1.1 minutes. On two incidents we were the first to submit |
| 3 | **The kit** | The worker works in code inside one cell, not one shell command at a time, so each item takes fewer steps | Plausible from earlier measurements. This match has no separate measurement of it |
| 4 | **The strongest allowed model** (workers at the highest reasoning effort) | The quality of each step | Not an advantage of ours alone: the model is on the organizers' allowed list, and any team could use it |
| 5 | **A helper in code** | It hands out work, integrates, submits, and submits for the worker when time is nearly up, so every item has a submission | Two items were handed off at the deadline mark and got full points. Two incidents were submitted for the worker and kept the 62 points for their code fix, while the winning margin was only 12 points |
| 6 | **The measure-then-fix loop** (real matches and the arena, always fixed at the general level) | The road that led to the five factors above | About 70 versions in two weeks. The faults that once cost 190, 80, and 70 points in practice matches did not come back |

The first four factors are "work fast and get it done". The fifth is "never score zero". The sixth is how we got the other five. The numbers support factors 1, 2, and 5 most clearly.

We have no test that isolates each factor in a real match, and we do not know the other teams' packs. So these are factors with evidence behind them, not proven causes.

**What we did not get done.** We still lost 221 points. 202 came from three fault classes of our own pack: incidents submitted with empty fields (71), test suites that did not catch the grader's broken versions (63), and missing business rules (68). The other 19 came from submitting incidents after another team.

All three fault classes sit where the agent still has to do by itself what the helper could do in code. So the next step is to widen the fifth factor: the helper gathers and narrows the data for an incident, measures how well a test suite catches faults, and follows every rule in the knowledge base to its source.

## The loop that turned lost points into fixes

The pack did not get better because I had good ideas. It got better because the contest gives a clear score, and I built a loop around that score. The grader computes the score, per check, on the exact commit, and says why each check failed. So every change to the pack could be judged by a number that nobody on the team can argue with.

The loop has five steps. The diagram shows them in order, and where a change is kept or thrown away.

```mermaid
flowchart LR
    A["1. Collect<br/>every match: items, data,<br/>grades, agent logs"] --> B["2. Replay offline<br/>a fake game server<br/>and a grader of our own"]
    B --> C["3. Trace each lost point<br/>to its root cause,<br/>fix the whole class"]
    C --> D{"4. One change per version,<br/>run twice: did the<br/>score go up?"}
    D -->|"No"| X["Throw the<br/>change away"]
    X --> C
    D -->|"Yes"| E["5. Practice match<br/>against other teams"]
    E -->|"new lost points"| A
    class D check
    classDef check fill:#fff4d6,stroke:#d9480f,stroke-width:2px
```

**1. Collect the matches and their backlogs.** After every match I saved everything: the text of each item, the knowledge-base articles, the test data, the grader's result for each check, and the full log of every agent. A lost point is only useful if you can go back and see exactly what the agent did in the minute it lost it.

**2. Replay a match offline.** A real match needs the organizers' server and other teams, and practice slots are limited. So I built a copy of the contest: a fake game server that opens the items in waves, and a grader that scores the result the way the real one does. Now any change to the pack can be run and scored on a saved exam, any time, before the next real match.

**3. Trace each lost point to its root cause.** For every lost check I asked why, until the answer was about the pack and not about the item. "The worker forgot the screenshot" is not a cause. "Nothing checks that the evidence exists before hand-off" is one. Then I fixed that cause for every exam, never as a patch for one item, because the next match has different items.

**4. One change per version, run twice.** Each version changes one thing. I run it twice on a graded exam, because the same pack can score differently from one run to the next. I keep the change only if the whole score goes up, not only the item I was fixing.

**5. Test in a real practice match.** The offline copy is not the real thing. It has no other teams, no real rate limit, and no real clock pressure. So a version that passes offline still has to hold in a practice match against other teams. Whatever it loses there goes back to step 1.

The loop has limits, and each one cost me points before I learned it.

- **A change judged only against its own target looks good and is not.** Eight versions in a row fixed their item and never beat the version before them. That is why step 4 scores the whole run.
- **One run is not a measurement.** The same item scored 100 in one run and 36 in another, on the same model. That is why step 4 runs twice.
- **The loop only fixes what a score has already shown.** No practice exam punished test suites that had no large-volume case. The official match did, and it cost 63 points.
- **A fix tested on an easy case is not tested.** The log search was fixed and checked on six days of logs from one service. In the official match the workers asked for a month from every service.

So a clear score makes the loop possible. What makes it work is scoring the whole run, twice, on a case harder than the friendly one.

## What the matches taught us

These are the lessons we took from the match records, the reviews after each match, and the grading of the official match. Some we are sure of, because they repeated many times. Others come from one run only, and I say so.

### About the model

**1. Balance rules in code against work given to the model.** Code runs the same way every time and costs no tokens, but it only knows the cases its author thought of. The model can handle a case nobody planned for, but it can forget an instruction. Faults we fixed in code never came back. A fault we fixed only with an instruction came back twice: 16 points, then 63. But a wrong rule in code is wrong on every item at once, and that hurt us too. So code gets the mechanical parts, the model gets the judgment, and a rule may only block an item over something the grader scores.

**2. The newer model (gpt-6.1-sol) was both better and cheaper than the older one (gpt-6-sol).** Same pack, same exam: 963 points against 853, and 176 credit against 325. It needs fewer steps per item, each step answers faster, and its cached input costs half. The downside is that it is often overloaded, so we test it before each match and keep a backup model ready. This is one run on each side. Whether each of its steps is more often right, and how it compares with another vendor's model, we have not measured.

**3. Time is the number of steps times the seconds per step.** A higher reasoning effort makes each step slower, but it cuts the number of steps by more. On one incident, the highest effort took 12 requests where it had taken 28. Each request took 11 seconds, up from 6, and the total still fell from 2.8 minutes to 2.2. So we judge a model or an effort level by total steps and total time, never by the delay of one step. This is one run.

**4. Writing code is not where the points are lost.** In the official match, on a codebase we had never seen, every check that graded the code directly got full points: 507 of 507. We lost points on answers computed from data (47 percent), on tests that missed faults at large volume (0 of 11 caught), and on getting submissions in. Code has tests that tell the model it is wrong. Nothing tells it "one rule is still missing" or "time is almost up". So the next investment is in reading documents and in tests that try to break the code.

### About how an agent works

**5. An instruction in the prompt is not yet a behaviour.** We told the orchestrator to wait 110 seconds in one call. It never did, because the platform it runs on has its own base instructions, and they forbid waiting more than 60 seconds. When ours and theirs conflict, theirs win. So before asking for a behaviour, we read the platform's base instructions, and we call a change "measured" only after reading a real run.

**6. The agent often already knows. It lacks a way to act on it.** In many lost points, the deciding fact was in the agent's own output before it submitted. One worker wrote down a conflict and submitted anyway. One wrote "it could be 3000" and submitted 0. One saw 17 product codes with an odd prefix and never looked them up. The doubt sat in a note, and the steps after it read only the structured fields. So everything known is written at once into the place that gets submitted, and a doubt becomes a field the hand-off check can read.

**7. Checking at the end and sending work back is expensive.** In one practice match, 30.7 of 160 worker-minutes were rework after the first hand-in. Each refusal is a full round: read the reason, redo, recheck, hand in again. And an instruction deep in a 31,000-character prompt gets less attention than a short list at the top. So "what scores" goes first in the brief, and we check during the work, not only at the end.

### About a system of many agents

**8. Running in parallel buys speed, then each shared resource becomes a way to lose points.** Each worker acts as if it were alone. Ten shared things failed on us, among them the main branch, the test suite under load, the organizers' rate limit, the limit on tool calls, the thread limit, and the build folder. None was on a list beforehand. We found each one by losing points or time. Now, before adding agents, we list every shared resource and give it an owner, a queue, or a budget.

**9. The backup disappears exactly when it is needed.** We added a second agent to compute the same answer separately. In the official match one incident had none, because the threads ran out, and the other's came too late, because it competed with the worker for the same rate-limited logs. With the same model and the same brief, it also tends to make the same mistake. In the records we could read, it never once turned a wrong answer into a right one before submission. A backup needs resources of its own, reserved in advance.

**10. Points fall off a cliff, so design for the worst case.** The score does not drop slowly with lateness. One second late cost a whole item, 70 points. In practice our incidents took 3 to 7 minutes against a 10-minute deadline. The real match had an 8-minute deadline and three times the logs, so the margin was zero. We now test at the worst case, and always keep a valid answer ready to submit.

### About how the team improves

**11. We removed the very safety check the real match needed.** An early match cost us 16 points for tests with no large inputs, so the pack got a check for it. On the practice exams that check did not raise the score, and two days before the official match we switched it off to go faster. The official match then had 11 items of that kind where practice had 1. We missed all 11 and lost 63 points, in a match we won by 12. Before dropping a check, ask which kind of fault it guards against, and whether your exams even contain that kind.

**12. The score on a new exam is the real measure.** On exams we had played many times we reached 1000. The first time we met each exam we scored 960, 984, 928, and then 779. Each replay fixes the faults that one exam exposes, and a new exam exposes others. So readiness is measured on an exam we have not seen.

**13. A practice environment can teach the wrong thing.** Our own offline grader was written from guesses. It marked a screenshot of demo data as wrong, and the real grader gave it full points. One rule in the pack had been written because of that lost point, which never existed. We no longer build a rule on a fake grader's verdict when the real records say otherwise.

**14. The first diagnosis after a match is often wrong.** Our records have more than ten places where a first explanation was later corrected. Every time, the correction came from reading the agent's own session, not from timings or log values. So a post-match analysis is a hypothesis until it is checked against the source.

**15. Every step forward came from a person refusing the first answer.** Four times the analysis stopped at "the provider is slower, the pack cannot change that". Four times I asked again: are you sure, is this still shallow? All four led to a real step: breaking down where the time goes, the kit, and checks in code. When an answer brings relief, that is the signal to dig further.

## Open ideas for the next match

None of these ideas is built or tested yet, so I keep them short. The details will come when we start. They come in two groups: ideas borrowed from how other people run agents, and our own.

### Ideas borrowed from other people's systems

Each row is one idea, where it comes from, and the problem of ours it would fix.

| # | Idea | Borrowed from | What it would fix |
| --- | --- | --- | --- |
| 1 | The worker writes each answer to disk the moment it knows it | [Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) by Steve Yegge, where "an agent is not a session": work lives outside the session, so a crash loses nothing | Two incidents scored 0 for the answer, because it was still in the worker's context when time ran out |
| 2 | The helper keeps the steps of an item, and the worker asks it where it is | [StateM](https://github.com/henryqin1997/statem), a tool that keeps the steps of a long run in a file and checks every move | A worker gathered data for five minutes before writing any answer |
| 3 | The worker hands in "what I did not test" and "what I am unsure about" as fields | [Claude DevFleet](https://github.com/LEC-AI/claude-devfleet), where every agent ends with a report in fixed fields | A worker wrote "it could be 3000" in free text and submitted 0 |
| 4 | The second agent gets a different job from the worker | The "Rule of Five" in Gas Town: a review with a different focus each time finds more | Our second agent repeated the worker's work and its mistakes |
| 5 | When an item opens, the helper decides which checks it needs | TypeSafe AI's [patterns](https://docs.typesafe.ai/patterns): ask small fixed questions, and let code decide | One check ran on every item, was switched off for all, and cost 63 points |
| 6 | "This item waits for that one" is recorded as data | [Beads](https://github.com/gastownhall/beads), a task tracker for agents where a task can be blocked by another | The link is found today by matching sentences in a notes file |
| 7 | A stop hook keeps a worker from ending its turn before it has handed in | [The handbook's Codex page](https://locchh.github.io/handbook/ai/tool_tip/codex/), which shows that a Codex hook can block an agent from stopping and make it continue | Today this rule is only a line in the prompt |

Ideas 1 and 3 cost no extra model requests, so they go first.

### Our own ideas

Our own ideas start from one worry. Every new match brings a new kind of problem, we fix it, and the next match brings another. Our first score on each new exam was 960, 984, 928, then 779, while on exams we had replayed we reached 1000. So the loop makes the pack good at exams it has already seen, and a final is one it has not.

The ideas below are aimed at that.

1. **Three more jobs for the helper.** The helper prepares the logs for an incident, measures how well the tests catch faults, and follows every reference in the knowledge base. These are the three faults we did not fix.
2. **More unseen practice exams.** New mock codebases and new kinds of grading, with some exams held back and run only once. The number to watch is the first score on an exam we have never seen.
3. **Visible work.** The helper records every event as data, and a screen shows where each item and each worker is. Its first use is replaying a finished match to debug it.
4. **More credit, spent on thinking.** We spent 198 credit for 779 points, and credit only breaks a tie. We would pay 250 or 300 if it buys judgment, not longer runs.
5. **A supervisor agent.** One agent watches the whole match and adjusts a worker that is going the wrong way, on problems no rule was written for. It only watches at first, and gets its powers one at a time.
6. **A new split of the ten threads.** One orchestrator, three workers that take incidents first, five general workers, and one supervisor.
7. **A loop that tests every fix on traps.** When we fix a lost point, another agent builds the same fault in another form, a look-alike that is not the fault, and the worst case. A fix counts only if it passes all of them. The test runs in a small lab of a few items, not a whole match.

Each idea will be one change in one version, tested the way the loop above describes.
