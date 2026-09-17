-- プロバイダ(remote plugin のホスト)を無効にする。
--
-- Neovim は他言語で書かれたプラグインを動かすために node / perl / python3 / ruby の
-- ホストを使う。いずれも各言語側に neovim パッケージを入れておく必要があり、入っていないと
-- :checkhealth が警告を出す(素の状態で 6 件)。どれも使う予定が無いので切る。
--
-- 0 を入れると「読み込み済み」扱いになり、プロバイダの初期化ごと飛ぶ(:h provider)。
-- 必要になったら該当行を消して、その言語側に neovim パッケージを入れる。
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
