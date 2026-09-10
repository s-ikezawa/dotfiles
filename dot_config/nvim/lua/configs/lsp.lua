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
