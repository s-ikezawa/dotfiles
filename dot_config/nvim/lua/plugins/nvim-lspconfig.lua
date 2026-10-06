-- nvim-lspconfig。言語サーバーごとの既定の設定(起動コマンド・filetypes・root_markers)を集めたもの。
--
-- Neovim 0.11 からは LSP の設定と起動を本体の vim.lsp.config / vim.lsp.enable で行う。
-- このプラグインは lsp/<名前>.lua として設定を runtimepath に足すだけで、自分では何も起動しない。
-- 既定を上書きしたいときは vim.lsp.config("<名前>", { ... }) を書くと、既定とマージされる。
--
-- 言語サーバー本体はここでは入れない。mise で入れて PATH に載せる(~/.config/mise/config.toml)。
-- キーマップは Neovim の既定(K / grn / gra / grr / gri / gO など。:h lsp-defaults)をそのまま使う。
vim.pack.add({
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    version = vim.version.range("^2.0"),
  },
})

-- Kotlin。JetBrains 公式の kotlin-lsp(mise の http:kotlin-lsp が入れる bin/intellij-server)。
--
-- ルート(LSP に渡すワークスペース)は、開いたファイルから上へ root_markers を探して決まる。
-- Neovim を起動したディレクトリ(cwd)は関係ないので、複数の言語が入ったモノレポの最上位で
-- 起動しても、Kotlin のファイルを開けばそのファイルが属する Gradle / Maven のプロジェクトが
-- ルートになる。root_markers は先に書いたものほど優先され(:h lsp-root_markers)、
-- lspconfig の既定は settings.gradle(.kts) が build.gradle(.kts) より先なので、
-- マルチプロジェクトのサブプロジェクトのファイルを開いても settings.gradle.kts のある
-- ディレクトリがルートになる。
-- 別のプロジェクトのファイルを開くと、ルートが違うので別のサーバーがもう 1 つ起動する。
-- IntelliJ が丸ごと動くので、1 つあたり数 GB のメモリを使う。
--
-- workspace_required = true で、どの root_markers も見つからないファイル(Gradle / Maven の
-- プロジェクトの外にある .kt / .kts)では起動しない。単独のファイルのためにサーバーを
-- 立ち上げても、依存が解決できず役に立たないため。kotlin-lsp の Neovim 向けの手順
-- (scripts/neovim.md)も single_file_support = false(0.11 より前のこのオプションの名前)にしている。
vim.lsp.config("kotlin_lsp", {
  workspace_required = true,
})
vim.lsp.enable("kotlin_lsp")
