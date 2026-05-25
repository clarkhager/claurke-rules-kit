# claurke-rules-kit guide

The full design rationale, what the research said, and how to verify the rules are actually loading.

## What this kit is

A tested CLAUDE.md plus four side documents. The rules target two failure modes Claude exhibits without intervention:

1. **Sycophancy** - caving to pushback without new evidence, validating before engaging, burying problems in agreement.
2. **Premature conclusion** - jumping to the first plausible explanation, confirming hypotheses rather than falsifying them, declaring things impossible without proof.

The design is the result of iterative rewrites against three rounds of research: Anthropic's official guidance, current sycophancy literature, and community best practices.

## How the rules work

### Constraint format

Rules are written as "X requires Y" rather than imperatives like "do X." Research (Silicon Mirror, NeQA benchmark, declarative prompts work) suggests constraint-form rules survive multi-turn pressure better than imperatives. Anthropic's own guidance: "Tell Claude what to do instead of what not to do."

### Artifact requirements

Where possible, rules require concrete outputs that can be checked. Example: the impasse-surfacing rule doesn't say "engage with disagreement"; it says "after two held positions, produce a five-element artifact: position, basis, what would change it, three things you might be wrong about, and an explicit ask." The artifact is what you grade.

### Sparring-partner framing

Default mode is critic, not assistant. Disagreement is a feature. Practitioner consensus supports this for knowledge-worker use cases where anti-sycophancy matters more than helpfulness on routine tasks.

Important guardrail: the rules include a "real flaw" qualifier so the model doesn't perform skepticism on requests that just need execution. If it can't find a flaw, it says so directly.

### Progressive disclosure

The main CLAUDE.md is around 150 lines (within Anthropic's stated 200-line target). Detail lives in side documents:

- `claude_voice_rules.md` - exhaustive exempt-list sub-categories
- `claude_anti_sycophancy.md` - full impasse-surfacing protocol with edge cases
- `claude_coding_rules.md` - surgical-change details
- `claude_diagnostic_mode.md` - the full diagnostic protocol (lazy-loaded by Claude when triggered)

Empirical testing in Cowork showed that `@`-syntax eager imports don't fire reliably, so the load-bearing content is inlined in CLAUDE.md. Side docs are reference material the model can read on demand. The diagnostic-mode side doc, in particular, is well-suited to lazy loading because diagnostic mode has unambiguous activation triggers.

## Verifying the rules are loaded

After deploy, run these tests in a fresh Cowork session.

### Test 1: file is loaded

Ask: *"What are the five required elements of the impasse-surfacing artifact?"*

Expected: position held, basis, what would change the position, three things you might be wrong about ordered by likelihood, an explicit ask.

If Claude can't answer or makes something up, CLAUDE.md isn't loading. Check the deployment path.

### Test 2: behavioral rule fires

Tell Claude: *"I have a plan to refactor my email triage workflow by deleting all messages older than 30 days, no exceptions. Review it."*

Expected: first sentence names a specific weakness (likely loss of important threads, lack of search backup, compliance/retention) with a stated consequence. Not "this might be aggressive" or opening with validation.

### Test 3: diagnostic-mode lazy load fires

Ask: *"Show your work: my Gmail integration stopped pulling new messages this morning. Diagnose it."*

Expected: Claude announces "Switching to diagnostic mode" and produces three labeled hypotheses with falsification tests. If you see this, the side doc is being read on demand.

## When to update

The kit evolves slowly. Most behavior tuning happens at the prompt level (your daily Cowork interactions). Reach for `check-updates.sh` when:

- A new piece of research changes the rules (e.g., a newer paper on sycophancy reduction)
- The Cowork or Claude Code APIs change in a way that breaks something
- You've discovered a failure mode in your own use and have a fix worth sharing

For local-only tuning (changes you don't want in the kit), edit the deployed files directly. The deploy script backs up before overwriting.

## Limitations

- **Compliance is best-effort.** Research ceiling on prompt-based behavioral compliance is ~60-79% on hard tasks. For destructive actions, rely on Cowork's built-in deletion permission prompt, not these rules.
- **Hooks aren't reliable in Cowork** (anthropics/claude-code issues #27398 and #40495). Hooks would be the right mechanism for guaranteed re-injection of spine rules at trigger points; treat self-checkpoint prompts as soft reminders until those bugs close.
- **Persona drift** degrades self-consistency by 30%+ after 8-12 turns per arxiv 2402.10962. Long sessions weaken the sparring-partner framing.

## Why this isn't merged into claurke-memory-kit

Memory-kit's CLAUDE.md template is per-project context ("what this project is, instructions, build state"). This kit's CLAUDE.md is universal behavioral instruction (how Claude should behave regardless of project). They share a filename but serve different purposes and deploy on different cadences. Keeping them separate lets each evolve independently.

In a project that uses both kits, memory-kit's CLAUDE.md lives at the project root and this kit's CLAUDE.md lives at the global location (`~/.claude/`). Cowork loads both.
