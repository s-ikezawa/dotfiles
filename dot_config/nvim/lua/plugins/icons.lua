-- =============================================================================
-- mini.icons (nvim-mini/mini.icons)
-- =============================================================================
-- Nerd Font ベースのアイコンプロバイダ。snacks.picker / lualine / neo-tree などが
-- 内部で利用する。
--
-- 主な API:
--   MiniIcons.get('file',      'init.lua')   -> アイコン, ハイライト, is_default
--   MiniIcons.get('extension', 'lua')
--   MiniIcons.get('directory', 'src')
--   MiniIcons.get('filetype',  'lua')
--   MiniIcons.get('lsp',       'function')
--
-- 詳細: :help mini.icons / https://github.com/nvim-mini/mini.icons
-- =============================================================================

require("mini.icons").setup({
  -- 'glyph' (Nerd Font グリフ) | 'ascii' (フォント未対応環境向けフォールバック)
  style = "glyph",
})

-- 旧 nvim-web-devicons の API を擬似的に提供する。
-- これにより nvim-web-devicons を require する古いプラグイン (lualine, neo-tree 等)
-- がそのまま mini.icons のアイコンを使えるようになる。
-- mini.icons 単独運用でも全プラグインのアイコン表示が壊れないので必ず呼ぶ。
MiniIcons.mock_nvim_web_devicons()
