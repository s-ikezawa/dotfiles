-- csvview.nvim。CSV / TSV の列を仮想テキストで揃えて、表のように見せる。
-- 揃えるための空白は画面上だけのもので、ファイルには書き込まれない。幅は strdisplaywidth で
-- 測るので、全角文字が混ざっても列がずれない。区切り文字とヘッダー行は自動で判定する。
--
-- version を指定していないのは、最新のタグ v1.3.0(2025-09)の後に、編集中のちらつきの修正や
-- 解析の高速化など 13 件のコミットが main にだけ入っているため。既定ブランチを追う。
vim.pack.add({
  { src = "https://github.com/hat0uma/csvview.nvim" },
})

-- display_mode = "border" で、区切り文字を縦線(│)に置き換えて見せる。既定の "highlight" は
-- 区切り文字をそのまま色付けする。
-- ヘッダー行は既定でウィンドウの上に固定される(view.sticky_header)。
require("csvview").setup({
  view = { display_mode = "border" },
})

-- csvview は開いただけでは有効にならない(:CsvViewEnable で有効にする作り)。csv と tsv の
-- ファイルを開いたら有効にする(.csv と .tsv の filetype は Neovim が csv / tsv と判定する)。
-- すでに有効なバッファで呼んでも、設定を当て直すだけで二重にはならない。
-- 生の区切り文字を見たいときは :CsvViewToggle で切り替える。
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("csvview-enable", {}),
  pattern = { "csv", "tsv" },
  callback = function(args)
    require("csvview").enable(args.buf)
  end,
})
