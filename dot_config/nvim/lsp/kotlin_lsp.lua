-- ~/.config/nvim/lsp/kotlin_lsp.lua
-- kotlin-lsp (JetBrains 公式 Kotlin LSP / intellij-server ベース) のサーバー定義。
-- 本体は brew (cask) で導入: brew install JetBrains/utils/kotlin-lsp
--   実体は kotlin-lsp.sh → bin/intellij-server。`kotlin-lsp` は安定した symlink なので
--   バージョン非依存にするためコマンドにはこれを使う (起動時の deprecation 警告は
--   stderr に出るだけで LSP 通信 (stdout) には影響しない)。
--   ※ macOS の Gatekeeper が未署名ランチャを隔離すると起動しなくなるため、
--     導入/更新後に
--     sudo xattr -rd com.apple.quarantine /opt/homebrew/Cellar/kotlin-lsp/
--     が必要なことがある。

return {
  cmd = { "kotlin-lsp", "--stdio" },
  filetypes = { "kotlin" },
  -- Gradle / Maven プロジェクトのルートを判定する
  root_markers = {
    "settings.gradle.kts", "settings.gradle",
    "build.gradle.kts", "build.gradle",
    "pom.xml",
    ".git",
  },
}
