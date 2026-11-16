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
  -- インデックスのデータベースの置き場所。271.2085.0 から --system-path の外（指定しないと
  -- ~/Library/Caches/JetBrains/IntelliJServer/workspaces/<ハッシュ>）に置かれ、Claude Code の kotlin-lsp と
  -- 同じプロジェクトで取り合って「While lock file: .../rocks/v241/LOCK: Resource temporarily unavailable」で失敗する。
  -- indexDir は渡したフォルダの直下にそのまま作るので、プロジェクトのルートのハッシュで分ける。
  before_init = function(params, config)
    local options = params.initializationOptions --[[@as table?]]
    params.initializationOptions = vim.tbl_extend('force', options or {}, {
      indexDir = vim.fs.joinpath(cache, 'index', vim.fn.sha256(config.root_dir or vim.fn.getcwd())),
    })
  end,
  filetypes = { 'kotlin' },                           -- このファイルタイプのバッファで動かす
  root_markers = {                                    -- 上の階層へ探して、最初に見つかった場所をプロジェクトのルートにする
    { 'settings.gradle.kts', 'settings.gradle' },     -- Gradle のマルチプロジェクトのルート
    { 'pom.xml', 'build.gradle.kts', 'build.gradle' }, -- Maven・Gradle の単体のプロジェクト
    '.git',
  },
}
