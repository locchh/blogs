---
title: "Words We Code By"
description: "Four common engineering words — testable, lean, DRY, symbolic — and the bigger ideas they smuggle past the surface."
pubDate: "2026-05-19"
author: "locchh"
tags: ["reflection", "vocabulary", "engineering", "ai", "wordplay"]
---

Software has a habit of compressing big ideas into small words. We say them so often that the meaning calcifies — we hear the syllables and stop checking what is inside. Lately I've been collecting a few of these words and pulling them apart. The interesting thing is that almost every one of them carries a *second* meaning that the surface hides.

Four that I keep coming back to: **testable**, **lean**, **DRY**, and **symbolic**.

---

## Testable — or test-stable?

The standard reading is *test-able*: the suffix `-able` meaning "capable of being." Code is testable if you can isolate it, inject its dependencies, and verify its behavior without dragging the whole world into the test runner.

But stare at the word a moment longer and a second reading appears: **test → stable**. Testable code is code that has been driven *through* tests to a stable state. The suffix hides a journey.

I prefer the second reading. Nothing is testable in the abstract. A function only becomes testable when someone has actually written the tests, watched them fail, and stabilized the surface until the failures went away. The word names a property; the property is earned.

> Testable code is not a shape your code already has. It is a shape your code has *survived into*.

---

## Lean — what's hidden in a four-letter word

Lean code is what's left after you've refused to add anything you don't need. No speculative abstractions, no "just in case" helpers, no half-finished frameworks. YAGNI in two letters.

The word arrived in software via *Lean Manufacturing* (Toyota) and *The Lean Startup* (Eric Ries), but the core idea is older than both: **eliminate waste**. Everything in the system either delivers value or it does not. Anything that doesn't, costs — in build time, in cognitive load, in the surface area future-you has to keep alive.

The trap is to confuse lean with *small*. Small code can still be wasteful: a tiny over-engineered helper that nobody calls is fat. And large code can still be lean — if every line earns its keep.

The cleanest way I've heard it phrased: *lean is what you have left when you stop carrying what you don't use.*

---

## DRY — knowledge, not lines

DRY is the most misquoted principle in our discipline. Most people think it means "don't write the same code twice." The original definition from *The Pragmatic Programmer* (Hunt & Thomas, 1999) is stricter and more interesting:

> Every piece of **knowledge** must have a single, unambiguous, authoritative representation within a system.

The key word is **knowledge**. Two functions that *look* identical but represent different concepts shouldn't be merged — they will evolve in different directions, for different reasons, and the abstraction that joined them becomes a hostage to whichever caller changes first.

This is why I like its counterweights:

- **WET** — "Write Everything Twice" (jokey opposite, real wisdom: wait for the pattern before extracting).
- **AHA** — "Avoid Hasty Abstractions" (Kent C. Dodds): premature DRY is often worse than duplication.
- **Rule of Three** — duplicate twice, refactor on the third.

The wordplay is fitting too: **DRY code is dehydrated** — all the redundant water squeezed out. The metaphor is taut.

---

## Symbolic — and what sits next to it

The word "symbolic" alone is fine. The interesting part is what it sits *next to*: **sub-symbolic**.

**Symbolic AI** represents knowledge as discrete, human-readable symbols and rules. Logic, predicates, ontologies. Reasoning is symbol manipulation. The strength is interpretability and compositional reasoning; the weakness is brittleness when the world is noisy.

**Sub-symbolic AI** stores knowledge as numbers distributed across millions of parameters. No neuron *means* anything by itself — meaning is the pattern. Neural networks, embeddings, LLMs. The strength is handling messy, perceptual data; the weakness is that you cannot easily look inside and ask *why*.

| | Symbolic | Sub-symbolic |
|---|---|---|
| Representation | Discrete symbols, rules | Distributed vectors, weights |
| Reasoning | Logic, search, planning | Pattern matching over continuous spaces |
| Strength | Interpretable, compositional | Robust to noise, scales with data |
| Weakness | Brittle, knowledge bottleneck | Opaque, hard to verify |
| Examples | Prolog, expert systems, CYC | Neural nets, embeddings, LLMs |

LLMs are sub-symbolic at their core. But the moment one of them writes code, calls a calculator, or hands you a structured JSON response, it is borrowing symbolic machinery from the outside. That is the bridge — and it is the most interesting place in AI right now. The frontier (*neuro-symbolic AI*: AlphaGeometry, tool-using agents, code-execution loops) is exactly the question of how to splice a sub-symbolic core to a symbolic shell so each compensates for the other's weakness.

The word "symbolic" looks like a single concept until you put it next to its shadow.

---

## Words as compressed thinking

These four words are tiny. Two syllables, three syllables, an acronym. But each is a compressed argument:

- *Testable* hides the journey from rough code to stable code.
- *Lean* hides the discipline of refusing the unnecessary.
- *DRY* hides the distinction between knowledge and lines.
- *Symbolic* hides the entire other half of AI history.

The compression is what lets us communicate quickly, but it is also what lets us stop thinking. Every once in a while it's worth picking up one of these worn coins and turning it over — there is usually more on the other side than the design we've memorized.
