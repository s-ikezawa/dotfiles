# =============================================================
#  エイリアス定義
# =============================================================
#  .zshrc から読み込まれる。定義が増えても .zshrc を汚さないよう分離した。

# -------------------------------------------------------------
# eza(モダンな ls / tree)
# -------------------------------------------------------------
# 共通で付けているオプション:
#   --group-directories-first ディレクトリを先頭にまとめる。
#   --git                     Git の追跡状態を列で表示(eza が +git ビルドのとき)。
#   --time-style=long-iso     時刻を 2026-07-21 14:27 形式に固定する。
#                             既定は「半年以上前は年、それ以外は時刻」と表示が
#                             揺れるため、桁を揃えて読みやすくする。
#
# eza が未導入のマシン(mise install 前など)では何も定義せず、
# 標準の ls にフォールバックする。
if (( $+commands[eza] )); then
  typeset -ga _EZA_OPTS=(--group-directories-first)

  # --- eza 0.23.x の 2 つの不具合を吸収するラッパー -----------
  # eza 0.23.5 で確認した挙動:
  #
  #  (1) パス引数が無く、かつ出力先が端末でないとき、終了コード 0 のまま
  #      何も出力しない。`ls | grep foo` が無言で空になり、grep が
  #      ヒットしなかったのか eza が出力しなかったのか区別できない。
  #      → https://github.com/eza-community/eza/issues/1568 (未修正)
  #
  #  (2) --icons=auto が実端末でもアイコンを表示しない。本来 auto は
  #      「stdout が端末のときだけ表示」の意味だが機能していない。
  #      always のみ効く(--color=auto は同条件で正しく機能する)。
  #
  # どちらも「eza 自身の端末判定に任せられない」という一点に帰着するため、
  # ここで [[ -t 1 ]] を見て明示的に振り分ける。
  # 上流が修正されたらこの関数を削除し、単純な alias に戻してよい。
  _eza() {
    local a
    if [[ -t 1 ]]; then
      # 端末に出力: アイコンを付ける。引数はそのまま渡す。
      command eza --icons=always "$@"
      return
    fi
    # パイプ・リダイレクト: アイコンは付けない(ファイル名が汚れるため)。
    for a in "$@"; do
      # 実在するパスを指す引数が既にあるなら (1) の補完は不要
      [[ $a != -* && -e $a ]] && { command eza --icons=never "$@"; return }
    done
    command eza --icons=never "$@" .
  }

  ls()   { _eza $_EZA_OPTS "$@" }
  ll()   { _eza $_EZA_OPTS --long --header --git --time-style=long-iso "$@" }
  la()   { _eza $_EZA_OPTS --long --header --git --time-style=long-iso --all "$@" }
  lt()   { _eza $_EZA_OPTS --tree --level=2 "$@" }
  tree() { _eza $_EZA_OPTS --tree "$@" }
fi

# 素の ls / tree を使いたいときは `command ls` と前置する。
# ここでは alias ではなく「関数」で上書きしているため、`\ls` では回避できない
# (バックスラッシュが無効化するのは alias のみ)。関数まで無視するのは
# command / builtin だけなので注意。
# eza は GNU/BSD の ls とオプション体系が異なるため、man の記述をそのまま
# 試すような場面では command ls を使うこと。
