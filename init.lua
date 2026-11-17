-- Option + Tab で「同一アプリのウィンドウ」を順番に切り替える
-- まず同一スペースのみを対象にし、足りない場合は全スペースへ拡張する
local function windowsInFocusedApp()
    local focusedWindow = hs.window.focusedWindow()
    if not focusedWindow then
        return {}
    end

    local app = focusedWindow:application()
    if not app then
        return {}
    end

    local function windowsForApp(spaceId)
        local list = {}
        for _, win in ipairs(hs.window.allWindows()) do
            if win:application() == app and win:isStandard() then
                if spaceId then
                    local spaces = hs.spaces.windowSpaces(win) or {}
                    for _, id in ipairs(spaces) do
                        if id == spaceId then
                            table.insert(list, win)
                            break
                        end
                    end
                else
                    table.insert(list, win)
                end
            end
        end
        table.sort(list, function(a, b)
            return a:id() < b:id()
        end)
        return list
    end

    local focusedSpace = hs.spaces.focusedSpace()
    local windows = windowsForApp(focusedSpace)
    if #windows < 2 then
        windows = windowsForApp(nil)
    end

    return windows
end

local function focusWindowWithSpace(win)
    if not win then
        return
    end

    local targetSpaces = hs.spaces.windowSpaces(win) or {}
    local targetSpace = targetSpaces[1]
    local focusedSpace = hs.spaces.focusedSpace()

    if targetSpace and focusedSpace and targetSpace ~= focusedSpace then
        hs.spaces.gotoSpace(targetSpace)
    end

    if win:isMinimized() then
        win:unminimize()
    end

    local app = win:application()
    if app then
        app:activate(true)
    end

    win:raise()
    win:focus()
end

local function debugFocusedAppWindows()
    local focusedWindow = hs.window.focusedWindow()
    if not focusedWindow then
        hs.alert.show("No focused window")
        return
    end

    local app = focusedWindow:application()
    if not app then
        hs.alert.show("No focused app")
        return
    end

    local windows = windowsInFocusedApp()
    local titles = {}
    local lines = {}

    for _, win in ipairs(windows) do
        local spaces = hs.spaces.windowSpaces(win) or {}
        local title = tostring(win:title())
        table.insert(titles, title)
        table.insert(lines, string.format(
            "[%s] id=%s title=%s standard=%s minimized=%s role=%s subrole=%s spaces=%s screen=%s",
            app:name(),
            tostring(win:id()),
            title,
            tostring(win:isStandard()),
            tostring(win:isMinimized()),
            tostring(win:role()),
            tostring(win:subrole()),
            hs.inspect(spaces),
            tostring(win:screen() and win:screen():name() or "unknown")
        ))
        print(lines[#lines])
    end

    local summary = string.format("Windows: %d\n%s", #windows, table.concat(titles, " | "))
    hs.alert.show(summary)
    hs.pasteboard.setContents(table.concat(lines, "\n"))
    hs.alert.show("Debug info copied to clipboard")
end

hs.hotkey.bind({ "alt" }, "tab", function()
    local windows = windowsInFocusedApp()
    if #windows < 2 then
        return
    end

    local focusedWindow = hs.window.focusedWindow()
    if not focusedWindow then
        windows[1]:focus()
        return
    end

    local nextWindow = nil
    for i, win in ipairs(windows) do
        if win:id() == focusedWindow:id() then
            if i == #windows then
                nextWindow = windows[1]
            else
                nextWindow = windows[i + 1]
            end
            break
        end
    end

    if nextWindow then
        focusWindowWithSpace(nextWindow)
    else
        focusWindowWithSpace(windows[1])
    end
end)

-- 設定保存時に自動リロード
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function()
    hs.reload()
end):start()

require("split_screen")

hs.alert.show("Hammerspoon Config Loaded")
