-- tree-sitter-manager: Tree-sitter のパーサーを入れて、構文に沿ったハイライトを有効にする。
-- Neovim 本体には一部の言語のパーサーしか入っておらず、入れる仕組みもないため使う。
-- パーサーのビルドに tree-sitter CLI（mise で導入）と C コンパイラ（Xcode）が要る。
-- :TSManager で一覧から入れたり消したりできる。パーサーの更新は :TSUpdate。
-- https://github.com/romus204/tree-sitter-manager.nvim

vim.pack.add({ 'https://github.com/romus204/tree-sitter-manager.nvim' })

require('tree-sitter-manager').setup({
  auto_install = true, -- パーサーのない言語のファイルを開いたら、その場で入れる
  noauto_install = {   -- Neovim に同梱のパーサーがある言語は入れない
    'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
  },
})
