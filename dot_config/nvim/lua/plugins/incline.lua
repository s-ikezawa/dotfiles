-- ============================================================================
-- incline.nvim - 各ウィンドウにファイル名をフロート表示する
-- https://github.com/b0o/incline.nvim
-- ============================================================================
-- ステータスラインを非表示(laststatus=0, options.lua)にした代わりに、
-- どのウィンドウがどのファイルかを軽量なフロートで示す。AI の変更を
-- 複数ペインで並べて読む用途では「窓 = ファイル名」が一目で分かるのが要。
--
-- 公式レシピ "Diagnostics + Git Diff + Icon + Filename" をベースに、
-- アイコン取得を nvim-web-devicons から既存の mini.icons に置き換えている。
-- 表示位置は右下 (window.placement = bottom-right)。
--
-- 表示内容: 診断件数 ┊ git diff ┊ アイコン ファイル名
-- 依存: mini.icons (アイコン/色), gitsigns.nvim (git diff), lua/icons.lua (グリフ定義)

local MiniIcons = require("mini.icons")
local Icons = require("icons")

-- ハイライトグループの前景色 (guifg) を "#rrggbb" で取得する。
-- mini.icons はアイコンとハイライトグループ名を返すので、そこから色を引く。
local function hl_fg(group)
  if not group then return nil end
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok and hl and hl.fg then
    return string.format("#%06x", hl.fg)
  end
  return nil
end

require("incline").setup({
  -- 右下に配置する
  window = {
    placement = {
      horizontal = "right",
      vertical = "bottom",
    },
  },
  render = function(props)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if filename == "" then
      filename = "[No Name]"
    end

    -- mini.icons からファイルアイコンとその色を取得
    local ft_icon, ft_hl = MiniIcons.get("file", filename)
    local ft_color = hl_fg(ft_hl)

    -- git diff (gitsigns の b:gitsigns_status_dict を参照)
    local function get_git_diff()
      local icons = Icons.git
      local signs = vim.b[props.buf].gitsigns_status_dict
      local labels = {}
      if signs == nil then
        return labels
      end
      for name, icon in pairs(icons) do
        if tonumber(signs[name]) and signs[name] > 0 then
          table.insert(labels, { icon .. " " .. signs[name] .. " ", group = "Diff" .. name })
        end
      end
      if #labels > 0 then
        table.insert(labels, { "┊ " })
      end
      return labels
    end

    -- 診断件数 (severity ごと)
    local function get_diagnostic_label()
      local icons = {
        error = Icons.diagnostics.ERROR,
        warn  = Icons.diagnostics.WARN,
        info  = Icons.diagnostics.INFO,
        hint  = Icons.diagnostics.HINT,
      }
      local label = {}
      for severity, icon in pairs(icons) do
        local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
        if n > 0 then
          table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
        end
      end
      if #label > 0 then
        table.insert(label, { "┊ " })
      end
      return label
    end

    return {
      { get_diagnostic_label() },
      { get_git_diff() },
      { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
      { filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
    }
  end,
})
