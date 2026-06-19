-- ============================================================================
-- mini.icons - アイコン（nvim-web-devicons の後継・互換）
-- https://github.com/nvim-mini/mini.icons
-- ============================================================================
-- nvim-web-devicons より新しく、mini.icons を要求するプラグインも増えている。
-- mock_nvim_web_devicons() で「require('nvim-web-devicons')」を mini.icons に
-- 差し替えるため、devicons 前提のプラグイン（diffview など）でもアイコンが出る。

require("mini.icons").setup() -- mini.icons を有効化（呼ばないと機能しない）

-- nvim-web-devicons を期待するプラグイン向けの互換シムを有効化
-- （require('nvim-web-devicons') の呼び出しを mini.icons がバックエンドとして処理）
MiniIcons.mock_nvim_web_devicons()
