# CLAUDE.md

chezmoi で管理する dotfiles リポジトリ。詳細は `README.md` を参照。

## 現在の状態

`before` フェーズ 4 本 + `after` フェーズ 1 本（`run_onchange_after_01-mise-bootstrap.sh.tmpl`）。

after を追加するときは、下の連番ルールを必ず守ること。

## 役割分担（重要）

**パッケージ導入と macOS 設定は mise、設定ファイルの配置は chezmoi。**
`mise bootstrap` は packages / macOS defaults に加えて dotfiles 配置まで機能を持つため、
線を引かないと二重管理になる。

| | 担当 | 実体 |
|---|---|---|
| 言語ランタイム・CLI | mise | `[tools]` |
| formula / cask / mas | mise | `[bootstrap.packages]` |
| `defaults write` | mise | `[bootstrap.macos.defaults]` |
| 設定ファイルの配置 | **chezmoi** | `dot_*` |
| 環境構築スクリプト | **chezmoi** | `run_*` |

**`mise` の `[dotfiles]` は使わない。** テンプレート機能が無く、`.chezmoi.os` による
OS 分岐・`private_` / `executable_` の属性・`run_once_` が書けないため。
Linux でも同じ dotfiles を使う以上、配置は chezmoi が勝つ。

chezmoi が親で、after フェーズから mise を呼ぶ。設定ファイル
（`dot_config/mise/config.toml`）はフェーズ 2 で配置されるので、
それを読む `mise bootstrap` は after にしか置けない。

### mise の brew に寄せるときの制約

mise は `brew` コマンドを呼ばず、Homebrew API から直接取得して `/opt/homebrew` に
展開する**再実装**。そのため次が効かない。

- **`brew services` は未実装。** 常駐サービスが要るものは `[bootstrap.packages]` に置かない
- **cask は app bundle / binary / font / 単純な pkg のみ。** 独自 installer を持つものは失敗する
- **`packages import` は formula 専用。** cask の移行は手書き
- **`packages prune` も cask は限定的**
- app bundle を差し替えると **TCC 権限（アクセシビリティ等）が失効しうる**
- Homebrew 本体は残しておくこと。`brew services` / `brew info` の逃げ道になる

`[bootstrap.macos.defaults]` 側の制約:

- 値の型は **int / bool / string / float のみ**。array / dict / date / data は
  警告付きでスキップされる
- `defaults -currentHost` と sudo が要るシステムドメインは非対応
- **mise はアプリを kill しない。** 反映は `[bootstrap.hooks.post-defaults]` の
  `killall` で自前でやる
- グローバル設定（`~/.config/mise/config.toml`）は trust 不要。
  フックを書いても `mise trust` は要らない（非グローバル設定のみが trust の対象）

## スクリプトの連番ルール（重要）

chezmoi は **属性（`once` / `onchange` / `before` / `after`）を取り除いたターゲット名**で
スクリプトをソートする。そのため**同じフェーズ内で `run_once_` と `run_onchange_` に
別々の連番を振ると、番号を無視して混ざる**。

```
run_once_after_01-homebrew.sh        →  ターゲット名 01-homebrew.sh
run_onchange_after_01-brew-bundle.sh →  ターゲット名 01-brew-bundle.sh

実行順: 01-brew-bundle.sh → 01-homebrew.sh   ← brew が無い状態で bundle が走る
```

### 守ること

- **`run_once_` は必ず `before`、`run_onchange_` は必ず `after`** に置く。
  フェーズが違えば順序は常に before → after で確定するので、
  2 つの家族はそれぞれ **01 から独立に採番**でき、衝突しない
- スクリプトを追加するときは、既存の番号を振り直さず**該当フェーズの末尾に採番**する。
  間に挟む必要がある場合のみ、そのフェーズ内だけで振り直す
- `before` / `after` を**省略しない**。省略すると before でも after でもなく、
  フェーズ 2（ファイル適用）の対象ファイル群と混ざってアルファベット順に実行され、
  実行タイミングが周囲のファイル名に左右される

### フェーズの意味

| フェーズ | 置くもの |
|---|---|
| `run_once_before_NN` | 環境構築（バイナリ導入）。設定ファイルに依存しないもの |
| `run_onchange_after_NN` | 配置済みの設定を読んで適用するもの。冪等に何度でも走る |

`mise install` のように `~/.config/**` を必要とする処理は after にしか置けない。

## zsh の PATH

`.zshenv` と `.zprofile` の**両方**で PATH を組んでいる。片方だけにしないこと。

- macOS の `/etc/zprofile` は `path_helper` を実行し、`.zshenv` で先頭に置いたパスを
  末尾へ回す。そのため `.zprofile`（path_helper の後に読まれる）で並び順を戻す必要がある
- 逆に `.zprofile` だけにすると、ログインシェルにしか効かず**スクリプトから
  GNU 版コマンドや mise のツールが使えなくなる**

実体は `.zshenv` の `_zsh_setup_path()` 1 箇所。`.zprofile` はそれを呼び直すだけ。
PATH を足すときはこの関数を編集する。`typeset -U path` で重複は自動的に消える。

## 前提

**Apple Silicon の macOS のみを対象とする。** Intel Mac（`/usr/local` の Homebrew）への
フォールバックは書かない。Homebrew の prefix は `/opt/homebrew` 決め打ちでよい。

## その他の注意

- **`run_onchange-foo.sh`（ハイフン）は `onchange` として認識されない。**
  ただの `run_` 扱いになり毎回実行される。必ずアンダースコアで書くこと
- `.chezmoitemplates/lib.sh` に `set -euo pipefail` / `ERR` トラップ / `log` / `skip` /
  `load_brew` がある。新しいスクリプトも先頭で `template "lib.sh"` を展開して使う
- macOS 専用の処理は `{{ if eq .chezmoi.os "darwin" }}` で囲む
- `killall` は対象プロセスが居ないと 1 を返す。`set -e` 下では
  `killall X 2>/dev/null || true` にしないとスクリプトが落ちる
- `curl | sh` は必ず `-fsSL` を付ける（`-f` が無いと HTTP エラー本文が sh に流れる）
- **Homebrew の installer は `NONINTERACTIVE=1` のとき `sudo -n`(パスワードを聞かない)で
  権限を確認する。** 認証情報がキャッシュされていないと、管理者であっても
  `Need sudo access on macOS ...` で即 abort する。事前に `sudo -v` で認証しておくこと
- `defaults write` は**ユーザードメイン（`NSGlobalDomain` / `com.apple.finder` /
  `com.apple.dock` / `com.apple.WindowManager` など）なら sudo 不要**。
  実体は `~/Library/Preferences/*.plist` でユーザー所有。
  sudo が要るのは `/Library/Preferences/` 配下や `nvram` / `systemsetup` / `scutil --set` など

## 変更後の確認

```sh
chezmoi execute-template < run_xxx.sh.tmpl | bash -n /dev/stdin   # 構文チェック
chezmoi apply --dry-run --verbose                                 # 実行せず内容と順序を確認
```
