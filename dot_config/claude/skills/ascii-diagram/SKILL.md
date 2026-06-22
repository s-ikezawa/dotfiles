---
name: ascii-diagram
description: Draw or fix plain-text ASCII diagrams (box-and-arrow, flowcharts, architecture, trees) that stay aligned in any terminal, font, and locale. Use whenever producing ASCII art / diagrams in markdown, docs, or code comments, or when an existing ASCII diagram looks misaligned ("ずれている"). Critical in CJK / Japanese and tmux environments, where Unicode box-drawing characters silently break alignment.
---

# ASCII Diagram (alignment-safe)

The #1 cause of "the diagram is misaligned even with a monospace font" is **using Unicode
box-drawing / arrow characters**. They are *East Asian Ambiguous-width* in Unicode, so a single
glyph is rendered as **1 OR 2 cells** depending on font, terminal, locale, `ambiwidth`, and tmux.
A monospace font does **not** save you — the width itself is ambiguous. This breaks alignment
hard in Japanese/CJK setups and inside tmux (`TERM=screen*`).

## Rule 1 — Use ONLY pure ASCII (0x20–0x7E)

Every printable ASCII character is unambiguously **1 cell** in every font/terminal/locale. Build
diagrams from these only:

```
boxes/lines : + - | _
arrows      : > < ^ v   (and -->  <--  | with v/^ for vertical)
diagonals   : / \
fill/branch : space . : *
```

**Never** use these in a diagram you want to stay aligned (all ambiguous-width):

```
┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼ ─ │ ═ ║   (box-drawing)
▶ ◀ ▲ ▼ → ← ↑ ↓ ⇒ ⇨ ●        (arrows / shapes)
```

Also avoid emoji and `✓ ✅ ⚠️` *inside* the diagram body — many are width-2 and shift columns.
(They're fine in normal prose/tables, just not in aligned ASCII art.)

## Rule 2 — Make every box a true rectangle

Alignment also fails from plain miscounting. Enforce the invariant: for each box,
**top border width == content row width == bottom border width**, counted in cells.

- Interior width = max content length; pad both sides with spaces to that width.
- Keep one vertical "spine" column for connectors and verify every `|`, `v`, `+` junction
  sits on the same column down the whole diagram.

```
+-------------+
|   Service   |   <- content padded to interior width
+------+------+   <- junction '+' on the spine column
       |
       v
+-------------+
```

## Rule 3 — Verify before finishing

Pure-ASCII check (flags any non-ASCII / control byte in the file — if it prints nothing, the
diagram is ambiguous-width-free):

```bash
grep -nP '[^\x09\x20-\x7E]' FILE
```

Rectangle / width check inside Neovim (also proves pure ASCII via `strwidth == byte length`):

```bash
nvim --headless "+lua \
  for _,l in ipairs(vim.fn.readfile('FILE')) do \
    print(string.format('w=%d b=%d %s', vim.fn.strwidth(l), #l, l)) end" "+qa!"
```

Same-shaped rows (a box's top/content/bottom) must report the same `w=`; `w` must equal `b` on
every line. Fix any row where they differ.

## Notes

- **mermaid / graphviz blocks are exempt** — they are source text inside a fenced code block, not
  hand-aligned art, so ambiguous width does not apply. Prefer mermaid for complex graphs and
  reserve hand-drawn ASCII for small, self-contained sketches.
- When *fixing* a misaligned diagram, first run the verify command to see whether the cause is
  non-ASCII characters (Rule 1) or miscounted widths (Rule 2) — then fix that layer.
