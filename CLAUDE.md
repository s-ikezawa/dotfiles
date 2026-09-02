# CLAUDE.md

chezmoi で管理する dotfiles リポジトリ。詳細は `README.md` を参照。

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
| マシン固有の値・秘密 | **chezmoi の data** | `.chezmoi.toml.tmpl` |

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

## zsh の対話設定

`/etc/zshrc` は `~/.zshrc` の**直前**に読まれ、`HISTFILE` / `HISTSIZE` / `SAVEHIST` /
`PS1` / `BEEP` / ↑↓ のキーバインドを設定してくる。これらを変えるには `.zshrc` での
明示的な上書きが要る（消す手段は無い）。

zsh が書き出すものは XDG に寄せてある。追加するときも同じ方針で。

| | 置き場 | 決めているもの |
|---|---|---|
| ヒストリ | `$XDG_STATE_HOME/zsh/history` | `.zshrc` の `HISTFILE` |
| compdump / compcache | `$XDG_CACHE_HOME/zsh/` | `compinit -d` と `cache-path` zstyle |
| less のヒストリ | `$XDG_STATE_HOME/less/history` | `.zshenv` の `LESSHISTFILE` |

ディレクトリは `run_once_before_01-xdg-dirs.sh` と `.zshrc` 冒頭のガード付き `mkdir` の
二重で用意している。`run_once_` は初回しか走らないので、`.zshrc` 側を消さないこと。

## zsh プラグイン

プラグインマネージャは**使わない**。実体は mise の `[bootstrap.packages]` の
`brew:` formula（`zsh-completions` / `zsh-autosuggestions` /
`zsh-syntax-highlighting` / `fzf-tab`。4 つとも依存ゼロの bottle）で、
`.zshrc` から直接 `source` する。

sheldon を使っていない理由は 2 つ。配布バイナリが Homebrew の `openssl@3` に
動的リンクしていて単体では起動しない（formula で入れると `libgit2` / `libssh2` も
付いてくる）こと、そして読み込み順の制約が強く、順序を 1 ファイルに並べたほうが
追いやすいこと。

### 読み込み順（崩すと壊れる）

```
fpath に share/zsh-completions を足す   ← compinit より前
compinit
fzf-tab                                 ← compinit の後。補完ウィジェットを置き換える
fzf --zsh                               ← ウィジェットを定義する側。包む側より先
zoxide init                             ← compdef を使うので compinit の後
zsh-autosuggestions                     ← 既存ウィジェットをラップする
zsh-syntax-highlighting                 ← 他プラグインのウィジェットも包むので必ず最後
```

`fzf --zsh` は `^I` を `fzf-completion` に奪うが、読み込み時点の `^I` バインドを
`fzf_default_completion` として控え、`**` トリガが無いときはそこへ委譲する。
fzf-tab を先に読んでいるので、素の Tab は fzf-tab、`**`+Tab は fzf のパス補完になる。

`zsh-syntax-highlighting` を確実に最後にするため、プラグイン節は
**プロンプト節より後（ファイル末尾）**に置いている。`bindkey` と
`zle -N`（↑↓ の検索ウィジェット）は、ラップされる側なのでプラグインより前に置く。

- **`zstyle ':completion:*' menu select` は使えない。** fzf-tab が候補を横取り
  できなくなるため `menu no` にしてある
- fzf は zsh プラグインではなくバイナリなので mise の `[tools]`。
  キーバインドは `fzf --zsh`（0.48 以降は本体が吐く）
- fzf の候補列挙は `FZF_DEFAULT_COMMAND` で `fd` に差し替えてある。既定の `find` だと
  `node_modules` や `.git` まで舐める。`FZF_*` を `.zshenv` ではなく `.zshrc` に
  置いているのは、Ctrl-T / Alt-C の設定と並べて読めるようにするため
- 検索は 2 系統ある。**Ctrl-T が「ファイル名」（fzf + fd）、Ctrl-G が「中身」
  （fzf + rg）**。Ctrl-G は fzf 側の絞り込みを `--disabled` で切り、入力のたびに
  `change:reload` で rg を回し直す。fzf に全行を食わせるのではなく、検索そのものを
  rg にやらせる形（fzf 公式の ripgrep 連携と同じ組み方）。`^G` の既定は
  `send-break` だが、中断は `^C` が残るので潰している
- 各 `source` は `[[ -r … ]]` で守る。`mise bootstrap` 前のマシンでも
  `.zshrc` が壊れないようにするため

### compinit の insecure directories

`fpath` に入れたディレクトリ**とその親**が group 書き込み可だと、`compinit` は
`[ynq]` を対話で聞いてくる。Homebrew の `/opt/homebrew/share` は既定で 775 なので、
`share/zsh-completions` を `fpath` に足した時点で該当する
（`share/zsh/site-functions` は親が `share/zsh`(755) なので元から無関係）。

`run_onchange_after_01-mise-bootstrap.sh` で `chmod g-w /opt/homebrew/share` して回避
している。`compinit -u`（検査ごと省略）には**しない**。同スクリプトは
`zcompdump` も消す。`.zshrc` が 24 時間以内のダンプを `-C` で使い回すため、
消さないと入れたばかりの補完が最大 1 日出てこない。

## コンテナ（colima / docker）

Docker Desktop は使わない。colima が lima 上に建てた VM の中で docker daemon を
動かし、ホストからは docker CLI だけで喋る。

| | 実体 |
|---|---|
| lima / colima / docker-cli / docker-compose | mise の `[tools]` |
| VM の設定 | chezmoi の `dot_config/colima/_templates/default.yaml.tmpl` |
| `DOCKER_CONFIG` | `.zshenv`（`$XDG_CONFIG_HOME/docker`） |

起動は手動（`colima start`）。常駐させていない。

### テンプレートが効くのは初回だけ

`_templates/default.yaml` は**新規インスタンスの雛形**で、初回の
`colima start` で `~/.config/colima/default/colima.yaml` に写される。以後はそちらが
優先され、テンプレートを直しても反映されない。**起動に失敗した試行でも写される**ので、
設定を間違えたまま起動すると、直した後も古い値で失敗し続ける。

作り直すには `colima delete` してから `colima start`。既存 VM の値を変えたいだけなら
`~/.config/colima/default/colima.yaml` を直接編集する（chezmoi 管理外）。
`mountType` と `runtime` と `arch` は VM 作成後に変更できない。

### マウント（devcontainer が壊れる主因）

- **`mounts` を書くと既定は消える。** colima の既定は「`$HOME` を writable で 1 つ」
  だけで、`mounts` に書いたものが全てになる（追加ではない）。Docker Desktop が
  `/Users` `/private` `/var/folders` `/tmp` をまとめて共有するのとは前提が違う
- **VM から見えないホストパスを bind mount してもエラーにならない。** 空ディレクトリが
  生えるだけなので、「コンテナの中に何も無い」という気づきにくい壊れ方をする
- **ホストの `/tmp` は VM の `/tmp`。** `/tmp` は lima が使うのでマウントしてはいけない。
  `realpath` 済みの `/private/tmp` を通してある（`docker run -v /tmp/x:/x` は VM 側の
  `/tmp` を見る、と実測で確認した）
- **`location: ~` は書けない。** YAML では `~` は null なので location が空になり、
  `overlapping mounts not supported: '' overlaps ...` で起動に失敗する。
  chezmoi に絶対パスを展開させている
- 現在通してあるのは `$HOME`（ソースコード）、`/var/folders`（macOS の `$TMPDIR`）、
  `/private/tmp` の 3 つ。VM 内でも同じパスにマウントされる
- コンテナ内のファイル所有者は `0:0` に見え、**非 root（devcontainer が使う uid 1000）
  でも書ける**（実測）。ホスト側の uid を合わせる小細工は要らない

### 環境変数

- **`DOCKER_CONFIG` は `colima start` より前に効いている必要がある。** colima は起動の
  たびに docker context を作って active にするが、書き込み先はこの変数で決まる。
  未設定のまま起動すると `~/.docker` 側に context ができ、後から XDG に寄せた瞬間に
  context を見失う
- **`LIMA_HOME` を export してはいけない。** colima は自分の VM を `$COLIMA_HOME/_lima`
  に作るが、環境に `LIMA_HOME` があるとそちらを見に行き `colima is not running` になる
- **`~/.colima` を作らないこと。** 存在すると XDG 配下ではなくそちらが使われる
  （場所は `colima template --print` で確認できる）
- `DOCKER_HOST` は設定していない。docker CLI は context から socket を見つけるし、
  設定すると context より優先されて `docker context ls` が警告を出す。context を
  読まないツール（Testcontainers など）を使うときに、socket の存在を見て足す

### amd64 イメージ

`rosetta: true` にしてある。Rosetta 2 本体は `run_once_before_05-rosetta.sh` が
`softwareupdate --install-rosetta --agree-to-license` で入れる（`softwareupdate` は
root が要るので、02-homebrew と同じく先に `sudo -v` で認証する）。

mise の postinstall ではなく before フェーズのスクリプトにしているのは、
mise が管理するパッケージではないこと、postinstall は colima を上げ直すたびに
走ること、after フェーズで sudo を求めると `mise install` のログに埋もれること、
の 3 点による。

Rosetta が無くても qemu の binfmt に落ちて動く（`--platform linux/amd64` で
`uname -m` が `x86_64` になる）が、実測で 2 倍以上遅い。

**VM は作成・起動時に Rosetta を掴む。** 後から入れたときは `colima restart` するまで
qemu のままになる（`colima ssh -- ls /proc/sys/fs/binfmt_misc/` に `rosetta` が
現れるかで判別できる）。

## 秘密情報とマシン固有の値

**このリポジトリは public。** メールアドレス・勤務先のオーガニゼーション名・
ホスト名など、書いた瞬間に公開されるものを `dot_*` に直書きしないこと。

置き場は `.chezmoi.toml.tmpl` → `~/.config/chezmoi/chezmoi.toml`（リポジトリ外）。
値の解決は「`op` があれば 1Password、無ければ対話プロンプト」の二段構え。

```
{{ if lookPath "op" }} … op read … {{ end }}   ← 空ならプロンプトへフォールバック
```

- **`.chezmoi.toml.tmpl` が評価されるのは `chezmoi init` のときだけ。**
  `chezmoi apply` では評価されない。値を変えたいときは `chezmoi init` をやり直す
- **`run_once_before_` より前に評価される。** つまり `op` は常に「まだ入っていない」。
  新品の Mac では 1Password アプリのサインインも未了なので、初回は必ず
  プロンプト側が走る。これは避けられないので、フォールバックを消さないこと
- `op read` は `sh -c '… || true'` で包む。`output` は非 0 終了でテンプレート全体を
  落とすため、未サインインや項目名変更で `chezmoi init` が死ぬのを防ぐ
- `lookPath` は見つからないとき**エラーにせず空文字**を返す（分岐に使ってよい）

## git

- 設定は `~/.config/git/config`（XDG）。**`~/.gitconfig` は作らない。**
  両方あると `~/.gitconfig` が後勝ちになる
- `~/.gitconfig` が無いと **`git config --global` の書き込み先が
  chezmoi 管理下の `~/.config/git/config` になる。** 直接書くと次の apply で
  巻き戻るので、`chezmoi edit` かマシン固有の `config.local` を使うこと
- **フックは `core.hooksPath` で `~/.config/git/hooks` に集約している。** chezmoi が配る
  `pre-commit` が betterleaks（gitleaks の作者が作り直したもの）でステージ済みの差分を
  見る。public リポジトリに秘密を入れない運用を機械で担保するのが目的で、
  エージェントにコミットさせる場合も同じように効く。
  代償として**各リポジトリの `.git/hooks` は読まれなくなる**（リポジトリ側で
  `core.hooksPath` を設定するツール、たとえば husky はローカル設定が勝つので影響しない）。
  誤検出は該当行の `betterleaks:allow` コメントか `.betterleaksignore` で抑える
- identity は個人用が既定で、会社用は `includeIf "gitdir:…"` で切り替える。
  判定に使うパスは ghq のレイアウト（`~/Projects/<host>/<org>/<repo>`）前提。
  パスもアドレスも data 由来なので、勤務先が分かる文字列はリポジトリに残らない
- `gitdir:` の**末尾のスラッシュは必須**。無いとそのディレクトリ自体にしか効かない
- `dot_config/git/config.work.tmpl` は会社用アドレスが空だと**何も出力しない**。
  chezmoi は出力が空のテンプレートをファイルとして作らない（`empty_` 属性が無い場合）

## Claude Code

設定は `dot_config/claude/settings.json.tmpl` → `~/.config/claude/settings.json`。
置き場が `~/.claude` ではなく XDG なのは `.zshenv` の `CLAUDE_CONFIG_DIR` による。

- **`settings.json` は chezmoi 管理下。** `/permissions` などから書き換えると次の
  `chezmoi apply` で巻き戻る。変更は `chezmoi edit` で行う（git config と同じ罠）
- `permissions` は `defaultMode: auto` を邪魔しない範囲に留めてある。allow は書かず、
  `deny` は秘密の読み出し（`.env` 系と `~/.ssh`）だけ。auto でも触らせないための最低限
- `additionalDirectories` に `~/.config` を入れてある。chezmoi のソースで作業しながら
  **配置先**を読む場面が常にあるため。パスは絶対パスで展開している
  （`~` が解釈されるか確認できなかったため）
- `env` の `BASH_DEFAULT_TIMEOUT_MS` / `BASH_MAX_TIMEOUT_MS` は、VM の起動や bottle の
  ダウンロードが既定の 2 分に収まらないので伸ばしてある
- グローバルの `~/.config/claude/CLAUDE.md` は**毎セッション読み込まれる**ので、
  無いと困る指示だけを置く。見出しや「ここには何を書く」といった人間向けの説明は
  書かない（読むのはモデルで、そのぶんコンテキストを食う）。
  リポジトリ固有の事情はそれぞれの CLAUDE.md へ

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
- **リポジトリ内では mise の shim が落ちうる。** mise は親を遡って `mise/config.toml`
  を探すため、ソースの `dot_config/mise/config.toml` をプロジェクト設定として拾い、
  trust が要る内容（postinstall / tasks）なので untrusted エラーで `rg` / `fd` /
  `eza` / `docker` などが軒並み失敗する。`run_onchange_after_01-mise-bootstrap.sh` の
  先頭で `mise trust --ignore` している。**`mise install` より前**に置くこと
  （install は対象の設定を自動で trust するため）。
  `settings.ignored_config_paths` は設定ファイル経由では効かなかった
- **AWS CLI の設定は `~/.aws` のまま。** このリポジトリは XDG に寄せる方針だが、
  ここは例外。`AWS_CONFIG_FILE` で移せても、SDK や terraform のように環境変数を
  継がずに `~/.aws/config` を直接読む経路があり、設定が二重化するため。
  プロファイル（SSO の開始 URL・アカウント ID・ロール名）は勤務先が分かる情報なので
  **リポジトリでは管理しない**。各マシンで `aws configure sso` を実行して作り、
  認証は `aws sso login`。アクセスキーは置かない
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
