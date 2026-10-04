-- render-markdown.nvim。Markdown の見出し・表・コードブロックなどをバッファ内で整形して見せる。
--
-- 描画するのはノーマル・コマンドラインモードのときだけで、挿入モードに入ると生テキストに戻る。
-- ノーマルモードでもカーソル行だけは生テキストのまま見せる(anti_conceal)。どちらも既定値。
--
-- version はリリースタグ(v8.14.0 など)を semver の範囲で追う。"^8.0" は >=8.0.0 <9.0.0。
--
-- README の導入例には nvim-treesitter が載っているが、コードは参照していない。パーサは
-- markdown / markdown_inline が Neovim 本体に同梱されていて、任意の html / yaml は
-- lua/plugins/tree-sitter-manager.lua で入れている。
-- コードブロックの言語アイコンは mini.icons(lua/plugins/mini-icons.lua)から自動で取る。
-- catppuccin 側の連携(integrations.render_markdown)は既定で有効なので、色の設定も要らない。
vim.pack.add({
  {
    src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    version = vim.version.range("^8.0"),
  },
})

require("render-markdown").setup({
  -- 数式($...$ / $$...$$)の描画は使わない。使うには latex パーサと、変換コマンドの
  -- utftex(libtexprintf)か latex2text(pylatexenc)が要り、無いと :checkhealth が警告を出す。
  latex = { enabled = false },
  -- コードブロックの ``` の行を、背景色の半角ブロック(上は ▄、下は ▀)で細い帯にして見せる。
  -- 既定の hide は言語名もアイコンも出ない行を隠すため、閉じ側の ``` の行が消えて
  -- ブロックの終わりが分かりにくい。上側の行は thin でも言語名とアイコンが出る。
  code = { border = "thin" },
})
