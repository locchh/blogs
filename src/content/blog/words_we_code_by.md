---
title: "Words We Code By"
description: "Five common engineering words — testable, lean, DRY, symbolic, abstraction — and the bigger ideas they smuggle past the surface."
pubDate: "2026-05-19"
author: "locchh"
tags: ["reflection", "vocabulary", "engineering", "ai", "wordplay"]
---

**Software has a habit of compressing big ideas into small words.** We say them so often that the meaning calcifies — we hear the syllables and stop checking what is inside. Lately I've been collecting a few of these words and pulling them apart. The interesting thing is that almost every one of them carries a *second* meaning that the surface hides.

Five that I keep coming back to: **testable**, **lean**, **DRY**, **symbolic**, and **abstraction**.

---

## Testable — or test-stable?

The standard reading is *test-able*: the suffix `-able` meaning "capable of being." Code is testable if you can isolate it, inject its dependencies, and verify its behavior without dragging the whole world into the test runner.

But stare at the word a moment longer and a second reading appears: **test → stable**. Testable code is code that has been driven *through* tests to a stable state. The suffix hides a journey.

I prefer the second reading. Nothing is testable in the abstract. A function only becomes testable when someone has actually written the tests, watched them fail, and stabilized the surface until the failures went away. The word names a property; the property is earned.

> Testable code is not a shape your code already has. It is a shape your code has *survived into*.

The canonical references are Michael Feathers' *Working Effectively with Legacy Code* (where the word "seam" enters the vocabulary as the precise place you can substitute behavior for a test) and Martin Fowler's bliki entry on [TestDrivenDevelopment](https://martinfowler.com/bliki/TestDrivenDevelopment.html), which frames the *red → green → refactor* loop that earns testability one cycle at a time.

---

## Lean — what's hidden in a four-letter word

Lean code is what's left after you've refused to add anything you don't need. No speculative abstractions, no "just in case" helpers, no half-finished frameworks. [YAGNI](https://martinfowler.com/bliki/Yagni.html) in two letters.

The word arrived in software via *Lean Manufacturing* (Toyota) and *[The Lean Startup](https://theleanstartup.com/)* (Eric Ries), but the core idea is older than both: **eliminate waste**. Everything in the system either delivers value or it does not. Anything that doesn't, costs — in build time, in cognitive load, in the surface area future-you has to keep alive.

The trap is to confuse lean with *small*. Small code can still be wasteful: a tiny over-engineered helper that nobody calls is fat. And large code can still be lean — if every line earns its keep.

The cleanest way I've heard it phrased: *lean is what you have left when you stop carrying what you don't use.*

---

## DRY — knowledge, not lines

DRY is the most misquoted principle in our discipline. Most people think it means "don't write the same code twice." The original definition from *[The Pragmatic Programmer](https://en.wikipedia.org/wiki/The_Pragmatic_Programmer)* (Hunt & Thomas, 1999) is stricter and more interesting:

> Every piece of **knowledge** must have a single, unambiguous, authoritative representation within a system.

The key word is **knowledge**. Two functions that *look* identical but represent different concepts shouldn't be merged — they will evolve in different directions, for different reasons, and the abstraction that joined them becomes a hostage to whichever caller changes first.

This is why I like its counterweights:

- **WET** — "Write Everything Twice" (jokey opposite, real wisdom: wait for the pattern before extracting).
- **[AHA](https://kentcdodds.com/blog/aha-programming)** — "Avoid Hasty Abstractions" (Kent C. Dodds): premature DRY is often worse than duplication.
- **Rule of Three** — duplicate twice, refactor on the third (Martin Fowler, *Refactoring*).

The wordplay is fitting too: **DRY code is dehydrated** — all the redundant water squeezed out. The metaphor is taut.

---

## Symbolic — and what sits next to it

The word "symbolic" alone is fine. The interesting part is what it sits *next to*: **sub-symbolic**. And the split is older than AI by a long way — it is one of the oldest fault lines in how we have tried to explain how thinking works at all.

**Symbolic** is the side that says meaning lives in discrete signs that combine by rules. Aristotle's syllogisms (~350 BCE) were the first formal grammar of inference. Leibniz, in the 1670s, dreamed of a *[characteristica universalis](https://en.wikipedia.org/wiki/Characteristica_universalis)* — a symbol system so precise that arguments could be settled by calculation. *Calculemus!* — "let us calculate." George Boole made it algebra in *[An Investigation of the Laws of Thought](https://en.wikipedia.org/wiki/The_Laws_of_Thought)* (1854). Frege's *[Begriffsschrift](https://en.wikipedia.org/wiki/Begriffsschrift)* (1879) gave us modern predicate logic. By the time computers arrived, the symbolic tradition already had two millennia of practice behind it.

**Sub-symbolic** is the older, quieter side that says meaning is a *pattern* — emerging from many small things, none of which mean anything on their own. Hume's [*Treatise of Human Nature*](https://en.wikipedia.org/wiki/A_Treatise_of_Human_Nature) (1739) located all knowledge in associations between sense impressions. William James, in his [*Principles of Psychology*](https://en.wikipedia.org/wiki/The_Principles_of_Psychology) (1890), described mental life as a "stream" of overlapping states rather than discrete tokens. Donald Hebb compressed the idea into a single line in *[The Organization of Behavior](https://en.wikipedia.org/wiki/Organization_of_Behavior)* (1949): *cells that fire together, wire together*. That is a claim about brains, not machines — but it is the seed every neural network later grew from.

The split shows up across disciplines under different names:

- Philosophy: **rationalism vs. empiricism** — Descartes and Leibniz against Locke and Hume.
- Linguistics: **generative grammar vs. distributional semantics** — Chomsky's rules against Firth's *"you shall know a word by the company it keeps."*
- Psychology: **cognitivism vs. associationism**.
- Mathematics: **logic vs. statistics**.

Same argument, restated each century in the vocabulary of its day. Two bets about what knowledge is made of: *crisp signs combined by rules*, or *blurry patterns shaped by exposure*.

| | Symbolic | Sub-symbolic |
|---|---|---|
| Carrier of meaning | Discrete signs | Distributed patterns |
| How it's acquired | Stated, derived | Absorbed from experience |
| Mode of operation | Rule-following | Association |
| Strength | Precise, compositional | Robust, generalizing |
| Weakness | Brittle, hand-authored | Opaque, example-hungry |

Whichever side of this you're standing on, the other side is already there — as a competitor, a complement, or a debt you haven't paid yet. The word "symbolic" looks like a single concept until you put it next to its shadow. The shadow is older than the word.

---

## Abstraction — the art of drawing away

The word is older than software. *Ab-stract* comes from Latin *abstrahere* — "to draw away from." When you abstract, you literally pull the essence out and leave the details behind. The word names the act, not the result.

[Bjarne Stroustrup](https://www.stroustrup.com/), the father of C++, has spent his career thinking about this single problem: how do you build abstractions that *cost nothing*? His **zero-overhead principle** is one of the cleanest statements of design intent in our field:

> What you don't use, you don't pay for. And what you do use, you couldn't hand-code any better.

That second clause is the hard part. An abstraction that's free at runtime but ugly to call is a half-success. An abstraction that's beautiful to call but slow is a different half-success. The masterwork is when both are true — `std::vector`, RAII, templates, smart pointers all clear that bar. They give you the higher-level vocabulary without forcing you to pay for the lift.

**Why we abstract.** Humans hold maybe seven things in working memory. A system worth writing has thousands of moving parts. Abstraction is how we close that gap: we replace a cluster of details with a single name, and from then on we reason at the level of the name. The cost-of-complexity stops growing linearly with the size of the system.

**How to apply it well:**

- **Name by intent, not implementation.** `sendInvoice()` survives a refactor; `httpPostToBillingApi()` does not. The name is the contract.
- **Pick the right altitude.** Too low and you've renamed without abstracting (`addOne(x)` is not abstraction). Too high and you've smothered control (`doTheThing()` hides decisions the caller still needs to make).
- **Match the abstraction to the audience.** A library's public surface is a different abstraction from its internal helpers, even when the code is identical. Who is reading this name?
- **Resist abstracting too early.** This is where AHA from the DRY section returns — the wrong abstraction is more expensive than the duplication it replaces.
- **Beware leaky abstractions.** Joel Spolsky's [law](https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/): *all non-trivial abstractions, to some degree, are leaky.* You can't fully hide the network, the filesystem, or the GC. The honest move is to acknowledge the leak in the interface, not pretend it isn't there.

Almost every other word on this list — *testable, lean, DRY* — is a constraint on *how* you build abstractions. Abstraction itself is the thing being built.

---

## Words as compressed thinking

These five words are short enough to slip past us in conversation. But each is a compressed argument:

- *Testable* hides the journey from rough code to stable code.
- *Lean* hides the discipline of refusing the unnecessary.
- *DRY* hides the distinction between knowledge and lines.
- *Symbolic* hides a millennia-old quarrel about what knowledge is made of.
- *Abstraction* hides the act of drawing detail away to leave intent.

The compression is what lets us communicate quickly, but it is also what lets us stop thinking. Every once in a while it's worth picking up one of these worn coins and turning it over — there is usually more on the other side than the design we've memorized.
