-- ~/.config/nvim/lua/plugins/diffview.lua
-- dlyongemallo/diffview-plus.nvim (sindrets/diffview.nvim の維持fork)
-- =============================================================================
-- diff レビュー特化プラグイン。1 タブに「変更ファイル一覧パネル + side-by-side
-- diff」を並べ、変更セット全体をファイル横断でレビューできる。
-- ハンクの staging / commit は AI に任せる方針のため、ここでは「読みやすさ」に
-- 全振りした設定にしている (操作系のキーは最小限)。
-- ファイルタイプアイコンは mini.icons の nvim-web-devicons モック (icons.lua)
-- 経由で取得される (use_icons = true)。
-- ファイルパネルの git status 文字 (A/M/D...) は、共通モジュール
-- require("icons") の M.git グリフに揃える (定義の二重管理を防ぐ)。
-- M.git のグリフは signcolumn 用に末尾スペースを含むため vim.trim で除去する。
-- キーは <leader>(= ,) prefix の `g` 系に割り当てる。
-- =============================================================================

local git = require("icons").git
local function g(name) return vim.trim(git[name]) end

require("diffview").setup({
  status_icons = {
    ["A"] = g("added"),   -- Added (追加)
    ["?"] = g("added"),   -- Untracked (新規・未追跡)
    ["M"] = g("changed"), -- Modified (変更)
    ["R"] = g("changed"), -- Renamed (リネーム)
    ["C"] = g("changed"), -- Copied (コピー)
    ["T"] = g("changed"), -- Type changed (型変更)
    ["D"] = g("removed"), -- Deleted (削除)
    ["B"] = g("removed"), -- Broken (破損)
  },
  enhanced_diff_hl = true, -- word-level の差分を強調 (追加/削除内の変更箇所を色分け)
  use_icons = true,
  view = {
    -- レビューは横並び (left=旧 / right=新) が読みやすい
    default = { layout = "diff2_horizontal" },
    merge_tool = { layout = "diff3_horizontal" },
    file_history = { layout = "diff2_horizontal" },
  },
  file_panel = {
    listing_style = "tree", -- 変更ファイルをツリー表示
    win_config = { position = "left", width = 35 },
  },
})

-- =============================================================================
-- ステータスアイコンの色を標準的な git 配色に寄せる。
-- diffview は changed 系 (M/R/C/T/U) を `diffChanged` にリンクするが、
-- catppuccin mocha の diffChanged は青系のため違和感がある。
-- changed 系のみ黄色 (mocha yellow) に上書きする (added=緑 / removed=赤 は標準なので既定のまま)。
-- 黄色はパレットから取得し、取得失敗時のみ mocha の既定値にフォールバックする。
-- ColorScheme でも再適用し、テーマ再読込後も維持する。
-- =============================================================================
local function fix_status_hl()
  local ok, palette = pcall(function()
    return require("catppuccin.palettes").get_palette("mocha")
  end)
  local yellow = (ok and palette.yellow) or "#f9e2af"
  for _, group in ipairs({
    "DiffviewStatusModified",
    "DiffviewStatusRenamed",
    "DiffviewStatusCopied",
    "DiffviewStatusTypeChange",  -- hl_links 側の綴り
    "DiffviewStatusTypeChanged", -- status マップ側の綴り (両方押さえる)
    "DiffviewStatusUnmerged",
  }) do
    vim.api.nvim_set_hl(0, group, { fg = yellow })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Diffview: changed 系ステータスアイコンを黄色に上書き",
  callback = fix_status_hl,
})
fix_status_hl() -- 起動時に即適用 (catppuccin 適用後・diffview setup 後に実行される)

local map = vim.keymap.set

-- レビュー対象を開く
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview: 作業ツリーの変更をレビュー (vs index)" })
map("n", "<leader>gD", function()
  -- ベースブランチとの差分セット全体をレビュー (PR レビュー相当)
  local base = vim.fn.input("Diffview base rev: ", "main...HEAD")
  if base ~= "" then
    vim.cmd("DiffviewOpen " .. base)
  end
end, { desc = "Diffview: 指定 rev との差分をレビュー (例 main...HEAD)" })

-- 履歴 (file history)
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview: 現在ファイルの変更履歴" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview: リポジトリ全体の変更履歴" })

-- 閉じる
map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Diffview: 閉じる" })
