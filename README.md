# dotfiles

macOS の開発環境を [chezmoi](https://www.chezmoi.io/) で管理するリポジトリ。

新しい Mac で 1 コマンド叩けば、Xcode CLT → Homebrew → mise → 各種設定ファイルまで
一通り揃うことを目標にしている。

---

## セットアップ

```sh
curl -fsSL https://raw.githubusercontent.com/s-ikezawa/dotfiles/main/install.sh | bash
```

`install.sh` がやること:

1. Xcode Command Line Tools のインストール（未インストールなら）
2. chezmoi のインストールと `chezmoi init --apply s-ikezawa`

以降は chezmoi が下記のフローを回す。

---

## 反映される流れ

`chezmoi apply`（`chezmoi init --apply` を含む）は、**3 つのフェーズを必ずこの順**で実行する。

```
  ┌─────────────────────────────────────────────────────────────┐
  │ 1. before フェーズ    run_*_before_*                        │
  │    → $HOME にはまだ 1 ファイルも書かれていない              │
  ├─────────────────────────────────────────────────────────────┤
  │ 2. ファイル適用       dot_* / private_* / executable_*      │
  │    → ソースの内容を $HOME に展開（.tmpl はここで評価）      │
  ├─────────────────────────────────────────────────────────────┤
  │ 3. after フェーズ     run_*_after_*                         │
  │    → 全ファイルが $HOME に揃った状態で走る                  │
  └─────────────────────────────────────────────────────────────┘
```

各フェーズ内では **ファイル名のアルファベット順**に実行される。だから
`00-` `10-` `20-` … と数字を振って順序を固定している。

> **before / after を付けないと？**
> `run_once_foo.sh` のように付けない場合、before でも after でもなく
> **フェーズ 2 のファイル群と混ざってアルファベット順**に実行される。
> つまり実行タイミングが周囲のファイル名に左右されるため、このリポジトリでは
> 必ず `before` / `after` を明示する。

### 実際の実行順

| フェーズ | ファイル | 内容 |
|---|---|---|
| before | `run_once_before_01-xdg-dirs.sh.tmpl` | `~/.config` `~/.cache` `~/.local/{share,state,bin}` 配下を作成 |
| before | `run_once_before_02-homebrew.sh.tmpl` | Homebrew 本体 |
| before | `run_once_before_03-mise.sh.tmpl` | mise 本体 |
| before | `run_once_before_04-claude-code.sh.tmpl` | Claude Code |
| 適用 | `dot_*` / `private_*` / `executable_*` | 設定ファイルを `$HOME` に配置（個別のファイルは列挙しない） |
| after | `run_onchange_after_01-mise-bootstrap.sh.tmpl` | `mise install` + `mise bootstrap packages apply` + `mise bootstrap macos defaults apply` |

before で入れたバイナリの上に設定ファイルが配置され、その設定を読んで after が走る、
という 3 段構え。設定ファイルは増えてもこの順序は変わらないので個別には並べない。

after フェーズは `mise bootstrap` の 1 本のみ。これが読む `~/.config/mise/config.toml` は
フェーズ 2 で配置されるため、after にしか置けない。パッケージも macOS 設定も
この 1 ファイルに宣言として集約してあるので、増えてもスクリプトは増えない。

### mise と chezmoi の分担

**パッケージ導入と macOS 設定は mise、設定ファイルの配置は chezmoi。**

| | 担当 | 実体 |
|---|---|---|
| 言語ランタイム・CLI | mise | `[tools]` |
| formula / cask / mas | mise | `[bootstrap.packages]` |
| `defaults write` | mise | `[bootstrap.macos.defaults]` |
| 設定ファイルの配置 | chezmoi | `dot_*` |
| 環境構築スクリプト | chezmoi | `run_*` |

`mise bootstrap` は dotfiles 配置の機能（`[dotfiles]`）も持っているが**使わない**。
テンプレートが無く、`.chezmoi.os` での OS 分岐や `private_` / `executable_` の属性、
`run_once_` が書けないため。Linux でも同じ dotfiles を使う以上、配置は chezmoi が勝つ。

Brewfile は使わない。mise の `brew` / `brew-cask` は Homebrew を呼ばず、
Homebrew API から直接取得して `/opt/homebrew` に展開する再実装なので、
**Homebrew 未インストールでも動く**。ただし `brew services` が未実装、
cask の対応 artifact が限定的、といった制約がある（下の「注意点」を参照）。
Homebrew 本体は逃げ道として残してある。

設定ファイルは zsh と git だけ。nvim / tmux などは必要になった時点で追加していく。

マシン固有の値（コミット用のメールアドレスなど）は `dot_*` ではなく
**chezmoi の data** に置く。詳細は下の「秘密情報とマシン固有の値」を参照。

**フェーズの使い分け**:

- **before = 素の環境を作る**。バイナリを入れるだけで、設定ファイルに依存しないもの。
  `run_once_` なので初回だけ走る
- **after = 配置済みの設定を読んで適用する**。`mise install` は `~/.config/mise/config.toml` が
  無いと何もできないため after にしか置けない。`run_onchange_` なので設定を変えるたびに再適用される

この分け方には副次的な効果がある。**`run_once_` と `run_onchange_` を別フェーズに分離できるので、
それぞれ独立に 01 から採番できる**（理由は次節）。

> ⚠️ before で失敗すると `$HOME` に dotfiles が 1 つも配置されないまま止まる。
> Homebrew や mise のインストールはネットワーク次第で落ちうるので、
> その場合は原因を潰してから `chezmoi apply` をやり直すこと。

---

## 秘密情報とマシン固有の値

**このリポジトリは public。** コミット用のメールアドレスや勤務先のオーガニゼーション名は
`dot_*` に直書きせず、`.chezmoi.toml.tmpl` 経由で
`~/.config/chezmoi/chezmoi.toml`（リポジトリ外）に置く。

```
.chezmoi.toml.tmpl        リポジトリに入る。「どこから値を取るか」だけが書いてある
        ↓ chezmoi init
~/.config/chezmoi/chezmoi.toml   ローカルのみ。ここに実際のアドレスが入る
        ↓ .git.personalEmail / .git.workEmail / .git.workGitdir として参照
dot_config/git/config.tmpl 等
```

値の解決は二段構え。

1. `op`（1Password CLI）があれば `op://Private/git-identity/…` から読む
2. 取れなければ対話プロンプトで聞く（`promptStringOnce`）

**新品の Mac では必ず 2 が走る。** `.chezmoi.toml.tmpl` は `chezmoi init` の最初に
評価されるので、`op` はまだ入っていないし、そもそも 1Password アプリのサインインも
済んでいないため。初回だけアドレスを手で入れれば、あとは自動で埋まる。
2 台目以降や値を変えたいときは `chezmoi init` をやり直せば金庫の内容で上書きされる。

> `.chezmoi.toml.tmpl` は `chezmoi apply` では評価されない。`chezmoi init` 専用。

プロンプトには TTY が要る。TTY の無い環境（CI や、端末を持たないラッパー越しの実行）では
`--promptString` で先に答えを渡す。キーは**プロンプトの文字列そのもの**。

```sh
chezmoi init \
  --promptString '個人用のメールアドレス=you@example.com' \
  --promptString '会社用のメールアドレス（不要なら空）=you@corp.example' \
  --promptString '会社用 gitdir（末尾に / を付ける）=~/Projects/github.com/<org>/'
```

1Password 側に置く項目（vault: Private、item: `git-identity`）:

| フィールド | 中身 |
|---|---|
| `personal-email` | 個人用のコミットアドレス |
| `work-email` | 会社用のコミットアドレス（不要なら作らない） |
| `work-gitdir` | 会社用 identity を使う gitdir（例 `~/Projects/github.com/<org>/`）|

## git の identity

`~/.config/git/config`（XDG）を chezmoi が生成する。`~/.gitconfig` は作らない。

既定は個人用。会社用は `includeIf "gitdir:…"` で切り替わる。判定は ghq のレイアウト
（`~/Projects/<host>/<org>/<repo>`）に依存していて、`ghq get` で取る限り置き場所は勝手に
決まるので、識別が崩れない。

```
~/.config/git/config        既定 = 個人用。chezmoi 管理
        ├─ includeIf gitdir:~/Projects/github.com/<org>/ → config.work  会社用。chezmoi 管理
        └─ include  config.local                                   マシン固有。管理外
```

> ⚠️ `~/.gitconfig` が無いため、**`git config --global` はこの chezmoi 管理ファイルに
> 書き込む**。直接書くと次の `chezmoi apply` で巻き戻る。設定変更は
> `chezmoi edit ~/.config/git/config`、このマシン限りの設定は `config.local` へ。

## ファイル命名規則

chezmoi はファイル名のプレフィックスで挙動を決める。

### 属性プレフィックス

| プレフィックス | 意味 |
|---|---|
| `dot_foo` | `~/.foo` として配置 |
| `private_foo` | パーミッション `0600` で配置 |
| `executable_foo.sh` | 実行ビットを立てて配置 |
| `empty_foo` | 空ファイルでも配置する（通常は削除される） |
| `foo.tmpl` | Go テンプレートとして評価してから配置 |

### スクリプトの再実行タイミング

| プレフィックス | いつ走るか |
|---|---|
| `run_once_*` | **一度だけ**。展開後の内容のハッシュを chezmoi が記録し、同じ内容なら二度と走らない |
| `run_onchange_*` | **内容が変わるたび**。冪等に何度でも適用したいもの（パッケージ一覧・macOS 設定）に使う |
| `run_*`（属性なし） | 毎回走る |

> ⚠️ `run_onchange-foo.sh`（**ハイフン**）は `onchange` として認識されず、
> ただの `run_` 扱いになって毎回実行される。必ずアンダースコアで書くこと。

### 採番のルール

**同じフェーズ内では `run_once_` と `run_onchange_` の連番が混ざる。**
chezmoi は属性（`once` / `onchange` / `before` / `after`）を**取り除いたターゲット名**で
ソートするため、次の 2 つは意図と逆順に実行される。

```
run_once_after_01-homebrew.sh        →  ターゲット名 01-homebrew.sh
run_onchange_after_01-brew-bundle.sh →  ターゲット名 01-brew-bundle.sh

実行順: 01-brew-bundle.sh → 01-homebrew.sh   ← brew が無い状態で bundle が走る
```

そのためこのリポジトリでは **`run_once_` は before、`run_onchange_` は after** と
フェーズごとに分けている。フェーズが違えば順序は常に before → after で確定するので、
**それぞれ 01 から独立に採番でき、後からスクリプトを挟んでも番号を振り直さなくてよい**。

| | 採番 |
|---|---|
| `run_once_before_01` 〜 `04` | 環境構築（バイナリ導入） |
| `run_onchange_after_01` 〜 | 設定の適用（何度でも冪等に走る） |

### `run_onchange_` を外部ファイルの変更に連動させる

`mise install` は `~/.config/mise/config.toml` が変わったときに走ってほしいが、
スクリプト自身は変わらないため、そのままでは再実行されない。
そこで **設定ファイルのハッシュをコメントとして埋め込み**、実質的なトリガにしている。

```
# mise config sha256: {{ include "dot_config/mise/config.toml" | sha256sum }}
```

`config.toml` を編集 → 展開後のスクリプト内容が変わる → chezmoi が再実行する、という仕組み。

---

## 日常の操作

```sh
chezmoi edit ~/.config/zsh/.zshrc   # ソースを編集
chezmoi diff                        # $HOME との差分を確認
chezmoi apply                       # 反映
chezmoi apply --dry-run --verbose   # 実行せず、走るスクリプトの中身を確認

chezmoi add ~/.config/foo/bar       # 新しいファイルを管理下に入れる
chezmoi cd                          # ソースディレクトリへ移動（git 操作用）
chezmoi update                      # git pull してから apply
```

パッケージ・ツールの更新はまとめて mise タスク（`[tasks.up]`）にしてある。

```sh
mise run up   # mise self-update + mise upgrade + mise bootstrap packages upgrade
```

パッケージは mise 管理なので `brew upgrade` は要らない。

パッケージの追加・削除は `config.toml` を直接編集するか、mise に書かせる。

```sh
mise bootstrap packages use -g "brew:ripgrep"        # 追加して即インストール
mise bootstrap packages status                       # 宣言と実機の差分
mise bootstrap packages prune --dry-run              # 宣言から消えたものを確認
mise bootstrap packages import -g --dry-run          # 既存の formula を吸い出す（cask は非対応）
```

`config.toml` を編集したら `chezmoi apply`。sha256 が変わるので
`run_onchange_after_01-mise-bootstrap.sh` が再実行される。

### リモートを SSH に切り替える

`install.sh` の `chezmoi init` は **HTTPS でクローンする**（新しいマシンにはまだ
SSH 鍵が無いため、これは避けられない）。そのままだと `git push` できないので、
1Password と SSH 鍵を用意したあとに切り替える。

```sh
chezmoi cd
git remote set-url origin git@github.com:s-ikezawa/dotfiles.git
```

### `run_once_` をもう一度走らせたい

内容を変えずに再実行したい場合は、記録済みの実行状態を消す。

```sh
chezmoi state dump                                  # 記録内容を確認
chezmoi state delete-bucket --bucket=scriptState    # 全 run_once_ の記録を削除
chezmoi apply
```

---

## 共通ヘルパ

`.chezmoitemplates/lib.sh` に `log` / `skip` / `load_brew` とエラートラップをまとめてあり、
各スクリプトの冒頭でテンプレート呼び出し（`template "lib.sh"`）として展開している。

- `set -euo pipefail` と `ERR` トラップ（失敗したファイル名・行番号・コマンドを表示）
- `load_brew` … `/opt/homebrew/bin/brew shellenv` を評価する。
  インストール直後の同一シェルでも `brew` が使えるようにするため

---

## 注意点

- **macOS の設定は再ログインで反映される**ものがある（キーリピート、Tab でのコントロール移動、
  ライブ変換の無効化など）。Finder / Dock / ステージマネージャは `killall` で即時反映される
- **`mas:` は App Store にサインイン済みであること**が前提。`mas` CLI も別途必要
- **mise の brew は Homebrew の再実装**。次が効かないので注意:
  `brew services` は未実装 / cask は app bundle・binary・font・単純な pkg のみ /
  `packages import` は formula 専用（cask は手書き）/ `packages prune` も cask は限定的 /
  app bundle の差し替えで **TCC 権限が失効しうる**
- **`[bootstrap.macos.defaults]` の値は int / bool / string / float のみ。**
  array / dict / date / data は警告付きでスキップされる。
  `defaults -currentHost` と sudo が要るシステムドメインも非対応
- **mise はアプリを kill しない。** Finder / Dock の反映は
  `[bootstrap.hooks.post-defaults]` の `killall` で自前でやっている
- `defaults write com.apple.finder` などは、実行元ターミナルに**フルディスクアクセス**が
  無いと静かに無視されることがある
- zsh の設定は 4 ファイル構成。

  | ファイル | 役割 |
  |---|---|
  | `dot_zshenv` → `~/.zshenv` | `ZDOTDIR` を設定し、本体を `source` するだけのブートストラップ |
  | `dot_config/zsh/dot_zshenv` → `~/.config/zsh/.zshenv` | 環境変数と PATH。**全てのシェル**で読まれる |
  | `dot_config/zsh/dot_zprofile` → `~/.config/zsh/.zprofile` | PATH の並び順を確定。**ログインシェルのみ** |
  | `dot_config/zsh/dot_zshrc` → `~/.config/zsh/.zshrc` | ヒストリ・補完・キーバインド・プロンプト。**対話シェルのみ** |

  zsh は `.zshenv` を 1 度しか読まないため、`~/.zshenv` の `source` が無いと本体が読まれない
- **`/etc/zshrc` は `~/.zshrc` の直前に読まれ、`HISTFILE` / `HISTSIZE` / `SAVEHIST` /
  `PS1` / `BEEP` / ↑↓ のキーバインドを設定してくる。** つまり黙っていると
  ヒストリは `$ZDOTDIR/.zsh_history`（= `~/.config/zsh/.zsh_history`）に 1000 行だけ残る。
  変えたいものは `.zshrc` で明示的に上書きすること（`setopt no_beep` もこれが理由）
- **zsh が書き出すファイルは XDG に寄せてある。**

  | | 置き場 |
  |---|---|
  | コマンドヒストリ | `$XDG_STATE_HOME/zsh/history` |
  | 補完のキャッシュ | `$XDG_CACHE_HOME/zsh/zcompdump`、`$XDG_CACHE_HOME/zsh/zcompcache` |
  | less のヒストリ | `$XDG_STATE_HOME/less/history`（`LESSHISTFILE`。既定は `~/.lesshst`）|

  ディレクトリは `run_once_before_01-xdg-dirs.sh` が掘るが、`.zshrc` 冒頭にも
  ガード付きの `mkdir` がある。無いとヒストリが黙って捨てられるため
- `compinit` は 24 時間以内に `zcompdump` を作っていれば `-C` で `fpath` の再検証を飛ばす。
  補完関数を追加したのに補完が出ないときは `rm $XDG_CACHE_HOME/zsh/zcompdump` して開き直す
- **`LANG` は `.zshenv` で `en_US.UTF-8` に固定している。** `/etc/zprofile` は `LANG` が
  空のときだけ `C.UTF-8` を入れるが、それはログインシェルのみ。
  非ログインシェルが `LANG` 無しになるとマルチバイトの扱いが壊れる
- **PATH を `.zshenv` と `.zprofile` の両方で組んでいる理由**:
  macOS の `/etc/zprofile` は `path_helper` を実行して `/etc/paths` と `/etc/paths.d/*` から
  PATH を作り直し、**`.zshenv` で先頭に置いたパスを末尾へ回してしまう**。
  ターミナルの新規タブはログインシェルなので、これをそのままにすると
  `/usr/bin` が mise の shims や GNU 版コマンドより先に来る。

  ```
  /etc/zshenv → ~/.zshenv → /etc/zprofile(path_helper) → ~/.zprofile → ~/.zshrc
                   ↑ ここで組む        ↑ 並びを壊される      ↑ ここで戻す
  ```

  そこで `.zshenv` で `_zsh_setup_path()` を定義して 1 度呼び、`.zprofile` から
  もう一度呼んで順序を戻している。`typeset -U path` により重複は自動で消える。
  Homebrew が `brew shellenv` を `~/.zprofile` に書くよう案内しているのも同じ理由
- **`.zshenv` 側にも PATH を置いているのは、スクリプト（非ログイン・非対話シェル）でも
  GNU 版コマンドや mise のツールを使うため。** `.zprofile` だけだとログインシェルにしか効かない。
  ただし zsh 以外から起動されたプロセスは親の PATH を引き継ぐだけなので、この限りではない
- GNU 版コマンドは `$HOMEBREW_PREFIX/opt/*/libexec/gnubin` を glob で拾っている。
  `brew install coreutils gnu-sed grep findutils` などを入れれば、
  `ls` / `sed` / `grep` が BSD 版ではなく GNU 版で解決される
- 旧環境で `/etc/zshenv` に `ZDOTDIR` を書いている場合、そちらが先に効くため
  `~/.zshenv` は読まれない（結果は同じなので実害は無い）。新しいマシンでは
  `/etc/zshenv` が空なので `~/.zshenv` 経由で解決される
