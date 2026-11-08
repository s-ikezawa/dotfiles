-- シェルスクリプト（sh・bash）の言語サーバー（bash-language-server。mise で npm:bash-language-server として導入）の設定。
-- PATH にある shellcheck（mise で導入）を内部で呼び、その警告を診断として出す。
-- Claude Code の LSP ツール（~/.config/claude/marketplace の bash-lsp）と同じ言語サーバーなので、同じ診断が見える。
-- zsh には対応していない（shellcheck も zsh 非対応）ので、filetypes に入れない。
-- chezmoi のテンプレートは filetype が sh.chezmoitmpl になり、ここに一致しないのでつながらない（{{ }} で構文エラーになるため）。

---@type vim.lsp.Config
return {
  cmd = { 'bash-language-server', 'start' }, -- 起動するコマンド
  filetypes = { 'sh', 'bash' },              -- このファイルタイプのバッファで動かす
  root_markers = { '.git' },                 -- 上の階層へ探して、最初に見つかった場所をプロジェクトのルートにする
}
