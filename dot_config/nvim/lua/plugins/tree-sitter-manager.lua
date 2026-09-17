-- tree-sitter-manager.nvim。tree-sitter のパーサを入れる・消す・更新する。
--
-- Neovim 0.12 は tree-sitter を本体に取り込んだが、パーサのインストーラは持っていない。
-- 従来その役目だった nvim-treesitter がアーカイブされたので、その置き換えとして使う。
--
-- 動作には tree-sitter CLI・git・C コンパイラが要る(CLI は mise、コンパイラは Xcode CLT)。
-- パーサとクエリの置き場は既定のまま $XDG_DATA_HOME/nvim/site/parser と .../site/queries で、
-- chezmoi の管理範囲(~/.config)には入らない。
vim.pack.add({
  {
    src = "https://github.com/romus204/tree-sitter-manager.nvim",
    version = vim.version.range("^1.0"),
  },
})

require("tree-sitter-manager").setup({
  -- 未導入の言語のファイルを開いたときに自動でパーサを入れる。
  auto_install = true,
  -- ただし Neovim 本体が同梱している分は入れ直さない。この 7 つは
  -- lib/nvim/parser/*.so として最初から入っている(0.12.5 で確認)。
  noauto_install = { "c", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc" },
})
