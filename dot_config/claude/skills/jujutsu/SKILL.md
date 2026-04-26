---
name: jujutsu
description: Use ONLY when the current repo has a `.jj/` directory, OR the user explicitly mentions "jj" / "jujutsu" / "colocate" / `jj <subcommand>` (`jj log`, `jj new`, `jj squash`, `jj rebase`, `jj op restore`, `jj absorb`, etc.). Maps Git habits to jj equivalents and explains jj's working-copy-as-commit, change-id vs commit-id, conflict-as-data, and operation-log model so the agent picks the right command instead of falling back to Git inside a jj-managed repo.
---

# Jujutsu (jj) — Bash-first guide

Jujutsu is a Git-compatible VCS. This skill exists because jj's mental model differs from Git, and mixing `git` mutations into a jj-managed repo can desynchronize state. Always invoke `jj` via the `Bash` tool — there is no SDK to import.

> **Targeted at jj v0.40+.** The `bookmark` subcommand was previously called `branch` (renamed in v0.21); ignore old tutorials that say `jj branch`.

## When to use

- The repo has a `.jj/` directory (colocated repos also have `.git/` — check `.jj/` first).
- The user names a `jj …` operation explicitly.
- The user wants to undo, reorder, split, squash, or absorb history non-destructively.
- The user wants to colocate Git + jj into an existing Git repo.

## When NOT to use

- Pure Git repos with no `.jj/` and no explicit "jj"/"jujutsu" request — keep using Git. (Phrases like "split this commit" alone do not trigger this skill in a Git repo.)
- PR creation, code review, CI status — those are not jj concerns.

## Preflight (run once at task start)

The output dictates which commands are safe.

```bash
test -d .jj && echo "jj-managed" || echo "not-jj"
test -d .git && test -d .jj && echo "colocated"   # both present
jj --version 2>/dev/null || echo "jj not installed"
jj config get user.email 2>/dev/null || echo "user.email NOT set — jj git push will refuse"
```

If `jj` is missing, tell the user. Do not install it without permission. If `user.email`/`user.name` are unset, ask the user once, then `jj config set --user user.name "…"` / `... user.email "…"`.

## Core mental model (read before issuing commands)

Five points cover ~90% of the friction:

1. **The working copy *is* a commit.** Every edit is auto-snapshotted into the current change `@` on the next `jj` command. There is no `git add` and no "dirty tree" error. There is no `git stash` either — `jj new` snapshots the current edits into the existing `@` (they stay safely in that change) and starts a fresh empty `@` on top, so nothing is lost.
2. **Change ID ≠ commit ID.** A change keeps the same change-id across rebases/amends; the commit-id changes. Reference revisions by the colored letters in `jj log`, or by symbols: `@` (working copy), `@-` (parent), `@+` (child), `trunk()`, bookmark names, etc.
3. **Conflicts are first-class data.** `jj rebase` never stops mid-way. Conflicted files are committed in a conflict state and propagate to descendants until you resolve them. Resolution = run `jj resolve` (launches the merge tool) or just edit the file and run any `jj` command — the snapshot picks up the resolved content.
4. **Operation log is the safety net.** Every state change is recorded in `jj op log`. `jj undo` reverses the last operation; running it again undoes the operation *before* that, and `jj redo` walks forward. `jj op restore <op-id>` jumps to any prior state. This is the right tool for "I broke something" — not `git reflog`/`git reset`.
5. **Bookmarks, not branches.** A `bookmark` is a movable name pointing at a change. Anonymous heads are normal — you don't have to name every line of work.

## Revset essentials

Almost every jj command takes a revset. Minimum vocabulary:

| Revset | Meaning |
|---|---|
| `@` / `@-` / `@+` | working copy / its parent / its child |
| `trunk()` | the configured trunk (typically `main`/`master`) |
| `mine()` | changes you authored |
| `description("text")` | changes whose description matches |
| `x..y` | ancestors of `y` not in `x` (like Git `x..y`) |
| `x::y` | DAG range, inclusive |
| `roots(x)` / `heads(x)` | endpoints of a set |
| `~x` | negation |

`trunk()` resolves via the `revset-aliases.'trunk()'` config; out of the box it picks `main`/`master`/`trunk` from the default Git remote. If `jj log -r 'trunk()'` errors out *or returns nothing*, `trunk()` isn't resolvable yet — `jj git fetch` first, or set the alias explicitly with `jj config set --repo "revset-aliases.'trunk()'" "<bookmark>"`.

## Git ↔ jj cheat sheet

| Intent | Git | jj |
|---|---|---|
| Status | `git status` | `jj st` |
| History | `git log --oneline --graph` | `jj log` (default revset) or `jj log -n 10` |
| Start new work | `git checkout -b feat` | `jj new` then optionally `jj bookmark create feat -r @` |
| Edit message | `git commit --amend -m …` | `jj describe -m …` |
| Stage + commit | `git add -A && git commit -m …` | `jj commit -m …` (finalizes `@`, opens a fresh empty `@` on top) |
| Move some changes into parent | `git commit --fixup` + autosquash | `jj squash` (whole change) or `jj squash -i` (interactive hunks) |
| Absorb pending edits into the right ancestor | manual fixups | `jj absorb` |
| Split a commit | `git rebase -i` + `edit` | `jj split` |
| Reorder | interactive rebase | `jj rebase -r <change> -o <new-parent>` |
| Drop the working-copy change but keep its diff in the parent | `git reset --soft HEAD^` | `jj squash` (folds `@` into `@-`, leaves `@` empty) |
| Drop a change entirely | `git reset --hard HEAD^` | `jj abandon <change>` |
| Undo last operation | `git reflog` + reset | `jj undo` (repeat to walk further back; `jj redo` reverses) |
| Switch to another change | `git checkout <sha>` | `jj edit <change>` (resume editing) or `jj new <change>` (start fresh on top) |
| Stash | `git stash` | *(not needed — just `jj new` to start something else)* |
| Push branch | `git push -u origin feat` | `jj git push --bookmark feat` |
| Push without a named bookmark | — | `jj git push -c @` (auto-creates a `push-<change-id>` bookmark; the template is configurable via `templates.git_push_bookmark`) |
| Push every already-tracked bookmark | `git push` | `jj git push` (with no `--bookmark`/`-c`/`--all`, pushes tracked bookmarks reachable from `@`) |
| Fetch | `git fetch` | `jj git fetch` |
| Show a commit | `git show <sha>` | `jj show <change>` |
| Show working-copy diff | `git diff` | `jj diff` (defaults to `-r @` = changes in `@` vs its parent — i.e. what you've edited) |
| Inspect a change's evolution | `git reflog` for that ref | `jj evolog -r <change>` |

## Common workflows

### Inspect a repo

```bash
jj st                    # working copy + parent summary
jj log -n 10             # last ~10 changes leading to @
jj log                   # default revset (recent + bookmarks + @)
jj op log -n 10          # recent operations (for undo planning)
```

### Make a change

```bash
# Edit files normally — no `add` step
jj describe -m "Fix null deref in parser"   # set message on current change @
jj new                                       # start a fresh empty change on top
```

If the user prefers Git-style "code first, message after":

```bash
# Edit files
jj commit -m "Fix null deref in parser"   # finalizes @, opens new empty @ on top
```

### Amend / split / squash / absorb

```bash
jj squash                # fold @ into @-; if both have descriptions, jj opens an editor to merge them — pass -m "msg" to skip
jj squash -i             # pick hunks interactively
jj split                 # split @ into two changes (interactive)
jj split -r <change>     # split a non-working-copy change
jj absorb                # auto-distribute pending edits to the changes that introduced those lines
```

### Rebase (never stops on conflicts)

`jj rebase` has three "what to move" flags and three "where to move it" flags. In v0.40 the canonical destination flag is `-o`/`--onto`; `-d`/`--destination` is still a documented alias of the same flag (use whichever — `-o` matches the help text).

```bash
jj rebase -o main                  # default selector is `-b @`, so this rebases @'s whole branch onto main
jj rebase -s <change> -o main      # move <change> + descendants
jj rebase -r <change> -o <parent>  # move just <change>, leaving descendants in place
```

If conflicts result, `jj st` lists them. Resolve by either:

```bash
jj resolve            # launch configured merge tool
# OR edit files manually, then any jj command snapshots the resolution
```

### Undo / recover

```bash
jj undo                   # reverse the last operation (run again to go further back)
jj redo                   # step forward after undo
jj op log                 # find the operation id you want to return to
jj op restore <op-id>     # jump entire repo state back to that op
```

All four are local and reversible — they do not touch the remote.

### Colocate jj into an existing Git repo

```bash
jj git init --colocate    # adds .jj/ alongside .git/, imports current state
```

Non-destructive but adds `.jj/` to the working tree. Confirm with the user before running, and have them either gitignore `.jj/` globally or accept the colocated layout.

> Alternative: from outside an existing Git repo, `jj git init --git-repo <path>` creates a non-colocated jj repo backed by that Git repo.

### Push to a Git remote

```bash
jj bookmark set feat -r @          # point bookmark at @, creating it if missing
                                   # (add --allow-backwards only when intentionally moving an existing bookmark backwards)
jj git push --bookmark feat        # push that bookmark; before mutating the remote, jj runs safety checks
                                   # similar to `git push --force-with-lease`

# Or, in one step, auto-create a bookmark from the change-id:
jj git push -c @                   # creates `push-<changeid>` and pushes it
```

## Working inside Claude Code

`jj` has several editor-launching subcommands. In a Claude Code session there is no interactive editor available — they will block. Subcommands that may open `$EDITOR`:

- `jj describe` (no `-m`)
- `jj commit` (no `-m`)
- `jj squash` *when both `@` and `@-` have non-empty descriptions* (jj asks for a combined message)
- `jj split -i`, `jj squash -i`, `jj diffedit`
- `jj resolve` when no merge tool is configured

**Always prefer non-interactive forms:**

- Pass `-m "msg"` to `describe` / `commit` / `squash`.
- Use `jj squash` (non-interactive, whole change) unless the user is driving.
- For interactive hunk splits, ask the user to run the command themselves with `! <command>` rather than running it from the agent.

## Safety rules

These mirror the host instructions on risky actions.

**Free to run without asking** (all local, all reversible via op log):

- Read-only: `jj st`, `jj log`, `jj diff`, `jj show`, `jj evolog`, `jj op log`
- Edits to the working copy or non-immutable history: `jj describe`, `jj new`, `jj commit`, `jj squash`, `jj split`, `jj absorb`, `jj rebase` (when the target revset stays inside non-immutable, non-pushed changes)
- The safety net itself: `jj undo`

**Confirm before running:**

- `jj abandon <change>` when the user has not explicitly told you to drop that change.
- `jj op restore <op-id>` — it can rewind past work. Show `jj op log -n 20` first and confirm the target.
- `jj rebase` whose target revset includes a bookmark already pushed to a remote — moving it will require a force-push later.
- Any `jj git push` — it mutates a shared remote. Before pushing, preview what will go out with `jj log -r 'remote_bookmarks()..@'`. Never push to `main`/`master` without explicit instruction.
- A `jj rebase` whose target revset overlaps already-pushed work. Check first with `jj log -r '<target-revset> & remote_bookmarks()'` — if it returns anything, the rebase will require a force-push later, so confirm with the user before running.
- Any command with `--ignore-immutable` (note: this flag *allows rewriting trunk-reachable history*; it has nothing to do with hooks).

**Never:** edit `.jj/` by hand; in a colocated repo, run `git rebase` / `git commit --amend` / `git reset` (use the jj equivalents — read-only Git commands like `git log`, `git show`, `git status` are fine); pass `--ignore-immutable` without explicit user permission.

## Troubleshooting

**"Working copy not snapshotted"** — benign. jj auto-snapshots on the next command. Run `jj st` once if `jj log` looks stale.

**"Cannot rebase: change is immutable"** — by default, anything in `immutable_heads()` (defaults to `trunk()` and ancestors) can't be rewritten. Either rebase on top of trunk instead, or — only with explicit user permission — pass `--ignore-immutable`.

**Conflict markers in a file after rebase** — open the file, resolve the `<<<<<<<` markers, then run any `jj` command (e.g. `jj st`) to snapshot the resolution. Or run `jj resolve` for the configured merge tool.

**"I ran the wrong command"** — `jj undo`. If the wrong command was several operations ago, `jj op log` then `jj op restore <op-id>`. Both are local-only.

**Old tutorials show `jj branch …`** — replace with `jj bookmark …`. Renamed in v0.21+.

**`jj git push` errors about untracked bookmarks** — first time pushing a new bookmark, jj asks you to track it. `jj git push --bookmark <name>` will offer to create the tracking; accept, or run `jj bookmark track <name>@<remote>` after a fetch.

## Related

- Official docs: <https://jj-vcs.github.io/jj/latest/>
- CLI reference: <https://docs.jj-vcs.dev/latest/cli-reference/>
- Revsets: <https://docs.jj-vcs.dev/latest/revsets/>
- Tutorial (offline): `jj help -k tutorial`
- Git compatibility notes: `jj help git`
