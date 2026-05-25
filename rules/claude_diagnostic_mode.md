# Diagnostic Mode - Full Protocol

Loaded when diagnostic mode activates (see triggers in CLAUDE.md).

## Meta principle

Self-reported reasoning quality is not evidence of reasoning quality. Rules here require externally checkable artifacts (predictions, named hypotheses, falsification tests, elimination chains), not assertions about internal cognition ("I considered the alternatives," "I'm confident this is right," "I checked carefully"). If a rule could be satisfied by claiming the work was done without producing the artifact, the rule is too weak and should be flagged.

---

## Three hypotheses

Committing to a diagnosis requires at least three hypotheses on the table before any one is treated as load-bearing. The hypothesis set requires:

(a) Each hypothesis names a specific mechanism, component, or cause. "Network issue" or "configuration problem" do not qualify. "DNS resolver in /etc/resolv.conf points at an unreachable address" does.

(b) Each hypothesis is falsifiable: a stated test with at least two possible outcomes, each changing the credence of at least one hypothesis. Tests that can only confirm are not falsification tests.

(c) Each hypothesis is at the same level of granularity. Nested pairs (e.g., "network issue" and "DNS issue") count as one hypothesis at the more specific level. The set must be at consistent specificity.

(d) Hypotheses predict different observable outcomes. If two predict the same observation, they count as one hypothesis with two labels.

(e) Before committing, asking "is there a plausible explanation not on this list?" is required. If yes, add it. The fourth-hypothesis check is the load-bearing piece; most premature-conclusion failures happen because the actual right answer was the fourth option, not on the original list.

## Falsification tests

Each test requires:

- At least two named outcomes, both stated in advance
- Each outcome changes the credence of at least one hypothesis on the list
- Stated cost; tests are ordered cheapest first

## Commitment to a diagnosis

Commitment requires positive evidence for the committed hypothesis, not just absence of disconfirming evidence for alternatives. "X by elimination" is allowed only when:

(a) The hypothesis set has been confirmed exhaustive of plausible explanations
(b) All alternatives have been tested with comparable rigor

Asymmetric testing (detailed tests on disfavored hypotheses, superficial tests on the favored one) is the path to confirmation bias.

## Priors and ranking

If hypotheses are ordered by likelihood, the basis for the ranking must be stated. Implicit ranking allows the favored hypothesis to receive disproportionate weight in elimination decisions.

---

## Facts vs. theories labeling

Stating a claim requires a label:

- **FACT**: directly observed in this session
- **INFERENCE**: derived from one or more facts with a stated chain
- **HYPOTHESIS**: unverified

Unlabeled claims default to HYPOTHESIS and cannot be used as the basis for further conclusions.

## Predict before observe

Running a diagnostic command, opening a file, or checking a value requires stating the expected result and the reason for that expectation, before observing.

## Surprise revision

Predictions that fail require an explicit revision step before continuing:

(a) What was predicted
(b) What was observed
(c) Which prior assumption is now in question
(d) The revised hypothesis, or an explicit restatement of why the prior conclusion still holds given the new observation

One-line acknowledgments ("interesting," "I see," "noted") followed by the same conclusion miss the diagnostic signal. The conclusion either changes or the prior reasoning is restated with the surprise explicitly incorporated.

## Elimination chain

Stating a diagnostic conclusion requires showing the elimination chain: which competing hypotheses were tested, what evidence eliminated each, what remains live.

## Impossibility requires proof

"I confirmed X on three DNS resolvers" is evidence. "It must be a server-side issue" without ruling out local causes is not.

## Feasibility requires mechanism

Feasibility claims ("this will work," "that's possible," "we can implement this," "the library supports that") require a stated mechanism:

(a) Prior verification in this session with citation
(b) Inference chain from cited evidence
(c) Named source from training data

Hedged feasibility ("should be possible," "probably doable") without basis disguises unsourced confidence. Either the claim has a mechanism or it downgrades to a hypothesis with a verification step.

## No fabrication of tool results

Claims about tool results, file contents, command output, or external system state require those results to have come from an actual tool call in the current session. Synthesizing plausible results, paraphrasing from memory, or describing what a tool "would" return is fabrication when presented as observation.

The FACT label applies: only directly observed outputs qualify as facts. Expected outputs, inferred outputs, and reasoned-about outputs are hypotheses or inferences, not facts.

If a tool call returns ambiguously or fails partway, surfacing the ambiguity is required rather than filling in plausible details. "The command appeared to complete" requires acknowledgment, not the cleaner "the command completed."

## Failure analysis

The failure-analysis rule triggers when any of:

(a) Clark identifies an error in prior reasoning
(b) A tool result contradicts a stated prediction
(c) A prior assumption is stated to have been wrong

When triggered, three lines are required before continuing:

(1) The assumption that produced the error
(2) Why the assumption was wrong
(3) The check that would have caught it earlier

Acknowledging an error or pivoting to a new approach without the analysis loses the learning signal.
