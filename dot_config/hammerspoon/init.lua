-- Hammerspoon の設定（~/.config/hammerspoon/init.lua）。
-- 置き場所は mise の [bootstrap.macos.defaults."org.hammerspoon.Hammerspoon"] の MJConfigFile で変えている。

-- ウィンドウを動かすときのアニメーションを切って、すぐに動かす
hs.window.animationDuration = 0

--------------------------------------------------------------------------------
-- 設定ファイルが変わったら読み直す（chezmoi apply で置き換えたときも含む）
--------------------------------------------------------------------------------
ConfigWatcher = hs.pathwatcher.new(hs.configdir, function(paths)
  for _, path in ipairs(paths) do
    if path:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end):start()

--------------------------------------------------------------------------------
-- フォーカスしているウィンドウを、一時的に画面の中央に大きく出す。
-- もう一度押すと、出す前の位置と大きさにそのまま戻す（人に画面を見せて説明するときなど）。
--------------------------------------------------------------------------------
-- 中央に出したときの大きさ。メニューバーと Dock を除いた範囲に対する割合
local centerRatio = { w = 0.6, h = 0.7 }

-- 中央に出す前の位置と大きさ。ウィンドウの ID ごとに覚えておく
local savedFrames = {}

local function toggleCenter()
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local id = win:id()
  if savedFrames[id] then
    win:setFrame(savedFrames[id])
    savedFrames[id] = nil
    return
  end

  savedFrames[id] = win:frame()
  local screen = win:screen():frame() -- メニューバーと Dock を除いた範囲
  local w = screen.w * centerRatio.w
  local h = screen.h * centerRatio.h
  win:setFrame({
    x = screen.x + (screen.w - w) / 2,
    y = screen.y + (screen.h - h) / 2,
    w = w,
    h = h,
  })
end

-- Ctrl + Option + Enter
hs.hotkey.bind({ "ctrl", "alt" }, "return", toggleCenter)

--------------------------------------------------------------------------------
-- いまのモニターの構成に合わせて、アプリのウィンドウを決まった位置に並べ直す。
-- 家と会社でモニターが違うので、構成（つながっているモニターの名前の組み合わせ）ごとに
-- 並び方を書く。勝手には並べ直さず、キーを押したときだけ並べる。
--------------------------------------------------------------------------------
-- 構成ごとの並び方。
--   screens: その構成でつながっているモニターの名前（hs.screen:name()。順番は問わない）
--   windows: アプリ（バンドル ID）ごとの置き場所。frame はモニターの、メニューバーと Dock を
--            除いた範囲（hs.screen:frame()）を受け取り、置く位置と大きさを返す関数
-- バンドル ID は `osascript -e 'id of app "アプリ名"'` で調べられる。
local layouts = {
  {
    name = "家（4K 1 枚）",
    screens = { "DELL U4320Q" },
    windows = {
      -- 画面を FHD の高さで上下 2 段に分け、中央の FHD の幅に置く
      -- 下の段の中央に FHD（1920 × 1080）
      ["com.mitchellh.ghostty"] = function(f)
        return { x = f.x + (f.w - 1920) / 2, y = f.y + f.h - 1080, w = 1920, h = 1080 }
      end,
      -- 上の段の中央に、Ghostty と同じ幅で。高さはメニューバーの下から Ghostty の上まで
      ["com.google.Chrome"] = function(f)
        return { x = f.x + (f.w - 1920) / 2, y = f.y, w = 1920, h = f.h - 1080 }
      end,
      -- 上の段の、Chrome の右（Chrome の右端から画面の右端まで）。高さは Chrome と同じ
      ["com.brave.Browser"] = function(f)
        return { x = f.x + (f.w + 1920) / 2, y = f.y, w = (f.w - 1920) / 2, h = f.h - 1080 }
      end,
    },
  },
}

-- つながっているモニターの名前の一覧（並べ替え済み）
local function screenNames()
  local names = {}
  for _, screen in ipairs(hs.screen.allScreens()) do
    table.insert(names, screen:name() or "（名前なし）")
  end
  table.sort(names)
  return names
end

-- いまの構成に合う並び方を探す。モニターの名前の組み合わせが同じものを選ぶ
local function findLayout()
  local current = table.concat(screenNames(), "\n")
  for _, layout in ipairs(layouts) do
    local names = { table.unpack(layout.screens) }
    table.sort(names)
    if table.concat(names, "\n") == current then
      return layout
    end
  end
  return nil
end

local function applyLayout()
  local layout = findLayout()
  if not layout then
    hs.alert.show("この構成の並び方はまだありません: " .. table.concat(screenNames(), "、"), 5)
    return
  end

  -- いまはどの構成もモニターが 1 枚なので、メインのモニターに置く
  local screen = hs.screen.mainScreen()
  for bundleID, frameOf in pairs(layout.windows) do
    local app = hs.application.get(bundleID)
    if app then
      for _, win in ipairs(app:allWindows()) do
        if win:isStandard() then
          win:setFrame(frameOf(screen:frame()))
        end
      end
    end
  end
  savedFrames = {} -- 並べ直したので、中央に出す前の位置は捨てる
  hs.alert.show("並べ直しました: " .. layout.name)
end

-- Ctrl + Option + L
hs.hotkey.bind({ "ctrl", "alt" }, "l", applyLayout)

--------------------------------------------------------------------------------
-- Neovim の which-key のように、リーダーキー（Ctrl + Option + /）を押すと、次に押せるキーと
-- その内容を画面に出す。続けてキーを押すと実行し、Esc かもう一度リーダーキーで閉じる。
-- キーが増えても覚えるのはリーダーキーだけで済むようにする。
-- 一覧に無いキーを押したときは、一覧を開いたまま、そのキーはアプリにそのまま届く。
--------------------------------------------------------------------------------
-- リーダーキーの後に押すキーと、その内容。キーを足すときはここに 1 行足す。
--   key:   hs.hotkey に渡すキーの名前、label: 一覧に出す名前（省くと key をそのまま出す）
--   desc:  一覧に出す説明、fn: 実行する関数
local showRexKeys -- 下の Rex の節で定義する
local whichKeyItems = {
  { key = "x", desc = "Rex の Ctrl+A のキーの一覧を出す", fn = function() showRexKeys() end },
  { key = "l", desc = "モニターの構成に合わせてウィンドウを並べ直す", fn = applyLayout },
  { key = "return", label = "Enter", desc = "ウィンドウを中央に大きく出す／元に戻す", fn = toggleCenter },
  { key = "r", desc = "Hammerspoon の設定を読み直す", fn = hs.reload },
}

-- 一覧の見た目。配色は Ghostty・Neovim と同じ Catppuccin Mocha、フォントは Ghostty と同じ
local whichKeyStyle = {
  font = "UDEVGothic35NF-Regular",
  fontSize = 20,
  padding = 24,
  width = 720,
  background = { hex = "#1e1e2e", alpha = 0.95 }, -- Base
  border = { hex = "#89b4fa" },                   -- Blue
  title = { hex = "#89b4fa" },                    -- Blue
  key = { hex = "#fab387" },                      -- Peach
  text = { hex = "#cdd6f4" },                     -- Text
}

local whichKeyCanvas = nil

-- items は { label = 一覧に出すキー, desc = 説明 } の並び
local function whichKeyText(title, items)
  local s = whichKeyStyle
  local function styled(str, color)
    return hs.styledtext.new(str, { font = { name = s.font, size = s.fontSize }, color = color })
  end

  local text = styled(title .. "\n\n", s.title)
  for _, item in ipairs(items) do
    text = text .. styled(string.format("%-6s", item.label), s.key) .. styled("  " .. item.desc .. "\n", s.text)
  end
  return text
end

local function hideWhichKey()
  if whichKeyCanvas then
    whichKeyCanvas:delete()
    whichKeyCanvas = nil
  end
end

-- 一覧を出す。position が "bottom" なら画面の下寄りに出す（既定は中央）
local function showWhichKeyList(title, items, position)
  hideWhichKey()
  local s = whichKeyStyle
  local lineHeight = s.fontSize * 1.5
  local height = s.padding * 2 + lineHeight * (#items + 2)
  local screen = hs.screen.mainScreen():frame()
  local y = position == "bottom" and (screen.y + screen.h - height - 48) or (screen.y + (screen.h - height) / 2)

  whichKeyCanvas = hs.canvas.new({
    x = screen.x + (screen.w - s.width) / 2,
    y = y,
    w = s.width,
    h = height,
  })
  whichKeyCanvas:appendElements(
    {
      type = "rectangle",
      action = "strokeAndFill",
      fillColor = s.background,
      strokeColor = s.border,
      strokeWidth = 2,
      roundedRectRadii = { xRadius = 12, yRadius = 12 },
    },
    {
      type = "text",
      text = whichKeyText(title, items),
      frame = { x = s.padding, y = s.padding, w = s.width - s.padding * 2, h = height - s.padding * 2 },
    }
  )
  whichKeyCanvas:level(hs.canvas.windowLevels.overlay)
  whichKeyCanvas:show()
end

local function showWhichKey()
  local items = {}
  for _, item in ipairs(whichKeyItems) do
    table.insert(items, { label = item.label or item.key, desc = item.desc })
  end
  showWhichKeyList("Hammerspoon（Esc で閉じる）", items)
end

-- Ctrl + Option + /
local whichKey = hs.hotkey.modal.new({ "ctrl", "alt" }, "/")
whichKey.entered = showWhichKey
whichKey.exited = hideWhichKey
whichKey:bind({}, "escape", function() whichKey:exit() end)
whichKey:bind({ "ctrl", "alt" }, "/", function() whichKey:exit() end)
for _, item in ipairs(whichKeyItems) do
  whichKey:bind({}, item.key, function()
    whichKey:exit() -- 先に閉じてから実行する（並べ直しや中央表示に一覧が重ならないように）
    item.fn()
  end)
end

--------------------------------------------------------------------------------
-- Rex の which-key。Rex が前面にあるときに Ctrl+A（Rex の init.lua の prefix）を押すと、
-- 続けて押せるキーを上の一覧と同じ見た目で出す。Rex には次に押せるキーを出す機能がないため。
-- キーは横取りせず見るだけなので、Rex にはそのまま届く。次のキーを押すと消える。
-- そのキーでキーモード（client.mode.enter）に入ったら、モードの中のキーを出したままにし、Esc で消す。
-- キーの一覧は `rex keymap --json` から作るので、Rex の init.lua にキーを足せば一覧にも出る。
--------------------------------------------------------------------------------
local rexBundleID = "com.superlogical.rex"
-- Hammerspoon からはシェルの PATH が見えないので、rex を置き場所で呼ぶ
local rexCommand = os.getenv("HOME")
  .. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex"
local rexPrefix = "ctrl+a"

-- 一覧に出す説明。ここに無いアクションは、アクションの名前と引数をそのまま出す
local rexActionDesc = {
  ["pane.split.right"] = "左右に分割する",
  ["pane.split.down"] = "上下に分割する",
  ["pane.focus.left"] = "左のブロックへ",
  ["pane.focus.down"] = "下のブロックへ",
  ["pane.focus.up"] = "上のブロックへ",
  ["pane.focus.right"] = "右のブロックへ",
  ["pane.balance"] = "分割を均等に戻す",
  ["pane.send_key"] = "Ctrl+A をターミナルに送る",
  ["client.tab.rename"] = "タブの名前を変える",
  ["session.rename"] = "セッションの名前を変える",
  ["session.next"] = "次のセッションへ",
  ["session.previous"] = "前のセッションへ",
}
local rexDirection = { left = "左", right = "右", up = "上", down = "下" }
local rexModeDesc = { navigate = "ナビゲートモード", resize = "リサイズモード" }

local function rexDescribe(b)
  local args = b.args or {}
  if b.action == "client.mode.enter" then
    return (rexModeDesc[args.name] or (args.name .. " モード")) .. "に入る"
  elseif b.action == "pane.resize" and rexDirection[args.direction] then
    return "境界線を" .. rexDirection[args.direction] .. "へ動かす"
  end
  local desc = rexActionDesc[b.action]
  if desc then return desc end
  return b.args and (b.action .. " " .. hs.json.encode(b.args)) or b.action
end

-- Rex のキーの書き方を、一覧に出す形にする（shift+\ → |、ctrl+a → Ctrl+A など）
local rexShifted = { ["\\"] = "|", ["4"] = "$", ["-"] = "_", ["="] = "+", [","] = "<", ["."] = ">", ["/"] = "?" }
local function rexLabel(key)
  local base = key:match("^shift%+(.+)$")
  if base and rexShifted[base] then return rexShifted[base] end
  return (key:gsub("ctrl%+", "Ctrl+"):gsub("shift%+", "Shift+"):gsub("alt%+", "Opt+"):gsub("cmd%+", "Cmd+"))
end

local rexBindings = {} -- 最後に読んだ rex keymap --json の bindings

-- 裏で rex keymap --json を読み直す。読み終えたら done を呼ぶ（省いてよい）
local function rexReloadKeymap(done)
  hs.task.new(rexCommand, function(code, out)
    if code == 0 then
      local ok, data = pcall(hs.json.decode, out)
      if ok and data and data.bindings then rexBindings = data.bindings end
    end
    if done then done() end
  end, { "keymap", "--json" }):start()
end

-- init.lua の書いた順に並べる（source は "init.lua:<行>"）
local function rexLine(b) return tonumber((b.source or ""):match(":(%d+)$")) or 0 end

-- mode が nil なら prefix に続くキー、名前ならそのモードの中のキー
local function rexItems(mode)
  local list = {}
  for _, b in ipairs(rexBindings) do -- JSON の null（モードの外）は nil になる
    local match
    if mode == nil then
      match = b.mode == nil and #b.keys == 2 and b.keys[1] == rexPrefix
    else
      match = b.mode == mode and #b.keys == 1
    end
    if match then table.insert(list, b) end
  end
  table.sort(list, function(a, b) return rexLine(a) < rexLine(b) end)
  local items = {}
  for _, b in ipairs(list) do
    table.insert(items, { label = rexLabel(b.keys[#b.keys]), desc = rexDescribe(b), binding = b })
  end
  return items
end

-- 一覧を出しているかと、何の一覧か。
--   nil: 出していない、"prefix": Ctrl+A を押した後、"list": リーダーキーから出した（次のキーで消す）、
--   それ以外: そのキーモードの中
local rexState = nil

local function rexHide()
  rexState = nil
  hideWhichKey()
end

-- 下寄りに出す（リサイズモードで、画面の中央にある境界線が隠れないように）
local function rexShowPrefix()
  rexState = "prefix"
  showWhichKeyList("Rex: Ctrl+A に続けて押すキー", rexItems(nil), "bottom")
end

local function rexShowMode(name)
  rexState = name
  showWhichKeyList("Rex: " .. (rexModeDesc[name] or name) .. "（Esc で抜ける）", rexItems(name), "bottom")
end

-- リーダーキーから出す。Rex に Ctrl+A は届いていないので、次のキーはモードに入るかを見ずに消すだけにする
showRexKeys = function()
  rexReloadKeymap(function()
    rexShowPrefix()
    rexState = "list"
  end)
end

-- キーを押したときの Rex のキーの名前（Shift を押さない側の文字。Rex の照合と同じ）
local function rexKeyName(event)
  local key = hs.keycodes.map[event:getKeyCode()]
  if not key then return nil end
  local flags = event:getFlags()
  local mods = {}
  if flags.ctrl then table.insert(mods, "ctrl") end
  if flags.alt then table.insert(mods, "alt") end
  if flags.shift then table.insert(mods, "shift") end
  if flags.cmd then table.insert(mods, "cmd") end
  table.insert(mods, key)
  return table.concat(mods, "+")
end

local function rexIsFront()
  local app = hs.application.frontmostApplication()
  return app ~= nil and app:bundleID() == rexBundleID
end

-- キーを押すたびに呼ばれる。false を返して、キーは必ず Rex に届ける。
-- macOS は時間のかかるコールバックのイベントタップを止めるので、ここでは rex を待たない。
-- イベントタップとウォッチャーは、ローカル変数にするとガベージコレクションで止まるのでグローバルに置く
RexKeyTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  if not rexIsFront() then
    if rexState then rexHide() end
    return false
  end
  local key = rexKeyName(event)

  if rexState == "list" then
    rexHide()
  elseif rexState == "prefix" then
    local pressed = nil
    for _, item in ipairs(rexItems(nil)) do
      if item.binding.keys[2] == key then pressed = item.binding end
    end
    if pressed and pressed.action == "client.mode.enter" and pressed.args and pressed.args.name then
      rexShowMode(pressed.args.name)
    else
      rexHide()
    end
  elseif rexState then -- キーモードの中
    if key == "escape" then rexHide() end
  elseif key == rexPrefix then
    rexShowPrefix()         -- いま覚えている一覧ですぐ出し、
    rexReloadKeymap(function() -- 読み直したら出し直す（init.lua を変えた直後でも合うように）
      if rexState == "prefix" then rexShowPrefix() end
    end)
  end
  return false
end):start()

-- Rex から離れたら消す
RexAppWatcher = hs.application.watcher.new(function(_, eventType, app)
  if eventType == hs.application.watcher.deactivated and app and app:bundleID() == rexBundleID then rexHide() end
end):start()

rexReloadKeymap()

hs.alert.show("Hammerspoon の設定を読み込みました")
