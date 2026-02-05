---
title: 'Some thoughts about coding'
description: 'Some thoughts about coding in the era of AI'
pubDate: 'Feb 05 2026'
heroImage: ''
---

## Some Highlights

*Mastering code implementation does not automatically mean you can design architecture better.*

In recent years, with the rise of AI coding tools (e.g., [Windsurf](https://windsurf.com/), [Cursor](https://cursor.com/), [Claude Code](https://github.com/anthropics/claude-code), [Opencode](https://opencode.ai/), [GitHub Copilot](https://github.com/features/copilot), etc.), coding has evolved.

While writing, reviewing, and debugging have become more efficient with the help of these tools, designing (architecture, system design, etc.) and orchestrating (setting up local environments, CI/CD, deployment, etc.) still require human judgment.

AI can handle massive workloads and process a lot of data instantly. For example, I think AI companies like OpenAI or Anthropic can now base on your conversation history to customize a system prompt for the model when you start a new session. Some AI platforms or tools can collect your data and customize the settings for your specific needs, or suggest you things to maximize their profit, and they can even use your data to improve their model.

But imagination, learning, and creativity still require humans. I mean, you can teach AI anything, but you need large resources (data, computation, time, etc.) to do that. Learning with fewer resources is still a challenge for AI (due to current model architectures and training methods). I think in the future, maybe they will do some tricks with their product more when they release new model versions like [Claude 5](https://claude5.com/), maybe they will equip that model with special, new technology knowledge needed in labor environment but less accessible to the public. (That seems not fair to humans). But anyway, we learn faster and at less cost.

## Some Levels

*Coding now becomes more about understanding, designing, and solving problems.*

### Human-AI Collaboration Levels

First, I classify there are 3 concepts we need to understand:
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

| Development Level | Manual | Semi-Autonomous | Autonomous |
|-------------------|--------|-----------------|------------|
| **Solution Architecture** | • Stakeholder interviews<br>• Business requirements<br>• Strategic decisions | • AI suggests tech stacks<br>• Human reviews & decides<br>• AI creates diagrams | ❌ Not feasible |
| **System Design** | • Draw system diagrams<br>• Define APIs<br>• Design DB schemas<br>• Plan data flow | • AI proposes components<br>• Human adjusts & validates<br>• AI generates diagrams | • Limited: Generate basic system design with human validation required |
| **Detailed/Low-Level Design** | • Create class diagrams<br>• Define interfaces<br>• Write method signatures<br>• Design algorithms | • AI generates class designs<br>• Human reviews & refines<br>• AI suggests algorithms | • Generate class structures<br>• Suggest algorithms<br>• Create interfaces |
| **Code Implementation** | • Write code from scratch<br>• Implement logic<br>• Manual debugging<br>• Write tests | • AI generates code<br>• Human reviews & edits<br>• AI suggests improvements<br>• Pair coding | • Full feature generation<br>• Complete implementation<br>• Test writing<br>• Auto bug fixes |
| **Unit/Module Level** | • Write functions<br>• Manual unit tests<br>• Debug issues<br>• Code review | • AI generates functions<br>• Human reviews & tests<br>• AI helps debug | • Auto unit test generation<br>• Code formatting<br>• Linting<br>• Style checks<br>• Auto-fix bugs |

- Example of a coding flow:

```ascii
+--------------+      +-----------+      +-------------+      +-----------------+
| Feature/CR   | ---> | Workflow  | ---> | Data Models | ---> | Code Components |
+--------------+      +-----------+      +-------------+      +-----------------+
                                                                        |
                                                                        v
                                                                +--------------+
                                                                |  Implement   |
                                                                +--------------+
                                                                        |
                                                                        v
                                                            +--------------------+
                                                            |  Smoke Test        |
                                                            |  Unit Test         |
                                                            |  Integration Test  |
                                                            +--------------------+
                                                                        |
                                                                        v
                                                                +--------------+
                                                                | Code Review  |
                                                                +--------------+
```

### Analogy between coding engineering and mechanical engineering

- In mechanical industry, we also have many already-to-use components (e.g. bolts, screws, gears, valves, pipes, etc.) they are designed, tested and they put into a catalog so the engineer can select them directly without designing from scratch (meaning they abstract the complexity of designing and testing).


## Tips

*So stay calm, we need to aware that, between Us, AI and the Code, there are alot if things for humans to do. (e.g designing, orchestrating, reviewing, etc.)*

### For high-level Tips

- Keep learning

- Preproduce a codebase

- Migrate a codebase

- Build a fake product


### For detailed implementation Tips

- Thinking first

- Control the high-level

- Setup local development environment

- Break down your work into smaller, manageable pieces (tasks, PRs, commits, etc.)

- Looping

- 