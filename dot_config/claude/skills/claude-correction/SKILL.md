---
name: claude-correction
description: Record a verified mistake in Claude's own previous answer, research, or reasoning into the user's Obsidian vault as a "correction" note. Use this whenever Claude acknowledges or concedes that something it said or wrote was actually wrong — typically right after the user points out the error, or when Claude catches its own mistake. The user wants every such factual/design error collected (not just big ones). Records the correct answer, the verifying source, and a link back to the original output.
---

# Claude Correction Logger

Log corrections of **Claude's own errors** into the user's shared Obsidian vault, so mistakes become a verified, reusable asset (and repeated mistakes can be turned into skill gotchas later).

## When to use

Trigger whenever you (Claude) admit an error in your **own prior output**:

- The user points out that your answer / research / code reasoning was wrong, and you agree.
- You independently realize a previous claim of yours was incorrect.

Collect **all** such errors — do **not** filter by how minor they seem. The user explicitly wants every failure recorded.

Do **not** log: pure style/preference changes, or cases where the user merely changed the requirements. Only log cases where something you **asserted was actually incorrect**.

## Destination (fixed)

Always record into this vault, regardless of which project you are currently working in:

```
~/Projects/github.com/s-ikezawa/obsidian-vault
```

- One note per error, in `Notes/Corrections/`.
- If that directory does not exist, do **not** invent another location — tell the user the vault was not found, and skip.

## Steps

1. **Date**: get today's date with `date +%F` (e.g. `2026-06-06`). Prefer the shell over your context date.
2. **Read the canonical format from the vault** (it is NOT auto-loaded when you are in another project):
   - `<vault>/Templates/correction.md` — the template.
   - `<vault>/.claude/rules/note-authoring.md` — see the "訂正ログ（correction）" section for naming, frontmatter, and link rules.
3. **Create** `<vault>/Notes/Corrections/<YYYY-MM-DD>-<short-kebab-slug>.md`. Fill the template yourself — `{{title}}`/`{{date}}` are NOT auto-expanded outside Obsidian:
   - `title`: the **correct** statement, as one sentence (the title is the reusable handle).
   - `type: correction`, `status: verified`, `severity: high|medium|low` (default `medium`), and `date`/`created`/`updated` = today.
   - `source`: the **primary source(s)** that verify the correction.
   - `related`: relative path to the original Claude output if it is a vault note; otherwise describe where it happened (session / PR / file).
   - `tags`: pick from the vault tag ledger `<vault>/00-Moc/tags.md`; if a needed tag is missing, add it to the ledger first.
   - Body sections: 何が間違っていたか（AIの主張）/ 正しくは / 根拠（自分で確認した内容）/ 出典 / 関連.
4. **Links**: use standard markdown `[text](relative.md)` — never wikilinks `[[ ]]`.
5. **Report, don't commit**: show the user the new file as `ファイル名（相対パス） — title`, and let them review. Do **not** `git commit` (the user controls commits). The vault's `00-Moc/corrections.base` aggregates the note automatically.

## Gotchas

- The filename **must start with the ISO date** (`YYYY-MM-DD-`) so the correction log sorts newest-first.
- You write the note, but the **human verified the error** — never fabricate a correction you cannot back with a real source.
- When invoked from a non-vault project, the vault's rules/templates are **not** in your context. Read them (step 2) before writing; do not guess the format.
- One error = one note. If the user flags several distinct errors, create several notes.
- This skill records the correction; turning repeated corrections into skill gotchas / atomic notes is a separate, later step.
