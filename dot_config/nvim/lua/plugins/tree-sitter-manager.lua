-- Tree-sitter パーサの導入と管理。
--
-- nvim 0.12 は tree-sitter を本体に取り込んだがパーサのインストーラは持たず、
-- 同梱されるのは c / lua / markdown / markdown_inline / query / vim / vimdoc の
-- 7 つだけ。その役目を担っていた nvim-treesitter は archived になったので、
-- 置き換えとして作られたこれを使う（:h treesitter が案内するのは今も
-- nvim-treesitter の方）。
--
-- 要る外部コマンドは tree-sitter CLI / git / C コンパイラ。CLI は mise の
-- [tools]、cc は Xcode Command Line Tools。揃っているかは
-- :checkhealth tree-sitter-manager で見られる。
--
-- パーサは git clone --depth=1 してから tree-sitter build され、
-- ~/.local/share/nvim/site/parser/<lang>.dylib に置かれる（拡張子は
-- os_uname().sysname で決まり、macOS は .dylib）。クエリは
-- site/queries/<lang> から、プラグインが同梱する runtime/queries/<lang> への
-- シンボリックリンク。どちらも nvim が書くので chezmoi では管理しない
-- （lockfile と同じ扱い）。
--
-- version はメジャーだけ固定する。理由は catppuccin と同じで、lockfile を
-- chezmoi の管理から外している以上、リビジョンを縛るのはここだけになる。
vim.pack.add({
  {
    src = "https://github.com/romus204/tree-sitter-manager.nvim",
    version = vim.version.range("1"),
  },
})

-- auto_install は、開いたファイルの filetype に対応するパーサをその場で入れる。
-- ensure_installed に言語を並べないのは、必要になった時点で足すという
-- このリポジトリの方針に合わせるため。手で入れるなら :TSInstall、
-- 一覧から選ぶなら :TSManager。
--
-- noauto_install は nvim が同梱している 7 つ。パーサはランタイムパスの
-- 先に見つかった方が使われるので、site/parser に入れると同梱版が隠れる。
-- 同じものを二重に持ってビルドの失敗要因を増やす理由が無い。
--
-- highlight は既定の true のまま。FileType ごとに vim.treesitter.start() が
-- 呼ばれる。
--
-- 入らない言語もある。プラグインの repos.lua が generate = true にしている
-- latex / mlir / ocamllex / perl / pod / svelte / swift / teal / unison の 9 つは
-- ビルドの前に tree-sitter generate が走り、grammar.js の評価に node を使う。
-- node はグローバルの [tools] に無いので、これらは auto_install でも失敗する。
require("tree-sitter-manager").setup({
  auto_install = true,
  noauto_install = {
    "c",
    "lua",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "vimdoc",
  },
})
