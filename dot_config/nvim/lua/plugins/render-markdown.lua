-- ============================================================================
-- render-markdown.nvim - Markdown をバッファ内でインラインレンダリングする
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
-- ============================================================================
-- AI の変更を別ペインで「読む」用途に最適。extmark で常時レンダリングするため、
-- ノーマルモードでスクロールしながら整形済みドキュメントを閲覧できる。
-- 依存: markdown / markdown_inline パーサー（tree-sitter-manager が "all" で導入済み）
--       アイコンは mini.icons（plugins/mini-icons.lua で setup 済み）を使用。

require("render-markdown").setup({
  -- ノーマル(n)/コマンド(c)/ターミナル(t)モードで常時レンダリングする（読む用途向け）
  render_modes = { "n", "c", "t" },
  -- カーソル行だけ生テキストに戻す（記号を確認しつつ閲覧できる）
  anti_conceal = { enabled = true },
  -- カーソル行でも conceal を維持する（normal/visual/command モード）。
  -- 既定 (concealcursor="") だと j/k でカーソルが mermaid ブロック行に乗ったとき
  -- conceal が外れて画像が消え、コードブロックのソース表示に戻ってしまう。
  -- nvc にすることで読む間は図を保持する（insert に入ればソースが見えるので編集も可能）。
  win_options = {
    concealcursor = { rendered = "nvc" },
  },
  -- LaTeX 数式レンダリングは外部ツール(utftex/latex2text)が必要。
  -- AI 変更の閲覧用途では使わないため無効化（:checkhealth の警告も消える）。
  latex = { enabled = false },
  -- 行番号横(サインカラム)に出る見出し等のアイコンを無効化する。
  sign = { enabled = false },
  code = {
    width = "block",  -- コードブロックの背景を内容の幅に合わせて描画する
    min_width = 60,   -- 背景ブロックの最小幅
    left_pad = 1,     -- コードブロック左の余白
    right_pad = 1,    -- コードブロック右の余白
    -- mermaid は snacks.image が画像描画するため render-markdown 側の描画を無効化する。
    disable = { "mermaid" },
  },
})

-- ----------------------------------------------------------------------------
-- Markdown を開いたときの読みやすさ設定（markdown バッファにのみ適用）
-- 全体設定は wrap=false（options.lua）だが、散文の閲覧では折り返しが快適なため
-- markdown のときだけローカルに上書きする。
-- ※ conceallevel は render-markdown が描画時に自動管理するためここでは触らない。
-- ----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true       -- 長い行を折り返して表示する
    vim.opt_local.linebreak = true  -- 単語の途中ではなく語の区切りで折り返す
  end,
})
