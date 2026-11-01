---
title: "From Prototype to Production: Building with AI Models"
description: "A developer's walk from the first API call to an asset a regulated customer can audit: model foundations, production prompting, tools, streaming, context, agents and memory, coding agents and MCP, evals, failure handling, cost, security, versioning, and reuse. Written around Claude, true for any model. With a glossary."
pubDate: "2026-11-01"
author: "locchh"
---

Most developers meet a language model in a chat window, then send it a few API calls, and for a while that is enough. It stops being enough the day the code has to survive production. A prompt that looked solid fails on an input nobody tried. A tool call breaks halfway. A stream drops in the middle of a sentence. An agent runs past its budget, or writes to a file it should never have touched. None of these are exotic. They are what happens when a working prototype meets real traffic.

This post follows that journey from the developer's side of the keyboard. My earlier post, [From Request to Running System](/blogs/blog/from_request_to_running_system/), looked at the same territory as an architect: which decisions to make before building, and how to defend them. This one is about the code and configuration that make those decisions real. It runs in five parts: the model foundations everything else assumes, production prompting with tools and agents, coding agents with MCP and enterprise integration, production engineering with evals and security, and finally turning a working build into something others can reuse and a customer can audit. Each part ends with a recap, and a glossary and references close the post.

As before, I write it around Claude, because its documentation is detailed and the product names make examples concrete. The engineering transfers to any model provider. API details, model names, beta headers, and limits change often, so check them against current documentation before you build. The failure stories are composites of patterns that keep recurring, not reports on any single project.

```mermaid
graph LR
    P1["1. Model<br/>foundations"] --> P2["2. Prompts, tools,<br/>agents, memory"]
    P2 --> P3["3. Coding agents,<br/>MCP, integration"]
    P3 --> P4["4. Evals, failures,<br/>cost, security"]
    P4 --> P5["5. Reuse, deployment,<br/>trust boundaries"]
```

## Part 1. Model foundations

Before writing a line of code against a model, it helps to know what the words mean. This part covers four foundations that every later section takes for granted: how a model consumes and produces text, how model choice differs from reasoning mode, how many examples to put in a prompt, and how a program actually reaches the model.

### How language models behave: tokens, context, sampling, non-determinism

A model does not read characters or words. It reads **tokens**, chunks of text whose average size depends on the model's tokenizer and changes between model generations, so any characters-per-token rule of thumb is only a rough guide. Everything the model touches is counted in tokens: your prompt, the conversation history, tool definitions, tool results, and the response it writes. Tokens are both the unit you pay for and the unit of your budget, so when you ask what a feature will cost or whether an input fits, you are counting tokens, not words.

The budget is the **context window**: the total number of tokens a model can take in for one request. It holds everything at once, from the system prompt to the last tool result to the answer being generated. It is fixed, and it has two different edges. If the input is already larger than the window, the API rejects the request with a validation error before generating anything. If the input fits but generation runs into the ceiling, current Claude models stop and return what they have so far with a stop reason that says the window was exceeded. In neither case does the API quietly drop your oldest messages. Keeping a long session alive is your application's job: it has to trim or summarize history before each call. In development the window rarely fills, because test inputs are short. In production, longer inputs and more turns fill it much sooner.

A model also does not pick one fixed next token. At each step it produces a probability distribution over possible tokens and samples from it. This is **sampling**. Settings such as temperature shape the distribution: lower values concentrate probability on the likeliest tokens and make output more repeatable, higher values spread it out. Because the choice is sampled, the same prompt can return different wording even when both answers are correct. Sampling controls are also model-dependent. The newest Claude models reject non-default temperature, top_p, and top_k with an error and are steered through prompting instead, and even temperature zero does not guarantee identical output.

The consequence is **non-determinism**: identical inputs do not guarantee identical outputs. That changes how you test. A test that asserts the exact text of a response will flicker, because a correct answer can be phrased many ways. Assert on what must hold instead: a required field is present, a value is in range, the structure parses. When you need to judge meaning rather than shape, you need an eval with a model as grader, which Part 4 builds.

### Models and reasoning modes

Model families come in tiers that trade cost, latency, and capability. Claude currently spans Haiku for speed and cost, Sonnet as the balanced default for most production work, Opus for demanding work above Sonnet, and Fable as the most capable tier for the hardest reasoning, coding, and agentic tasks. The practical habit is to start with the balanced default, move up only when an eval shows it missing your quality bar, and move down only when an eval shows the drop is acceptable.

Whether the model reasons before answering is a separate decision, made per request. On current Claude models this is **adaptive thinking**: the model decides when and how much to think, and you tune depth with an effort setting rather than a fixed token budget. The older budget setting is deprecated and errors on the newest models, and thinking content is hidden by default unless you request a summary. Reasoning earns its cost on hard, multi-step problems and is wasted on lookups and classification. Because the two levers are independent, they compose: a capable model with reasoning off is fast and direct, a smaller model with reasoning on spends more tokens to think, and the hardest tasks pair a capable model with higher effort.

### Prompting modes: zero-shot, one-shot, multi-shot

Separate from how you word a prompt is how many worked examples you put inside it. **Zero-shot** gives the instruction alone. One-shot adds one example of an input paired with the desired output. Multi-shot, also called **few-shot**, includes several. The examples are not training data. They sit in the prompt and show the exact shape of answer you want, which a description alone often fails to pin down.

Each example costs tokens on every call, so the choice trades quality against cost. Use zero-shot when the task is simple and the output shape is obvious. Add one or two examples when the output has a specific structure, casing, or edge case that instructions keep missing. One or two correct examples usually fix that faster than another paragraph of instructions. The two choices interact: a more capable model may succeed zero-shot where a smaller one needs examples, so examples can let a cheaper model do the job. Try the smallest model and the fewest examples that pass your eval, and add only where the eval says you must.

### The technical substrate: SDKs, REST, streaming, async

At bottom, a model provider is an HTTP REST API: your code sends a JSON request with an API key and reads a JSON response back. You can call it with any HTTP client, but most teams use an official **SDK**, a thin convenience layer that handles authentication, request construction, retries, and parsing. The SDK and raw REST reach the same API and the same model.

There are three response shapes to choose from. A synchronous request sends the request and waits for the complete answer, which is fine for short responses and backend jobs. **Streaming** sends the answer in pieces as the model generates it, so output appears immediately, and your code reassembles the pieces. Claude streams over the same HTTP connection using server-sent events. For high volume, two patterns solve different problems. An async client, such as the Python SDK's async client or the promise-based TypeScript client, makes non-blocking calls so your application can do other work while it waits. The **Message Batches API** is for bulk offline work: you submit a large set of requests at once, get an identifier, and poll for completion. Batches can take up to 24 hours and cost less per token in exchange. That suits overnight pipelines and evaluation runs where nobody is waiting on any single result.

### Recap of Part 1

- **Think in tokens.** Tokens are the unit of input, output, and cost, and that is what the API meters and the context window measures.
- **The context window is a fixed budget.** An oversized input fails before generation, and hitting the ceiling mid-answer returns truncated output, so managing history is the application's job.
- **Sampling makes output non-deterministic.** Test on properties, not exact text, and use evals to judge meaning.
- **Model choice and reasoning mode are separate levers.** Use the smallest model and the simplest reasoning and prompting that pass your eval.
- **Pick the request shape by who is waiting.** Use synchronous, streaming, async, or batch depending on whether a user is waiting and whether the work is real-time or bulk.

## Part 2. Production-grade prompting, agents, and tool use

Writing code that uses a model is different from using a model to write code. Interactively, you type a prompt, read the answer, and adjust. Programmatically, nobody is there to adjust, so prompts, tool calls, streams, context, and agent loops all have to hold up on inputs you never saw. This part takes each of those in turn, and each section is built around a failure that is easy to miss in development and expensive to fix once it ships.

### Prompting craft: system prompts, XML, few-shot, and output constraints

A prompt that works once in a chat window often breaks against untested inputs in production. The instinct is to add more words and try again. That rarely helps, because rewording changes how you say something without adding the structural piece that is missing. If the model is blurring your instructions with your input data, clearer phrasing will not fix it. If the output format keeps drifting, "please format this correctly" will not fix it either.

The better habit is to diagnose the failure first, then add the one technique that addresses it. There are four techniques, and four common failures that point to them. When the result comes back in the wrong shape, such as a sentence where you wanted a label or prose where you wanted JSON, the prompt is missing an **output constraint** that names the form, field names, and stopping point. When content drifts in scope or tone and gets worse deeper into a conversation, the **system prompt**, the behavioral contract for the whole session, is too vague. When the model understood the task but invented a structure you never asked for, it needs few-shot examples, because it cannot infer an exact shape from a description. And when output is clean on the cases you tested but breaks on a variant, the prompt needs a constraint or an example that covers that variant. **XML tags** with descriptive names, such as `<my_code>` and `<docs>`, mark where instructions end and data begins, so the model does not read one as the other.

A support-ticket classifier shows how these combine. A bare prompt, "You are a support classifier. Classify the ticket," returned "Billing" on some runs, "billing" on others, and occasionally "This looks like a billing issue," and the router downstream broke on the inconsistency. The fix stacked three techniques: a system prompt that allowed exactly one label from BILLING, TECHNICAL, or ESCALATION and nothing else, two tagged examples showing the exact casing, and tags keeping those examples apart from the instruction.

```text
System: You are a support classifier. Classify each ticket into exactly one of:
BILLING, TECHNICAL, ESCALATION. Return only the label. No other text.

<sample_input>My account shows two charges for April.</sample_input>
<ideal_output>BILLING</ideal_output>
<sample_input>The API keeps returning a 429 error.</sample_input>
<ideal_output>TECHNICAL</ideal_output>

User: <ticket>I was charged twice for the same month.</ticket>
```

The cost of skipping diagnosis shows up clearly in one developer's six revisions of that same prompt. Pass one asked for one of three categories and got sentences back. Pass two added "be concise" and got inconsistent casing. Pass three added three paragraphs describing each category and got "billing/technical" for ambiguous tickets. Pass four forbade two categories and worked on 80 percent of tickets. Pass five added more paragraphs about edge cases, and the now-verbose prompt produced verbose output, over 2,000 characters per call, with higher latency and no gain in accuracy, because models tend to match their output length to their input. Only pass six, which replaced the instructions with a schema and two examples, worked on every ticket. If three re-prompts in a row have not helped, stop adding text and diagnose.

Prompt instructions are still requests, and a model can occasionally return a stray sentence or malformed JSON. **Structured outputs** close that gap at the API level by constraining generation against a JSON schema, so output that violates the schema cannot be produced. There are two forms. JSON outputs constrain the final response to your schema, which removes the parse-and-retry code around extraction calls. Strict tool use validates the arguments the model passes to a tool before your code runs, which matters in agent loops where a malformed argument could trigger a wrong action. The costs are real but small. The first request on a new schema is slower while the API compiles it, though compiled schemas are cached for a day. A short injected prompt adds input tokens. Refusals and truncation at the token limit can still return non-conforming output, so you still check the stop reason. And JSON outputs cannot be combined with prefilling the assistant's reply.

### Extended thinking

Prompting shapes what the model produces. Extended thinking shapes how much work it does first. Turned on, the model reasons step by step in a separate thinking block before the block that holds the answer. On current Claude models it is adaptive, tuned with an effort setting, and thinking tokens are billed at the output rate, so running a simple task at high effort means paying for accuracy you do not need.

The decision follows the shape of the task. Multi-step reasoning that holds several constraints at once, such as a derivation, a multi-hop logic problem, or planning dependent actions, deserves it, with effort matched to depth. Mechanical work such as classification, format conversion, or field extraction does not: a constrained prompt is cheaper and just as accurate. Agent loops that plan across several tool calls benefit, because reasoning before a plan reduces wrong-tool choices later, but you budget for the planning step rather than every call.

One rule is not optional. When thinking is on and the conversation uses tools, every thinking block must go back to the API unchanged on the next turn. Each block carries a signature that verifies the reasoning was not altered. Edit it, summarize it, or drop it, and the API rejects the request. Redacted thinking blocks follow the same rule even though their content is encrypted. The most common slip is stripping thinking blocks to save context, which breaks the next call. If accumulated reasoning is eating your budget, the answer is context engineering, not deletion.

### Tool use and schema design

With tools, you stop steering language toward a good answer and start handing the model a set of actions, trusting it to pick the right one. That pick is driven almost entirely by what you wrote in the schema.

The most common misconception is that the model runs the tools. It does not. **Tool use** is a loop between the model and your code. You define each tool with a name, a description, and an input schema. The model reads those definitions, decides a tool fits, and returns a block naming the tool and its inputs. Your application executes the tool and sends the result back, and the model continues. The loop is not automatic: if your code does not handle the return correctly, the model never gets the data it asked for.

The conversation is built from typed blocks, and the API enforces how they pair. A text block carries prose. A **tool_use block** carries a tool call with its name, a unique ID, and its inputs. A tool_result block carries what your code returned, with the matching ID and an optional error flag. A thinking block carries reasoning when extended thinking is on. Every tool_use block must be answered by a tool_result with the same ID in the very next user turn. A missing result, a mismatched ID, or results that arrive a turn late all fail validation, and no prompt change will fix that, because it is structural. When the model returns text alongside a tool call, keep the whole content array when you append the turn, or you corrupt the context it relies on.

The description is where tool selection is won or lost. Names should be specific: `get_account_balance` tells the model far more than `get_data`. Descriptions should say both when to use the tool and when not to. "Use this to find information" is indistinguishable from any other tool that retrieves something. "Use this to retrieve the current balance for an account ID. Do not use this for transaction history" gives the model an exclusion condition. Mark fields as required only when the call makes no sense without them, because forcing every field to be required makes the model invent values it has no basis for. Three or four sentences per tool, covering what it does, when to reach for it, and what it returns, is about right. When two tools take the same parameter shape, routing falls back on the descriptions alone, so add language that separates their domains. Independent calls can run in parallel, and current models issue them that way by default. Where one call depends on another's result, the calls must run in sequence, and you can force one call per turn when needed.

Here is how overlapping descriptions play out. A developer spent a morning wondering why the model kept calling `search_docs` when the answer was already in the conversation. The senior engineer asked what the two descriptions said. One read "Use this to find information about the product." The other read "Use this to retrieve relevant information from the current session." From the model's side, both said "find information." The fix was two sentences per tool: when to call it, and when not to. If descriptions cannot be separated even with exclusions, the tools probably should be merged into one with a type parameter. And exclusions only work when the model sees the full history, so truncating earlier turns silently breaks them.

When someone has already written your tools, you may not need to write schemas at all. The **Model Context Protocol (MCP)** moves tool definitions and execution out of your application into dedicated servers. For a service like GitHub, an existing MCP server already exposes repositories, pull requests, issues, and more. Your client asks the server for its tool list, passes the definitions to the model, and the same description-based routing applies. The tool-use loop does not change, only who wrote and maintains the definitions. Each connected server adds its definitions to the context window whether or not they are used, so connect only what you need. Claude's API connector lets you defer loading definitions and switch individual tools off. Local servers communicate over standard input and output, remote servers over streamable HTTP, and the older SSE-only transport is deprecated. Use MCP when a well-maintained server exists, write schemas yourself when none fits or you need tighter control, and use both together, connecting for breadth and tuning descriptions for the tools you actually route to.

### Streaming responses

Streaming makes long responses feel fast, but it gives your code a new job: you assemble the final message yourself from a series of events, and you must be ready for the series to stop early.

A streamed response arrives as events, each describing one change. A start event opens the message. A block-start event opens a content block with its type and index. A tool_use block opens with its name and ID but no input yet. Delta events append fragments: text, pieces of a tool's JSON input, or thinking. A block-stop event closes the block. A message-delta event carries the stop reason and final usage. A message-stop event says the stream is complete. Your handler applies each event to the partial state it is building.

The rule that keeps state from corrupting is simple: do not act on a partial block. A tool call's input arrives as a JSON string spread across many deltas and is not valid until its block closes, so parsing it early either crashes or runs the tool with half its arguments. Likewise, append the assistant turn to history only after message-stop, with every block complete. If the stream breaks first, discard the partial turn and retry from the last complete one, and check the stop reason before continuing a loop: only "tool_use" means the assembled calls are ready to run.

One team learned this the hard way. Their agent streamed so operators could watch it work, and the handler appended the turn whenever its read loop ended. On a fast local connection, the loop always ended at message-stop. In production, a network blip ended one stream after a tool call had opened but before its input finished. The handler appended a turn with truncated JSON, the operator retried, and the retry failed validation on the corrupted turn. The team spent an afternoon inspecting the schema and retry logic, because the error appeared on the retry. The real cause was upstream: a stream ending is not the same as a message completing. For short responses or backend jobs where nobody is watching, a plain non-streamed call avoids the whole problem.

### Context engineering

Every tool result is appended to the context window and stays there for the rest of the session. In a single call that is invisible. In an agent running ten or twenty tool calls, the window fills fast, and then the agent either compacts and loses detail or stalls before finishing. Deciding in advance what enters the window, what comes back out as a summary, and what never enters at all is **context engineering**.

It starts with the model choice, which sets the price and speed floor, and then with an honest view of the window as working memory. Production tool outputs are often three to five times longer than test fixtures, sessions run longer, and windows fill far earlier than in development.

There are four strategies for staying in budget, each suited to a different situation. Pruning rewinds to an earlier message and drops what came after, useful after an unproductive detour, at the cost of anything learned along the way. **Compaction** summarizes history into a shorter version that keeps what matters, useful when you want to continue the same work near the ceiling, at the cost of whatever the summary leaves out. In Claude Code that is a command. On the API it is a server-side option in beta, or a summarizer you write yourself. Clearing starts fresh, right when the next task is unrelated and old context would only bias it, so anything that must persist has to live somewhere durable. A subagent handoff gives a self-contained task to a **subagent** with its own context window and only what it needs, and gets back a short result, which is ideal for exploration where the journey is long but the answer is short. You lose visibility into how it got there.

Two API features cut the cost of what is already in the window. **Prompt caching** stores the processing of a stable prefix so later requests reuse it at a fraction of the price. You mark a breakpoint on the last block to cache, up to four per request, and long system prompts and tool definitions are the best candidates. Token counting measures a request before you send it, so you can check budgets against real tool outputs in development and stop oversized requests in production before they fail.

Retrieval is part of context engineering too. A retrieval path can break in three places. Chunks can be too small to be useful or too large to match well, so sentence- or section-based chunks with a little overlap are a sensible default. The embedding match retrieves what is semantically close, which can miss an exact identifier, so a lexical match is sometimes run alongside it. And the assembly step must hand retrieved text to the model in the structure the prompt expects, or the model answers from memory. A pre-built index is inspectable and testable but must be built, synced, and secured. Letting the model search iteratively at query time avoids the index and its staleness at a higher cost per query. A stable corpus with simple lookups favors the index. A changing corpus or multi-step questions favor iterative search.

When you write your own compaction, the summarizer prompt decides what the agent will know next. "Summarize the conversation so far" tends to drop task-critical state such as which files changed, what was decided at a branch point, and which errors were hit and fixed. "Summarize the conversation, preserving every file path modified, every decision made, and every error encountered with its resolution" produces a summary the agent can actually use. An under-specified summarizer is one of the most common causes of agents failing across sessions.

The failure here usually looks like something else. A receipt-processing agent ran under a 40,000-token budget the team set for cost, well below the model's own window. In development, twenty receipts produced tool results of about 800 tokens each, and a full session used about 18,000 tokens. In production, receipts came with supporting documents, results averaged about 3,200 tokens, and the budget filled at turn eight. The agent started picking the wrong tools and returning incomplete analyses, which looked like a schema problem. The real cause was that accumulated tool output had crowded the system prompt and early instructions out of the window. The fix was to prune tool outputs after use and compact before the cap. When tool selection degrades after a fixed number of turns, check the window before the schema.

### Agent construction

An agent is a multi-step tool-use loop with managed context and a defined goal. You already have the pieces. Connecting them across many turns surfaces new failures, so the first design question is whether the problem needs an agent at all.

Choose a **workflow** when you can write the exact steps in code, errors are costly, standard observability matters, inputs are well constrained, and every run follows the same sequence. Choose an **agent** when you can state the goal and the tools but not the path, inputs vary unpredictably, the actions are constrained by the registered tools, and some non-determinism is acceptable. Using an agent where a workflow would do adds behavior that lives in transcripts. Using a workflow where an agent is needed breaks the first time input leaves the planned path.

Once you choose an agent, the loop is the pattern and the wiring is an implementation choice. There are three wiring paths, which differ in how much of the runtime you own. A raw loop against the Messages API gives you full control and makes you responsible for the loop, tool execution, context, retries, and exit conditions. The **Agent SDK** runs the same loop that powers Claude Code inside your own process. You still execute the tools, and whether project files such as CLAUDE.md and skills load is controlled by a setting you should always set explicitly rather than trust a default. A managed agent service, which for Claude is in public beta, runs the loop and a sandbox on the provider's side while your application streams events in and results out. It suits long-running work and saves you building a sandbox, but sessions are stored server-side, which currently rules it out for zero-data-retention and HIPAA workloads. A common path is to prototype on the SDK and move to the managed service, expecting to re-express the agent definition rather than export it.

Whatever the path, the loop needs the same four things: tools registered, a system prompt scoped to the task and to the tools that actually exist, every tool call answered before the next turn, and explicit exit conditions that do not depend on the model volunteering to stop. Add at least one human-in-the-loop (**HITL**) checkpoint, placed by asking what the worst outcome would be if a step ran unchecked. Put a gate before any write, delete, or send that cannot be undone. Put one after a planning step, before execution, to catch a wrong plan. And put one on unexpected output, such as an error flag, an empty result, or a value out of range. Keep the tool set minimal. Registering every tool "just in case" degrades selection, so start small and add a tool only when a real gap appears.

Regulated data decides the endpoint, credentials, and log destinations before you write the wiring. Privileged legal material usually means the API inside the firm's own application, through an approved gateway with full logging that the organization implements itself. Health data means a configuration covered by a Business Associate Agreement, which excludes consoles, beta features, and consumer plans. EU residency means a cloud route with the region pinned in client configuration, because the direct API does not currently offer EU-only processing. Government workloads mean an authorized environment, and development code must not drift onto the commercial endpoint. Internal policy means the cloud vendor the CIO has already cleared.

One configuration agent shows why gates belong in the design. It could read, write, and validate config files, retrying its edit until validation passed, up to ten times. In a scratch directory it worked every time. In a customer environment it found an out-of-range rate limit, corrected it, validated it, and stopped after one clean iteration, exactly as designed. The customer's application depended on the old value and began failing within minutes, because validation checked the schema, not downstream dependencies. The loop was fine. What was missing was a pause between "change proposed" and "change written to a live system," a state the tests never needed.

### Agent memory

An agent that works within a session remembers nothing when the session ends. Memory scope decides what it knows at the start of the next one, and the wrong choice fails in one of two opposite ways: too much in-context state inflates every call, and too little persistent state makes the agent forget.

There are four scopes. In-context memory keeps state in the live conversation, with no retrieval overhead but a token cost that grows with every turn, and it is lost when the session ends. External storage writes state to a database and reads it back, surviving across sessions, users, and instances at the cost of latency and read-write code. Summarized memory injects a condensed version of earlier conversations, cheaper than replaying history but limited to whatever the summarizer kept. Stateless agents carry nothing, which is correct for jobs that finish and close. Make the choice at design time. An assistant that picks up a user's thread each day needs external storage. A formatter that transforms one file and exits is stateless. A multi-hour coding session that will not continue can stay in context.

Repeatable instructions are a separate problem from state, and the pattern for them is a **Skill**: a SKILL.md file with a name and description in its frontmatter and instructions below. Only the name and description load at startup. The full instructions load when a request matches the description. By contrast, a project instruction file such as CLAUDE.md loads into every Claude Code session, and in-context instructions grow with the conversation. Use the instruction file for always-on project standards, skills for task-specific expertise, and in-context instructions for one-off work. On the API, skills are in beta and run inside the code execution container, not your environment. Subagents do not inherit the parent's skills or history, so list any skill a subagent needs explicitly, although they do inherit the parent's permissions.

A support-escalation agent shows the memory failure. Development ran single long sessions, and in-context history worked. Production ran many shorter sessions across days, and by the fourth session the injected history alone exceeded 40,000 tokens, with the system prompt and tools pushing past 45,000 before the first useful turn. The agent began returning incomplete results that looked like tool-selection failures. Moving history to external storage and injecting only the relevant part was not hard, but doing it under production pressure cost far more than deciding at design time.

### Multimodal input and batch processing

Images and documents spend context before the model reads a word of your prompt. Claude sees images in 28-by-28-pixel patches, so an image costs roughly its width divided by 28 times its height divided by 28 in visual tokens. A 1,000-by-1,000 image is about 1,296 tokens, so ten high-resolution screenshots weigh as much as a long system prompt. Each model tier has its own maximum resolution, and larger images are downscaled first. Run that arithmetic on your largest production image before writing the ingestion code, because the fix is often a resize step that takes minutes to add before launch.

There are three ways to send an image. Inline base64 suits one-off images, though the bytes travel with every request. A public URL avoids the payload but depends on the link being stable and reachable. The **Files API** uploads once and references a file ID from then on, which suits assets reused across requests or conversation turns. It is in beta and not available on every cloud route. PDFs use a document block with the same source options. The prompting techniques still apply, plus guidance for visual ambiguity, such as how to treat overlapping objects.

For high volume, looping over the synchronous API is the wrong model, and splitting the list into chunks does not change that. One developer kept hitting rate limits on a nightly job despite chunking, until a senior engineer pointed out that the API still saw one request per item, back to back. The Message Batches API takes up to 100,000 requests or 256 MB in one submission, processes them asynchronously at lower cost, and returns results in arbitrary order, matched back by a custom ID you set on each request. It is right for nightly pipelines and evaluation runs and wrong for anything a user is waiting on. Files and batches combine well for offline jobs that reuse the same assets, such as classifying images against a fixed taxonomy every night.

### Recap of Part 2

- **Diagnose a failed prompt before re-prompting.** Wrong shape means a missing output constraint, drift means a weak system prompt, invented structure means missing examples. When untested inputs still break the parser, move control into the API with structured outputs.
- **Match reasoning depth to the task.** Enable extended thinking only where it changes the answer, calibrate effort, and always return thinking blocks unchanged.
- **A stream ending is not a message completing.** Act on a block only after it closes, commit a turn only after message-stop, and discard partial turns on interruption.
- **Most wrong-tool bugs live in the description.** Write when to use the tool and when not to, and when someone else has written the tools, connect an MCP server deliberately.
- **Context is a fixed budget that tool outputs spend fastest.** Prune, compact, or delegate to subagents, and suspect the window when tool choices degrade after a fixed number of turns.
- **Decide workflow or agent before wiring, and design the human gates in.** Irreversible actions get a checkpoint before the loop ships.
- **Choose memory scope by the shape of the session.** Carry state in storage or summaries as needed, and carry repeatable instructions in skills.
- **Calculate multimodal cost first, and batch offline work.** Looping over the synchronous API is not batching.

## Part 3. Coding agents, MCP, and integration

Once a model works in your code, the next challenge is making that work configurable, shareable, and safe to connect to real systems. On your own machine every shortcut feels fine: the permission mode, the small rules file, the script path, the credential in the config, the connection that worked in staging. Each of those can fail the moment the work leaves your machine. This part covers running a coding agent under a permission model, giving it durable project context, packaging a workflow so a teammate can install it, and connecting to external and enterprise systems through MCP without leaking credentials or failing a security review. I use Claude Code as the example, and other coding agents have similar concepts.

### Permission modes and human gates

A coding agent runs the same tool loop as the API, with one more layer: a permission system that decides which actions need your approval. It works in three phases. It explores first, reading files and tracing logic until it understands the codebase. Then it proposes a plan. Only after you approve the plan does it write and run changes. That order produces better changes, and it is also where permissions apply.

A **permission mode** sets how often the agent stops to ask. Claude Code's default mode allows reads and prompts before nearly every edit or command, which is safe but slow and the right start for an unfamiliar codebase. An accept-edits mode also approves file edits and common filesystem commands inside the working directory, while other shell commands, writes outside the directory, and protected paths still prompt. Plan mode allows research only and blocks all edits until a plan is approved. An auto mode lets a separate classifier approve safe actions and block anything that escalates beyond your request, with production deploys, mass deletes, credential exfiltration, and force-pushes to main blocked by default. It is a research preview, not a guarantee. A do-not-ask mode runs only pre-approved tools and denies everything else, for locked-down CI. A bypass mode skips every check except a last-resort prompt on catastrophic deletes and belongs only in a disposable container.

Settings live at four levels. User settings follow you across projects. Project settings are committed so the whole team shares them. Local project settings hold personal overrides and are ignored by git. Enterprise managed settings are set by administrators and cannot be overridden. Allow and deny rules sit on top of the mode, a deny always beats an allow, and an enterprise-level deny is the most durable control there is, because no developer can remove it and it holds even in bypass mode.

Modes decide what the agent may do unasked. Where a human must still look comes from one question: what is the worst outcome if this runs unchecked? Let low-stakes, reversible actions through, such as a formatting fix inside the working directory. Gate anything hard to undo or touching a sensitive path, such as writes outside the project, destructive commands, or security-relevant files. And never let the agent be the only gate on code your team has marked sensitive, however confident its own review sounds.

One cleanup session shows what bypass mode removes. After three quiet days, a developer switched to bypass to rename old API endpoint references, a task that felt routine. The pattern matched files in both the source tree and a production config directory, the cleanup script ran without a prompt, and three files of production endpoint overrides were deleted. In default or accept-edits mode, the script call would have stopped for approval. Before switching modes, put deny rules on sensitive directories, and if you want fewer prompts, use a classifier-gated mode rather than a full bypass.

AI code review deserves the same calibrated trust. A review gives you findings to triage, not a verdict to apply. Trust what the reviewer can prove from the diff in front of it, such as a missing null check or an unclosed resource, and confirm it on the lines it cites. Treat any claim about runtime behavior or another system as a hypothesis to test. Put the human gate where a finding turns into an action that is hard to reverse, and improve the reviewer's accuracy by giving it the conventions it would otherwise have to guess.

### Durable project context

Permissions control what the agent may do. Project context controls what it knows and how it behaves, session after session. Four mechanisms carry it, each with a different trade-off between context cost and reliability.

**CLAUDE.md** is a file at the project root that loads into every session before your first message, so its conventions, constraints, and commands are always present. The init command generates a starter version, which you should prune to the rules that actually change outcomes: test commands, framework conventions, paths not to touch, and departures from defaults. Size is its main failure mode. Every line dilutes every other line.

**Rules files** in the project's rules directory add a narrower layer. A paths pattern in a rule's frontmatter makes it load only when the agent works on matching files, such as a rule that every SQL file in the database module must declare a transaction boundary. Without a paths field, a rule loads at startup like CLAUDE.md, whatever folder it sits in.

**Hooks** run your own scripts at fixed points in the agent's lifecycle, and unlike instructions, they fire every time regardless of what the model decides. A pre-tool hook runs before a tool call and can block it by exiting with code 2 and explaining why. A post-tool hook runs after a call and suits formatting, tests, and audit logging. Other events fire when a prompt is submitted, when the model stops, on notifications, and when sessions start and end. A rule in CLAUDE.md is followed most of the time. A hook is followed every time. That is the difference between a convention and a guardrail.

Subagents run delegated tasks in their own context and return only a result. The built-in Explore and Plan subagents skip CLAUDE.md and git status for speed, so project rules are not in their view. The general-purpose subagent loads both. Custom subagents do not see your skills unless you list them in the subagent's frontmatter.

An 847-line CLAUDE.md shows the dilution in practice. It had grown over two months of team additions: framework preferences, testing conventions, a style guide, dependency rules, path restrictions, a historical decisions log, and archived notes. Line 347 said not to modify a legacy tokens directory. Asked to refactor an auth module and told again not to touch that directory, the agent edited a file in it anyway while updating an interface. The rule was there. It was simply outweighed by the 846 lines around it. Keep CLAUDE.md to the rules that change behavior now, move path-specific guidance into rules files and history into reference documents, and turn the one rule you cannot afford to lose into a hook.

### Packaging workflows

Once your setup works, the next question is how a teammate installs it in one step rather than repeating your configuration by hand.

A skill is a SKILL.md file in the project's skills directory, and the same file can run in Claude Code, through the Messages API, in the Agent SDK, or in a managed agent. It loads and runs differently in each. In Claude Code it is discovered from the filesystem and runs locally under your permission rules. On the API it is sent with the request and runs in the provider's code execution container, behind beta headers, so a skill that calls a local script will not find it there. In the Agent SDK it loads only if you set the setting sources explicitly, and the most common surprise is a skill that worked in the terminal doing nothing in the SDK because that setting was never set. In a managed agent it is attached to the agent definition and runs in the provider's sandbox. Three rules keep a skill portable. Write the description as the matching criterion. Do not assume local files or tools exist. And remember that subagents do not inherit skills.

Explicit entry points are now skills too. You invoke a skill by name with a slash command, and a frontmatter flag stops the model from loading it automatically when you want it to run only on request. The older commands directory still works but is legacy. Commands shipped in a plugin are namespaced by the plugin's name, so two plugins can both offer a run-tests command without colliding, and renaming a plugin renames all of its commands.

A **plugin** bundles skills, hooks, subagents, and MCP servers into one versioned, installable unit, distributed through a marketplace. The official marketplace is available by default, third-party ones can be added from a GitHub repository, and administrators can push plugins organization-wide through managed settings, with an allowlist of permitted marketplace sources. A plugin carries only what it bundles. A deny rule or hook the author relied on locally does not travel unless it is included.

The classic packaging failure installs everywhere and runs only on the author's machine. One deployment-validation skill pointed at a script under the author's home directory, an absolute path that existed nowhere else. A second skill in the same plugin depended on an environment variable set in the author's shell and never documented. Every install succeeded and every teammate's run failed, and three people spent two hours tracing the missing variable. Reference scripts relative to the project or the plugin's own root, through the variables the tool provides for that, bundle what the plugin depends on, document and validate every required environment variable, and test the install on a clean machine before sharing it.

### MCP servers

An MCP server is the layer that exposes capabilities to the model from outside your codebase, and building one starts with transport and scope.

Wiring a tool directly means each application owns its schema and code, so three applications that need the same service maintain three integrations. MCP turns the integration into a server that any MCP client can use. Servers expose three kinds of capability. Tools are actions the model can call. Resources are read-only data the client fetches into context directly, either at a fixed address or through a template with a parameter, which is cheaper and more predictable than a tool call when you know the data is needed. Client support for resources varies. Prompts are vetted instruction templates a client invokes by name, so every user gets the same carefully built wording.

Transport is the channel between client and server, and it follows where the server runs. **Stdio** launches the server as a local subprocess and suits personal tools and development servers. HTTP connects to a remote server and is the choice for anything shared or hosted. SSE is a legacy transport, superseded by HTTP. Each connected server adds tool definitions to the pool the model must account for. Claude Code defers them by default and searches for the relevant ones when a task needs them, with an option to load them upfront when they fit in about a tenth of the window.

Prompt caching applies here as well. You enable it by marking breakpoints, because there is no global switch. The cached content must match exactly, since one changed character before the breakpoint forces a fresh write. Requests are processed in the order tools, system prompt, then messages, so a breakpoint after the tools caches the tool definitions while messages stay dynamic. The default cache lives five minutes from last use, a one-hour option suits agents that pause between steps, and prompts below a minimum length, around a thousand tokens for most current models, are never cached.

Retrieval solves the same context problem for large bodies of reference material. Classical RAG chunks and embeds the material ahead of time and matches questions against the index, like a librarian who has already summarized every chapter. **Agentic search** skips the index and lets the model search and read at the moment of need, like a researcher who goes and finds the answer. Claude Code's deferred tool loading and Claude.ai Projects with large knowledge bases both work this way. Either way, retrieval scales because each request receives only a slice, and it is only as good as what it finds, so descriptive file names and well-organized material matter.

Scope decides who loads a server. Local scope keeps it to you and the current project. User scope makes it yours across every project. Project scope writes it to a committed `.mcp.json` so everyone who clones the repository gets it. Note that a project-scoped stdio server spawns a local process on each teammate's machine, so each needs the runtime installed. Enterprise scope is pushed by administrators and cannot be overridden. Permission rules can target single MCP tools by server and tool name, such as allowing only GitHub's create-issue tool to run unprompted while everything else on that server still asks, and a deny on one tool beats an allow on the server. On the API connector, a per-tool enabled flag decides whether the model sees a tool at all, which controls context and scope rather than governance.

The GitHub server ties these together. It is remote, so it uses HTTP. Project scope fits a team, local scope fits one person. It authenticates with a personal access token passed as a bearer header, supplied through an environment variable and never written into the committed file. Linear's server uses OAuth instead: the first connection opens a browser sign-in, and the token is issued and stored without anyone copying a secret.

The most common mistake in this area is a key in the config. A developer connected a data-warehouse server with a service-account key written straight into `.mcp.json`, meaning to move it later, then committed the file so teammates could connect. Within two days the key was on three teammates' machines, in a CI runner, and in repository history. Moving it to an environment variable fixed the current file but not the history, so the account had to be rotated, which broke two other services using the same key and cost three hours. Treat any inline credential in a committed file as compromised. Prevent it with an instruction in CLAUDE.md and back that instruction with a pre-tool hook that blocks writes of credential-like values to the config.

### Enterprise integration

A prototype answers one question: does the connection work? An enterprise integration must also answer who the model acts as and whether that is auditable, what data it can reach and where that data goes, whether an administrator can lock the configuration, and whether access is logged well enough for an audit.

Authentication follows the service. Remote services tied to a user's identity use OAuth: the server signals that authentication is required, the client runs a browser sign-in, and a token is stored. Remote services that act as a service account use an API key from an environment variable or a pipeline secret, never a committed file. Local services over stdio rely on filesystem permissions and deny rules.

Managing the secret matters as much as choosing the method, through three practices. Separation: the config holds a variable reference, never the value, because config files get committed and cloned. A home for the value: an environment variable for something local and short-lived, a **secret store** for anything shared or audited, since a store centralizes the value, controls who reads it, logs access, and updates every consumer in one rotation. And rotation: on a schedule and immediately after any suspected exposure, because a leaked key cannot be made secret again. A value read by name rotates without touching code, while a value baked into code cannot be rotated cleanly. Scope each credential to the narrowest access it needs, and keep a list of what uses it so rotation does not surprise anyone.

Regulated customers add three requirements on top. Enterprise managed configuration lets an administrator lock the integration so no developer can change authentication during an audit window. A post-tool hook that logs every tool call and its parameters gives auditors their record. And a regional endpoint combined with a platform that pins processing to that region answers where data goes.

Code modernization is a good test of all of this, because it concentrates the risks: a large blast radius, unknown dependencies, and limited reversibility. Plan mode holds the agent in read-only exploration while you build confidence. Hooks block edits to the most sensitive paths. CLAUDE.md carries the target conventions so the agent does not drift back to the legacy patterns it reads around it. Before starting, answer three questions: what breaks downstream if an edit is wrong, how every change is audited, and who approves each phase before the next begins.

One OAuth integration passed every staging test and failed every production sign-in with a redirect mismatch. The OAuth app had been registered for the staging host only, and providers accept only registered redirect addresses. The security reviewer added a second point: most enterprise customers want separate OAuth app registrations per environment anyway. Add the redirect registration to the deployment checklist so it is not discovered at the first production login.

### Recap of Part 3

- **Permission mode is a risk decision, not a speed decision.** Match the mode to the work and environment, and use deny rules at project or enterprise level to cover what a mode alone does not.
- **Treat an AI review as findings to triage.** Trust what the reviewer can prove from the diff, test its other claims, and gate where a finding becomes an action that is hard to reverse.
- **A skill is portable only if you design it to be.** Each runtime loads and sandboxes it differently, and subagents never inherit skills.
- **Use the right mechanism for each piece of durable context.** CLAUDE.md for universal rules, rules files for scoped guidance, hooks for enforcement, subagents for isolated work.
- **Shareable setups need portable components.** Avoid absolute paths, document required variables, and test installs on a clean machine.
- **Transport and scope are separate decisions with linked consequences.** Stdio is for local servers and HTTP for shared ones. A stdio server in a committed config only looks shareable.
- **Settle enterprise security before deployment.** OAuth for user identity, environment variables or a secret store for service credentials, audit hooks, and locked managed settings are easy to build in and hard to retrofit.

## Part 4. Production engineering, evals, and security

A system that works on your machine has not yet proven it keeps working. This part closes the gap between development and production, where an untested input arrives, a rate limit hits at peak, a corpus outgrows the window, or a fetched page carries an instruction aimed at the agent. The failure is almost never a bug in the code that ran. It is a decision that was never made. So this part starts with writing those decisions down, then builds the layers that enforce them: evals, tests and tracing, failure handling, model and cost discipline, and a security boundary.

### The design document

Before writing production code, write a short **design document**, usually one page, that records four decisions concretely enough to check the built system against them. Success criteria name what the feature must produce for representative cases, in terms specific enough to grade: "summarize the thread" cannot be checked, "a two-sentence summary listing every action item and its owner" can. Failure handling lists the errors production will throw, marks each retriable or terminal, and says what the user gets when recovery is impossible. The cost and latency budget sets the per-request and monthly ceilings, the latency target, and the minimum reliability the design will not trade away. The trust boundary names which inputs someone else can write and the smallest set of actions the feature needs. Every later layer reads from this page: the criteria become eval cases, the failures become error paths, the budget becomes what you instrument, and the boundary becomes what you enforce with a hook. If a coding agent is doing the building, this is also what you hand it before it writes anything.

### Evals and a calibrated judge

An **eval** works like a thermometer. It does not make the system healthier, but it gives you a number you can trust. You collect input cases, write down the expected behavior for each, run the feature on every case, grade each output, and average the scores. Before you have one, "done" is a feeling. After, it is a score you can track as you change the prompt, the tools, or the model. You write it before the feature so that you define success before you start rationalizing whatever the model happens to produce.

```python
def run_eval(dataset):
    results = []
    for case in dataset:
        output = run_feature(case["input"])
        results.append(grade(case, output))
    return sum(results) / len(results)
```

A first score of two or three out of ten is normal. What matters is whether it rises as you change one thing at a time, and the per-case results matter as much as the average, because a steady average can hide three cases fixed and three broken.

Choose the grader by the shape of the output. Exact match works when there is one correct form, such as a single label, and is nearly free, but it fails every valid paraphrase or reordering. A code-graded check works when a rule can validate the output: valid JSON, parseable code, a number in range, a required field. It is cheap, and it says nothing about whether the content is good. **LLM-as-judge** works for open-ended quality such as faithfulness, instruction following, or tone, which no code rule captures, at the price of a model call per case and noisier scores. Many teams grade structure in code on every commit and run the judge on a slower schedule.

A judge is only useful if it is anchored and calibrated. Ask it for strengths, weaknesses, and brief reasoning before the score, or scores drift toward a safe middle around six. Then calibrate: run it on cases a human has already labeled and measure how often it agrees. If agreement is low, tighten what each score means, add a good and a bad example, and measure again. Coverage matters more than a perfect rubric. Twenty cases that include awkward inputs catch more than three hand-picked ones, and you can have the model generate more cases from a labeled seed set and spot-check them. When a case fails, the category tells you where to look: a formatting failure points at output instructions, a factual failure on retrieved content points at retrieval, a failure only on long inputs points at context handling.

Here is what skipping this costs. A team shipped a field extractor after reading a dozen sample outputs. It validated that messages were non-empty and dates were well formed. Two weeks later, a customer wrote "I placed my order on March 3 but did not receive it until April 12," and the feature took April 12 as the order date. Every validation passed, because validation checks shape, not correctness, and a batch of records was updated wrongly. Nobody had ever defined the expected behavior for a message with two dates. The fix was a prompt change, but the eval is what found the gap and now guards against it. Ask the model to list edge cases that could break your implementation, such as two dates, no date, or "next Tuesday," and turn the plausible ones into graded cases before launch.

### Testing and tracing

An eval tells you how good the system is. It does not tell you where a failure happened, and a passing eval can hide a break elsewhere. Underneath it you need tests that isolate each kind of failure and traces that show which step produced a bad result.

Four test levels each catch something the others cannot. A unit test checks one function, such as a parser or tool wrapper, in isolation. A functional test checks that one model call returns the expected shape for an input. An **integration test** exercises the handoff between two components, such as retrieval output passed into a model call, and this is where most silent failures hide, because each side can pass its own tests while the handoff is broken. An end-to-end test runs the full flow as a user would and catches anything that only appears when everything runs together, though it cannot tell you where.

A trace records each step of a run: the prompt, the tool calls, intermediate outputs, and timing. It turns "the case failed" into "step four, the parser, raised a KeyError on a field the model did not return," which is the difference between a five-minute fix and a day of searching by hand.

One end-to-end failure shows why the integration level exists. The parser's unit tests passed, and the model call's functional test passed. The full flow failed because retrieval returned a list of chunk dictionaries while the prompt builder expected a plain string, so the context arrived malformed and the model answered from memory. Each side worked alone, and no test covered the handoff. Define the format contract between components and test the seam with real data.

The same instinct applies to retrieval strategy. A cheap classification call can route single-fact lookups to a fixed retrieval pass and multi-step questions to agentic search, so you pay for iteration only when the question needs it. If all your traffic has one shape, skip the router and hardcode the path that fits.

### Failure handling

Tests show that failures exist and traces show where. The next question is what the system does when a failure happens in live traffic, and the answer starts with one question: would retrying the same request plausibly work?

If yes, the error is retriable. Rate limits, temporary overloads, and transient server faults clear with time. On Claude's API that means 429, 529, and the 5xx family, including 500 and 504. If no, the error is terminal: a malformed request, a failed authentication, a missing resource, which on Claude's API means 400, 401, 403, and 404. Retrying a terminal error only burns the retry budget and buries the real problem under identical failures. When unsure, treat an error as terminal and raise it, because a terminal error fails loudly and gets fixed, while a misclassified retriable one hammers a service.

```python
RETRIABLE = {429, 529, 500, 502, 503, 504}

def is_retriable(status):
    return status in RETRIABLE  # everything else fails fast
```

Check what the SDK already does before writing your own retries. Claude's SDKs retry transient failures with growing delays, and wrapping your own retry loop around theirs multiplies attempts against the very rate limit you hit. Decide where retries live. Rate-limit responses also include a header saying how long to wait, which is more precise than guessing, so honor it and fall back to **exponential backoff** with jitter and a cap when it is missing.

Tool failures must reach the model explicitly. When a tool fails, return its result with the error flag set and a short message, not an empty result, so the model can try another approach, ask for clarification, or stop. An empty result is treated as valid data and produces a confident wrong answer. Refusals need their own path too: they arrive with an ordinary success status and a refusal stop reason, so a status-code classifier will not catch them. Raise them, log them, and never retry them silently.

One customer-facing feature called the API in a loop with no error handling, because nothing had ever failed in development. At the first traffic peak, a rate-limit response raised an unhandled exception and the whole request failed. The first fix, immediate retries in a tight loop, made it worse, because every instant retry counted against the same limit. The right fix was to classify the error as retriable, back off with a cap, and honor the wait header.

### Model selection in production

Cost management optimizes spend within a model. Model selection sets the baseline it works from. A larger model buys quality at a higher per-token price and usually higher latency, and a smaller one buys speed and savings at the risk of quality. A larger model can sometimes be cheaper overall if it finishes in fewer tokens, and the cost of mistakes belongs in the calculation, since saving a little per day on a smaller model is a poor trade if its errors are expensive downstream. Reaching for the most capable model by default is the most common and most expensive selection mistake.

You do not need one model for everything. A common pattern is a balanced default with an override: route most traffic to the middle tier and send specific requests to a larger or smaller model based on a cheap signal such as task type, input length, or a difficulty classification. Step up when an eval shows the current model failing on the hardest cases and errors are costly. Step down when an eval shows a cheaper model holding the bar on the bulk of traffic. A high-volume classifier with an eval showing the smallest model holds the bar belongs on that model. A dependent multi-step refactor where the middle tier misses the hard cases belongs on a larger one. Mixed traffic belongs behind a router. The eval is the gate in every case.

### Cost, latency, and orchestration

A system that recovers from failure must still be affordable and fast. In development you never see the bill. In production, cost and latency become the constraint, so instrument three numbers on every call from the start: token usage, latency, and error rate. With per-call data, a cost spike stops being one question, "why is the bill high," and becomes a sortable table that often shows one step doing most of the spending.

```python
def instrumented_call(make_call, step):
    start = time.perf_counter()
    resp = make_call()
    log_metric(step=step,
               input_tokens=resp.usage.input_tokens,
               output_tokens=resp.usage.output_tokens,
               latency_ms=(time.perf_counter() - start) * 1000)
    return resp
```

A cost or latency problem almost always traces to a few levers: the model for each step, the size of the prompt and context, the number of tool calls, and how output is delivered. Streaming improves perceived latency for users, because a response that starts in 300 milliseconds feels faster than one that arrives whole after two seconds. Streaming with tools also requires accumulating each tool's JSON input across deltas until the stream closes before parsing it, and a stream that breaks midway is a retriable failure of the whole request.

Prompt caching pays when reads outnumber writes. Cache writes cost more than ordinary input, about 1.25 times for the five-minute lifetime and 2 times for the one-hour lifetime, while reads cost about a tenth. An automatic mode manages breakpoints as a conversation grows, and explicit breakpoints give finer control. Three conditions decide whether caching helps: the prefix must be identical, it must recur within the cache lifetime, and it must be long enough to clear the minimum. Cached content can also be stale, which is fine for a fixed system prompt and dangerous for anything that should reflect live state. The Batches API is the other big lever for anything that can wait, trading latency for a much lower bill, and batching combines with caching when a scheduled job reuses a long fixed prompt.

Multi-agent orchestration is the pattern that multiplies cost fastest. In an **orchestrator-worker** design, a lead agent splits a task, subagents work in parallel in their own context windows, and the lead combines the results. Treat it like a hiring decision: five researchers finish a broad survey faster than one, and you pay five salaries. Anthropic reported that its multi-agent research system, with Opus as lead and Sonnet subagents, clearly beat a single agent on its internal research evals while using roughly fifteen times the tokens of a normal chat. It found that token usage explained most of the difference in performance, meaning the pattern works mainly by buying more parallel computation. It fits broad tasks that split into independent parts, such as research across many sources, and fits poorly with tightly coupled work such as coding, where each step depends on the last. Each subagent also needs its own retry and fallback handling, and a cheaper model for the workers reduces the multiplier.

Cost is only half the budget. Reliability sets a floor you tune cost above, never below. Decide the floor first, for example a four-second ceiling and three retries per dependency, then accept a cheaper model only if it stays inside both, and refuse to cut retries if failures would rise past the floor. Cost pressure is loud and daily, while reliability problems look like noise until they become an incident, so setting the floor first stops the louder pressure from winning. A pinned eval baseline makes the floor checkable.

A developer who split a slow task across parallel subagents saw latency drop slightly and the bill triple, with answers barely better. The task did not split: each step depended on the previous one, so the subagents mostly waited on each other while each consumed its own tokens. Moving back to a single agent with good context cut the bill and kept the quality.

### Security

The hooks and logging you already have can also enforce a security boundary. The core threat for any agent that reads content it did not write is **prompt injection**. A model processes its whole context as one stream of tokens and has no built-in line between your instructions and text that arrived from a fetched page, a document, a database record, an email, or a tool result. An instruction hidden in that content, in white text at the bottom of a page, in an image, or in a record the agent will read next week, can be taken as a command. Model training and classifiers make current models resist many injections, and wrapping untrusted content in delimiters helps a little, but none of this is guaranteed. Trusting your users does not help either, because the hostile instruction comes through the content, not the user. The reliable boundary is not in the wording. It is in what the agent is allowed to do.

A jailbreak is a different threat with the same defense. It tries to get the model to ignore its own safety constraints, while an injection tries to hijack your application's instructions. In both cases, you validate and constrain what reaches the model and limit what the model can do as a result.

Identity and access form that limit. Give the agent an identity with the narrowest permissions the task needs: write to one output directory, read only its input, explicitly deny system paths, secrets, and cloud credentials. Keep secrets in environment variables or a secret manager, and protect the agent's own auth configuration, because whatever can widen its permissions can remove the control that limits damage. Assume an injection gets through everything else. With broad permissions it becomes an incident. With **least privilege** it becomes a denied action and a log entry.

Hooks turn those limits into enforcement. A pre-tool hook can deny a write outside the permitted path and log the attempt, while logging every permitted privileged action as well, so the control and its evidence exist before anyone asks. When several rules apply to the same action, deny beats ask, and ask beats allow. A prompt instruction is not a security control. If something must hold, enforce it with a hook. Hooks do share one dependency, though: they only cover what they explicitly check. Operating-system sandboxing closes that gap by restricting the agent's filesystem to its working directory and its network to named endpoints, enforced by the OS rather than application logic, so it holds even when a hook is missing or misconfigured.

Regulated customers ask three questions early: where data is processed, how access is logged, and whether an administrator controls configuration centrally. Answer them during scoping and the security review becomes a checklist instead of a blocker. Zero-data-retention eligibility varies by model and platform, so confirm it for each model you plan to use.

One pair of developers learned this in a pairing session. Their agent fetched web pages and could write to one file path. Since all users were internal, they had skipped validating fetched pages. Then the agent wrote a file nobody asked for. A line near the bottom of a summarized page told it to ignore its instructions and write the summary elsewhere, and it did. The fix had two sides: treat fetched content as data, and put a hook in front of the write tool that refuses actions triggered by untrusted input. With the hook in place, the same injected line produced a denied write and an audit entry.

### Recap of Part 4

- **Set the standard before you build.** An eval turns "done" into a score. Match the grader to the output and calibrate a judge against human labels before trusting it.
- **Match the test to the failure and trace every run.** Most silent failures hide at integration seams, and traces turn a day of searching into a short fix.
- **Classify every failure, then handle each one by name.** Retriable errors get capped backoff, tool errors go back to the model flagged, and every unrecoverable failure has a named fallback.
- **Measure per call and fan out only when work truly splits.** Instrument tokens, latency, and errors, tune named levers, and reserve orchestrator-worker designs for tasks that parallelize.
- **Treat fetched content as data and enforce the boundary outside the prompt.** Use least privilege, keep secrets out of config, and put hooks and sandboxing in front of every consequential action.

## Part 5. Accelerators, contribution, and deployment

The point where code starts working is where the last part of the job begins. A build that works is not yet a build that survives reuse, review, or deployment. The same template must be configured by a team that never spoke to you. A contribution must be verifiable by a maintainer who reconstructs nothing. A model must be pinned so an upstream change is a decision rather than a surprise. A platform must pass a customer's residency review. And connected components must hold their trust boundaries under audit. More of these decisions than you might expect are driven by the customer's existing cloud, compliance posture, and review process.

### Packaging a working build for reuse

The most expensive thing on a delivery team is engineering time spent rebuilding the same thing for the next customer. An **accelerator** is a solution packaged so the next engagement starts from a working foundation: separate the customer-specific parts, expose them as parameters with documented defaults, and the asset gets configured rather than rewritten. Doing this while the build is fresh is far cheaper than reconstructing intent months later, after the person who knew why a value was hardcoded has moved on.

Reusable work usually takes one of three forms. An agent template bundles a system prompt, tool schemas, and loop structure, and packaging it means pulling domain-specific values into configuration. An MCP server package bundles tools, and packaging it means documenting each input and letting the installing team set the scope. An eval suite bundles a graded dataset and rubric, and packaging it means shipping them together so a new team can confirm the asset still works in their context, which also makes it the gate when a new model version is promoted. Shipping an agent as loose scripts is the most common wrong form, because every customer value hides in a different file and the next team copies and diverges instead of configuring.

Document what the code cannot say: the environment the asset assumes, the inputs it expects, the failures it already handles, and the eval that defines working. And bundle the audit story, meaning what data the asset touches, what identity it acts under, and what it logs, because an accelerator without those passes a demo and stalls at the first security review.

A team that shipped an agent template under deadline hardcoded the repository path, model name, review thresholds, and a few domain-specific prompt fragments, then filed it as reusable. Months later, a second team found nothing to configure, no note of which values were customer-specific, and no eval to tell them whether their edits worked. They rewrote it from scratch. A template that runs has not been packaged. The warning signs are no parameters, no documented assumptions, and no bundled eval.

### Contributing back

Packaging for your own team already does most of the work of sharing: parameters, documented assumptions, and a bundled eval are what a maintainer needs too. Contributing back moves an asset from private reuse into shared infrastructure through a channel built for it. Anthropic's Cookbook, for example, is a repository of focused reference implementations, while open-source tools and MCP servers each have their own repositories and conventions. Sending a whole multi-component application where one focused pattern belongs is one of the most common reasons contributions never get reviewed.

Maintainers accept what they can verify, and four things make that possible: code that does one thing, an example that shows it running, a test that proves the behavior, and a short statement of assumptions. Rights come before any technical review. Code carried in from a customer engagement may have restrictions on where it can go, so confirm you may contribute it and attribute what you built on, or legal will have to unwind it later. A conversation-handling pattern from a customer-service engagement, stripped of customer specifics and reduced to one clear example with a test, is the kind of contribution that gets accepted.

One developer's pull request sat unreviewed for three weeks. The code worked and was used daily. The maintainer explained that they could not tell: there was no test to run, no example to watch, and nothing saying what the code assumed. Reviewers handle contributions they can verify quickly and leave the rest for whenever they have time to reverse-engineer them.

### From requirements to the systems lifecycle

The platform decisions that follow assume the requirements already exist, so it helps to say where they come from. A functional requirement states what the system must do, specifically enough to check. "Help support agents answer faster" is a business problem. "Classify each ticket into one of four queues, draft a reply citing the relevant policy, and never send without human approval" is a set of functional requirements, each of which can become an eval case and a review criterion. Infrastructure requirements are the non-functional constraints the deployment must meet, and most are not stated in the business problem. You derive them by asking about latency where the user is, scale and peaks, data residency and the regulation behind it, and identity and auditability. Those four most often decide the platform, and they are easiest to capture before any platform is chosen. A short requirements record lets you defend the platform choice as following from requirements rather than familiarity.

For a regulated EU bank that wants call transcripts summarized and reviewed before they are stored, "a human approves each summary before it is stored" is a functional requirement, while "transcripts are processed in the EU" is an infrastructure requirement. "Fast and accurate" is neither, because nothing can be checked against it.

Requirements are the first phase of a **systems lifecycle** that every engineered system shares. Requirements capture the needs. Design chooses the platform, model, and trust boundaries. Build writes the agent, tools, and prompts. Test runs evals and the four test levels. Deploy pins versions and gates promotion on the eval. Operate instruments cost, latency, and errors and enforces guardrails. Iterate feeds what production teaches back into requirements. Gates between phases are where a regulated engagement keeps control: no build until the platform satisfies residency, no full rollout until the new version clears the eval against the pinned baseline.

### Choosing the deployment platform and versioning what ships

The same model can run in several environments, and the customer's existing cloud usually decides which. For Claude, the first-party API is Anthropic's own and usually gets new features first. Claude Platform on AWS is reached through the customer's AWS account with Anthropic's model IDs and lifecycle, with inference run by Anthropic outside the AWS boundary. Amazon Bedrock offers a Messages-API integration with broad feature parity and a legacy integration with its own versioned identifiers, keeping data inside the customer's AWS boundary under AWS identity. Google Vertex AI does the same inside Google Cloud. Third-party platforms such as Microsoft Foundry embed the model in a product the customer already uses, and on Foundry where inference actually runs depends on the specific model's hosting form, which matters for residency. Matching the platform to the customer's existing compliance agreements avoids starting a residency review from scratch.

Versioning keeps an upstream change from silently changing production. Aliases are convenient, but they move to new snapshots over time and can resolve differently on different platforms. A pinned full model ID is a fixed snapshot. Current Claude models pin with the model ID alone, and older ones needed a date suffix. Pin the model, version the prompt and the asset with the code, keep the previous version available for rollback, and promote a new version by sending it a share of traffic, comparing it against the pinned baseline on your eval, and only then promoting or rolling back. That is where the eval stops being a one-time test and becomes the deployment gate.

The log of one incident tells the story in six lines. The app deployed against the "opus" alias. The alias advanced to a new version with no application change. The parser threw a KeyError because the output shape had changed. A rollback was attempted, but no pinned prior version had been kept. The parser was hot-fixed, and the root cause was recorded as an unpinned deployment, which the hotfix left in place.

### Comparing platforms on latency, compliance, and cost

Choosing the customer's cloud is a start, not yet an argument a procurement and security team will sign. Three measurements make it one. Latency should be measured from the customer's actual region with their actual payload, because a number taken from your laptop hides the round-trip penalty, and an in-region cloud route often wins on round trip while the first-party API wins on earliest feature access. Within Bedrock, choosing between global and regional endpoints is also the main residency control and can affect cost. Compliance often ends the debate: a customer certified on one cloud rarely re-certifies on another, residency and certifications differ by platform, and regulated customers treat them as pass or fail. EU-only processing, for example, currently needs Bedrock or Vertex rather than the direct API. Cost is broadly similar per token across platforms, so total cost moves with data egress, platform fees, and integration effort, and the cheapest token is not always the cheapest system.

A team building for a regulated customer picked the platform they had shipped on before. The integration came together quickly and passed functional tests. At the security review, the reviewer asked where data was processed, and the answer failed the customer's residency rule, which a less familiar platform with a regional option would have met. The build had to be redone. The comparison trace was blunt: platform chosen on familiarity, latency measured from a developer laptop at 180 milliseconds, customer in eu-west, EU-only residency required, rejected because data was processed outside the EU. Easy to build is not the same as allowed to ship, and checking during scoping costs one conversation while checking at review costs a rebuild.

### Coordinating deployments across trust boundaries

Finally, the pieces come together in one application. An API request might start a Claude Code task that reaches a customer system through an MCP server, with each component adding a capability the others lack. Every connection between them is a place where identity, secrets, and untrusted input can cross, so map which component does what before connecting anything.

A **trust boundary** is any point where data or instructions move from one deployment environment to another, and it is exactly where the injection and access controls from Part 4 apply. Content a coding task fetched is untrusted when it reaches the next component, which must treat it as data, not instructions. Least privilege applies to the whole application: it is only as contained as its most privileged seam, so one over-scoped component becomes the weak point even if every other one is tight. At the entry point, validate input and choose the identity the call runs under. At the coding task, treat fetched content as data at the next seam. At the MCP server, scope access to the minimum and log it. If a seam cannot be secured, do not ship around it. Escalate to a human owner.

Two developers wiring three components that each passed their own tests found the gap in one exchange. The coding task's fetched content went straight into the next call's prompt. If it carried instructions, the next component would follow them, because nobody had marked that seam as a boundary. Each component was trusted. The seam between them was not.

The end-to-end fix for a code-review accelerator deployed on Bedrock for a regulated AWS customer shows every lesson of this part in a few lines. Parameterize the hardcoded repository path. Pin the full Bedrock model ID and keep the previous version for rollback. Wrap fetched content as data before it reaches the next call. Gate promotion on the bundled eval against a baseline score.

```python
def build_agent(repo_path):                         # set per engagement
    return Agent(model="us.anthropic.claude-opus-4-8",  # pinned, not an alias
                 system_prompt=SYSTEM_PROMPT,
                 repo_path=repo_path,
                 tools=[read_file, run_linter])

deploy(platform="amazon_bedrock", identity=aws_role_arn,
       retain_previous_pinned_version=True)          # rollback target

fetched = code_task.run(fetch_url=customer_page)
next_call(input=treat_as_data(fetched))              # untrusted is data

assert eval_suite.run(model="us.anthropic.claude-opus-4-8") >= baseline_score
```

### Recap of Part 5

- **Package while the build is fresh.** Expose customer-specific values as documented parameters and bundle the eval and the audit story, because what is customer-specific is hardest to reconstruct after people move on.
- **A maintainer accepts what they can verify.** Match the contribution to its channel, send focused code with an example, a test, and stated assumptions, and confirm the rights first.
- **Pin what ships.** Choose the platform by the customer's cloud and compliance posture, pin the full model ID, keep the previous version, and promote through the eval.
- **Measure the dimension that decides placement.** Latency from the customer's region, compliance against their certifications, and total cost per call. For regulated customers, compliance is usually pass or fail.
- **Mark every seam as a boundary.** Scope each component to least privilege, treat fetched content as data, and send unsecurable seams to a human owner instead of shipping them.

## Glossary

The terms used in this post. The last column shows the part where each one matters most.

| Term | Meaning | Part |
| --- | --- | --- |
| Accelerator | A working build packaged so the next engagement configures it instead of rebuilding it: parameters, documented assumptions, a bundled eval | 5 |
| Adaptive thinking | A reasoning mode where the model decides when and how much to think, tuned by an effort setting rather than a token budget | 1, 2 |
| Agent | The model choosing its own sequence of tool calls toward a goal. The control flow lives inside the model | 2 |
| Agent SDK | A library that runs the same agent loop as Claude Code inside your own process, while your code executes the tools | 2, 3 |
| Agentic search | Letting the model search and read across several rounds at query time instead of matching a pre-built index | 3, 4 |
| CLAUDE.md | A project file loaded into every coding-agent session, holding universal constraints and conventions. It dilutes as it grows | 3 |
| Compaction | Summarizing accumulated conversation so a session can continue near the context ceiling | 2 |
| Context engineering | Deciding in advance what enters the context window, what is summarized, and what never enters | 2 |
| Context window | The total tokens a model can take in for one request, including prompts, history, tools, results, and the answer | 1, 2 |
| Contribution readiness | What a maintainer needs to accept a contribution: focused code, a runnable example, a test, stated assumptions, and confirmed rights | 5 |
| Design document | A one-page record of success criteria, failure handling, cost and latency budget, and trust boundary, written before building | 4 |
| Eval | A set of input cases, expected behaviors, and grades that turns "done" into a trackable score | 1, 4 |
| Exponential backoff | Retrying with growing waits, jitter, and a cap, honoring the server's wait header when present | 4 |
| Few-shot | Including several input-output examples in a prompt to show the exact shape of the answer | 1, 2 |
| Files API | Uploading a file once and referencing it by ID in later requests | 2 |
| HITL | Human in the loop: a checkpoint that pauses an automated process for review before a consequential action | 2 |
| Hook | A script bound to a lifecycle event, such as before a tool call, that runs every time and can block the action | 3, 4 |
| Integration test | A test that drives the handoff between two components with real data, where most silent failures hide | 4 |
| Least privilege | Giving each identity or component only the access its task needs, so a steered agent can do little harm | 4, 5 |
| LLM-as-judge | Grading open-ended output with a second model and a rubric, trustworthy only after calibration against human labels | 4 |
| MCP | Model Context Protocol: an open standard for exposing tools, resources, and prompts from a server to any MCP client | 2, 3 |
| Message Batches API | Submitting many requests at once for asynchronous processing at lower cost, with results matched by a custom ID | 1, 2 |
| Model alias vs pinned ID | An alias moves to new snapshots over time. A pinned full model ID stays fixed until you change it | 5 |
| Non-determinism | Identical inputs can produce different outputs, so tests assert properties rather than exact text | 1 |
| Orchestrator-worker | A lead agent that splits work across parallel subagents and combines their results, at a large token multiplier | 4 |
| Output constraint | The part of a prompt that fixes the form of the response: fields, types, length, and what to do when data is missing | 2 |
| Permission mode | A coding-agent setting that controls how often the agent asks before acting, from asking before everything to asking for nothing | 3 |
| Plugin | A versioned bundle of skills, hooks, subagents, and MCP servers installed in one step from a marketplace | 3 |
| Prompt caching | Reusing the processing of a stable prompt prefix across requests at a fraction of the cost | 2, 3, 4 |
| Prompt injection | Instructions hidden in content the agent reads that it treats as commands. Defended by treating content as data and limiting actions | 4 |
| Retriable vs terminal error | Whether retrying the same request could succeed. Retriable errors get backoff, terminal ones fail fast | 4 |
| Rules file | A scoped instruction file that loads only when the agent works on matching paths | 3 |
| Sampling | Choosing each next token from a probability distribution, which is why the same prompt can return different text | 1 |
| SDK | A language library that wraps the REST API, handling authentication, retries, and parsing | 1 |
| Secret store | A managed service that holds credentials, returns them at runtime, logs access, and makes rotation a single change | 3 |
| Skill | A SKILL.md file of reusable instructions that loads on demand when a request matches its description | 2, 3 |
| Stdio | A local MCP transport where the client launches the server as a subprocess | 3 |
| Streaming | Receiving a response as a series of events while it is generated, then assembling it yourself | 1, 2 |
| Structured outputs | API-level schema enforcement for responses or tool arguments, so non-conforming output cannot be generated | 2 |
| Subagent | A separate agent with its own context that handles a delegated task and returns only a result | 2, 3 |
| System prompt | The persistent behavioral contract for a session: role, scope, format, and rules that must not change | 2 |
| Systems lifecycle | Requirements, design, build, test, deploy, operate, and iterate, with gates between phases | 5 |
| Token | The unit a model reads, writes, and bills by. Its size depends on the model's tokenizer | 1 |
| Tool use | The loop in which the model asks for a tool, your code runs it, and the result goes back to the model | 2 |
| tool_use block | The content block naming a tool call, its ID, and its inputs, which must be answered by a matching result in the next turn | 2 |
| Trust boundary | Any seam where data or instructions cross from one environment to another, where incoming content is treated as data | 5 |
| Workflow | Steps orchestrated in your own code, some of which call the model | 2 |
| XML tags | Descriptively named tags that separate instructions from data and examples inside a prompt | 2 |
| Zero-shot | A prompt with instructions and no examples | 1, 2 |

## References

**Anthropic partner training** (sign-in required)

- Anthropic, [Claude Certified Developer – Foundations](https://anthropic-partners.skilljar.com/path/claude-certified-developer-foundations): MSO Foundations, Production-Grade Prompting, Agents & Tool Use, Claude Code, MCP & Integration, Production Engineering, Evals & Security, and Accelerators & IP Contribution. The source of the five-part structure and most of the examples here.

**Documentation**

- [Claude platform documentation](https://platform.claude.com/docs): models and tiers, tool use, structured outputs, streaming, prompt caching, token counting, vision, Files API, Message Batches API, errors and rate limits, model IDs and deprecations, and cloud platform guides. Other vendors publish equivalent pages.
- [Claude Code documentation](https://code.claude.com/docs): permission modes and settings, CLAUDE.md, rules, hooks, subagents, skills, plugins and marketplaces, MCP configuration, and sandboxing.
- [Model Context Protocol](https://modelcontextprotocol.io/): the open specification for tools, resources, prompts, and transports.

**Engineering writing**

- Anthropic, [Building effective agents](https://www.anthropic.com/engineering/building-effective-agents). Workflow patterns and when an agent is worth it.
- Anthropic, [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system). The orchestrator-worker pattern and its token cost.
- [Claude Cookbooks](https://github.com/anthropics/claude-cookbooks). Focused reference implementations, including building evals, and a channel for contributions.
- [Anthropic Trust Center](https://trust.anthropic.com/). Certifications, data retention, and regulated-industry posture.

**Related posts on this blog**

- [From Request to Running System](/blogs/blog/from_request_to_running_system/). The architect's view of the same territory: decomposition, patterns, production, safety, stakeholders, and teams.
- [When Code Is Cheap](/blogs/blog/when_code_is_cheap/). Eleven questions to ask before and after putting AI into a project.
- [Migration is a harness](/blogs/blog/migration_is_a_harness/). Planner, orchestrator, generator, and evaluator applied to migrating a legacy system.
