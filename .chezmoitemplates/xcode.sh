# Xcode(App Store 版)のセットアップ。lib.sh の後に template で展開し、setup_xcode を呼ぶ。
#
# Xcode 本体は mise の [bootstrap.packages] にある mas:497799835 が入れるが、App Store からの
# インストールでは xcode-select の切り替え・ライセンス同意・追加コンポーネントの導入は
# 行われない。
#
# xcode-select を明示していない状態で Xcode.app が入ると /usr/bin/git は Xcode 側を使う
# ようになり、ライセンスに同意するまで exit 69 で落ちる。mise の bootstrap packages apply /
# macos defaults apply も開始時に変更履歴の git リポジトリを開くので巻き込まれる。
# だから git を使う処理より前に呼ぶ。どの手順も済んでいれば sudo を呼ばずに返る。
setup_xcode() {
  local developer_dir="/Applications/Xcode.app/Contents/Developer"
  if [[ ! -d "${developer_dir}" ]]; then
    skip "Xcode は未インストール"
    return 0
  fi

  # 確認は DEVELOPER_DIR で Xcode を直接指して行う。xcode-select が CLT を指したままでも
  # xcodebuild が動き、sudo も要らない。export はしない。後続の git や mise まで Xcode 側に
  # なるうえ、xcode-select -p が DEVELOPER_DIR をそのまま返して切り替えの要否を誤るため。
  local need_switch=0 need_license=0 need_first_launch=0
  [[ "$(env -u DEVELOPER_DIR xcode-select -p 2>/dev/null)" == "${developer_dir}" ]] || need_switch=1
  DEVELOPER_DIR="${developer_dir}" xcodebuild -license check >/dev/null 2>&1 || need_license=1
  # 追加コンポーネントの導入が要るとき 0 以外で終わる。
  DEVELOPER_DIR="${developer_dir}" xcodebuild -checkFirstLaunchStatus >/dev/null 2>&1 || need_first_launch=1

  if (( need_switch + need_license + need_first_launch == 0 )); then
    skip "Xcode はセットアップ済み"
    return 0
  fi

  # どれも root が要る。05-rosetta と同じく先に認証しておく。
  if ! sudo -n true 2>/dev/null; then
    log "sudo の認証（Xcode のセットアップに必要）"
    if ! sudo -v; then
      echo "sudo の認証に失敗しました。管理者アカウントで実行してください。" >&2
      return 1
    fi
  fi

  # sudo 側の xcodebuild は xcode-select の指す先を使うので、切り替えを最初に行う。
  if (( need_switch )); then
    log "xcode-select を Xcode に切り替え"
    sudo xcode-select --switch "${developer_dir}"
  fi
  if (( need_license )); then
    log "Xcode のライセンスに同意"
    sudo xcodebuild -license accept
  fi
  if (( need_first_launch )); then
    log "Xcode の追加コンポーネントをインストール"
    sudo xcodebuild -runFirstLaunch
  fi
}
