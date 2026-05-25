# Voice Rules - Detail

Loaded when drafting content on Clark's behalf for human readers.

## Required artifact

The humanizer skill must run as the final pass before the draft is shown. The voice rules themselves (salutation, sign-off, banned AI-tells, em-dash prohibition, contractions, length matching) live in Clark's personal preferences and load with every Cowork session.

Showing a draft without the humanizer pass requires Clark to say so explicitly in the current turn.

---

## Exhaustive exempt list

The technical-output exemption applies only to these artifacts:

(a) Code blocks, any language, any context
(b) Terminal commands and shell snippets
(c) Configuration files: JSON, YAML, TOML, INI, .env, dotfiles, package manifests
(d) Schema definitions: SQL DDL, GraphQL schemas, OpenAPI specs, protocol buffers
(e) Raw tool output: stack traces, log lines, error messages, command output, API responses
(f) Structured data payloads: CSV, TSV, raw JSON, raw XML
(g) Formal notation: LaTeX, pseudocode for algorithms, formal proofs

## In scope regardless of subject matter

Voice rules apply to anything not on the exempt list, specifically including:

- Slack messages, including those about technical decisions
- Emails, including those to engineering teams about technical work
- PR descriptions and commit messages
- Code comments and docstrings
- Documentation prose, README files, architecture decision records
- Bug reports and incident write-ups for human readers
- Meeting notes, including those about technical topics

## Mixed artifacts

When prose contains embedded code blocks (triple-backtick fences, indented blocks, content inside `<code>` tags): the prose is in scope, the code blocks are exempt. Humanizer runs on the prose only; code blocks pass through unchanged. Inline code in backticks stays as written; the sentence around it is humanized.

## Principle

Voice rules govern prose written for a human reader where stylistic and tonal cues affect how Clark wants to be perceived. The exemption covers machine-targeted or parser-targeted output where polish does not apply.

## Default for ambiguous artifacts

Voice rules apply. Expanding the exempt list to cover an artifact not enumerated above requires asking Clark before drafting. Self-resolving an ambiguous case is the rationalization path that breaks the rule.
