---
title: "Loop Engineering, Another Buzzword?"
description: "Some thoughts about loop engineering"
pubDate: "2026-07-03"
author: "locchh"
tags: ["loop-engineering", "harness", "ai-agent"]
draft: true
---

## The Evolution

### Loop Engineering

- [What Is Loop Engineering? A Complete Guide from Prompt to Harness Engineering](https://tosea.ai/blog/loop-engineering-ai-agents-complete-guide-2026) - The definition I keep coming back to: designing the system that prompts, checks, remembers, and re-runs an agent — with each layer (prompt → context → harness → loop) wrapping the previous one, not replacing it

- [Loop Engineering](https://addyosmani.com/blog/loop-engineering/) - Addy Osmani's essay: "loop engineering is replacing yourself as the person who prompts the agent" — skeptical about token costs, practical about worktrees, and closing with the right warning: build the loop, stay the engineer

- [Loop Engineering: The Anthropic Playbook for Designing Systems That Prompt Your Agents](https://drive.google.com/file/d/1qzKI4DKnyHRpXK1J3ATPqwaqLc0iNu-M/view?trk=public_post_comment-text) - A field study of designing loops that run themselves (PDF on Google Drive)

- [3 Key Loops for Building 0-to-1 Products with AI Agents](https://www.linkedin.com/posts/andrewyng_loop-engineering-is-a-hot-buzzphrase-after-share-7477753882505338880-dBJ-/?utm_source=share&utm_medium=member_android&rcm=ACoAAD9laxkBsmkcAipJMc2HAVrKjjkg5sWujiY) - Andrew Ng's LinkedIn post — "loop engineering is a hot buzzphrase" — naming the three key loops for building 0-to-1 products with AI agents

- [The Art of Loop Engineering](https://www.langchain.com/blog/the-art-of-loop-engineering) - LangChain's four-loop stack, from the core agent loop up to the hill-climbing loop that improves the harness from production traces — their take on swyx's "loopcraft"

- [Claude Code Loops](https://claude.ai/public/artifacts/11bdc800-3d82-4cd1-8a05-a82ae516f8cb) - An applied coursebook on Claude Code loops, published as a public Claude artifact

### Harness Engineering

- [Learn Harness Engineering](https://walkinglabs.github.io/learn-harness-engineering/en/) - A multilingual course on the engineering of AI coding agents — lectures, hands-on projects, and copy-ready templates (AGENTS.md, feature_list.json); its core line: a harness doesn't make the model smarter, it builds a closed-loop working system around it

- [Harness Engineering là gì?](https://goonnguyen.substack.com/p/harness-engineering-la-gi) - A Vietnamese explainer by Duy /zuey/ with the best metaphor of the bunch: prompt engineering is writing the email, context engineering is attaching the right file, harness engineering is designing the whole office

- [Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/) - OpenAI's field report on building a product from an empty repo to a million lines of code with agents writing every line — "humans steer, agents execute"; the discipline moves out of the code and into the scaffolding

### Context Engineering

- [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) - Anthropic's guide to treating context as a finite resource — "find the smallest set of high-signal tokens that maximize the likelihood of your desired outcome"

- [Agentic Context Engineering: Evolving Contexts for Self-Improving Language Models](https://arxiv.org/abs/2510.04618) - The ACE paper (ICLR 2026): instead of fine-tuning weights, the context itself becomes an evolving artifact that the model keeps improving

### Prompt Engineering

- [Prompt Engineering Guide](https://www.promptingguide.ai/) - The reference guide where this all started — the latest papers, advanced prompting techniques, model-specific guides, and lectures for getting the most out of LLMs