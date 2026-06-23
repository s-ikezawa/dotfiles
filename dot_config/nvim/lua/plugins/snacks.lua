-- ============================================================================
-- snacks.nvim（image / explorer モジュール）
-- https://github.com/folke/snacks.nvim/blob/main/docs/image.md
-- https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
-- ============================================================================
-- 端末 Ghostty（Kitty Graphics Protocol）+ tmux allow-passthrough=on で動作する。
-- mermaid は mmdc（mermaid-cli, mise 管理）が PNG 化し、それを Ghostty に転送して表示する。
-- mmdc は内部で puppeteer 経由で Chrome を起動するため、既存の Google Chrome を使わせる
-- （Chromium の重複ダウンロード約 300MB を回避）。

-- snacks が起動する mmdc サブプロセスはこの環境変数を継承する。
-- パスは /Applications 固定なので、存在確認のうえ直接指定する（Playwright 方式と違い rev 番号で揺れない）。
local chrome = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if vim.uv.fs_stat(chrome) then
  vim.env.PUPPETEER_EXECUTABLE_PATH = chrome
end

-- tmux の内側だと $TERM=screen になり、snacks は「下の端末が Ghostty」だと判別できない。
-- その結果 Ghostty の supported/placeholders=true が適用されず kitty graphics 非対応扱いになり、
-- インライン描画ができず崩れた float（ポップアップ）に落ちる。
-- SNACKS_GHOSTTY=1 で Ghostty 検出を強制し、unicode プレースホルダ方式のインライン描画を有効にする。
vim.env.SNACKS_GHOSTTY = "1"

require("snacks").setup({
  -- --------------------------------------------------------------------------
  -- notifier（通知 UI）
  -- noice.nvim の notify ビューは backend = { "snacks", "notify" } で、snacks の
  -- notifier が有効なら最優先で使う（無効時のみ nvim-notify にフォールバック）。
  -- ここを有効化することで noice の通知が snacks 側に集約される（plugins/noice.lua）。
  -- --------------------------------------------------------------------------
  notifier = { enabled = true },
  -- --------------------------------------------------------------------------
  -- explorer（snacks.picker ベースのサイドバー型ファイルツリー）
  -- AI の変更レビュー用途なので、生成物や設定ファイルも含め全ファイルを見たい。
  -- 既定では隠しファイルと gitignore 対象が隠れるため、両方とも表示に倒す。
  -- 起動後も list 上で H（hidden 切替）/ I（ignored 切替）でトグルできる。
  -- --------------------------------------------------------------------------
  explorer = { enabled = true }, -- :Explorer / Snacks.explorer() を有効化（netrw も置換）
  picker = {
    sources = {
      explorer = {
        hidden = true,  -- ドットファイル等の隠しファイルも表示する
        ignored = true, -- .gitignore で無視されるファイルも表示する
      },
    },
  },
  image = {
    -- 端末応答破壊の原因だった tmux `extended-keys always` を off にし、Shift+Enter を
    -- Ghostty の keybind に移したため再有効化する（snacks #2332 の回避策が効くようになる）。
    enabled = true,
    doc = {
      enabled = true, -- markdown 等ドキュメント内の画像 / mermaid 図を描画する
      inline = true,  -- バッファ内にインライン表示する
      float = true,   -- インライン不可時はフロートにフォールバックする
      -- mermaid のソースコードを隠して図だけ見せる（数式も既定で隠す）
      conceal = function(lang, type)
        return type == "math" or lang == "mermaid"
      end,
    },
    -- LaTeX 数式の描画は無効化（tectonic / ImageMagick 未導入。render-markdown 側でも無効化済み）
    math = { enabled = false },
    -- mermaid 変換は snacks 既定の convert.mermaid（mmdc 呼び出し）をそのまま使う
  },
})

-- ----------------------------------------------------------------------------
-- キーマップ（リーダーは "," なので ,e で起動）
-- ----------------------------------------------------------------------------
vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer() -- ファイルエクスプローラーを開く（開いていればフォーカス）
end, { desc = "Snacks: ファイルエクスプローラー" })

-- ----------------------------------------------------------------------------
-- トグル類（Snacks.toggle）。:map は which-key 連携・通知付きで登録される
-- ----------------------------------------------------------------------------
-- inlay hints の ON/OFF（内部で vim.lsp.inlay_hint.enable）。初期状態は
-- lua/lsp.lua の LspAttach で ON。,uh は一時的に OFF/ON を切り替える用途。
Snacks.toggle.inlay_hints():map("<leader>uh")

-- explorer の git sign を外部 git 操作後に確実に再描画させる workaround。
-- snacks 本体には 2 つの取りこぼしがあり、両方を補正する必要がある:
--   (1) .git/index の uv.fs_event 監視を外部ツール (CLI / Claude Code 等) からの
--       commit で取りこぼし、git status cache (TTL 15 分) が更新されない。
--   (2) snacks/explorer/git.lua の M._update が node.status / node.ignored は
--       walk クリアするが node.dir_status をクリアしないため、過去に untracked
--       だった directory に "??" が tree node に残り続ける。さらに renderer は
--       "子の status が無ければ親の dir_status を継承する" (source/explorer.lua:235)
--       仕様なので、stale な dir_status は子 node の sign 表示にも波及する。
--
-- (2) の対処:
--   _update をラップして、status/ignored の同期クリア walk と同じタイミングで
--   dir_status も全クリアし、その後 original が現在の results から再設定する。
--   ただし original の戻り値 (changed) は { status, ignored } の差分しか見ない
--   ため、dir_status だけ変わった場合に on_update が発火しない。これを補うため
--   dir_status を含めた追加 snapshot で差分判定し、必要なら changed=true を返す。
--   こうしておけば fs_event 経由で _update が呼ばれた時も再描画が走る。
local Git = require("snacks.explorer.git")
local Tree = require("snacks.explorer.tree")
if not Git._update_dir_status_patched then
  local original_update = Git._update
  Git._update = function(cwd, results)
    local node = Tree:find(cwd)
    if not node then
      return original_update(cwd, results)
    end
    local pre = Tree:snapshot(node, { "dir_status" })
    Tree:walk(node, function(n) n.dir_status = nil end, { all = true })
    local changed = original_update(cwd, results)
    if not changed then
      changed = Tree:changed(node, pre)
    end
    return changed
  end
  Git._update_dir_status_patched = true
end

-- (1) の対処: FocusGained 等で explorer_update アクションを叩く。`u` 押下と同等で、
-- 内部的に Tree:refresh → Git.refresh (cache 無効化) → picker:find → Git.update
-- → _update (パッチ済み) → on_update → 再描画 という確実な経路を通る。
--
-- alt-tab 連打などで FocusGained が短時間に複数回発火すると picker:find と
-- 非同期 git fetch が交錯し、中間状態の Tree から items を組まれて signs が
-- 一瞬消えたように見えることがある。最後のイベントから 200ms 静まってから
-- 1 回だけ refresh が走るよう、共有タイマーで debounce する。
-- 200ms の遅延は .git/index.lock の write 完了を待つ目的も兼ねる。
local refresh_timer = assert((vim.uv or vim.loop).new_timer()) -- 非 nil を保証 (型警告対策)
local function schedule_refresh()
  refresh_timer:stop()
  refresh_timer:start(200, 0, vim.schedule_wrap(function()
    for _, picker in ipairs(Snacks.picker.get({ source = "explorer" })) do
      picker:action("explorer_update")
    end
  end))
end

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("snacks_explorer_git_refresh", { clear = true }),
  callback = schedule_refresh,
})
