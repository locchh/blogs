---
title: "Agent-Driven Design"
description: "Some thoughts on agent-driven design (May 2026)"
pubDate: "2026-05-28"
author: "locchh"
tags: ["agent", "design", "2026"]
---

A friend asked me, in May 2026, what *"agent-driven design"* actually meant in practice. I sent them an HTML file an AI had written, then a screenshot of the same UI rebuilt as vectors by a *different* AI an hour later. Both said *sign-up card*. Both were that thing. Neither was a substitute for the other.

This post is the longer version of that answer. Two tools sit on either side of the diagram:

- **[Open Design](https://github.com/nexu-io/open-design)** — an open-source generator that writes HTML / Markdown / decks from a brief, by spawning whatever coding-agent CLI you have on `PATH`.
- **[Penpot](https://penpot.app/) + MCP** — a self-hostable vector design tool with a plugin that lets an agent push and pull from a live design file.

They're not competitors. Open Design compresses the blank-canvas phase; Penpot is where the artifact becomes design infrastructure. The interesting question — the only one this post is really about — is what happens to a single design intent as it travels between them, and where it leaks on the way.

---

## Open Design

[`nexu-io/open-design`](https://github.com/nexu-io/open-design) (v0.8.0-preview) calls itself *"an open-source, local-first alternative to Claude Design."* The first thing I noticed is that it doesn't ship its own model. Whichever coding-agent CLI you already have on `PATH` — Claude Code, Cursor, Gemini CLI, Copilot, sixteen of them detected automatically — that's the one doing the design work. Open Design is the orchestrator, not the brain.

The bundle is generous: 132 skills (`SKILL.md` folders organized by mode × scenario), 150 design systems lifted from real-world brands, five named visual directions, and a workflow that *forces* a brief through a discovery form before generation. The discovery form is the part I came to appreciate. It does the work of *"tell me what you actually want"* before any tokens are spent.

### Architecture

```
┌─────────────────┐      ┌─────────────────┐      ┌──────────────────┐
│  Web UI         │  ◀── │  Local daemon   │  ──▶ │  Agent CLI       │
│  Next.js 16     │      │  Express +      │      │  (spawned)       │
│  React 18 / TS  │      │  better-sqlite3 │      │  or OpenAI proxy │
└─────────────────┘      └─────────────────┘      └──────────────────┘
                                 │
                                 ▼
                         ┌──────────────────┐
                         │ Stdio MCP server │  ◀── external coding agents
                         │  (`od` binary)   │      query live design files
                         └──────────────────┘
```

Everything persists in a local `.od/` directory — projects, conversations, open tabs in SQLite, generated artifacts on the filesystem. Nothing ships to a cloud you didn't choose.

| Asset | Count | What it is |
|---|---|---|
| Skills | 132 | `SKILL.md` folders, by mode (prototype / deck / template / image / video) × scenario (design / marketing / engineering / HR / finance) |
| Design systems | 150 | `DESIGN.md` files (Linear, Stripe, Vercel, Notion, Tesla…) following a 9-section schema |
| Visual directions | 5 | Editorial, Modern Minimal, Tech Utility, Brutalist, Soft Warm — deterministic OKLch palettes |
| Export formats | — | HTML, PDF, PPTX, ZIP, Markdown |

### How I installed it

Three paths exist (AppImage, Docker, source). I picked source because I already had Node 24 and a `claude` CLI on `PATH` — the source install lets the daemon spawn my local CLI directly, no API key in any UI. The other two paths are listed in case your starting point is different.

#### Option A — Linux AppImage (no build, ~1 min)

```bash
mkdir -p ~/Apps && cd ~/Apps
# Grab the latest *.AppImage from https://github.com/nexu-io/open-design/releases
chmod +x open-design-*.AppImage
./open-design-*.AppImage
```

The Electron app auto-discovers any agent CLI on your `PATH` (`claude`, `cursor-agent`, `gemini`, etc.).

#### Option B — Docker (containerized, persistent, ~3 min)

```bash
mkdir -p ~/Works/open-design && cd ~/Works/open-design
git clone https://github.com/nexu-io/open-design.git .
cd deploy
cp .env.example .env
echo "OD_API_TOKEN=$(openssl rand -hex 32)" >> .env
docker compose up -d
docker compose logs -f od
# Browse: http://localhost:7456
```

Drawback: the container **can't see your host's agent CLIs**, so you'll need to use the BYOK proxy (paste an Anthropic/OpenAI key into the UI).

#### Option C — From source (recommended if you have agent CLIs locally)

```bash
# pnpm via corepack (shipped with Node 24)
corepack enable
corepack prepare pnpm@10.33.2 --activate

mkdir -p ~/Works/open-design && cd ~/Works/open-design
git clone https://github.com/nexu-io/open-design.git .
pnpm install

# Fixed ports so you can bookmark it
pnpm tools-dev run web --daemon-port 17456 --web-port 17573
# Web UI → http://localhost:17573
```

`pnpm tools-dev status` to inspect sidecars, `pnpm tools-dev stop` to shut down. The daemon runs as your user, so Claude Code / Cursor / Gemini CLIs on your `PATH` are detected and usable directly — no API keys needed.

### Two Claudes, no shared context

This is the part of agent-driven design that took me a moment to internalize. When you use Open Design's web UI to generate something, it spawns **a fresh `claude` subprocess** — not the Claude Code session you're currently chatting with somewhere else. The two share nothing.

|  | The Claude **inside Open Design** | Your Claude Code session |
|---|---|---|
| How invoked | OD's daemon spawns `claude` as a subprocess per generation request | You launched it in some working dir |
| Sees | OD's internal prompt, its skills/design systems, the task brief | Your chat history, your files, your `CLAUDE.md` |
| Working dir | `~/Works/open-design/.od/projects/<id>/` | Wherever you started it |
| Lifetime | Dies when the OD task finishes | Lives until you exit |
| Memory of the other | None | None |

Three things follow from that:

- Context doesn't carry. If your session and you decided on a palette, OD-Claude won't know unless you paste it into the brief.
- The two can disagree — OD's discovery form and per-skill checklists push it toward different choices than a free-form chat would.
- Token spend roughly doubles for the "generate in OD, then refine via Claude Code" loop.

Artifacts land as plain files on disk, so your own session can `Read` / `Edit` / `Write` them directly once OD finishes — no MCP needed for filesystem edits. The OD MCP server is only useful when you want a *third* agent (Cursor, a different Claude Code instance) to query OD's output without leaving its own workspace.

---

## Penpot

If Open Design is the artifact factory, [Penpot](https://penpot.app/) is the design-infrastructure layer downstream. It's the open-source design tool people reach for when they want Figma without Figma — but the part that matters here is the **MCP plugin**. Install it in the editor, point your MCP client at a local endpoint, and your agent gets a JavaScript runtime inside the Penpot Plugin sandbox: create shapes, edit styles, apply tokens, export CSS, all from chat.

Prerequisites: Docker, Docker Compose, ~4 GB free RAM.

### 1. Run Penpot

```bash
mkdir penpot && cd penpot
curl -O https://raw.githubusercontent.com/penpot/penpot/main/docker/images/docker-compose.yaml
docker compose -p penpot up -d
```

Open http://localhost:9001/ and create an account. No SMTP is configured, so the verification email is in the backend logs:

```bash
docker compose -p penpot logs penpot-backend | grep -i verify-token | tail
```

### 2. Switch the MCP server to single-user mode

There's one detour I'd flag for self-hosters, because I lost an hour to it. The official image starts the MCP server with `--multi-user`, which forces token auth on every WebSocket. The plugin's reconnect logic doesn't carry the token on reconnect, so every idle drop turns into a red bar reading **"Disconnected: Missing userToken parameter"**. The plugin is fine; the server is rejecting it.

For a self-host with one user, drop the flag. No tokens needed anywhere — not in `.mcp.json`, not in the plugin URL, not in the conversation.

Create `docker-compose.override.yaml` next to `docker-compose.yaml`:

```yaml
services:
  penpot-mcp:
    command: ["node", "index.js"]
```

Apply:

```bash
docker compose -p penpot up -d penpot-mcp
docker compose -p penpot logs penpot-mcp --tail 5    # expect: "Multi-user mode: false"
```

### 3. Wire up your agent

`.mcp.json` (Claude Code, or your agent's equivalent):

```json
{
  "mcpServers": {
    "penpot": { "type": "http", "url": "http://localhost:9001/mcp/stream" }
  }
}
```

### 4. Install the Penpot MCP plugin

In Penpot: **Plugins icon → Plugin manager** → paste:

```
http://localhost:9001/plugins/mcp/manifest.json
```

Click **Install**, then **Open**. The panel should go **`● Connected`** immediately. Restart your agent so it picks up `.mcp.json`, and the `mcp__penpot__*` tools become available.

> **If you must run multi-user mode** (shared instance): keep `--multi-user`, generate an access token in **Your account → Access tokens**, and append `?userToken=<TOKEN>` to **both** the `.mcp.json` URL and the plugin manifest URL. Expect occasional disconnects — the plugin's reconnect logic loses the token.

### 5. First call

Ask your agent for something cheap to confirm round-trip works:

> *"List the pages in my connected Penpot file."*

A working answer is one page with an id and a name (`Page 1` and `83b6d729-…` in my case) plus a synthetic `Root Frame`. That's normal — every Penpot page has one. From there you drive the design from chat:

- *"List all the shapes on Page 1."*
- *"Create a 400×80 button labeled 'Sign up' on Page 1."*
- *"Select a shape in Penpot, then inspect its styles and export it as PNG."*
- *"Generate the CSS for the current selection."*
- *"Build a card component (header, body, footer) using flex layout."*

### 6. What an agent can do over MCP

The connected agent gets a JavaScript runtime inside the Penpot plugin sandbox, plus tooling for export and inspection. In practice the scope is "anything a designer can do with mouse + keyboard, but scriptable" — and a few things that would be tedious by hand.

**Read**

- Pages, boards, groups, and every shape with full geometry, fills, strokes, shadows, blurs, rotation, opacity, constraints, and layout settings
- Text content, font family, weight, size, line height, per-range styling
- Asset libraries — colors, typographies, components (local + connected external libs)
- Design tokens — sets, themes, values, and the references between them
- Current selection, current page, viewport, active collaborators
- Generated CSS, HTML, and SVG markup for any selection
- Exports of any shape or full page as PNG or SVG

**Write**

- Create boards, rectangles, ellipses, paths, text, booleans, or import SVG
- Modify anything writable — position, size, fills, strokes, radii, rotation, opacity, text, font
- Apply flex/grid layouts, padding, gaps, sizing, alignment
- Append, insert, reparent, reorder, clone, or delete shapes
- Create and instantiate library components, including variant sets
- Create and apply design tokens; retoken existing shapes in bulk
- Upload images and use them as fills

**Out of scope**

- Switching which file is connected (the user does that in Penpot's UI)
- Files that aren't open with the plugin running
- User accounts, billing, sharing, permissions — only design content
- Arbitrary HTTP from inside Penpot; everything goes through the plugin API

**Tasks where the agent earns its keep**

- *"Rename every layer on this page to PascalCase based on its content."*
- *"Find every text on Page 1 and switch to Inter; report any missing weights."*
- *"Build a 6-step ramp from #5B47F5 and add each step as a library color."*
- *"Make a Button variant set: primary/secondary/ghost × default/hover/disabled."*
- *"Audit every board on this page — flag any without a flex or grid layout."*
- *"Generate React JSX + CSS for the selected card component."*

The pattern that works best is conversational and iterative: ask, see the diff in Penpot, adjust. Treat the agent as a designer-with-a-keyboard, not a one-shot generator.



### 7. Comparison Penpot vs Figma

**Shared core (works the same in both)**

- Frames / artboards / boards
- Vector tools (pen, shapes, boolean ops, masks)
- Typography, colors, gradients, shadows, blurs
- Components + variants + overrides
- Auto-layout (Penpot calls it flex/grid, same idea)
- Shared styles / libraries
- Constraints & responsive resizing
- Multi-page files
- Real-time multiplayer + comments
- Prototyping with clickable flows
- Design tokens / variables
- Dev handoff with CSS inspect
- Export PNG/SVG/PDF
- Plugin API

**Where they still diverge (not core, but felt daily)**

- Prototyping depth — Figma has conditional logic, expressions, complex variables; Penpot is simpler click-through.
- Variables/modes — Figma's multi-mode variables (light/dark, density, etc.) are more powerful; Penpot's tokens are spec-compliant but less interactive.
- Performance on huge files — Figma handles 1000+ frame files better.
- Plugin ecosystem — Figma has thousands; Penpot has dozens.
- AI features — Figma Make, First Draft, etc. Penpot has none yet.


## The pipeline, with one card

Setup done, here's what an actual end-to-end run looks like. I picked the simplest brief I could think of — a single sign-up card — and walked it from a blank discovery form to a vector design source with a dev-ready CSS export. Five stages, two tools, two Claudes, one card.

The interesting thing is that **no single file format flows end to end**. What crosses each boundary is the design *intent*, re-encoded for the next tool. Drawing the stages out makes that visible.

### The pipeline at a glance

```
   1. OD output                 2. DNA spec               3. Penpot design          4. Dev handoff
   ──────────────               ─────────────             ────────────────          ───────────────
   Welcome.html                 text in agent             vector shapes             SignUp.png
   styles.css                   chat context              + library colors          card.css
   tokens.json                  (palette, type,           + library typography      tokens.json
   /assets/*                    spacing, radius)          + component               saved to repo

   On disk:                     In agent memory          In Penpot's DB             On disk:
   .od/projects/<id>/           (no file by default)     (no file form)             ./design-handoff/
```

### Step-by-step with the sign-up card

**1. Brief** — fill OD's discovery form like this:

| Field | Value |
|---|---|
| What should I build? | **Live artifact** |
| Who is this for? | `Backend engineers signing up for a developer tool — assume they already chose the product.` |
| Brand context | Click **Pick a direction for me** |
| Roughly how much? | `One card / single screen` |
| Any important constraints? | See the block below |

Paste this into **"Any important constraints"** verbatim:

```
Single sign-up card, centered on a dark background.
Visual direction: Tech Utility. One accent color of your choice.

Content:
- Heading: "Create your account"
- Subhead: "Sign up in seconds — no credit card required."
- One email input (placeholder: "you@company.com")
- One primary CTA button: "Sign up"
- Small muted footer link: "Already have an account? Sign in"

No marketing fluff. No hero illustration. No social-login buttons.
Standalone HTML, no external CDNs or fonts beyond what's bundled.
Output as a single HTML file plus tokens.json if a token schema is supported.
```

Hit **Send answers** → OD spawns Claude to generate.

**2. OD generates.** Its spawned Claude writes `~/Works/open-design/.od/projects/<id>/index.html` — in my run, a 20 KB standalone file with embedded CSS and inline JS for form validation. Brand: "forge.dev" (it picked the name itself). Accent: `oklch(74% 0.16 145)`, a muted dev-tool green. Nothing in Penpot yet.

![OD's rendered Forge sign-up form on the grid-pattern dark background](/agent-driven-design/od-output.png)

The interesting part is that OD shipped *more than I asked for*. The brief said heading, subhead, email input, primary CTA. The HTML included GitHub + GitLab OAuth buttons, a password field with a 4-cell strength meter, a ToS checkbox, loading states, and a "Check your inbox" success view. Either OD knows what *sign-up card* tends to mean and is helping me skip a round of refinement, or it's spending tokens on features I didn't authorize. Both are true depending on the day.

**3. Extract the DNA.** I gave my Claude Code session the file path and asked it to summarize OD's design choices in chat — palette, typography, geometry, motifs. The summary stays in agent context unless you ask for `dna.yaml` on disk.

> *Palette: bg `#0E1116`, surface `#161B22`, accent `#5DDB95`, ink `#F4F6F8`, muted `#8993A3`. Type: Inter 20/600 heading, 13/400 body, JetBrains Mono 11 uppercase labels. Spacing: 32 padding, 14 row gap. Card: 6 radius, 1 px border. Motifs: 48 × 48 grid background, 3 px accent focus ring, 4-cell strength meter.*

**4. Encode into Penpot.** This is where the MCP plugin earns its keep. I asked my session to translate the DNA into Penpot library colors and rebuild the card as a vector component. One `mcp__penpot__execute_code` call — four, actually; three of them failed first on Penpot API quirks I hadn't yet learned (`setFont` missing at runtime, `letterSpacing` rejecting `em` units, negative values rejected). The fourth succeeded and the card materialized: eleven library colors under `Forge/`, a fifty-shape vector board called `Forge / SignUp Card`, flex layouts top to bottom.

![The same card rebuilt in Penpot as a vector component](/agent-driven-design/penpot-forge-card.png)

Visually faithful, structurally a different kind of object. The OD draft is a styled HTML document; the Penpot version is a tree of boards, frames, and tokens — design infrastructure you can build a system around. What didn't survive the transfer: the 48×48 grid background pattern, the OAuth SVG icons, the 4-cell strength meter under the password field. About 3% of the surface, and the most visually-noisy 3%. With one more prompt the gap closes; the point of the convert pass is structure, not pixel parity.

Then you tweak in chat: *"radius is too big, make it 12"*, *"swap the accent to mint"* — the agent retokens the value and every instance updates. Stage 4 is the cheapest part of the whole pipeline once the design is in.

**5. Dev handoff.** From the vector source it's one MCP call to engineer-ready artifacts:

- `mcp__penpot__export_shape` returns PNG / SVG bytes
- `penpot.generateStyle` (inside `execute_code`) returns a CSS string
- Local library tokens export as W3C-DTCG JSON

The agent writes those back to disk with the regular `Write` tool. The engineer never opens Penpot — they get code-ready files in the repo.

### The receipts

I told myself, while doing this, that the whole pipeline cost roughly 60–80k tokens. Then I went and checked. Claude Code writes every session to `~/.claude/projects/<cwd>/<session>.jsonl`, including for OD's spawned subprocess — it gets its own log under the OD project directory. Counting the relevant turns produced numbers that surprised me.

|  | Design phase (OD-Claude) | Convert phase (Penpot MCP) |
|---|---|---|
| Wall clock | **1m 58s** | **13m 24s** |
| Assistant turns | 4 | 63 |
| `cache_creation` | 129,724 | 146,011 |
| `cache_read` | 116,469 | **15,603,929** |
| `output` | 30,095 | 104,974 |
| **Effective billed**¹ | **~171,500 tokens** | **~1,811,500 tokens** |
| Output artifact | 20 KB `index.html` + tokens.json | 11 library colors + ~50-shape vector component |

¹ Anthropic prices `cache_read` at ~10% of input, so effective = `input + cache_creation + 0.1 × cache_read + output`.

The convert phase came in at **~1.8 million effective tokens**, not 30k. I was off by roughly fifty times.

The reason turned out to be unsubtle, and worth understanding. Every Claude Code turn re-sends the full conversation history as `cache_read`. By the time I reached the convert phase, the session was four hours deep — Penpot setup, MCP debugging, an earlier throwaway sign-up card, the OD install. Sixty-three convert-phase turns each dragged ~250k tokens of stale history through `cache_read` just to add another 1.5k of reasoning. That's where the 15.6M raw goes.

Three lessons fell out of that:

- **Long sessions amplify cost geometrically.** The same convert work, run in a *fresh* session in the OD project directory, would have been more like 150–200k effective tokens — close to the design phase.
- **Failed `execute_code` attempts pay full price.** Each of the three retries on Penpot API quirks carried a full context rehydration. The fix is a `CLAUDE.md` that pre-loads the quirks; the cost is paying for them once.
- **Token cost is not wall-clock cost.** The 13-minute convert phase was mostly me typing chat messages between MCP calls. Actual agent compute was a small fraction.

The quality side of the ledger comes through cleaner. The converted Penpot card is structurally faithful — palette, spacing, type, layout — but skips details that need real raster or SVG: the 48 × 48 grid background, the OAuth SVG icons, the strength meter. Maybe 3% of the surface, and visually the noisiest 3%. With one more prompt I could close that gap. The point of the convert is the structural pass, not pixel parity.

The mental model I keep returning to: **OD is the first comp in HTML; Penpot is the same design as design infrastructure.** The convert phase is the cost of making that second statement true.

To cut the convert cost ~10× next time: run it in a fresh session in the OD project dir, ship a `CLAUDE.md` with the Penpot API quirks, and persist the DNA as `dna.yaml` so re-runs skip the HTML re-read.

### The design gap

The pipeline above is what works. It's worth saying just as plainly what *doesn't* — where the agent helps, where it doesn't, and where it creates new gaps that didn't exist before AI tools entered the diagram.

| Gap | What it is | Agent's effect |
|---|---|---|
| **Intent → Brief** | Your vision vs. what you typed | Neutral — and dangerously easy to under-specify |
| **Brief → Artifact** | What the brief asked vs. what OD shipped | Big speedup, but expect scope drift (we got OAuth + strength meter we didn't ask for) |
| **Artifact → Infra** | HTML draft vs. vector source of truth | Big speedup, small fidelity loss (grid bg, SVG icons skipped) |
| **Design → Code** | Mock vs. production frontend | Tokens bridge ~60 %; animation, focus, ARIA, edge cases stay human |
| **Code → Production** | Green-path vs. real users | Unchanged — AI rarely designs for long content, RTL, accessibility |
| **Two-Claude divergence** | OD-Claude's taste vs. session-Claude's | **New gap.** Pass the DNA explicitly or they'll disagree at the margins |
| **Taste** | Median-good vs. distinctive | AI smooths toward the average of its training data; humans earn their keep at the edges |

The agent wins in the middle of the pipeline — *brief → artifact → infra*. The endpoints — intent, production reality, taste — stay human-shaped. Designing with agents doesn't replace design judgement; it moves it. You spend less time pushing pixels and more time deciding what the artifact should *be*, and which AI drifts to overrule.

---

## Tearing it down

When you're done playing:

```bash
# Open Design — stops daemon + web sidecars
cd ~/Works/open-design && pnpm tools-dev stop

# Penpot — stops every container, keeps your data in named volumes
cd ~/Works/penpot && docker compose -p penpot down

# Penpot, clean slate (also wipes the file you built in this post)
docker compose -p penpot down -v
```

Sanity check nothing's still running:

```bash
docker ps --filter name=penpot
pnpm --prefix ~/Works/open-design tools-dev status
```

---

## Crossing into Figma

If your team lives in Figma, the open-source pipeline above is only useful insofar as you can hand the result off. So: how does a Penpot file get into Figma?

The blunt answer is **there's no `.penpot` import in Figma**, and there probably won't be — Adobe has no incentive to build one. What does work in 2026:

### Route A — SVG + DTCG tokens (lossy, two minutes)

Penpot exports SVG cleanly. From the editor: select a board → **File → Export** → choose SVG → drop the file into a Figma page. Figma treats it as editable vector. What survives the crossing: the visual fidelity, basic groups, fills, strokes. What doesn't: components, auto-layout containers, styles, anything tied to Penpot's library.

For the design *system* — colors, typography, spacing — Penpot's local library exports as W3C-DTCG JSON. The [Tokens Studio](https://tokens.studio/) plugin in Figma imports DTCG. Tokens travel cleanly even when layouts don't.

> **Visual fidelity travels through SVG. System fidelity travels through tokens. Neither carries components.**

Good for: hero illustrations, icons, single screens you want to polish in Figma. Bad for: handing off a whole component library.

### Route B — agent recreates via Figma's MCP (faithful, full token bill)

The agent-era twist: **you don't need a file-format bridge.** The same pattern we used for OD → Penpot — agent reads from one tool, writes to another — works for Penpot → Figma. Figma ships its own [Dev Mode MCP server](https://developers.figma.com/docs/figma-mcp-server/), and most MCP clients can hold two servers concurrently:

```json
{
  "mcpServers": {
    "penpot": { "type": "http", "url": "http://localhost:9001/mcp/stream" },
    "figma":  { "type": "http", "url": "http://localhost:3845/sse"      }
  }
}
```

Then in chat: *"Read the `Forge / SignUp Card` from Penpot and recreate it as a Figma component with auto-layout."* The agent does the structural translation — components stay components, tokens become Figma variables, auto-layout maps to auto-layout. Pays the convert-phase token cost again, just in the other direction.

Good for: handing off a whole component library, keeping the design system intact across tools. Bad for: budgets that care about every million tokens.

### Which route when

| You want… | Use |
|---|---|
| One screen in Figma now, no system | Route A — SVG + DTCG |
| Whole component library, faithful | Route B — agent + Figma MCP |
| Engineering handoff only | Skip Figma entirely; Penpot's CSS export is enough |

The third option is the one I'd nudge teams toward when the work is genuinely for production: the value of Figma in an open-source-design workflow is often *collaboration with designers who already know Figma*, not anything intrinsic to the file format. If the artifact is shipping straight to engineering, Penpot → CSS → repo is shorter and loses nothing.

### Why Penpot, then?

A reasonable question after spending a whole section on how to get *out* of Penpot is why I put the artifact there in the first place. It is **not** because Figma's MCP is read-only — it isn't. Figma's MCP in 2026 exposes write tools (`use_figma`, `generate_figma_design`, `create_new_file`, `upload_assets`) and can build a design from chat just like Penpot can.

The reasons that *do* hold up:

| Reason | Penpot | Figma |
|---|---|---|
| Self-hostable on your machine | Yes (Docker) | No (cloud-only) |
| Open, inspectable file format | SVG-based | Proprietary `.fig` |
| Cost per agent iteration | Free, local | Counts against seat + API quota |
| Failed-attempt blast radius | Local DB, wipe with `down -v` | Live multiplayer file — your churn is visible to everyone |
| Sandbox flexibility | `execute_code` is raw JS against the full Plugin API | Higher-level tool surface; less precise for arbitrary mutations |
| Vendor / format lock-in | None | Adobe owns the format and roadmap |

For a team that already lives in Figma, the agent does fine and the case for switching is weak. For a solo or open-source-aligned workflow that iterates with hundreds of `execute_code` calls against a fast-moving design — and pays in tokens for every retry — Penpot wins on cost, control, and reversibility. Not on capability.

---

## What I keep coming back to

The smoother the AI output, the easier it is to ship something that *looks* designed but doesn't *feel* designed. Open Design and Penpot+MCP together produced a very polished sign-up card in fifteen minutes. Whether it's *yours* is a separate question, and one no token budget will answer.

Two tools in this post, both open source, both running on my laptop, both genuinely useful — but only as far as the design judgement you bring to the brief on the way in and the taste you apply to the artifact on the way out. The middle is solved. The ends are still the work.

## Resources

- [Claude Design (Anthropic Labs)](https://www.anthropic.com/news/claude-design-anthropic-labs) — the reference point Open Design names itself against.
- [`VoltAgent/awesome-claude-design`](https://github.com/VoltAgent/awesome-claude-design) — running list of agent-driven design tools.
- [`nexu-io/open-design`](https://github.com/nexu-io/open-design) — the project covered above.
- [Penpot](https://penpot.app/) and the [Penpot MCP server](https://penpot.app/ai/mcp-server).
- [Figma](https://www.figma.com/) and its [MCP server docs](https://developers.figma.com/docs/figma-mcp-server/) — for the other end of the open / proprietary axis.