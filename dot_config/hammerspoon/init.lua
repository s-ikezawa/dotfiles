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

hs.alert.show("Hammerspoon の設定を読み込みました")
