---
title: 'Why model hallucinate?'
description: 'Some explaination about why model hallucinate'
pubDate: 'Jan 24 2026'
heroImage: ''
---

## [OpenAI's Explanation](https://openai.com/index/why-language-models-hallucinate/)

### Because the generation process itself

- **Probabilistic nature**: Always generating most likely next word, not most accurate

- **Pattern matching vs reasoning**: Models excel at statistical patterns but lack true understanding of facts

### Because the training and evaluation setup

- **Benchmark gaming**: Models optimized for test performance rather than truthfulness

- **Confidence rewarded**: Systems prefer confident wrong answers over uncertain admissions

### Because the data and knowledge limitations

- **Knowledge cutoff**: Models can't access real-time information

- **No ground truth labels**: Unlike classification tasks with clear right/wrong answers, language models only see text sequences without factual validation

- **No fact-checking mechanism**: No built-in process to verify generated content

## My Thoughts

### Cross-lingual bias

- There is a bias in training data between English and other languages (*This bias is hard to recognize and remove because it requires language experts to validate, which is time-consuming, so I think this process is not widely applied when creating training data for models*), meaning even when we mention the same concept, the model may generate slightly different responses in different languages. Sometimes, just changing some characters, the order of words, or punctuation can lead to different meanings.

- The reason for this can be the dependencies of meaning. [When you explain a word in English, you actually use other English words to explain it](https://www.oxfordlearnersdictionaries.com/definition/english/agnostic_1?q=agnostic). These words were invented in countries like the US, America, etc., and have cultural and historical backgrounds. So when you translate them to other languages, the meaning may be different.

- So these biases existed but rarely people know about them. They lead to inconsistent knowledge representation, which can cause hallucinations.

This thinking is consolidated from [Benchmarking Concept-Spilling Across Languages in LLMs](https://arxiv.org/abs/2601.12549).

### Post-training effects create personality traits:

- At the pretraining stage, we create an ["untamed monster"](https://huyenchip.com/2023/05/02/rlhf.html) by making it learn statistical patterns from internet data (trillions of tokens). Data includes clickbait, misinformation,etc. Models learn to complete text without understanding truth vs falsehood.

- At the supervised fine-tuning (SFT) stage, models are trained on higher-quality data (StackOverflow, Quora, human annotations) to follow instructions and be "socially acceptable". Creates the "naive expert" - sounds authoritative but may lack underlying knowledge.

- At the RLHF stage, models are polished to be "customer-appropriate" using reward models, but this introduces bias where models prioritize agreement to maximize reward. Models learn to be helpful, confident, and definitive rather than uncertain.

These thoughts are consolidated from [AI Sycophancy: How Users Flag and Respond](https://arxiv.org/pdf/2601.10467). (*They published this paper on arXiv on Jan 20, 2026. I had similar thoughts independently and wrote them down, then wondered if anyone else in the world was thinking like me - that's when I found this paper*)

### Hallucination Accumulation in Long-Term Task:

#### Come from the model itself

Sometimes, models are too confident about their answers, especially when performing long-term tasks without human-in-the-loop (HITL) feedback or using tools to verify intermediate results, even when they have the ability to do so. For models with reasoning ability, it's hard to track the reasoning process (*They think too much, sometimes overthinking and too fast*), so it's difficult to know if the model is reasoning correctly or not. Especially in long-term tasks, models can fall into incorrect hypotheses or misconceptions and generate many hallucinations. 

There are some solutions to reduce this, for example [GLM provides thinking abilities to models](https://docs.z.ai/guides/capabilities/thinking-mode) by adjusting the thinking behavior of models via special tokens and training data, including:

- **Interleaved thinking**: Allowing GLM to think between tool calls and after receiving tool results. This enables more complex, step-by-step reasoning: interpreting each tool output before deciding what to do next, chaining multiple tool calls with reasoning steps, and making finer-grained decisions based on intermediate results.

- **Preserved thinking**: The model can retain reasoning content from previous assistant turns in the context. This helps preserve reasoning continuity and conversation integrity, improves model performance, and increases cache hit rates—saving tokens in real tasks.

- **Turn-level thinking**: Is a capability that lets you control reasoning computation on a per-turn basis: within the same session, each request can independently choose to enable or disable thinking.

#### Come from the collaboration between user and model

The hallucination can also come from the collaboration between user and model:

- User provides unsure/misinformation (*This is an agnostic behavior of users - if they know the information is false, they won't provide it, but they don't know that they don't know*) → "Naive well-kind expert" accepts it as truth.

- Model incorporates this false information into its context/reasoning.

- Model builds upon false premises → generates more hallucinations based on bad foundation.

- User sees confident "expert" responses → trusts the model more.

- Cycle repeats → accumulated errors compound over time.

These thoughts are consolidated from [If You Want Coherence, Orchestrate a Team of Rivals: Multi-Agent Models of Organizational Intelligence](https://arxiv.org/pdf/2601.14351). (*Again, i had similar thoughts independently, seem like when i have some thoughts, there are some one else in the world already public it on arXiv 😭*)

## Tips

So the tips to reduce hallucination are:

- Using fact-checking mechanisms

- Challenging the model, adding rival perspectives

- Or simply just asking twice [Prompt Repetition Improves Non-Reasoning LLMs](https://arxiv.org/pdf/2512.14982) 

