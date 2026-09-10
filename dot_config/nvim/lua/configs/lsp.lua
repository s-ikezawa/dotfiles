-- LSP。Neovim 本体のクライアントだけを使い、nvim-lspconfig は入れない。
-- サーバごとの設定は 'runtimepath' 直下の lsp/<設定名>.lua に置き、ここで名前を
-- 挙げて有効にする（:help lsp-new-config）。設定を書くだけでは起動せず、
-- vim.lsp.enable() を呼んだものだけが filetypes / root_markers に従って
-- 自動で attach する。
--
-- 起動の確認は :checkhealth vim.lsp（Enabled Configurations と、attach した
-- バッファの一覧が出る）。
--
-- attach 後の操作は本体の既定に任せる。診断は既定で有効、K が hover、
-- gra が code action、grn が rename、grr が references、gri が implementation、
-- grt が type definition、gO が document symbol、挿入モードの CTRL-S が
-- signature help、CTRL-] が定義ジャンプ（'tagfunc' 経由）。
-- 補完は 'omnifunc' に入るので CTRL-X CTRL-O で引く。自動で出す
-- （vim.lsp.completion.enable の autotrigger）のは必要になってから入れる。
-- 一覧は :help lsp-defaults。

vim.lsp.enable("kotlin_lsp")

-- 診断のサインを Nerd Font のアイコンにする。
--
-- 既定は severity ごとに "E" / "W" / "I" / "H" の 1 文字（:help vim.diagnostic.Opts.Signs）。
-- signs = true のまま text だけ差し替えるので、色（DiagnosticSign*）と優先度は既定のまま。
-- サイン桁は options.lua の signcolumn = "yes" で常時空けてある。
--
-- 使うのは codicon 系。4 つが同じ意匠で揃っていて、VS Code の診断アイコンと同じもの。
-- 端末フォントの PlemolJPConsoleNF-Regular.ttf（mise の [bootstrap.packages] の
-- brew-cask:font-plemol-jp-nf、Ghostty の font-family で指定）の cmap に
-- 4 つとも入っていることを確認した。
--
--   U+EA87 cod-error
--   U+EA6C cod-warning
--   U+EA74 cod-info
--   U+EA61 cod-lightbulb
--
-- Font Awesome 系（U+F057 times_circle / U+F071 warning / U+F05A info_circle /
-- U+F0EB lightbulb_o）も同じフォントに入っているので、好みで差し替えてよい。
-- 別のフォントに移るときは、そちらに該当のコードポイントがあるか確かめること。
-- 無いと豆腐になる。
--
-- 文字はリテラルではなく \u{} エスケープで書く。LuaJIT はこの記法を解釈する
-- （Lua 5.2 由来）。私用領域の文字は編集やコピーの経路で落ちることがあり、
-- 実際ここをリテラルで書いたときは空文字列になっていた。エスケープなら
-- どのコードポイントを指しているかがファイルだけで分かる。
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{EA87}",
      [vim.diagnostic.severity.WARN] = "\u{EA6C}",
      [vim.diagnostic.severity.INFO] = "\u{EA74}",
      [vim.diagnostic.severity.HINT] = "\u{EA61}",
    },
  },
})
