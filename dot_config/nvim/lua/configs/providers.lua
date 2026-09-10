-- 言語ごとの provider を無効にする。
--
-- provider は Python / Ruby / Perl / Node.js で書かれた remote-plugin を動かすための
-- 仕組みで、使うには各言語の処理系とホストモジュール（pynvim など）が要る。
-- この dotfiles は依存に言語処理系を増やさない方針で、その種のプラグインも入れない
-- ので、探させずに無効だと宣言しておく。
-- 変数名の出所は :help provider-python / provider-ruby / provider-perl /
-- provider-nodejs。
--
-- 実利もある。node が無い状態だと :checkhealth vim.provider は Node.js の節で
-- 例外を出して止まる（0.12.5 の runtime/lua/vim/provider/health.lua:189 が
-- nil を連結する）。無効にすると節ごと「Disabled」の 1 行になり、診断が最後まで
-- 通るようになる。

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- クリップボードも provider（:help provider-clipboard）だが、これは言語処理系では
-- なく macOS の pbcopy / pbpaste を使うので有効なまま。options.lua の
-- clipboard = "unnamedplus" はこれに乗っている。
