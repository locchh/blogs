---
title: "Migration Is Translation"
description: "Migration is translation, and translators already drew the map."
pubDate: "2026-11-04"
author: "locchh"
tags: ["migration", "translation", "2026"]
draft: true
---

When people talk about migration, they talk about migration: lift and shift, the 7 R's, a cutover date. When they do say "translation," they mean a dictionary job. I think migration is translation in the full sense.

Machine translation drew the map in 1968. The [Vauquois triangle](https://en.wikipedia.org/wiki/Comparison_of_different_machine_translation_approaches) has three heights: **direct** (word by word), **transfer** (change the structure), and **interlingua** (pull out the meaning, then write it fresh). Migration has the same three: a transpiler, a syntax-tree rewrite, and "write a spec, then build from the spec." So most "port or rewrite?" fights are one question: **how high should we climb?**

Stay low and you get [JOBOL](https://intellyx.com/2022/07/16/modernizing-your-mainframe-cobol-beware-the-jobol-pitfall/): Java that only a COBOL programmer can maintain. Climb high and the spec is usually plain English, so every rule it forgets is lost for good. [Skopos theory](https://en.wikipedia.org/wiki/Skopos_theory) says the purpose of a translation decides its method. So decide why you migrate before you decide how.

> **Lesson:** the purpose of a migration tells you how high to climb.
