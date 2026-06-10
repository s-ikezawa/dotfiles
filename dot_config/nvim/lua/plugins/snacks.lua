-- ~/.config/nvim/lua/plugins/snacks.lua
-- Snacks (Picker / Explorer)

-- explorer の <c-h/j/k/l> によるペイン/ウィンドウ移動。
-- snacks の explorer(input/list)はレイアウトボックス内の「フローティング
-- ウィンドウ」で、ここからの `wincmd h/j/k/l` はどの方向でも隣のウィンドウへ
-- 飛んでしまう。そのため vim-tmux-navigator は「ウィンドウが変わった=端ではない」
-- と誤判定し、tmux ペインへ抜けられず誤った場所へ止まってしまう。
-- 対策として wincmd に依存せず、画面座標から「その方向に隣接する通常ウィンドウ」を
-- 自前で探し、あればそこへ、無ければ tmux ペインへ移動する。
-- これにより explorer が左/右どちらに配置されていても正しく機能する。
local function snacks_nav(dir)
  local flag = ({ h = "L", j = "D", k = "U", l = "R" })[dir]
  local function is_float(w)
    return vim.api.nvim_win_get_config(w).relative ~= ""
  end
  local function rect(w)
    local p = vim.api.nvim_win_get_position(w)
    return {
      top = p[1], left = p[2],
      bottom = p[1] + vim.api.nvim_win_get_height(w),
      right = p[2] + vim.api.nvim_win_get_width(w),
    }
  end
  return function()
    local cur = vim.api.nvim_get_current_win()
    -- フローティング(list/input)の場合は、それを包含する非フロート
    -- コンテナ(explorer 本体)の矩形を基準にする。
    local box = cur
    if is_float(cur) then
      local cr = rect(cur)
      for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if not is_float(w) then
          local r = rect(w)
          if cr.left >= r.left and cr.right <= r.right and cr.top >= r.top and cr.bottom <= r.bottom then
            box = w
            break
          end
        end
      end
    end
    local br = rect(box)
    -- 指定方向に隣接する通常(非フロート)ウィンドウを探す。
    local target
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if w ~= box and not is_float(w) then
        local r = rect(w)
        local overlap_v = r.top < br.bottom and r.bottom > br.top
        local overlap_h = r.left < br.right and r.right > br.left
        if dir == "h" and r.right <= br.left and overlap_v then target = w
        elseif dir == "l" and r.left >= br.right and overlap_v then target = w
        elseif dir == "k" and r.bottom <= br.top and overlap_h then target = w
        elseif dir == "j" and r.top >= br.bottom and overlap_h then target = w
        end
        if target then break end
      end
    end
    if target then
      vim.api.nvim_set_current_win(target)
    elseif vim.env.TMUX then
      vim.fn.system({ "tmux", "select-pane", "-" .. flag })
    end
  end
end
local explorer_nav_keys = {
  ["<c-h>"] = { snacks_nav("h"), mode = { "i", "n" }, desc = "左のウィンドウ/ペインへ移動" },
  ["<c-j>"] = { snacks_nav("j"), mode = { "i", "n" }, desc = "下のウィンドウ/ペインへ移動" },
  ["<c-k>"] = { snacks_nav("k"), mode = { "i", "n" }, desc = "上のウィンドウ/ペインへ移動" },
  ["<c-l>"] = { snacks_nav("l"), mode = { "i", "n" }, desc = "右のウィンドウ/ペインへ移動" },
}

require("snacks").setup({
  picker = {
    enabled = true, -- ファジーピッカーを有効にする
    hidden = true,  -- ドットファイル(隠しファイル)も表示する
    ignored = true, -- .gitignore で無視されているファイルも表示する
    -- 通常の picker(files/grep 等)はフローティングなので、<c-j>/<c-k> は
    -- snacks 既定のリスト移動(list_down/list_up)のまま使う。
    -- Explorer だけは下記 sources.explorer で tmux ペイン移動に差し替える。
    sources = {
      explorer = {
        hidden = true,  -- Explorer でも隠しファイルを表示する
        ignored = true, -- Explorer でも .gitignore 対象のファイルを表示する
        -- Explorer は全高サイドバー。フローティングな list/input から wincmd では tmux ペインへ抜けられないため、explorer_nav_keys で直接移動させる。
        -- ※ win は top-level explorer ではなく picker.sources.explorer に置く必要がある。
        win = {
          list  = { keys = explorer_nav_keys },
          input = { keys = explorer_nav_keys },
        },
      },
    },
  },
  explorer = {
    enabled = true,       -- ファイルエクスプローラを有効にする(picker ベース)
    replace_netrw = true, -- 標準の netrw を置き換える
  },
  indent = {
    enabled = true, -- インデントガイド(インデントライン)とスコープ強調を有効にする
  },
})

-- Picker / Explorer のキーマップ
local map = vim.keymap.set
-- Explorer
map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Explorer を開く" })
-- Picker (検索)
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "ファイル検索" })
map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Grep 検索" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "バッファ一覧" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "最近開いたファイル" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "ヘルプ検索" })
map("n", "<leader>fp", function() Snacks.picker() end, { desc = "Picker 一覧" })

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
