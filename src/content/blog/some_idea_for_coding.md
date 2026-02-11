---
title: 'Some thoughts about coding'
description: 'Some thoughts about coding in the era of AI'
pubDate: 'Feb 09 2026'
heroImage: ''
---

I have been looking for the growth of AI in coding and how it affects the way we work. Here are some thoughts.

## Some Highlights

*Mastering code implementation does not automatically mean you can design architecture better.*

In recent years, with the rise of AI coding tools (e.g., [Windsurf](https://windsurf.com/), [Cursor](https://cursor.com/), [Claude Code](https://github.com/anthropics/claude-code), [Opencode](https://opencode.ai/), [GitHub Copilot](https://github.com/features/copilot), etc.), coding has evolved.

While writing, reviewing, and debugging have become more efficient with the help of these tools, designing (architecture, system design, etc.) and orchestrating (setting up local environments, CI/CD, deployment, etc.) still require human judgment.

AI can handle massive workloads and process a lot of data instantly. For example, I think AI companies like OpenAI or Anthropic can now base their models on your conversation history to customize a system prompt when you start a new session. Some AI platforms or tools can collect your data and customize the settings for your specific needs, or suggest things to maximize their profit, and they can even use your data to improve their models.

But imagination, learning, and creativity still require humans. I mean, you can teach AI anything, but you need large resources (data, computation, time, etc.) to do that. Learning with fewer resources is still a challenge for AI (due to current model architectures and training methods). I think in the future, they may do more tricks with their products when they release new model versions like [Claude 5](https://claude5.com/), perhaps equipping those models with special, new technology knowledge needed in the workplace but less accessible to the public. (That doesn't seem fair to humans.) But anyway, we learn faster and at less cost.

## Some Levels

*Coding now becomes more about understanding, designing, and solving problems.*

### Code Levels

Code exists at different levels of abstraction, from individual statements to entire systems. Understanding these levels helps you think about where to focus your attention and how to leverage AI effectively.

#### 1. Expression / Statement
The smallest unit of code that performs a single action or evaluation.
- **Examples**: `x + y`, `return result`, `if (condition) { ... }`
- **AI capability**: Excellent — AI can generate, optimize, and debug expressions with high accuracy
- **Human focus**: Ensure correctness, readability, and intent

#### 2. Function / Method
A reusable block of code that performs a specific task.
- **Examples**: `calculateTotal()`, `fetchUserData()`, `validateInput()`
- **AI capability**: Very strong — AI can suggest implementations, refactor, and write tests
- **Human focus**: Define clear contracts, handle edge cases, ensure single responsibility

#### 3. Class / Struct
A blueprint for creating objects that encapsulate data and behavior.
- **Examples**: `User`, `Order`, `PaymentProcessor`
- **AI capability**: Strong — AI can generate class structures, suggest patterns, but needs guidance on design
- **Human focus**: Design relationships, choose patterns, ensure cohesion and low coupling

#### 4. Module
A collection of related functions, classes, and resources organized together.
- **Examples**: `auth.js`, `database.py`, `utils.ts`
- **AI capability**: Moderate — AI can help structure modules but needs clear requirements
- **Human focus**: Define module boundaries, manage dependencies, ensure reusability

#### 5. Sub-package, Name-space package
Logical groupings of related modules that provide organization and prevent naming conflicts.
- **Examples**: `auth.oauth`, `database.queries`, `api.controllers`
- **AI capability**: Moderate — AI can suggest organization but needs architectural vision
- **Human focus**: Design hierarchy, manage scope, ensure discoverability

#### 6. Package
A complete unit of distribution that can be installed and used as a dependency.
- **Examples**: `express`, `react`, `numpy`
- **AI capability**: Limited — AI can help implement but not design package structure
- **Human focus**: Define public API, manage versioning, handle backward compatibility

#### 7. Application
A complete, deployable software product that solves a specific problem.
- **Examples**: Web app, mobile app, CLI tool, microservice
- **AI capability**: Collaborative — AI can implement features but needs human guidance on architecture
- **Human focus**: Product requirements, user experience, system integration, deployment

#### 8. System
A collection of applications and infrastructure working together to solve complex business problems.
- **Examples**: E-commerce platform, social network, enterprise ERP
- **AI capability**: Advisory — AI can suggest patterns but cannot replace human architectural thinking
- **Human focus**: Business requirements, scalability, reliability, security, cost optimization

### Effort Levels

There are differences between making AI work on long-term tasks versus regular chatting. For example:

- **ChatGPT or Claude.ai** can help with regular chatting, online searching, and synthesizing information. However, this is still short-term focused.

- **Deep research mode** may provide more advanced abilities like planning, researching, using tools (read/write to offload and reload context to files), and formatting data into documents or reports following templates.

I think there's something that controls AI's effort level, making it plan more, use tools more, generate more tokens, and do more reflection. This might be the system prompt or something else.

### Collaboration Levels

First, there are 3 concepts we need to understand:
- **Work**: A chain or group of tasks
- **Task**: A specific job to be done
- **Participation**: Who participates in the task: human, AI, or both

Based on these concepts, there are 3 main levels of human-AI collaboration:

1. **Autonomous**: AI works independently without human intervention.

2. **Semi-Autonomous/Collaborative**: AI still needs humans for feedback, validation, and decision-making, or there is still human knowledge that AI does not possess.

3. **Manual**: Humans have full control over the AI system.

### Development Levels

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

## Tools for the Full Design Spectrum

*In mechanical engineering, you don't machine a part without a drawing, you don't make a drawing without a design review, and you don't start design without requirements. The same discipline should apply to software.*

The analogy above raises a practical question: **do we actually have tools that enforce this discipline across the full software design spectrum?** The answer is yes — and three tools in particular map remarkably well to the mechanical engineering workflow.

### The Three Tools

| Tool | What It Does | Mechanical Engineering Analogy |
|------|-------------|-------------------------------|
| [**BMAD Method**](https://docs.bmad-method.org/) | Full pipeline with 26+ specialized AI agents: Analyst → PM → Architect → Scrum Master → Developer. Covers ideation, PRD, architecture, stories, and implementation. | The **entire engineering department** — from concept design through manufacturing instructions |
| [**Spec Kit**](https://github.github.com/spec-kit/) | Spec-driven development: Constitution → Specify → Plan → Tasks → Implementation. Specifications are executable — they *generate* code, not just guide it. | The **drawing standards & BOM system** — specs are the single source of truth, everything traces back to them |
| [**Plannotator**](https://plannotator.ai/) | Visual annotation & review of AI-generated plans. Inline commenting, team sharing, diff review — all running locally with no external service. | The **drawing review & approval process** — red-lining, annotations, ECN sign-offs |

### Mapping Tools to Development Levels

Here's how these three tools cover each development level — with their mechanical engineering equivalents:

| Development Level | Mechanical Equivalent | BMAD Method | Spec Kit | Plannotator |
|---|---|---|---|---|
| **Solution Architecture** | Mechanism diagram | Analyst + PM agents create project brief & PRD | Constitution (immutable high-level principles) | Review & annotate architecture plans |
| **System Design** | Assembly drawing | Architect agent designs system architecture | Specify (full spec / PRD as source of truth) | Team review of system design |
| **Detailed/Low-Level Design** | Part / Detail drawing | Scrum Master creates hyper-detailed development stories | Plan (technical plan with precise definitions) | Annotate specific design decisions |
| **Code Implementation** | Machining | Developer agent implements each story | Tasks (small, testable, reviewable units) | Code review via `/plannotator-review` |
| **Unit/Module Level** | QC / Inspection | Tests & validation against acceptance criteria | Task verification against spec | Diff review with inline annotations |

### My Opinion: They're Complementary, Not Competing

These three tools are not alternatives — they solve different problems in the same pipeline, just like different roles in a mechanical engineering workshop:

- **BMAD** = the **process & people**. It defines *who* does *what*, in *what order* — like having a design engineer, a manufacturing engineer, and a QC inspector each with defined responsibilities. Its 26 specialized agents act as expert collaborators guiding you through structured phases using progressive disclosure and strategic questioning.

- **Spec Kit** = the **drawing system & standards**. Specs are executable, not just reference documents. This is the software equivalent of a modern CAD model that directly drives the CNC machine — the spec *is* the source of truth, and code *serves* the spec, not the other way around. Its workflow (Constitution → Specify → Plan → Tasks) ensures nothing gets built without a traceable requirement.

- **Plannotator** = the **review & approval workflow**. In mechanical engineering, every drawing goes through a review cycle: annotations, red-lines, sign-offs. Plannotator brings this exact process to AI-generated plans — you can select specific text, mark it for deletion, add comments, or suggest replacements. It fills the critical gap that terminal-based plan approval cannot.

The parallel to mechanical engineering is almost exact:

```
Mechanical Engineering          Software (with these tools)
─────────────────────           ───────────────────────────
Requirements gathering    →     BMAD Analyst + PM agents
↓                               ↓
Concept design            →     BMAD Architect + Spec Kit Constitution
↓                               ↓
Detail drawings           →     Spec Kit Specify + Plan
↓                               ↓
Drawing review & approval →     Plannotator (annotate, review, approve)
↓                               ↓
Manufacturing             →     BMAD Developer agent + Spec Kit Tasks
↓                               ↓
QC & Inspection           →     Tests + Plannotator diff review
```

The key insight: **in both mechanical and software engineering, the cost of fixing a mistake increases exponentially the later you catch it.** A requirement error caught in the drawing review is cheap. The same error caught after manufacturing (or after deployment) is catastrophic. These tools enforce early validation at every level — just like a proper engineering drawing review process.

## Isolated Work Items

Breaking down work into isolated, independent items is one of the most important practices in software development. Each level below represents a boundary where you can scope, manage, and control your work independently.

### Work Item Levels

#### 1. Environment
The runtime context where your code lives. Isolating by environment prevents unintended side effects across stages.
- **Examples**: dev, staging, production
- **Key practice**: Never test directly in production. Use environment-specific configurations and feature flags.
- **Tools**: Docker, Kubernetes, `.env` files, Terraform

#### 2. Repository
The boundary of a codebase. Each repository is an independent unit of code ownership, versioning, and CI/CD.
- **Examples**: monorepo vs multi-repo, local vs remote (GitHub, GitLab, Bitbucket)
- **Key practice**: Keep repositories focused — one repo per service or domain. Sync local and remote frequently.
- **Tools**: Git, GitHub, GitLab, Bitbucket

#### 3. Branch
A parallel line of development within a repository. Branches isolate features, fixes, and releases from each other.
- **Examples**: `main`, `develop`, `feature/*`, `hotfix/*`, `release/*` — [Refer to: A Successful Git Branching Model](https://nvie.com/posts/a-successful-git-branching-model/)
- **Key practice**: Keep branches short-lived. Merge frequently. Use pull requests for review.
- **Tools**: Git, GitHub PRs, GitLab MRs

#### 4. Commit
The most important unit of work in coding. A commit captures a single, atomic change that can be reviewed, reverted, or cherry-picked independently.
- **Examples**: a bug fix, a new function, a config change, a refactor
- **Key practice**: Make commits small and atomic — each commit should do one thing and work independently if rolled back. [Refer to: Write Better Commits, Build Better Projects](https://github.blog/developer-skills/github/write-better-commits-build-better-projects/)
- **Tools**: Git, `git rebase -i`, conventional commits

#### 5. File Change (Diff / Hunk)
Below the commit level — individual file modifications within a commit. This is where you see exactly what lines were added, removed, or modified.
- **Examples**: a modified function, an added import, a changed config value
- **Key practice**: Review diffs carefully. Each hunk should be intentional and related to the commit's purpose. Avoid mixing unrelated changes in the same file change.
- **Tools**: `git diff`, PR review UI, IDE diff viewers

#### 6. Code Unit
The smallest isolatable piece of work — a single function, class, or module that can be implemented and tested independently.
- **Examples**: a utility function, a React component, a database query, a test case
- **Key practice**: Write the test first, then implement. Run linter, formatter, and type checker after each change. This maps directly to the [Code Levels](#code-levels) described above.
- **Tools**: Jest, Pytest, ESLint, Prettier, SonarQube

### How It All Fits Together

```
                ┌──────────────────────────────────────────────┐
                │ Environment (dev / staging / production)     │
                │  ┌────────────────────────────────────────┐  │
                │  │ Repository (local / remote)            │  │
                │  │  ┌──────────────────────────────────┐  │  │
                │  │  │ Branch (feature / hotfix / main) │  │  │
                │  │  │  ┌────────────────────────────┐  │  │  │
                │  │  │  │ Commit (atomic change)     │  │  │  │
                │  │  │  │  ┌──────────────────────┐  │  │  │  │
                │  │  │  │  │ File Change (diff)   │  │  │  │  │
                │  │  │  │  │  ┌────────────────┐  │  │  │  │  │
                │  │  │  │  │  │ Code Unit      │  │  │  │  │  │
                │  │  │  │  │  └────────────────┘  │  │  │  │  │
                │  │  │  │  └──────────────────────┘  │  │  │  │
                │  │  │  └────────────────────────────┘  │  │  │
                │  │  └──────────────────────────────────┘  │  │
                │  └────────────────────────────────────────┘  │
                └──────────────────────────────────────────────┘
```

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
    
    - scope by branches (main/master, develop, and support branches like feature/*, hotfix/*, release/*) [Refer to: A Successful Git Branching Model](https://nvie.com/posts/a-successful-git-branching-model/)
    
    - scope by features, modules, components, etc. [Refer to: Write Better Commits, Build Better Projects](https://github.blog/developer-skills/github/write-better-commits-build-better-projects/) or [Git Commit Guidelines](https://github.com/git-guides/git-commit). A commit is the most important unit in coding, with varying sizes from a small bug fix to a large feature implementation — from a single-line change to an entire codebase. One more convenient thing is that, when you **work commit by commit**, you can easily see what file and what line was changed, added, or removed in the UI.

    #### Three Golden Rules for Better Commits:
    
    - Structure Your Narrative: Plan your story first, then reorder commits to match logical flow using `git rebase -i`
    
    - Make Commits Small & Atomic: Each commit should do one thing and work independently if rolled back
    
    - Explain the Context: Explain what you're doing, why it's needed, why this approach was chosen, and how it was implemented

- Always use tools to support your work (AI cannot handle a large process alone — you will have to pay a lot)
    
    - Run linter, formatter, type checker when developing
    
    - Run SonarQube on release branches

### For detailed implementation Tips

- Think first — as mentioned above, before coding, brainstorm with AI to create a narrative commit structure and try to make atomic commits.

- You cannot read all AI-generated code anymore. So instead of going to the detailed implementation level, you must control something higher — like a TODO list or a detailed design of modules, sub-packages, etc. Use tools like [BMAD Method](https://docs.bmad-method.org/) (structured agent-driven pipeline), [Spec Kit](https://github.github.com/spec-kit/) (spec-driven development), or [Plannotator](https://plannotator.ai/) (visual plan review) to help you with this. See [Tools for the Full Design Spectrum](#tools-for-the-full-design-spectrum) above for how these map to each development level.

- Set up a ready-to-code local development environment. It makes you aware of the code and the system structure.

- Don't forget to practice manual coding skills — it's like making your brain do physical exercise. You still need to know how to code without AI.

- Looping is a powerful technique to improve AI output quality and reduce errors. If you write a function or module, create the test for it first, then let AI implement it. After that, you can run the linter, the formatter, the type checker, and the test to see if it passes.

## Final Thoughts

AI has changed *how* we code, but not *what* makes a good engineer. The fundamentals remain the same: understand the problem, design a clear solution, break it into manageable pieces, and verify the result. AI accelerates the implementation, but the thinking, designing, and decision-making are still ours. Stay curious, keep learning, and use AI as a powerful tool — not a replacement for your judgment.

*So, my aiming is to answer the question what are you designing, not what are you coding anymore.*