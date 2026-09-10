-- Kotlin。JetBrains 公式の kotlin-lsp（Kotlin/kotlin-lsp）。実体は IntelliJ IDEA と
-- IntelliJ の Kotlin プラグインの実装で、README の言う通り Alpha。
--
-- バイナリは mise の [tools] の http:kotlin-lsp。JBR 同梱なので JDK は別に要らない。
-- **ビルドに 30 日ほどの有効期限がある**（土台が IntelliJ Platform の EAP ビルドのため）。
-- 期限が切れると起動直後に "This build of intellij-server has expired." を出して
-- 終了するので、そうなったら mise の config.toml でバージョンを上げる。経緯はそちらに。
--
-- ファイル名がそのまま設定名になる（:help lsp-new-config）。kotlin_lsp にしてあるのは
-- nvim-lspconfig が同じ名前で設定を配っているためで、後からあれを入れても
-- 名前が割れない（rtp 上の lsp/kotlin_lsp.lua どうしがマージされ、こちらが勝つ）。
return {
  -- 配布物の kotlin-lsp.sh は非推奨（起動のたびに警告を stderr に出して
  -- bin/intellij-server に exec するだけ）なので、実体を直接呼ぶ。
  -- nvim-lspconfig の lsp/kotlin_lsp.lua と同じ形。
  --
  -- --stdio は必須。付けないと 127.0.0.1:9999 で待ち受けるサーバモードになる
  -- （intellij-server --help）。
  cmd = { "intellij-server", "--stdio" },

  -- .kt / .kts とも Neovim 本体が kotlin と判定するので、filetype プラグインは要らない。
  filetypes = { "kotlin" },

  -- ビルド定義の場所をプロジェクトルートとする。nvim-lspconfig の
  -- lsp/kotlin_lsp.lua と同じ並び。上から順に探し、最初に見つかったものが勝つ。
  root_markers = {
    "settings.gradle", -- Gradle（マルチプロジェクト）
    "settings.gradle.kts",
    "pom.xml", -- Maven
    "build.gradle", -- Gradle
    "build.gradle.kts",
    "workspace.json", -- 独自のビルドシステムを繋ぐとき用
  },

  -- ルートが見つからないバッファでは起動させない。ビルド定義を読んで依存を解決する
  -- サーバなので、単独の .kt を開いただけで IntelliJ を丸ごと起動しても得るものが無い。
  -- nvim-lspconfig 時代の single_file_support = false にあたる（:help vim.lsp.Config）。
  workspace_required = true,
}
