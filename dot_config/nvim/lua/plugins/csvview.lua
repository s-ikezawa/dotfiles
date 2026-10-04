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
--
-- keymaps は csvview が有効なバッファでだけ効く(README の例のまま)。
--   if / af        セル(フィールド)を選ぶテキストオブジェクト。af は区切り文字も含む。
--                  例: cif でセルの中身を書き換え、daf で区切りごと消す。
--   <Tab> / <S-Tab>      右 / 左のセルの末尾へ移る(Excel の Tab)。
--   <Enter> / <S-Enter>  下 / 上の行の同じ列へ移る(Excel の Enter)。
-- どれも件数を前に付けられる(3<Tab> で 3 つ右のセル)。
-- <Tab> と <C-i>(ジャンプリストを進む)、<S-Enter> と <Enter> は、端末が CSI u で送り分けて
-- いないと区別できない。Neovim は起動時に端末へ CSI u を問い合わせて有効にする(:h tui-csiu)。
-- Ghostty は対応しているので、<C-i> はそのまま使える想定(実機では未確認)。
require("csvview").setup({
  view = { display_mode = "border" },
  keymaps = {
    textobject_field_inner = { "if", mode = { "o", "x" } },
    textobject_field_outer = { "af", mode = { "o", "x" } },
    jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
    jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
    jump_next_row = { "<Enter>", mode = { "n", "v" } },
    jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
  },
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
