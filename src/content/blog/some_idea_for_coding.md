---
title: 'Some thoughts about coding'
description: 'Some thoughts about coding in the era of AI'
pubDate: 'Feb 09 2026'
heroImage: ''
---

As a mechanical engineer turned developer, I've been reflecting on how AI is reshaping the way we write software. This post shares my observations on what has changed, what still requires human judgment, and practical tips for working effectively alongside AI tools.

## Some Highlights

*Mastering code implementation does not automatically mean you can design architecture better.*

In recent years, with the rise of AI coding tools (e.g., [Windsurf](https://windsurf.com/), [Cursor](https://cursor.com/), [Claude Code](https://github.com/anthropics/claude-code), [Opencode](https://opencode.ai/), [GitHub Copilot](https://github.com/features/copilot), etc.), coding has evolved.

While writing, reviewing, and debugging have become more efficient with the help of these tools, designing (architecture, system design, etc.) and orchestrating (setting up local environments, CI/CD, deployment, etc.) still require human judgment.

AI can handle massive workloads and process a lot of data instantly. For example, I think AI companies like OpenAI or Anthropic can now base their models on your conversation history to customize a system prompt when you start a new session. Some AI platforms or tools can collect your data and customize the settings for your specific needs, or suggest things to maximize their profit, and they can even use your data to improve their models.

But imagination, learning, and creativity still require humans. I mean, you can teach AI anything, but you need large resources (data, computation, time, etc.) to do that. Learning with fewer resources is still a challenge for AI (due to current model architectures and training methods). I think in the future, they may do more tricks with their products when they release new model versions like [Claude 5](https://claude5.com/), perhaps equipping those models with special, new technology knowledge needed in the workplace but less accessible to the public. (That doesn't seem fair to humans.) But anyway, we learn faster and at less cost.

## Some Levels

*Coding now becomes more about understanding, designing, and solving problems.*

### Effort Levels

There are differences between making AI work on long-term tasks versus regular chatting. For example:

- **ChatGPT or Claude.ai** can help with regular chatting, online searching, and synthesizing information. However, this is still short-term focused.

- **Deep research mode** may provide more advanced abilities like planning, researching, using tools (read/write to offload and reload context to files), and formatting data into documents or reports following templates.

I think there's something that controls AI's effort level, making it plan more, use tools more, generate more tokens, and do more reflection. This might be the system prompt or something else.

### Human-AI Collaboration Levels

First, there are 3 concepts we need to understand:
- **Work**: A chain or group of tasks
- **Task**: A specific job to be done
- **Participation**: Who participates in the task: human, AI, or both

Based on these concepts, there are 3 main levels of human-AI collaboration:

1. **Autonomous**: AI works independently without human intervention.

2. **Semi-Autonomous/Collaborative**: AI still needs humans for feedback, validation, and decision-making, or there is still human knowledge that AI does not possess.

3. **Manual**: Humans have full control over the AI system.

### Software Development Levels

There are several levels in software development. Here's the progression from highest to lowest:

- **Solution Architecture**: solving specific business problems
- **System Design**: detailed design of systems and components
- **Detailed/Low-Level Design**: specific implementation details like class diagrams, method signatures, data structures, and algorithms for individual modules
- **Code Implementation**: the actual writing of code
- **Unit/Module Level**: individual functions, methods, or small code units

- Below is relationship between software development levels and human-AI collaboration levels:

| # | Development Level | Human (Manual) | Human + AI (Semi-Autonomous) | AI (Autonomous) | Platforms & Tools |
|---|-------------------|----------------|------------------------------|-----------------|-------------------|
| 1 | **Solution Architecture** | • Stakeholder interviews<br>• Gather business requirements<br>• Make strategic & budget decisions<br>• Evaluate vendor/build vs buy | • AI suggests tech stacks & trade-offs<br>• AI drafts architecture diagrams<br>• Human reviews & makes final decisions | ❌ Not feasible | Miro, Lucidchart, Confluence, PowerPoint, Google Slides |
| 2 | **System Design** | • Define NFRs (scalability, security)<br>• Design cross-service communication<br>• Plan data flow & integration points | • AI proposes component diagrams & API contracts<br>• AI generates DB schema drafts<br>• Human validates & adjusts | • Generate basic diagrams from descriptions (requires human validation) | Draw.io, PlantUML, Swagger/OpenAPI, dbdiagram.io, Excalidraw |
| 3 | **Detailed/Low-Level Design** | • Define module boundaries<br>• Choose design patterns<br>• Review & approve designs | • AI generates class diagrams & interfaces<br>• AI suggests algorithms & data structures<br>• Human refines & approves | • Generate class structures<br>• Generate interface definitions<br>• Suggest algorithm implementations | PlantUML, Mermaid, UMLet, IDE built-in tools |
| 4 | **Code Implementation** | • Define acceptance criteria<br>• Review PRs & approve merges<br>• Handle complex business logic | • AI generates feature code<br>• AI suggests improvements & refactors<br>• Human reviews, edits & pair-codes | • Full boilerplate generation<br>• CRUD implementation<br>• Write integration tests<br>• Auto bug fixes for known patterns | Windsurf, Cursor, GitHub Copilot, VS Code, JetBrains IDEs, Git |
| 5 | **Unit/Module Level** | • Verify test coverage<br>• Review generated tests<br>• Debug edge cases | • AI generates functions<br>• AI helps debug with context<br>• Human validates correctness | • Auto unit test generation<br>• Code formatting & linting<br>• Style enforcement<br>• Auto-fix simple bugs | Jest, Pytest, ESLint, Prettier, SonarQube, pre-commit hooks |

- Example of a coding flow:

```
                        ┌─────────────────┐
                        │ From Feature/CR │
                        └─────────────────┘
                                ↓
                        ┌─────────────────┐
                        │ Think about     │
                        │ workflow        │
                        └─────────────────┘
                                ↓
                        ┌─────────────────┐
                        │ Define data     │
                        │ models          │
                        └─────────────────┘
                                ↓
                        ┌─────────────────┐
                        │ Design code     │
                        │ components      │
                        └─────────────────┘
                                ↓
                        ┌─────────────────┐
                        │   Implement     │
                        └─────────────────┘
                                ↓
                        ┌─────────────────┐
                        │ Do Smoke Test   │
                        │ & Unit Test     │
                        └─────────────────┘
                                ↓
                        ┌─────────────────┐
                        │   Code Review   │
                        └─────────────────┘
```

## Analogy between 💻 coding engineering and 🔧 mechanical engineering

I am a mechanical engineer by education and have worked in the industry for many years. Based on my experience, coding engineering is very similar to mechanical engineering in many ways.

In the mechanical industry, we have many **ready-to-use components** (bolts, screws, gears, valves, etc.) that are designed, tested, and put into a catalog so engineers can select them directly without designing from scratch. Similarly, in coding, we have **libraries, frameworks, and packages** that we can use directly. Both fields share the same pattern: abstract complexity, document everything, assemble components, test the result.

Here's how the two fields compare:

| **Mechanical Engineering** | **Software Engineering** | **Purpose** |
|---------------------------|-------------------------|-------------|
| **Ready-to-use components** (bolts, gears, valves) | **Libraries & frameworks** (npm, pip packages) | Pre-designed components to avoid reinventing the wheel |
| **Mechanism diagrams** | **Architecture diagrams / Flowcharts** | Show how components interact and work together |
| **Assembly drawings** | **System design / Integration diagrams** | Show how parts/modules connect into complete system |
| **Detailed/Part drawings** | **API specs / Module documentation** | Complete specifications for individual components |
| **Manufacturing drawings** | **Deployment docs / CI/CD pipelines** | Instructions for actually building/producing the product |
| **Machining** | **Coding / Programming** | Creating individual components |
| **Assembly** | **Merging / Integration** | Combining components into final system |
| **Bill of Materials (BOM)** | **Dependencies list** (package.json) | List of all required components |
| **Testing & QC** | **Unit/Integration tests** | Verify components meet specifications |
| **Maintenance manuals** | **Documentation / README** | Usage and troubleshooting instructions |

## Tips

*So stay calm — we need to be aware that, between us, AI, and the code, there are a lot of things for humans to do (e.g., designing, orchestrating, reviewing, etc.).*

### For high-level Tips

- **Keep learning** — you learn faster and more efficiently than AI (*that's why you still have the job*). Use AI fully, even if it's more costly than a human and comes without responsibility or accountability.

- **Do reverse engineering** on existing codebase, explore the codebase, understand the design, the architecture, the patterns, the conventions, etc. Try to:

    - Make a comprehensive documentation

    - Reproduce a codebase — you can do the managing, orchestrating, reviewing, etc., and let AI implement the code.

    - Or use AS-IS knowledge to migrate a codebase into new technology, new architecture, new language, etc.

- **Break down your work** into smaller, manageable, testable, isolated and independent pieces.

    - scope by environment (dev, staging, production)
    
    - scope by code online repository vs local repository
    
    - scope by branches (main/master, develop, and support branches like feature/*, hotfix/*, release/*) [Refer to](https://nvie.com/posts/a-successful-git-branching-model/)
    
    - scope by features, modules, components, etc. [Refer to](https://github.blog/developer-skills/github/write-better-commits-build-better-projects/) or [This](https://github.com/git-guides/git-commit). A commit is the most important unit in coding, with varying sizes from a small bug fix to a large feature implementation — from a single-line change to an entire codebase. One more convenient thing is that, when you **work commit by commit**, you can easily see what file and what line was changed, added, or removed in the UI.

    #### Three Golden Rules for Better Commits:
    
    - Structure Your Narrative: Plan your story first, then reorder commits to match logical flow using `git rebase -i`
    
    - Make Commits Small & Atomic: Each commit should do one thing and work independently if rolled back
    
    - Explain the Context: Explain what you're doing, why it's needed, why this approach was chosen, and how it was implemented

- Always use tools to support your work (AI cannot handle a large process alone — you will have to pay a lot)
    
    - Run linter, formatter, type checker when developing
    
    - Run SonarQube on release branches

### For detailed implementation Tips

- Think first — as mentioned above, before coding, brainstorm with AI to create a narrative commit structure and try to make atomic commits.

- You cannot read all AI-generated code anymore. So instead of going to the detailed implementation level, you must control something higher — like a TODO list or a detailed design of modules, sub-packages, etc. Use tools like [Plannotator](https://plannotator.ai/) or [BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) to help you with this.

- Set up a ready-to-code local development environment. It makes you aware of the code and the system structure.

- Don't forget to practice manual coding skills — it's like making your brain do physical exercise. You still need to know how to code without AI.

- Looping is a powerful technique to improve AI output quality and reduce errors. If you write a function or module, create the test for it first, then let AI implement it. After that, you can run the linter, the formatter, the type checker, and the test to see if it passes.

## Final Thoughts

AI has changed *how* we code, but not *what* makes a good engineer. The fundamentals remain the same: understand the problem, design a clear solution, break it into manageable pieces, and verify the result. AI accelerates the implementation, but the thinking, designing, and decision-making are still ours. Stay curious, keep learning, and use AI as a powerful tool — not a replacement for your judgment.
