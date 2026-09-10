-- カラースキーム。Catppuccin の mocha（4 つあるフレーバーのうち最も暗いもの）。
--
-- name を明示するのは、リポジトリ名が "nvim" で、そのままだと
-- ~/.local/share/nvim/site/pack/core/opt/nvim という紛らわしいディレクトリ名に
-- なるため（vim.pack はプラグインの name をディレクトリ名に使う）。
--
-- version はメジャーだけ固定する。"2" は >=2.0.0 <3.0.0 の意味（:help version-range）。
-- lockfile を chezmoi の管理から外している以上、どのリビジョンが入るかを縛るのは
-- ここだけなので、破壊的変更を跨がない範囲に留める。更新は :lua vim.pack.update()。
vim.pack.add({
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
    version = vim.version.range("2"),
  },
})

-- setup() は colorscheme より前に呼ぶ（README の "setup must be called before
-- loading"）。flavour をここで決めるので、colorscheme 名は flavour 付きではなく
-- 素の "catppuccin" を使い、切り替え点を 1 箇所にしておく。
require("catppuccin").setup({
  flavour = "mocha",
})

vim.cmd.colorscheme("catppuccin")
