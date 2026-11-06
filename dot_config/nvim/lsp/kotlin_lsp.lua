-- Kotlin の言語サーバー（JetBrains の kotlin-lsp。mise で導入）の設定。
-- Gradle・Maven のプロジェクトを読み込んでインデックスを作り終えるまで、補完や定義へのジャンプは使えない。
-- 進み具合はステータスラインの右側に出る（lua/config/lsp_progress.lua）。

local cache = vim.fs.joinpath(vim.env.XDG_CACHE_HOME or vim.fs.joinpath(vim.env.HOME, '.cache'), 'kotlin-lsp')

---@type vim.lsp.Config
return {
  cmd = {                                             -- 起動するコマンド
    'intellij-server',
    '--stdio',                                        -- 標準入出力でやりとりする（既定は TCP のサーバー）
    -- キャッシュとインデックスの置き場所。指定しないと起動のたびに一時フォルダに作り直し、毎回インデックス作業から始まる
    '--system-path=' .. cache,
  },
  filetypes = { 'kotlin' },                           -- このファイルタイプのバッファで動かす
  root_markers = {                                    -- 上の階層へ探して、最初に見つかった場所をプロジェクトのルートにする
    { 'settings.gradle.kts', 'settings.gradle' },     -- Gradle のマルチプロジェクトのルート
    { 'pom.xml', 'build.gradle.kts', 'build.gradle' }, -- Maven・Gradle の単体のプロジェクト
    '.git',
  },
}
