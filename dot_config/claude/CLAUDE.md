# Communication

- Write everything addressed to the user in Japanese: answers, explanations, questions, and confirmations.
- Ask the user only one thing at a time: one question, one confirmation, or one instruction
  (e.g. a command for them to run). Wait for the reply before the next one.
  Reason: several at once force the user to scroll, and when a command they ran gives an
  unexpected result, going back to find which step it was is tedious.
  Only after the reply move on; if the remaining items depend on it, adjust them first.

# Shell tools

These tools are installed via mise. Prefer them over the classic equivalents in Bash.

- Text search: `rg`, not `grep -r`. It skips files ignored by `.gitignore` and hidden files;
  add `--hidden` or `-uu` when searching dotfiles or ignored paths (e.g. `.github/`, build output).
- File search: `fd`, not `find`. Same default as rg (respects `.gitignore`, skips hidden);
  use `-H` for hidden and `-I` for ignored files. Note the argument order: `fd <pattern> [dir]`.
- JSON: `jq`. Combine with `gh ... --json <fields> --jq <expr>` rather than parsing text output.
- YAML / TOML / XML: `yq` (mikefarah v4, jq-like syntax), not sed/awk/python.
  TOML input needs `-p toml`; add `-oy` for YAML output or `-o toml` to keep TOML.
- GitHub: `gh` (authenticated) instead of curl or web fetch for repos, PRs, issues, CI logs, and `gh api`.
- Local clones: repositories live under `ghq root` (`~/Projects/<host>/<owner>/<repo>`);
  find one with `ghq list -p | rg <name>` before cloning anything.

Do not use `bat`, `eza`, or `delta` for your own output: they are for interactive use, and their
colors and decorations only add noise. Use plain `cat`/`sed -n`, `ls`, and `git diff`.
