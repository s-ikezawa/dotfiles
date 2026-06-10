-- ~/.config/nvim/lua/plugins/octo.lua
-- pwntester/octo.nvim
-- =============================================================================
-- GitHub の PR / Issue / Discussion を Neovim 上でレビュー・操作する。
-- gh CLI (認証済み) を裏で呼ぶため、push 済みで GitHub 上に存在する PR が対象。
-- (commit 前のローカル変更レビューは diffview の領分。両者は用途が異なり併存する)
--
-- 依存: plenary.nvim (plugins.lua で追加)、picker は既存の snacks を使用。
-- ファイルパネルのアイコンは file_panel.icons = true → nvim-web-devicons を参照し、
-- icons.lua の MiniIcons.mock_nvim_web_devicons() が肩代わりする (mini.icons に一本化)。
--
-- レビュー操作 (コメント追加 / approve / submit 等) は octo が PR・review バッファに
-- <localleader> 系のバッファローカルキーを自動設定する (:h octo-mappings)。
-- ここでは入口となるコマンドだけ <leader>(= ,) prefix の `o` 系に割り当てる。
-- =============================================================================

require("octo").setup({
  picker = "snacks",     -- 一覧・検索の UI に既存の snacks.nvim を使う
  enable_builtin = true, -- 素の :Octo でコマンドパレット (picker) を開けるようにする
  reaction_viewer_hint_icon = " ", -- marker for user reactions
  user_icon = " ", -- user icon
  ghost_icon = "󰊠 ", -- ghost icon
  copilot_icon = " ", -- copilot icon
  dependabot_icon = " ",
  comment_icon = "▎",
  outdated_icon = "󰅒 ",
  resolved_icon = " ",
  timeline_marker = " ",
  timeline_icons = {
    auto_squash = "  ",
    blocking = "  ",
    commit_push = "  ",
    comment_deleted = "  ",
    duplicate = "  ",
    force_push = "  ",
    draft = "  ",
    ready = " ",
    commit = "  ",
    deployed = "  ",
    issue_type = "  ",
    label = "  ",
    reference = "  ",
    project = "  ",
    connected = "  ",
    subissue = "  ",
    cross_reference = "  ",
    transferred = "  ",
    parent_issue = "  ",
    head_ref = "  ",
    pinned = "  ",
    milestone = "  ",
    renamed = "  ",
    automatic_base_change_succeeded = "  ",
    base_ref_changed = "  ",
    merged = { "  ", "OctoPurple" },
    closed = {
      closed = { "  ", "OctoRed" },
      completed = { "  ", "OctoPurple" },
      not_planned = { "  ", "OctoWhite" },
      duplicate = { "  ", "OctoWhite" },
    },
    reopened = { "  ", "OctoGreen" },
    assigned = "  ",
    locked = "  ",
    review_requested = "  ",
    runs = {
    icons = {
      pending = "🕖",
      in_progress = "🔄",
      failed = "❌",
      succeeded = "",
      skipped = "⏩",
      cancelled = "✖",
    },
  },
  },
  right_bubble_delimiter = "", -- bubble delimiter
  left_bubble_delimiter = "", -- bubble delimiters
})

local map = vim.keymap.set

-- PR (主目的: レビュー担当)
map("n", "<leader>op", "<cmd>Octo pr list<cr>",   { desc = "Octo: PR 一覧" })
map("n", "<leader>oP", "<cmd>Octo pr search<cr>", { desc = "Octo: PR 検索" })
map("n", "<leader>oo", "<cmd>Octo pr checkout<cr>", { desc = "Octo: 現在の PR を checkout" })

-- レビュー (PR バッファ内 / PR 指定で)
map("n", "<leader>ovs", "<cmd>Octo review start<cr>",  { desc = "Octo: レビュー開始" })
map("n", "<leader>ovr", "<cmd>Octo review resume<cr>", { desc = "Octo: 保留中レビューを再開" })
map("n", "<leader>ovS", "<cmd>Octo review submit<cr>", { desc = "Octo: レビューを提出" })

-- その他の入口
map("n", "<leader>oi", "<cmd>Octo issue list<cr>",        { desc = "Octo: Issue 一覧" })
map("n", "<leader>on", "<cmd>Octo notification list<cr>", { desc = "Octo: 通知一覧" })
map("n", "<leader>oc", "<cmd>Octo<cr>",                   { desc = "Octo: コマンドパレット" })
