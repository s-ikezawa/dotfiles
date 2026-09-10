-- LSP の進捗表示。サーバが送ってくる $/progress を右下に出す。
--
-- 入れた動機は kotlin-lsp（lsp/kotlin_lsp.lua）で、あれは開いてから使えるようになるまでに
-- 数十秒かかる。その間に何が起きているかは進捗通知に出ている。実測した流れは
-- Initializing server（Initializing IntelliJ → Starting indexer → Opening project database
-- → Loading workspace model from cache）→ Importing project / Indexing で、
-- **percentage は送られてこない**（title と message だけ）。パーセントや進捗バーは出ない。
--
-- Neovim 本体でも同じことはできる（:help LspProgress の例、vim.lsp.status()、
-- 0.12 の progress-message）が、statusline を組んでいないので置き場が無く、
-- 素の progress-message はコマンドライン行に出て他のメッセージと混ざる。
-- 隅に出して勝手に消えるものが欲しかったのでこれを使う。
--
-- 要件は Neovim v0.11.3 以上（README）。プラグインの依存は無い。
-- 動いているかは :checkhealth fidget、$/progress を出すサーバかどうかは
-- 本家 Wiki の Known compatible LSP servers に一覧がある。
--
-- version はメジャーだけ固定する。catppuccin と同じ理由で、lockfile を chezmoi の
-- 管理から外している以上リビジョンを縛るのはここだけになる。README も
-- 「Fidget is actively developed on the main branch, and may occasionally undergo
-- breaking changes」と言っているので main は追わない。更新は :lua vim.pack.update()。
vim.pack.add({
  {
    src = "https://github.com/j-hui/fidget.nvim",
    version = vim.version.range("2"),
  },
})

-- 既定の整形処理。下の format_message から呼ぶ。
local display = require("fidget.progress.display")

-- 1 行の上限。これを超えたら末尾を … にする。fidget が折り返す幅（画面の 30%）とは
-- 別で、こちらは折り返しの行数を抑えるためのもの。
local MESSAGE_MAX_CHARS = 60

-- 通知のグループ名は LSP クライアント名になるので kotlin_lsp と出る。
-- vim.notify を乗っ取るかは notification.override_vim_notify で、既定は false。
-- 進捗表示だけが要るのでそのままにしてある。
require("fidget").setup({
  progress = {
    display = {
      -- 長いメッセージを右下に収める。既定の format_message
      -- （fidget.progress.display.default_format_message）はサーバが送ってきた
      -- message をそのまま出すので、実測した kotlin-lsp のメッセージだと
      -- 69 文字や 115 文字のものが並ぶ。
      --
      -- 既定の実装を**呼んでから**加工する。message が無いときの
      -- "Completed" / "In progress..." と percentage の付け方を自前で書き直すと、
      -- 本体の実装が変わったときにズレる（今の既定は percentage が number でも
      -- string でも扱うようになっている）。kotlin-lsp は percentage を送らないが、
      -- 送ってくるサーバを足したときにここが素通りするようにしておく。
      --
      -- やることは 2 つ。
      --
      --   1. 絶対パスを最後の要素だけにする。対象は「スラッシュを含む空白なしの塊」
      --      だけなので、パスではない長い語（'com.jetbrains.ls.imports.gradle.model.
      --      ModuleSourceSets' など）には触らない。丸ごと消さずに basename を残すのは、
      --      複数のプロジェクトやモジュールを開いたときにどれの話か分かるようにするため
      --   2. それでも長いものを切る。fidget はウィンドウ幅を画面の 30% に抑えて
      --      折り返すので（v2.0.0 の "limit window max_width to 0.3 + reflow by
      --      default"）、長い行は消えずに縦に伸びる。上の 115 文字がそれ
      format_message = function(msg)
        local message = display.default_format_message(msg)

        message = message:gsub("%S*/%S+", function(path)
          return vim.fn.fnamemodify(path, ":t")
        end)

        -- 切るのは文字単位。バイト単位（#message）だと日本語を送ってくる
        -- サーバで壊れる。
        if vim.fn.strchars(message) > MESSAGE_MAX_CHARS then
          message = vim.fn.strcharpart(message, 0, MESSAGE_MAX_CHARS - 1) .. "…"
        end

        return message
      end,
    },
  },
})
