-- ~/.config/nvim/lsp/kotlin_lsp.lua
-- ============================================================================
-- kotlin-lsp（JetBrains 公式）の LSP サーバ設定
-- ============================================================================
-- Neovim 0.11+ は runtimepath 上の lsp/<name>.lua を自動で
-- vim.lsp.config('<name>') として読み込む。起動（有効化）は lua/lsp.lua の
-- vim.lsp.enable('kotlin_lsp') が担う。
--
-- 実体は intellij-server バイナリで、`--stdio` で LSP を stdin/stdout に直接話す
-- （socat/netcat は不要）。brew formula(jetbrains/utils/kotlin-lsp) は PATH 上に
-- "kotlin-lsp" の名前で置くため、既定の cmd（intellij-server）ではなくこの名前を指定する。

---@type vim.lsp.Config
return {
  cmd = { "kotlin-lsp", "--stdio" },
  filetypes = { "kotlin" },
  root_markers = {
    "settings.gradle.kts", -- Gradle（マルチプロジェクトのルート）
    "settings.gradle",
    "build.gradle.kts",    -- Gradle
    "build.gradle",
    "pom.xml",             -- Maven
    "workspace.json",      -- 独自ビルドシステム連携用
  },
}
