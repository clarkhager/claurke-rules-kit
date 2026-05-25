# claurke-rules-kit

A deployable behavioral rules system for Claude. One command installs a tested CLAUDE.md (anti-sycophancy, sparring-partner framing, plan-before-coding, diagnostic mode, response-shape rules) globally or per-project.

Built and validated through iterative rewrites against Anthropic official guidance, current sycophancy research, and community CLAUDE.md best practices. Companion to [claurke-memory-kit](https://github.com/clarkhager/claurke-memory-kit), which handles project-level memory; this handles universal behavior.

---

## Quick Start

### First time on a new machine

```bash
gh repo clone clarkhager/claurke-rules-kit ~/.claude/rules-kit
bash ~/.claude/rules-kit/deploy.sh
```

### Deploy globally (all Cowork / Claude Code sessions)

```bash
bash ~/.claude/rules-kit/deploy.sh --global
```

### Deploy to a single project folder

```bash
bash ~/.claude/rules-kit/deploy.sh --project /path/to/folder
```

### Check for updates

```bash
bash ~/.claude/rules-kit/check-updates.sh
```

---

## What Gets Installed

Five markdown files at the chosen target location:

- **CLAUDE.md** - the main rules file (~150 lines). Always loaded.
- **claude_voice_rules.md** - reference detail for the exempt-list sub-categories
- **claude_anti_sycophancy.md** - reference detail for impasse-surfacing protocol and edge cases
- **claude_coding_rules.md** - reference detail for surgical-change edge cases
- **claude_diagnostic_mode.md** - lazy-loaded by Claude when diagnostic mode activates

For global mode the install lands at `~/.claude/`. For project mode the install lands at the project root. Existing files are backed up before overwrite.

---

## What's In CLAUDE.md

Built around two failure modes the model exhibits without intervention:

**Sycophancy**: caving to pushback without new evidence, validating before engaging, burying problems in agreement.

**Premature conclusion**: jumping to the first plausible explanation, confirming hypotheses rather than falsifying them, declaring things impossible without proof.

The rules use constraint format ("X requires Y") and artifact requirements (concrete outputs the rule produces) rather than capability assertions. See `docs/guide.md` for the full design rationale and what the research said.

Key components:

- **Sparring-partner framing** at the top. Disagreement is a feature; the model leads with real flaws and says so directly when none exist.
- **Anti-Sycophancy spine** with a strict "new evidence" definition, an impasse-surfacing protocol after two consecutive held positions, and an override path for direct user direction.
- **Response-shape rules**: cite the specific claim being agreed with, state the weakest point first in evaluations, require sourced confidence statements.
- **Voice integration**: defers to your personal preferences for voice rules; the file does not duplicate them.
- **Coding behavior**: plan-before-coding requirement with falsification step, surgical-change rule, abstraction-requires-consumer rule.
- **Diagnostic mode**: explicit trigger system, three-hypothesis requirement with falsification tests, fourth-hypothesis check, fabrication prohibition.
- **Self-checkpoint prompts**: best-effort re-statement of spine rules at named triggers, honest about the limits.

---

## Known Limitations

- **Compliance is best-effort, not enforced.** Research suggests ~60-79% rule compliance on hard tasks. For destructive actions, rely on Cowork's built-in deletion permission prompt, not these rules.
- **Hooks don't fire reliably in Cowork** (anthropics/claude-code issues #27398 and #40495). Hooks would be the right mechanism for guaranteed re-injection of spine rules; until those bugs close, treat self-checkpoint prompts as soft reminders.
- **Persona drift** degrades self-consistency by 30%+ after 8-12 turns per arxiv 2402.10962. Long sessions weaken the sparring-partner framing regardless of how well the rules are written.

---

## Source documents

- Anthropic memory docs: https://docs.claude.com/en/docs/claude-code/memory
- Sharma et al. sycophancy: https://arxiv.org/abs/2310.13548
- Karpathy-derived CLAUDE.md: https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md
- HumanLayer "Writing a good CLAUDE.md": https://www.humanlayer.dev/blog/writing-a-good-claude-md
- Companion: https://github.com/clarkhager/claurke-memory-kit

---

## Contributing

Iterations should be deliberate. Changes to the rules in `rules/` need rationale; if you discover something that should be in the file, open a PR with the failure mode it addresses and the citation behind the fix.
