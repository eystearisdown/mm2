--[[ 
Nevoirs - Auto Egao Glass v3
Bám sát logic gốc; thêm loop FullBright/NoFog + auto nhìn EgaoEventRig khi Egao xuất hiện.
Lobby -> MimicSaveSync(0,1) -> Forest -> đợi loading/IntroCutscene -> check EgaoPulseText -> hop lại Lobby nếu không có.
]]

local PAYLOAD = [===[
-- Nevoirs - Auto Egao Glass v3 | Runtime payload

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local LOBBY_PLACE_ID = 6243699076
local FOREST_PLACE_ID = 128715637193371
local CHECK_CF = CFrame.new(-3658, 8, 372)

getgenv().NevoirsEgao = getgenv().NevoirsEgao or {}
local STATE = getgenv().NevoirsEgao
STATE.Running = true
STATE.Hops = STATE.Hops or 0
STATE.StartedAt = STATE.StartedAt or os.time()
STATE.Visual = STATE.Visual or { FullBright = true, NoFog = true, Started = false }
STATE.Visual.FullBright = STATE.Visual.FullBright ~= false
STATE.Visual.NoFog = STATE.Visual.NoFog ~= false
STATE.Visual.Started = false
STATE.AutoLook = STATE.AutoLook or { Enabled = true }
STATE.AutoLook.Enabled = STATE.AutoLook.Enabled ~= false
STATE.AutoLook.Active = false
STATE.AutoLook.TargetName = "-"
STATE.AutoLook.TargetDistance = "-"
STATE.AutoLook.LastReason = "idle"

print("[Nevoirs Auto Egao Glass v3] boot", game.PlaceId)

local function safe(fn, ...)
    local ok, result = pcall(fn, ...)
    if ok then return result end
end

local function getQueueFunction()
    local env = (getgenv and getgenv()) or _G
    local candidates = {
        rawget(env, "queue_on_teleport"),
        rawget(env, "queueonteleport"),
        rawget(env, "QueueOnTeleport"),
        queue_on_teleport,
        queueonteleport,
        QueueOnTeleport,
        syn and syn.queue_on_teleport,
        fluxus and fluxus.queue_on_teleport,
        KRNL_LOADED and queue_on_teleport,
    }

    for _, fn in ipairs(candidates) do
        if typeof(fn) == "function" then
            return fn
        end
    end
end

local function queueSelf()
    local q = getQueueFunction()
    local payload = rawget(getgenv(), "NEVOIRS_EGAO_PAYLOAD")
    if q and payload then
        local source = "getgenv().NEVOIRS_EGAO_PAYLOAD = " .. string.format("%q", payload) ..
            "\nloadstring(getgenv().NEVOIRS_EGAO_PAYLOAD)()"
        safe(q, source)
        return true
    end
    return false
end

local function mk(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        safe(function() obj[k] = v end)
    end
    obj.Parent = parent
    return obj
end

local gui = PG:FindFirstChild("NevoirsEgaoFinder")
if gui then gui:Destroy() end

-- Liquid Glass UI: gọn, giữa màn hình, không dùng thư viện ngoài.
gui = mk("ScreenGui", {
    Name = "NevoirsEgaoFinder",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, PG)

local frame = mk("Frame", {
    Name = "GlassMain",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 125, 0, 94),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = Color3.fromRGB(14, 32, 62),
    BackgroundTransparency = 0.06,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, gui)
mk("UICorner", { CornerRadius = UDim.new(0, 12) }, frame)
mk("UIStroke", {
    Color = Color3.fromRGB(165, 215, 255),
    Thickness = 1.1,
    Transparency = 0.22,
}, frame)
mk("UIGradient", {
    Rotation = 90,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(70, 170, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 18, 38)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.46),
        NumberSequenceKeypoint.new(0.35, 0.66),
        NumberSequenceKeypoint.new(1, 0.78),
    }),
}, frame)

local shine = mk("Frame", {
    Name = "GlassShine",
    Size = UDim2.new(1, -10, 0, 28),
    Position = UDim2.new(0, 5, 0, 4),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.70,
    BorderSizePixel = 0,
}, frame)
mk("UICorner", { CornerRadius = UDim.new(0, 10) }, shine)
mk("UIGradient", {
    Rotation = 7,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.38),
        NumberSequenceKeypoint.new(0.55, 0.76),
        NumberSequenceKeypoint.new(1, 0.92),
    }),
}, shine)

local frostBlobA = mk("Frame", {
    Name = "FrostBlobA",
    Size = UDim2.new(0, 54, 0, 54),
    Position = UDim2.new(0, -14, 1, -38),
    BackgroundColor3 = Color3.fromRGB(50, 170, 255),
    BackgroundTransparency = 0.70,
    BorderSizePixel = 0,
}, frame)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, frostBlobA)

local frostBlobB = mk("Frame", {
    Name = "FrostBlobB",
    Size = UDim2.new(0, 48, 0, 48),
    Position = UDim2.new(1, -34, 0, 34),
    BackgroundColor3 = Color3.fromRGB(95, 150, 255),
    BackgroundTransparency = 0.72,
    BorderSizePixel = 0,
}, frame)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, frostBlobB)

local title = mk("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -22, 0, 14),
    Position = UDim2.new(0, 11, 0, 8),
    BackgroundTransparency = 1,
    Text = "Nevoirs - Auto Egao",
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextColor3 = Color3.fromRGB(250, 252, 255),
    TextStrokeTransparency = 0.72,
    TextXAlignment = Enum.TextXAlignment.Center,
}, frame)

local statusLine = mk("TextLabel", {
    Name = "StatusLine",
    Size = UDim2.new(1, -10, 0, 10),
    Position = UDim2.new(0, 5, 0, 28),
    BackgroundTransparency = 1,
    RichText = true,
    Text = "Trạng Thái : <font color=\"#FFD769\">●</font> Off   |   Ping : 0 ms",
    Font = Enum.Font.GothamMedium,
    TextSize = 5,
    TextColor3 = Color3.fromRGB(224, 232, 244),
    TextStrokeTransparency = 0.80,
    TextXAlignment = Enum.TextXAlignment.Center,
}, frame)

local mainBox = mk("Frame", {
    Name = "MainStateBox",
    Size = UDim2.new(1, -24, 0, 20),
    Position = UDim2.new(0, 12, 0, 48),
    BackgroundColor3 = Color3.fromRGB(245, 250, 255),
    BackgroundTransparency = 0.54,
    BorderSizePixel = 0,
}, frame)
mk("UICorner", { CornerRadius = UDim.new(0, 8) }, mainBox)
mk("UIStroke", {
    Color = Color3.fromRGB(255, 255, 255),
    Thickness = 0.8,
    Transparency = 0.32,
}, mainBox)
mk("UIGradient", {
    Rotation = 0,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 180, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 238, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 135, 255)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.54),
        NumberSequenceKeypoint.new(0.5, 0.66),
        NumberSequenceKeypoint.new(1, 0.58),
    }),
}, mainBox)

local status = mk("TextLabel", {
    Name = "MainStateText",
    Size = UDim2.new(1, -8, 1, 0),
    Position = UDim2.new(0, 4, 0, 0),
    BackgroundTransparency = 1,
    Text = "Loading...",
    Font = Enum.Font.GothamBlack,
    TextSize = 8,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextStrokeTransparency = 0.60,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
}, mainBox)

local stop = mk("TextButton", {
    Name = "Stop",
    Size = UDim2.new(0, 12, 0, 12),
    Position = UDim2.new(1, -16, 0, 5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.62,
    BorderSizePixel = 0,
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 8,
    TextColor3 = Color3.fromRGB(255, 215, 220),
}, frame)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, stop)
mk("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Thickness = 0.8, Transparency = 0.48 }, stop)

-- Các label ẩn này giữ tương thích với logic gốc, nhưng UI chỉ hiện 3 phần chính như yêu cầu.
local detail = mk("TextLabel", {
    Name = "HiddenDetail",
    Visible = false,
    BackgroundTransparency = 1,
    Text = "",
}, frame)

local footer = mk("TextLabel", {
    Name = "HiddenFooter",
    Visible = false,
    BackgroundTransparency = 1,
    Text = "",
}, frame)

local rows = {}
local CURRENT_MODE = "Off"
local CURRENT_MAIN = "Loading..."
local CURRENT_ERROR = false

local MODE_COLOR = {
    Focus = "#72FF9A",
    Off = "#FFD769",
    ["Lỗi"] = "#FF5F6D",
}

local MAIN_COLOR = {
    ["Load Save"] = Color3.fromRGB(255, 236, 174),
    ["Loading..."] = Color3.fromRGB(214, 231, 255),
    ["Find Egao..."] = Color3.fromRGB(185, 220, 255),
    Return = Color3.fromRGB(255, 211, 142),
    ["Egao Is Here !!"] = Color3.fromRGB(130, 255, 170),
    Off = Color3.fromRGB(255, 215, 120),
    ["Lỗi"] = Color3.fromRGB(255, 125, 135),
}

local function readPing()
    local ping = safe(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    return math.floor(tonumber(ping) or 0)
end

local function updateGlassLine()
    local mode = CURRENT_MODE or "Off"
    local color = MODE_COLOR[mode] or MODE_COLOR.Off
    local ping = readPing()
    statusLine.Text = "Trạng Thái : <font color=\"" .. color .. "\">●</font> " .. mode .. "   |   Ping : " .. tostring(ping) .. " ms"

    status.Text = tostring(CURRENT_MAIN or "Loading...")
    status.TextColor3 = MAIN_COLOR[CURRENT_MAIN] or (mode == "Focus" and MAIN_COLOR["Egao Is Here !!"]) or (mode == "Lỗi" and MAIN_COLOR["Lỗi"]) or Color3.fromRGB(255, 255, 255)
end

local function setGlass(mode, mainText)
    CURRENT_MODE = mode or CURRENT_MODE or "Off"
    CURRENT_MAIN = mainText or CURRENT_MAIN or "Loading..."
    CURRENT_ERROR = CURRENT_MODE == "Lỗi"
    updateGlassLine()
end

local function containsAny(raw, lower, list)
    for _, token in ipairs(list) do
        if string.find(raw, token, 1, true) or string.find(lower, string.lower(token), 1, true) then
            return true
        end
    end
    return false
end

local function classifyMain(text)
    text = tostring(text or "")
    local lower = string.lower(text)

    if containsAny(text, lower, {"EGAO", "Egao", "egao", "Đang nhìn", "nhìn Egao"}) then
        return "Focus", "Egao Is Here !!"
    end

    if containsAny(text, lower, {"Lỗi", "Thiếu", "Error", "error"}) then
        return "Lỗi", "Lỗi"
    end

    if containsAny(text, lower, {"Không thấy", "không thấy", "Về Lobby", "Retry", "Return"}) then
        return "Off", "Return"
    end

    if containsAny(text, lower, {"Đang dò", "dò", "Pulse", "tín hiệu", "Find"}) then
        return "Off", "Find Egao..."
    end

    if containsAny(text, lower, {"Lobby", "Save", "save", "Vào Forest", "MimicSaveSync"}) then
        return "Off", "Load Save"
    end

    if containsAny(text, lower, {"Đợi", "Loading", "loading", "load", "Đến điểm", "khởi động", "Khởi động"}) then
        return "Off", "Loading..."
    end

    if containsAny(text, lower, {"Dừng", "dừng", "Stop", "stop", "Off", "off"}) then
        return "Off", "Off"
    end

    return CURRENT_MODE or "Off", text ~= "" and text or (CURRENT_MAIN or "Loading...")
end

local function row(name, y, value)
    rows[name] = tostring(value or "-")
end

local function setRow(name, value, color)
    rows[name] = tostring(value or "-")
    if name == "Look" then
        local v = string.lower(rows[name])
        if string.find(v, "active=y") or string.find(v, "tracking") then
            setGlass("Focus", "Egao Is Here !!")
        elseif not CURRENT_ERROR and CURRENT_MAIN == "Egao Is Here !!" then
            updateGlassLine()
        end
    elseif name == "Pulse" then
        local v = string.lower(rows[name])
        if string.find(v, "visible=y") or string.find(v, "visible=true") then
            setGlass("Focus", "Egao Is Here !!")
        end
    end
end

local function yn(v)
    return v and "Y" or "N"
end

local function refreshMiniRows()
    local root = PG:FindFirstChild("EgaoPulseText")
    local fr = root and root:FindFirstChild("Frame")

    rows.Pulse = "root=" .. yn(root) .. " frame=" .. yn(fr) .. " visible=" .. yn(fr and fr.Visible)
    rows.Visual = "FullBright=" .. yn(STATE.Visual.FullBright) .. " | NoFog=" .. yn(STATE.Visual.NoFog)
    rows.Look = "enabled=" .. yn(STATE.AutoLook.Enabled) .. " active=" .. yn(STATE.AutoLook.Active)
    rows.Target = tostring(STATE.AutoLook.TargetName or "-") .. " | d=" .. tostring(STATE.AutoLook.TargetDistance or "-")
    rows.Net = "ping=" .. tostring(readPing()) .. "ms | place=" .. tostring(game.PlaceId)

    if STATE.AutoLook.Active or (fr and fr.Visible) then
        if not CURRENT_ERROR then
            CURRENT_MODE = "Focus"
            CURRENT_MAIN = "Egao Is Here !!"
        end
    elseif not CURRENT_ERROR and CURRENT_MAIN == "Egao Is Here !!" then
        CURRENT_MODE = "Off"
    end

    updateGlassLine()
end

row("Pulse", 0, "root=N frame=N visible=N")
row("Target", 0, "-")
row("Look", 0, "enabled=Y active=N")
row("Visual", 0, "FullBright=Y | NoFog=Y")
row("Net", 0, "ping=? | place=" .. tostring(game.PlaceId))

local stopAutoLook = function() end

stop.MouseButton1Click:Connect(function()
    STATE.Running = false
    STATE.Visual.Started = false
    stopAutoLook("manual stop")
    setGlass("Off", "Off")
    detail.Text = "Script đã dừng trong phiên hiện tại."
end)

local function setStatus(a, b, color)
    local mode, mainText = classifyMain(a)
    if color == Color3.fromRGB(255, 160, 160) then
        mode, mainText = "Lỗi", "Lỗi"
    end
    setGlass(mode, mainText)

    if detail and detail.Parent and b then
        detail.Text = tostring(b)
    end
    if footer and footer.Parent then
        footer.Text = "Hop: " .. tostring(STATE.Hops) .. " | Place: " .. tostring(game.PlaceId)
    end
    refreshMiniRows()
end

setGlass("Off", "Loading...")
-- Auto Look nhẹ: dựa trên log thực tế Egao spawn thành Workspace.EgaoEventRig.
-- Không scan nặng. Chỉ bắt ChildAdded/DescendantAdded và quét direct children khi cần retarget.
local AUTO_LOOK_BIND = "NevoirsEgaoAutoLook"
local autoConnections = {}
local targetPart = nil
local targetModel = nil
local targetLabel = nil
local lastTargetSeenAt = 0
local autoStartedAt = 0
local lastRetargetAt = 0
local lastUiUpdateAt = 0

-- Delay nhẹ sau mỗi lần EgaoEventRig xuất hiện/dịch chuyển.
-- Log thực tế cho thấy rig spawn theo từng phase; chờ khoảng 1s giúp tránh lock camera quá sớm khi model vừa tạo/animation chưa ổn định.
local AUTO_LOOK_DELAY = 1.0
local rigFirstSeenAt = setmetatable({}, { __mode = "k" })
local pendingDelayNoticeAt = 0

local function markRigSeen(rig)
    if rig and not rigFirstSeenAt[rig] then
        rigFirstSeenAt[rig] = os.clock()
    end
    return (rig and rigFirstSeenAt[rig]) or os.clock()
end

local function rigReadyToLook(rig)
    local seenAt = markRigSeen(rig)
    local elapsed = os.clock() - seenAt
    return elapsed >= AUTO_LOOK_DELAY, math.max(0, AUTO_LOOK_DELAY - elapsed)
end

local FACE_PRIORITY = {
    "sw face",
    "r eye",
    "l eye",
    "teeth",
    "gums",
    "head",
    "face",
    "RootPart",
}

local function disconnectAutoConnections()
    for _, c in ipairs(autoConnections) do
        safe(function()
            if c and c.Disconnect then c:Disconnect() end
        end)
    end
    table.clear(autoConnections)
end

local function partAlive(part)
    return part and part.Parent and part:IsA("BasePart") and part:IsDescendantOf(workspace)
end

local function rigAlive(rig)
    return rig and rig.Parent and rig:IsDescendantOf(workspace)
end

local function getRoot()
    return LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
end

local function getDistanceText(part)
    local hrp = getRoot()
    if part and hrp then
        return tostring(math.floor((part.Position - hrp.Position).Magnitude))
    end
    return "-"
end

local function findTargetInRig(rig)
    if not rig then return nil, nil end
    for _, name in ipairs(FACE_PRIORITY) do
        local obj = safe(function()
            return rig:FindFirstChild(name, true)
        end)
        if obj and obj:IsA("BasePart") then
            return obj, name
        end
    end
    return nil, nil
end

local function setTarget(part, label, rig, reason)
    if not partAlive(part) then return false end
    targetPart = part
    targetModel = rig or part:FindFirstAncestor("EgaoEventRig") or part.Parent
    targetLabel = label or part.Name
    lastTargetSeenAt = os.clock()
    STATE.AutoLook.TargetName = tostring(targetLabel)
    STATE.AutoLook.TargetDistance = getDistanceText(part)
    STATE.AutoLook.LastReason = tostring(reason or "target")
    setRow("Target", tostring(STATE.AutoLook.TargetName) .. " | d=" .. tostring(STATE.AutoLook.TargetDistance), Color3.fromRGB(120, 255, 160))
    setRow("Look", "enabled=Y active=Y | " .. tostring(STATE.AutoLook.LastReason), Color3.fromRGB(120, 255, 160))
    return true
end

local function acquireRig(rig, reason)
    if not rig or rig.Name ~= "EgaoEventRig" then return end
    markRigSeen(rig)

    -- Mỗi phase/dịch chuyển tạo rig mới. Tạm nhả target cũ và chờ 1s rồi mới nhìn.
    if targetModel ~= rig then
        targetPart = nil
        targetModel = nil
        targetLabel = nil
        STATE.AutoLook.TargetName = "delay"
        STATE.AutoLook.TargetDistance = "-"
        setRow("Look", "delay " .. string.format("%.1fs", AUTO_LOOK_DELAY) .. " | " .. tostring(reason or "EgaoEventRig"), Color3.fromRGB(255, 205, 135))
        setRow("Target", "waiting settle | d=-", Color3.fromRGB(255, 205, 135))
    end

    task.spawn(function()
        local ready, remain = rigReadyToLook(rig)
        if not ready then
            task.wait(remain)
        end

        local started = os.clock()
        repeat
            local part, label = findTargetInRig(rig)
            if part then
                if setTarget(part, label, rig, reason or "EgaoEventRig") then
                    setStatus("Đang nhìn Egao", "Target: " .. tostring(label) .. " / " .. tostring(part.Name), Color3.fromRGB(120, 255, 160))
                    return
                end
            end
            task.wait(0.04)
        until os.clock() - started > 2.2 or not STATE.Running or not STATE.AutoLook.Active
    end)
end

local function scanExistingRig()
    local now = os.clock()
    if now - lastRetargetAt < 0.08 then return end
    lastRetargetAt = now

    local hrp = getRoot()
    local bestPart, bestLabel, bestRig, bestDist
    local children = safe(function() return workspace:GetChildren() end)
    if typeof(children) ~= "table" then return end

    for _, obj in ipairs(children) do
        if obj.Name == "EgaoEventRig" and obj:IsA("Model") then
            local ready, remain = rigReadyToLook(obj)
            if not ready then
                if STATE.AutoLook.Active and now - pendingDelayNoticeAt > 0.30 then
                    pendingDelayNoticeAt = now
                    setRow("Look", "delay " .. string.format("%.1fs", remain) .. " | waiting rig settle", Color3.fromRGB(255, 205, 135))
                    setRow("Target", "waiting settle | d=-", Color3.fromRGB(255, 205, 135))
                end
            else
                local part, label = findTargetInRig(obj)
                if partAlive(part) then
                    local dist = hrp and (part.Position - hrp.Position).Magnitude or 0
                    if not bestPart or dist < bestDist then
                        bestPart, bestLabel, bestRig, bestDist = part, label, obj, dist
                    end
                end
            end
        end
    end

    if bestPart then
        setTarget(bestPart, bestLabel, bestRig, "scan")
    end
end

local function getAimPosition(part, label)
    if not partAlive(part) then return nil end
    if tostring(label or part.Name) == "RootPart" then
        return part.Position + Vector3.new(0, 3.35, 0)
    end
    return part.Position
end

local function aimCameraAtTarget()
    local cam = workspace.CurrentCamera
    if not cam or not STATE.AutoLook.Active then return end

    if not partAlive(targetPart) or not rigAlive(targetModel) then
        targetPart = nil
        targetModel = nil
        targetLabel = nil
        STATE.AutoLook.TargetName = "searching"
        STATE.AutoLook.TargetDistance = "-"
        scanExistingRig()
        return
    end

    local targetPos = getAimPosition(targetPart, targetLabel)
    if not targetPos then return end

    local camPos = cam.CFrame.Position
    local delta = targetPos - camPos
    if delta.Magnitude < 1 then return end

    -- Apply after default camera; không đổi CameraType để tránh kẹt camera trên mobile.
    cam.CFrame = CFrame.lookAt(camPos, targetPos)

    if os.clock() - lastUiUpdateAt > 0.12 then
        lastUiUpdateAt = os.clock()
        STATE.AutoLook.TargetDistance = getDistanceText(targetPart)
        setRow("Target", tostring(targetLabel or targetPart.Name) .. " | d=" .. tostring(STATE.AutoLook.TargetDistance), Color3.fromRGB(120, 255, 160))
        setRow("Look", "tracking | " .. tostring(math.floor(os.clock() - autoStartedAt)) .. "s", Color3.fromRGB(120, 255, 160))
    end
end

local function startAutoLook(reason)
    if not STATE.AutoLook.Enabled then return end
    if STATE.AutoLook.Active then
        scanExistingRig()
        return
    end

    STATE.AutoLook.Active = true
    STATE.AutoLook.TargetName = "searching"
    STATE.AutoLook.TargetDistance = "-"
    STATE.AutoLook.LastReason = tostring(reason or "start")
    autoStartedAt = os.clock()
    lastTargetSeenAt = os.clock()
    targetPart = nil
    targetModel = nil
    targetLabel = nil

    setStatus("EGAO Ở ĐÂY", "Auto nhìn đã bật. Đang chờ Workspace.EgaoEventRig...", Color3.fromRGB(120, 255, 160))
    setRow("Look", "enabled=Y active=Y | waiting rig", Color3.fromRGB(120, 255, 160))
    setRow("Target", "searching | d=-", Color3.fromRGB(255, 205, 135))

    disconnectAutoConnections()

    table.insert(autoConnections, workspace.ChildAdded:Connect(function(obj)
        if STATE.AutoLook.Active and obj.Name == "EgaoEventRig" then
            acquireRig(obj, "child-added")
        end
    end))

    table.insert(autoConnections, workspace.DescendantAdded:Connect(function(obj)
        if not STATE.AutoLook.Active then return end
        if obj.Name == "EgaoEventRig" and obj:IsA("Model") then
            acquireRig(obj, "desc-added")
        elseif targetModel and obj:IsDescendantOf(targetModel) and obj:IsA("BasePart") then
            local part, label = findTargetInRig(targetModel)
            if part then setTarget(part, label, targetModel, "part-added") end
        elseif obj:IsA("BasePart") then
            local rig = obj:FindFirstAncestor("EgaoEventRig")
            if rig then
                local part, label = findTargetInRig(rig)
                if part then setTarget(part, label, rig, "rig-part-added") end
            end
        end
    end))

    scanExistingRig()

    safe(function()
        RunService:UnbindFromRenderStep(AUTO_LOOK_BIND)
    end)

    RunService:BindToRenderStep(AUTO_LOOK_BIND, Enum.RenderPriority.Camera.Value + 1, function()
        if not STATE.Running or not STATE.AutoLook.Active then return end
        if not partAlive(targetPart) then
            scanExistingRig()
        end
        aimCameraAtTarget()
    end)

    -- Egao nhiều phase. Giữ auto-look đủ lâu để bắt rig mới, rồi tự nhả camera nếu không còn target.
    task.spawn(function()
        while STATE.Running and STATE.AutoLook.Active do
            local elapsed = os.clock() - autoStartedAt
            if elapsed > 62 then
                stopAutoLook("timeout")
                break
            end
            task.wait(0.5)
        end
    end)
end

stopAutoLook = function(reason)
    if not STATE.AutoLook.Active and not targetPart then return end
    STATE.AutoLook.Active = false
    STATE.AutoLook.TargetName = "-"
    STATE.AutoLook.TargetDistance = "-"
    STATE.AutoLook.LastReason = tostring(reason or "stopped")
    targetPart = nil
    targetModel = nil
    targetLabel = nil
    disconnectAutoConnections()
    safe(function()
        RunService:UnbindFromRenderStep(AUTO_LOOK_BIND)
    end)
    setRow("Look", "enabled=" .. yn(STATE.AutoLook.Enabled) .. " active=N | " .. tostring(reason or "stopped"), Color3.fromRGB(255, 205, 135))
    setRow("Target", "-", nil)
end

local pulseWatchConnection = nil
local function armPulseWatcher()
    task.spawn(function()
        while STATE.Running do
            if not pulseWatchConnection then
                local root = PG:FindFirstChild("EgaoPulseText")
                local fr = root and root:FindFirstChild("Frame")
                if fr then
                    if fr.Visible then startAutoLook("pulse already visible") end
                    pulseWatchConnection = fr:GetPropertyChangedSignal("Visible"):Connect(function()
                        setRow("Pulse", "root=Y frame=Y visible=" .. yn(fr.Visible), fr.Visible and Color3.fromRGB(120, 255, 160) or Color3.fromRGB(255, 205, 135))
                        if fr.Visible then
                            startAutoLook("pulse visible")
                        end
                    end)
                end
            end
            task.wait(0.35)
        end
    end)
end

local function describeTeleportResult(result, msg)
    local name = tostring(result or "Unknown")
    if typeof(result) == "EnumItem" then
        name = result.Name
    end
    if msg and tostring(msg) ~= "" then
        return name .. " | " .. tostring(msg)
    end
    return name
end

safe(function()
    TeleportService.TeleportInitFailed:Connect(function(player, result, msg)
        if player ~= LP or not STATE.Running or not STATE.PendingLobbyTeleport then
            return
        end

        setStatus("Retry Lobby", describeTeleportResult(result, msg), Color3.fromRGB(255, 205, 135))
        task.delay(2.5, function()
            if not STATE.Running or not STATE.PendingLobbyTeleport then return end
            queueSelf()
            safe(function()
                TeleportService:Teleport(LOBBY_PLACE_ID, LP)
            end)
        end)
    end)
end)

local function getPingSeconds()
    local value = safe(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    value = tonumber(value) or 0
    return math.clamp(value / 1000, 0, 3)
end

local function applyLightOnly()
    local visual = STATE.Visual
    if not visual then return end

    if visual.FullBright then
        safe(function() Lighting.Brightness = 2 end)
        safe(function() Lighting.ClockTime = 14 end)
        safe(function() Lighting.GlobalShadows = false end)
        safe(function() Lighting.Ambient = Color3.fromRGB(255, 255, 255) end)
        safe(function() Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255) end)
    end

    if visual.NoFog then
        safe(function() Lighting.FogStart = 0 end)
        safe(function() Lighting.FogEnd = 1000000 end)
        -- Chỉ xử lý Atmosphere vì đây là sương/fog, không đụng Blur/Bloom/ColorCorrection/VHS GUI.
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") then
                safe(function() obj.Density = 0 end)
                safe(function() obj.Haze = 0 end)
                safe(function() obj.Glare = 0 end)
            end
        end
    end
end

local function startVisualLoop()
    if STATE.Visual.Started then return end
    STATE.Visual.Started = true
    task.spawn(function()
        while STATE.Running and STATE.Visual.Started do
            applyLightOnly()
            refreshMiniRows()
            task.wait(0.6)
        end
    end)
end

local function waitGameLoaded()
    if not game:IsLoaded() then
        setStatus("Đợi game", "Roblox/game chưa load xong...")
        safe(function() game.Loaded:Wait() end)
    end
    task.wait(0.8)
end

local function getCharacterRoot(timeout)
    timeout = timeout or 18
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart", timeout)
end

local function waitForPath(root, names, timeout)
    timeout = timeout or 20
    local started = os.clock()

    repeat
        local obj = root
        for _, name in ipairs(names) do
            obj = obj and obj:FindFirstChild(name)
        end
        if obj then return obj end
        task.wait(0.2)
    until os.clock() - started >= timeout or not STATE.Running
end

local function waitForEgaoGui(timeout)
    timeout = timeout or 25
    local started = os.clock()

    repeat
        local root = PG:FindFirstChild("EgaoPulseText")
        local fr = root and root:FindFirstChild("Frame")
        if fr then return fr end
        task.wait(0.15)
    until os.clock() - started >= timeout or not STATE.Running

    return nil
end

local function waitForestReady()
    waitGameLoaded()
    if not STATE.Running then return false end

    setStatus("Đợi loading", "Đang chờ Forest / save load xong...")
    getCharacterRoot(20)

    -- Bản gốc đợi IntroCutscene.SpawnBox biến mất. Bản cũ lỗi vì nếu IntroCutscene chưa kịp xuất hiện thì bỏ qua luôn.
    local intro
    local startedIntroSearch = os.clock()
    repeat
        intro = workspace:FindFirstChild("IntroCutscene")
        if intro then break end

        -- Nếu map đã có Section3 và UI Egao thì có thể Intro đã qua sẵn.
        if workspace:FindFirstChild("Section3") and PG:FindFirstChild("EgaoPulseText") then
            break
        end

        task.wait(0.25)
    until os.clock() - startedIntroSearch >= 35 or not STATE.Running

    if intro and intro.Parent then
        setStatus("Đợi intro", "Chờ SpawnBox biến mất...")
        local startedSpawnBox = os.clock()
        repeat
            task.wait(0.1)
        until not STATE.Running
            or not intro.Parent
            or not intro:FindFirstChild("SpawnBox")
            or os.clock() - startedSpawnBox >= 90
    end

    if not STATE.Running then return false end

    -- Đợi map/GUI thật sự có mặt trước khi tween và check.
    setStatus("Đợi UI", "Đang chờ EgaoPulseText / map object...")
    local readyStart = os.clock()
    repeat
        local hasEgaoGui = PG:FindFirstChild("EgaoPulseText") ~= nil
        local hasSection3 = workspace:FindFirstChild("Section3") ~= nil
        if hasEgaoGui and (hasSection3 or game.PlaceId ~= FOREST_PLACE_ID) then
            break
        end
        task.wait(0.25)
    until os.clock() - readyStart >= 35 or not STATE.Running

    task.wait(1.2)
    return STATE.Running
end

local function tweenToCheckPoint()
    local hrp = getCharacterRoot()
    if not hrp then
        setStatus("Lỗi nhân vật", "Không tìm thấy HumanoidRootPart.", Color3.fromRGB(255, 160, 160))
        return false
    end

    safe(function()
        local tw = TweenService:Create(
            hrp,
            TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
            { CFrame = CHECK_CF }
        )
        tw:Play()
        tw.Completed:Wait()
    end)
    return true
end

local function findMimicSaveSync()
    local direct = ReplicatedStorage:FindFirstChild("MimicSaveSync")
    if direct and direct:IsA("RemoteEvent") then
        return direct
    end

    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if d.Name == "MimicSaveSync" and d:IsA("RemoteEvent") then
            return d
        end
    end
end

local function goLobby()
    if not STATE.Running then return end

    STATE.Hops += 1
    STATE.PendingLobbyTeleport = true

    local queued = queueSelf()
    if queued then
        setStatus("Không thấy", "Đang về Lobby để thử server khác...", Color3.fromRGB(255, 205, 135))
    else
        -- Bản cũ dừng tại đây nên trên vài mobile executor sẽ không về Lobby.
        -- Bản này vẫn teleport; nếu executor thật sự không queue được thì cần chạy lại script ở Lobby.
        setStatus("Về Lobby", "Không thấy queue_on_teleport; vẫn teleport, có thể cần chạy lại script ở Lobby.", Color3.fromRGB(255, 205, 135))
    end

    task.wait(0.45)

    local function teleportOnce()
        safe(function()
            TeleportService:Teleport(LOBBY_PLACE_ID, LP)
        end)
    end

    teleportOnce()

    -- Nếu lệnh đầu bị nuốt / delay, thử lại nhẹ vài lần. Không ảnh hưởng nếu teleport đã bắt đầu.
    for i = 1, 3 do
        task.delay(4 * i, function()
            if STATE.Running and STATE.PendingLobbyTeleport and game.PlaceId ~= LOBBY_PLACE_ID then
                queueSelf()
                setStatus("Retry Lobby", "Thử teleport lại lần " .. tostring(i) .. "...", Color3.fromRGB(255, 205, 135))
                teleportOnce()
            end
        end)
    end
end

local function runLobby()
    waitGameLoaded()
    if not STATE.Running then return end
    STATE.PendingLobbyTeleport = false

    setStatus("Lobby", "Đang chọn Save 1 / Forest...")

    local queued = queueSelf()
    if not queued then
        setStatus("Thiếu queue", "Không thể tự chạy sau teleport. Executor cần queue_on_teleport.", Color3.fromRGB(255, 160, 160))
    end

    local remote
    for i = 1, 12 do
        if not STATE.Running then return end

        remote = remote or findMimicSaveSync()
        if remote then
            setStatus("Vào Forest", "Đã gọi MimicSaveSync(0, 1).")
            safe(function()
                remote:FireServer(0, 1)
            end)
            task.wait(1.1)
        else
            setStatus("Đợi save", "Chưa thấy MimicSaveSync... " .. tostring(i) .. "/12")
            task.wait(0.6)
        end
    end

    if STATE.Running then
        setStatus("Đang chờ", "Nếu chưa vào map, kiểm tra Forest có phải Save 1 không.", Color3.fromRGB(255, 205, 135))
    end
end

local function runForest()
    if not waitForestReady() then return end
    if not STATE.Running then return end

    setStatus("Đến điểm", "Đang tới vị trí kiểm tra EgaoPulseText...")
    tweenToCheckPoint()
    if not STATE.Running then return end

    -- Đợi UI thêm một lần sau khi tới điểm check, vì UI đôi khi tạo muộn sau loading.
    local frame = waitForEgaoGui(30)
    if not frame then
        setStatus("Thiếu UI", "Không thấy EgaoPulseText sau loading. Về Lobby để thử lại.", Color3.fromRGB(255, 205, 135))
        return goLobby()
    end

    local found = frame.Visible == true
    local con
    con = frame:GetPropertyChangedSignal("Visible"):Connect(function()
        if frame.Visible then
            found = true
        end
    end)

    local waitTime = 5 + getPingSeconds()
    setStatus("Đang dò", "Chờ tín hiệu Egao trong " .. string.format("%.1f", waitTime) .. "s...")

    local started = os.clock()
    repeat
        if frame.Visible then found = true end
        task.wait(0.1)
    until found or os.clock() - started >= waitTime or not STATE.Running

    if con then con:Disconnect() end
    if not STATE.Running then return end

    if found then
        startAutoLook("found during check window")
        safe(function()
            for i = 1, 2 do
                frame.BackgroundColor3 = Color3.fromRGB(80, 140, 90)
                task.wait(0.10)
                frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                task.wait(0.10)
            end
        end)
    else
        goLobby()
    end
end

startVisualLoop()
armPulseWatcher()

task.spawn(function()
    task.wait(0.3)
    if not STATE.Running then return end

    if game.PlaceId == LOBBY_PLACE_ID then
        runLobby()
    else
        runForest()
    end
end)
]===]

getgenv().NEVOIRS_EGAO_PAYLOAD = PAYLOAD
loadstring(PAYLOAD)()
