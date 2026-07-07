-- Nevoirs - Rage
-- WindUI shell with local player, ESP and auto helpers.

pcall(function()
    local pg = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then
        for _, name in ipairs({"Nevoirs_Rage_UI", "Nevoirs_Mimic_UI", "MiniIY_UI", "Nevoirs_LeftToggle_UI"}) do
            local old = pg:FindFirstChild(name)
            if old then old:Destroy() end
        end
    end
end)
_G.NevoirsMimic_Loaded = true

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local LocalPlayer      = Players.LocalPlayer
local Workspace        = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")

local NEVOIRS_UI_ICON = "rbxassetid://106478063464970"
local CAMERAREPLICA = nil -- silent camera replica cho Auto Nearby Kill; không xoay camera thật

-- ── States ────────────────────────────────────────────────────────────────────
local States = {
    TPWalk       = false,
    Noclip       = false,
    InfiniteJump  = false,
    ESPPlayer    = false,
    ESPMonster   = false,
    ESPTaskMaster = false,
    ESPTaskBody      = false,
    ESPTaskSpider    = false,
    ESPTaskGenerator = false,
    ESPTaskTerminal  = false,
    ESPTaskValve     = false,
    ESPTaskWire      = false,
    ESPTaskDirector  = false,
    Fullbright   = false,
    AutoNearbyKill = false,
    AutoYenESP = false,
    AutoYenCollect = false,
    LoopGoto = false,
}

-- ── Persistent settings (executor workspace) ────────────────────────────────
local SETTINGS_FILE = "Nevoirs_B3C1_Settings.json"

local DEFAULT_SETTINGS = {
    TPWalkSpeed = 0,
    VFlySpeed = 0,

    AutoKillFireDelay = 0.03,
    AutoKillRangeGata = 70,
    AutoKillRangeHogo = 25,
    AutoKillRangeFleshBlock = 20,
    AutoKillRangeSpider = 20,
}

local SavedSettings = {}

local function __readSettings()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    local ok, exists = pcall(isfile, SETTINGS_FILE)
    if not ok or not exists then return end
    local okRead, raw = pcall(readfile, SETTINGS_FILE)
    if not okRead or type(raw) ~= "string" or raw == "" then return end
    local okDecode, data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if okDecode and type(data) == "table" then
        SavedSettings = data
    end
end

local function __writeSettings()
    if type(writefile) ~= "function" then return end
    pcall(function()
        writefile(SETTINGS_FILE, HttpService:JSONEncode(SavedSettings))
    end)
end

local function getSetting(key, defaultValue)
    if SavedSettings[key] ~= nil then
        local n = tonumber(SavedSettings[key])
        if n ~= nil then return n end
        return SavedSettings[key]
    end
    return defaultValue
end

local function setSetting(key, value)
    SavedSettings[key] = value
    __writeSettings()
end

local function getNumberSetting(key, defaultValue, minValue, maxValue)
    local n = tonumber(getSetting(key, defaultValue))
    if n == nil or n ~= n or n == math.huge or n == -math.huge then
        n = defaultValue
    end
    if minValue ~= nil and n < minValue then n = minValue end
    if maxValue ~= nil and n > maxValue then n = maxValue end
    return n
end

__readSettings()

-- Migration nhẹ cho bản này: delay mặc định 0.03, Hogo 25, FleshBlock 20, Spider 10.
-- Không overwrite nếu bạn đã tự nhập giá trị khác các mặc định cũ.
if SavedSettings.__RangeSchema ~= "delay003_hogo25_flesh20_spider10_grunts_v4" then
    local oldDelay = tonumber(SavedSettings.AutoKillFireDelay)
    if oldDelay == nil or oldDelay == 0.12 then
        SavedSettings.AutoKillFireDelay = DEFAULT_SETTINGS.AutoKillFireDelay
    end

    local oldHogo = tonumber(SavedSettings.AutoKillRangeHogo)
    if oldHogo == nil or oldHogo == 70 then
        SavedSettings.AutoKillRangeHogo = DEFAULT_SETTINGS.AutoKillRangeHogo
    end

    local oldFlesh = tonumber(SavedSettings.AutoKillRangeFleshBlock)
    if oldFlesh == nil or oldFlesh == 70 or oldFlesh == 10 then
        SavedSettings.AutoKillRangeFleshBlock = DEFAULT_SETTINGS.AutoKillRangeFleshBlock
    end

    local oldSpider = tonumber(SavedSettings.AutoKillRangeSpider)
    if oldSpider == nil or oldSpider == 38 or oldSpider == 20 then
        SavedSettings.AutoKillRangeSpider = DEFAULT_SETTINGS.AutoKillRangeSpider
    end

    SavedSettings.__RangeSchema = "delay003_hogo25_flesh20_spider10_grunts_v4"
    __writeSettings()
end

local TPWalkSpeed = getNumberSetting("TPWalkSpeed", DEFAULT_SETTINGS.TPWalkSpeed, 0, 9999)


local OrigLighting = {
    Brightness     = Lighting.Brightness,
    GlobalShadows  = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient        = Lighting.Ambient,
    FogEnd         = Lighting.FogEnd,
}

local MonsterAllows = {
    Gata = true,
    Boss = true,
}

local TaskAllows = {
    Body = true,
    Spider = true,
    Generator = true,
    Terminal = true,
    Valve = true,
    Wire = true,
    Director = true,
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "Nevoirs_Rage_UI"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent         = LocalPlayer:WaitForChild("PlayerGui")

local C_DIM = Color3.fromRGB(120, 120, 145)

-- ── Misc helpers ──────────────────────────────────────────────────────────────
local function getChar()     return LocalPlayer.Character end
local function getHRP(char)  return char and char:FindFirstChild("HumanoidRootPart") end

local function safeFolder(path)
    local cur = Workspace
    for _, name in ipairs(path) do
        cur = cur and cur:FindFirstChild(name)
        if not cur then return nil end
    end
    return cur
end

local function validPart(p)
    return p and p.Parent and p:IsDescendantOf(game) and p:IsA("BasePart")
end

local function validAdornee(obj)
    return obj and obj.Parent and obj:IsDescendantOf(game) and (obj:IsA("BasePart") or obj:IsA("Model"))
end

local function rootOf(obj)
    if not obj or not obj.Parent then return nil end
    if obj:IsA("BasePart") then return obj end
    return obj:FindFirstChild("HumanoidRootPart")
        or obj:FindFirstChild("Head")
        or obj:FindFirstChild("Hitbox")
        or obj:FindFirstChild("PromptPart")
        or obj:FindFirstChildWhichIsA("BasePart")
end

local function makeUniqueKey(base, inst)
    local id
    pcall(function()
        id = inst and inst:GetDebugId()
    end)
    if not id then
        pcall(function()
            id = inst and inst:GetFullName()
        end)
    end
    id = id or tostring(inst)
    return base .. "_" .. tostring(id)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ESP CORE
-- ══════════════════════════════════════════════════════════════════════════════
local espPool  = { Player = {}, Monster = {}, Task = {}, Yen = {} }
local pollConns = { Player = nil, Monster = nil, Task = nil, Yen = nil }

local function destroyEntry(e)
    if not e then return end
    pcall(function() if e.distConn then e.distConn:Disconnect() end end)
    pcall(function() if e.hl and e.hl.Parent then e.hl:Destroy() end end)
    pcall(function() if e.bb and e.bb.Parent then e.bb:Destroy() end end)
end

local function clearPool(cat)
    for k, e in pairs(espPool[cat]) do
        destroyEntry(e)
        espPool[cat][k] = nil
    end
end

local function stopPoll(cat)
    if pollConns[cat] then
        pollConns[cat]:Disconnect()
        pollConns[cat] = nil
    end
end

local function createESPEntry(cat, key, adornee, anchor, label, color)
    if not validAdornee(adornee) or not validPart(anchor) then return end
    if espPool[cat][key] then return end

    local ok1, hl = pcall(function()
        local h = Instance.new("Highlight")
        h.Name = "MIIY_HL"
        h.Adornee = adornee
        h.FillColor = color
        h.OutlineColor = Color3.new(1,1,1)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = adornee
        return h
    end)
    if not ok1 or not hl or not hl.Parent then return end

    local ok2, bb = pcall(function()
        local b = Instance.new("BillboardGui")
        b.Name = "MIIY_BB"
        b.Adornee = anchor
        b.Size = UDim2.new(0, 160, 0, 36)
        b.StudsOffset = Vector3.new(0, 2.8, 0)
        b.AlwaysOnTop = true
        b.Parent = anchor
        return b
    end)
    if not ok2 or not bb or not bb.Parent then
        pcall(function() hl:Destroy() end)
        return
    end

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1,0,0.55,0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = label
    nameLbl.TextColor3 = color
    nameLbl.TextStrokeTransparency = 0.1
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 11
    nameLbl.Parent = bb

    local distLbl = Instance.new("TextLabel")
    distLbl.Size = UDim2.new(1,0,0.45,0)
    distLbl.Position = UDim2.new(0,0,0.55,0)
    distLbl.BackgroundTransparency = 1
    distLbl.TextColor3 = C_DIM
    distLbl.Font = Enum.Font.Gotham
    distLbl.TextSize = 9
    distLbl.Parent = bb

    local distConn = RunService.Heartbeat:Connect(function()
        if not bb.Parent or not anchor.Parent then return end
        local mc  = getChar()
        local mrp = getHRP(mc)
        if mrp then
            distLbl.Text = string.format("%.0f st", (mrp.Position - anchor.Position).Magnitude)
        end
    end)

    espPool[cat][key] = {
        hl = hl,
        bb = bb,
        distConn = distConn,
        adornee = adornee,
        anchor = anchor,
        label = label,
        color = color,
    }
end

local function prunePool(cat)
    for k, e in pairs(espPool[cat]) do
        local ok = true
        if not e or not e.hl or not e.bb then
            ok = false
        end
        if ok then
            if not validAdornee(e.adornee) or not validPart(e.anchor) then
                ok = false
            end
        end
        if not ok then
            destroyEntry(e)
            espPool[cat][k] = nil
        end
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ESP PLAYER
-- ══════════════════════════════════════════════════════════════════════════════
local playerCharConns = {}

local function scanPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        if not head then continue end

        local key = "Player_" .. tostring(plr.UserId)
        if espPool.Player[key] and espPool.Player[key].adornee ~= char then
            destroyEntry(espPool.Player[key])
            espPool.Player[key] = nil
        end

        createESPEntry("Player", key, char, head, plr.Name, Color3.fromRGB(0,255,200))
    end
end

local function setPlayerESP(state)
    States.ESPPlayer = state
    stopPoll("Player")
    for _, c in ipairs(playerCharConns) do pcall(function() c:Disconnect() end) end
    table.clear(playerCharConns)
    clearPool("Player")
    if not state then return end

    scanPlayers()

    local function hookPlayer(plr)
        if plr == LocalPlayer then return end
        local c = plr.CharacterAdded:Connect(function()
            task.wait(0.3)
            if States.ESPPlayer then
                local key = "Player_" .. tostring(plr.UserId)
                destroyEntry(espPool.Player[key])
                espPool.Player[key] = nil
                scanPlayers()
            end
        end)
        table.insert(playerCharConns, c)
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        hookPlayer(plr)
    end

    table.insert(playerCharConns, Players.PlayerAdded:Connect(function(plr)
        hookPlayer(plr)
        task.wait(0.5)
        if States.ESPPlayer then scanPlayers() end
    end))

    table.insert(playerCharConns, Players.PlayerRemoving:Connect(function(plr)
        local key = "Player_" .. tostring(plr.UserId)
        destroyEntry(espPool.Player[key])
        espPool.Player[key] = nil
    end))

    local t = 0
    pollConns.Player = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        if t >= 1 then
            t = 0
            prunePool("Player")
            if States.ESPPlayer then scanPlayers() end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ESP MONSTER
-- ══════════════════════════════════════════════════════════════════════════════
local C_MON = Color3.fromRGB(220, 60, 60)

local function scanMonsters()
    local function addCreep(model)
        if not model or not model.Parent then return end
        local hitbox = model:FindFirstChild("Hitbox") or rootOf(model)
        if not hitbox or not validPart(hitbox) then return end
        local key = makeUniqueKey("Monster_Creep", model)
        if espPool.Monster[key] and espPool.Monster[key].adornee ~= model then
            destroyEntry(espPool.Monster[key])
            espPool.Monster[key] = nil
        end
        createESPEntry("Monster", key, model, hitbox, "Creep", C_MON)
    end

    if MonsterAllows.Gata then
        -- Gata gốc: Section1.Grunts, model có Humanoid.
        local grunts = safeFolder({"Section1","Grunts"})
        if grunts then
            for _, v in ipairs(grunts:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") then
                    addCreep(v)
                end
            end
        end

        -- Grunts mở rộng: ví dụ Section2.Grunts.Grunt1 và các thư mục Grunts khác trong Section.
        local seenGrunts = {}
        local function addGruntFolder(folder)
            if not folder then return end
            for _, obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("Model") and not seenGrunts[obj] then
                    local n = tostring(obj.Name or ""):lower()
                    if n:find("grunt", 1, true) and (obj:FindFirstChildOfClass("Humanoid") or rootOf(obj)) then
                        seenGrunts[obj] = true
                        addCreep(obj)
                    end
                end
            end
        end
        addGruntFolder(safeFolder({"Section2","Grunts"}))
        addGruntFolder(safeFolder({"Section3","Grunts"}))
        addGruntFolder(safeFolder({"Section4","Grunts"}))
        addGruntFolder(safeFolder({"Section5","Grunts"}))
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name:match("^Section%d+") and obj.Name ~= "Section1" then
                addGruntFolder(obj:FindFirstChild("Grunts"))
            end
        end

        -- Muki/Muki2: cùng nhánh Creep, mở rộng bằng tên chứa "muki" để không miss biến thể cùng loại.
        local mukiRoots = {
            safeFolder({"Section4","Lab","Floor1","Objective2","MukiSpawn"}),
            safeFolder({"Section4","Lab","Floor1","Objective2"}),
        }
        local seen = {}
        for _, root in ipairs(mukiRoots) do
            if root then
                local pool = root:GetDescendants()
                table.insert(pool, 1, root)
                for _, obj in ipairs(pool) do
                    if obj:IsA("Model") then
                        local n = tostring(obj.Name or ""):lower()
                        if n:find("muki", 1, true) and not seen[obj] then
                            seen[obj] = true
                            addCreep(obj)
                        end
                    end
                end
            end
        end
    end

    -- Boss / NM boss ESP.
    -- Update workspace mới: các bản NM đôi khi là Model trực tiếp
    -- (workspace.Section2.Monster.AkariNM, workspace.Section2.Rage.AkariRageNM,
    -- workspace.Section3.Monster.MizunoNM) và không phải lúc nào cũng expose Hitbox
    -- ngay lúc scan. Vì vậy mỗi entry có cả hitboxPath + modelPath fallback.
    local C_MON_NM = Color3.fromRGB(255, 115, 95)
    local bosses = {
        { hitboxPath = {"Section2","Monster","Akari","Hitbox"},      modelPath = {"Section2","Monster","Akari"},      label = "Akari",        color = C_MON },
        { hitboxPath = {"Section2","Monster","AkariNM","Hitbox"},    modelPath = {"Section2","Monster","AkariNM"},    label = "AkariNM",      color = C_MON_NM },

        { hitboxPath = {"Section2","Rage","AkariRage","Hitbox"},     modelPath = {"Section2","Rage","AkariRage"},     label = "Akari Rage",   color = C_MON },
        { hitboxPath = {"Section2","Rage","AkariRageNM","Hitbox"},   modelPath = {"Section2","Rage","AkariRageNM"},   label = "AkariRageNM",  color = C_MON_NM },

        { hitboxPath = {"Section3","Monster","Mizuno","Hitbox"},     modelPath = {"Section3","Monster","Mizuno"},     label = "Mizuno",       color = C_MON },
        { hitboxPath = {"Section3","Monster","MizunoNM","Hitbox"},   modelPath = {"Section3","Monster","MizunoNM"},   label = "MizunoNM",     color = C_MON_NM },

        { hitboxPath = {"Section4","Monster","HogoGuntai","Hitbox"}, modelPath = {"Section4","Monster","HogoGuntai"}, label = "HogoGuntai",   color = C_MON },
        { hitboxPath = {"Section5","StairsSection","Monster","HogoGuntai","Hitbox"}, modelPath = {"Section5","StairsSection","Monster","HogoGuntai"}, label = "HogoGuntai", color = C_MON },
        { hitboxPath = {"Section5","Monster","Baigai","Hitbox"},     modelPath = {"Section5","Monster","Baigai"},     label = "Baigai",       color = C_MON },
    }

    local function resolveBossEntry(b)
        local anchor = safeFolder(b.hitboxPath)
        local model = safeFolder(b.modelPath)

        if anchor and not validPart(anchor) then
            anchor = nil
        end

        if not anchor and model then
            anchor = model:FindFirstChild("Hitbox")
                or model:FindFirstChild("HumanoidRootPart")
                or model:FindFirstChild("RootPart")
                or model:FindFirstChild("Head")
                or model:FindFirstChildWhichIsA("BasePart", true)
        end

        if not model and anchor then
            model = anchor:FindFirstAncestorOfClass("Model") or anchor.Parent
        end

        if anchor and validPart(anchor) then
            local adornee = (model and model:IsA("Model")) and model or anchor
            return adornee, anchor
        end
        return nil, nil
    end

    if MonsterAllows.Boss then
        for _, b in ipairs(bosses) do
            local adornee, hitbox = resolveBossEntry(b)
            if adornee and hitbox then
                local key = makeUniqueKey("Monster_" .. b.label, adornee)
                if espPool.Monster[key] and espPool.Monster[key].adornee ~= adornee then
                    destroyEntry(espPool.Monster[key])
                    espPool.Monster[key] = nil
                end
                createESPEntry("Monster", key, adornee, hitbox, b.label, b.color or C_MON)
            end
        end
    end
end

local function setMonsterESP(state)
    States.ESPMonster = state
    stopPoll("Monster")
    clearPool("Monster")
    if not state then return end

    scanMonsters()

    local t = 0
    pollConns.Monster = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        if t >= 1.5 then
            t = 0
            prunePool("Monster")
            if States.ESPMonster then scanMonsters() end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- ESP TASK (Granular - selectable task types with full model charms)
-- ══════════════════════════════════════════════════════════════════════════════
local C_TASK = Color3.fromRGB(80, 180, 255)

-- Individual scan functions for each task type (adornee = Model for full Highlight charm)
local function scanTaskBodies()
    if not States.ESPTaskBody then return end
    local deadCiv = safeFolder({"Section1","DeadCivilians"})
    if not deadCiv then return end
    for _, v in ipairs(deadCiv:GetChildren()) do
        if v and v.Parent then
            local hrp = v:FindFirstChild("HumanoidRootPart")
            local prompt = hrp and hrp:FindFirstChildWhichIsA("ProximityPrompt")
            if hrp and prompt and validPart(hrp) then
                local key = makeUniqueKey("Task_Body", v)
                if espPool.Task[key] and espPool.Task[key].adornee ~= v then
                    destroyEntry(espPool.Task[key])
                    espPool.Task[key] = nil
                end
                createESPEntry("Task", key, v, hrp, "Body", C_TASK)
            end
        end
    end
end

local function scanTaskSpiders()
    if not States.ESPTaskSpider then return end
    local spiders = safeFolder({"Section2","MAINOBJECTIVE2","Spiders"})
    if not spiders then return end
    for _, v in ipairs(spiders:GetChildren()) do
        if v.Name == "AkariSpider" then
            local hitbox = v:FindFirstChild("Hitbox")
            if hitbox and validPart(hitbox) then
                local key = makeUniqueKey("Task_Spider", v)
                if espPool.Task[key] and espPool.Task[key].adornee ~= v then
                    destroyEntry(espPool.Task[key])
                    espPool.Task[key] = nil
                end
                createESPEntry("Task", key, v, hitbox, "Spider", C_TASK)
            end
        end
    end
end

local function scanTaskGenerators()
    if not States.ESPTaskGenerator then return end
    local circuits = safeFolder({"Section3","OBJECTIVE","Circuits"})
    if not circuits then return end
    for _, v in ipairs(circuits:GetChildren()) do
        if v.Name == "CircuitPillar" then
            local pp = v:FindFirstChild("PromptPart")
            if pp and validPart(pp) then
                local key = makeUniqueKey("Task_Gen", v)
                if espPool.Task[key] and espPool.Task[key].anchor ~= pp then
                    destroyEntry(espPool.Task[key])
                    espPool.Task[key] = nil
                end
                createESPEntry("Task", key, v, pp, "Generator", C_TASK)
            end
        end
    end
end

local function scanTaskTerminals()
    if not States.ESPTaskTerminal then return end
    local terminals = safeFolder({"Section4","Lab","CleanseRoomObjective","ShapeTerminals"})
    if not terminals then return end
    for _, v in ipairs(terminals:GetChildren()) do
        local pp = v:FindFirstChild("PromptPart")
        local pr = pp and pp:FindFirstChildWhichIsA("ProximityPrompt")
        if pp and pr and validPart(pp) then
            local key = makeUniqueKey("Task_Terminal", v)
            if espPool.Task[key] and espPool.Task[key].anchor ~= pp then
                destroyEntry(espPool.Task[key])
                espPool.Task[key] = nil
            end
            createESPEntry("Task", key, v, pp, "Terminal", C_TASK)
        end
    end
end

local function scanTaskValves()
    if not States.ESPTaskValve then return end
    local valves = safeFolder({"Section4","Lab","CleanseRoomObjective","Valves"})
    if not valves then return end
    for _, v in ipairs(valves:GetChildren()) do
        if v:IsA("Model") then
            local icon = v:FindFirstChild("Notification") and v.Notification:FindFirstChild("Icon")
            if icon and icon.Enabled then
                local anchor = rootOf(v) or v:FindFirstChildWhichIsA("BasePart")
                if anchor and validPart(anchor) then
                    local key = makeUniqueKey("Task_Valve", v)
                    if espPool.Task[key] and espPool.Task[key].anchor ~= anchor then
                        destroyEntry(espPool.Task[key])
                        espPool.Task[key] = nil
                    end
                    createESPEntry("Task", key, v, anchor, "Valve", C_TASK)
                end
            end
        end
    end
end

local function scanTaskWires()
    if not States.ESPTaskWire then return end
    local boxes = safeFolder({"Section5","MainObjective","Boxes"})
    if not boxes then return end
    for _, box in ipairs(boxes:GetChildren()) do
        if box.Name == "WireBox" then
            local pp = box:FindFirstChild("PromptPart")
            local prompt = pp and pp:FindFirstChildWhichIsA("ProximityPrompt")
            if pp and prompt and prompt.Enabled and validPart(pp) then
                local key = makeUniqueKey("Task_Wire", box)
                if espPool.Task[key] and espPool.Task[key].anchor ~= pp then
                    destroyEntry(espPool.Task[key])
                    espPool.Task[key] = nil
                end
                createESPEntry("Task", key, box, pp, "Wire", C_TASK)
            end
        end
    end
end

local function scanTaskDirector()
    if not States.ESPTaskDirector then return end
    local root = safeFolder({"Section4","Lab","Floor1","Objective","DirectorSpawn"})
    if not root then return end

    local function addDirector(obj, label)
        if not obj then return end
        local anchor
        if obj:IsA("BasePart") then
            anchor = obj
        else
            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
            anchor = (prompt and prompt.Parent and prompt.Parent:IsA("BasePart")) and prompt.Parent or rootOf(obj)
        end
        if not anchor or not validPart(anchor) then return end
        local key = makeUniqueKey("Task_Director", obj)
        if espPool.Task[key] and espPool.Task[key].anchor ~= anchor then
            destroyEntry(espPool.Task[key])
            espPool.Task[key] = nil
        end
        createESPEntry("Task", key, obj, anchor, label or "Director", C_TASK)
    end

    addDirector(root, "Director")
    local director = root:FindFirstChild("Director")
    if director then addDirector(director, "Director") end
    local card = director and director:FindFirstChild("IDCARD2")
    if card then addDirector(card, "ID Card") end
end

local function scanAllActiveTasks()
    scanTaskBodies()
    scanTaskSpiders()
    scanTaskGenerators()
    scanTaskTerminals()
    scanTaskValves()
    scanTaskWires()
    scanTaskDirector()
end

local function isAnyTaskESPActive()
    return States.ESPTaskBody or States.ESPTaskSpider or States.ESPTaskGenerator
        or States.ESPTaskTerminal or States.ESPTaskValve or States.ESPTaskWire
        or States.ESPTaskDirector
end

local function clearTaskType(prefix)
    for k, e in pairs(espPool.Task) do
        if k:match("^Task_" .. prefix) then
            destroyEntry(e)
            espPool.Task[k] = nil
        end
    end
end

local taskPollConn
local function stopTaskPoll()
    if taskPollConn then
        taskPollConn:Disconnect()
        taskPollConn = nil
    end
end

local function startTaskPollIfNeeded()
    if taskPollConn then return end
    local t = 0
    taskPollConn = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        if t >= 1 then
            t = 0
            prunePool("Task")
            if isAnyTaskESPActive() then
                scanAllActiveTasks()
            else
                stopTaskPoll()
            end
        end
    end)
end

-- Individual toggle functions for each task type
local function setTaskBodyESP(state)
    States.ESPTaskBody = state
    clearTaskType("Body")
    if state then
        scanTaskBodies()
        startTaskPollIfNeeded()
    elseif not isAnyTaskESPActive() then
        stopTaskPoll()
    end
end

local function setTaskSpiderESP(state)
    States.ESPTaskSpider = state
    clearTaskType("Spider")
    if state then
        scanTaskSpiders()
        startTaskPollIfNeeded()
    elseif not isAnyTaskESPActive() then
        stopTaskPoll()
    end
end

local function setTaskGeneratorESP(state)
    States.ESPTaskGenerator = state
    clearTaskType("Gen")
    if state then
        scanTaskGenerators()
        startTaskPollIfNeeded()
    elseif not isAnyTaskESPActive() then
        stopTaskPoll()
    end
end

local function setTaskTerminalESP(state)
    States.ESPTaskTerminal = state
    clearTaskType("Terminal")
    if state then
        scanTaskTerminals()
        startTaskPollIfNeeded()
    elseif not isAnyTaskESPActive() then
        stopTaskPoll()
    end
end

local function setTaskValveESP(state)
    States.ESPTaskValve = state
    clearTaskType("Valve")
    if state then
        scanTaskValves()
        startTaskPollIfNeeded()
    elseif not isAnyTaskESPActive() then
        stopTaskPoll()
    end
end

local function setTaskWireESP(state)
    States.ESPTaskWire = state
    clearTaskType("Wire")
    if state then
        scanTaskWires()
        startTaskPollIfNeeded()
    elseif not isAnyTaskESPActive() then
        stopTaskPoll()
    end
end

local function setTaskDirectorESP(state)
    States.ESPTaskDirector = state
    clearTaskType("Director")
    if state then
        scanTaskDirector()
        startTaskPollIfNeeded()
    elseif not isAnyTaskESPActive() then
        stopTaskPoll()
    end
end

local function refreshMonsterESP()
    if States.ESPMonster then setMonsterESP(true) end
end

local function setMonsterAllowGata(state)
    MonsterAllows.Gata = state
    refreshMonsterESP()
end

local function setMonsterAllowBoss(state)
    MonsterAllows.Boss = state
    refreshMonsterESP()
end

local function applyTaskMaster()
    setTaskBodyESP(States.ESPTaskMaster and TaskAllows.Body)
    setTaskSpiderESP(States.ESPTaskMaster and TaskAllows.Spider)
    setTaskGeneratorESP(States.ESPTaskMaster and TaskAllows.Generator)
    setTaskTerminalESP(States.ESPTaskMaster and TaskAllows.Terminal)
    setTaskValveESP(States.ESPTaskMaster and TaskAllows.Valve)
    setTaskWireESP(States.ESPTaskMaster and TaskAllows.Wire)
    setTaskDirectorESP(States.ESPTaskMaster and TaskAllows.Director)
end

local function setTaskMasterESP(state)
    States.ESPTaskMaster = state
    applyTaskMaster()
end

local function setTaskAllow(kind, state)
    TaskAllows[kind] = state
    applyTaskMaster()
end

-- ══════════════════════════════════════════════════════════════════════════════
-- AUTO YEN SUPPORT (logic gốc: Workspace.MimicCurrencySpawns.Yen + prompt <= 10 studs)
-- Nằm ở tab Main/Auto, không đưa vào ESP tab để tránh rối.
-- ══════════════════════════════════════════════════════════════════════════════
local C_YEN = Color3.fromRGB(255, 220, 55)
local YEN_COLLECT_RANGE = 10

local function getYenFolders()
    local out, seen = {}, {}
    local function add(folder)
        if folder and folder.Parent and not seen[folder] then
            seen[folder] = true
            table.insert(out, folder)
        end
    end

    -- Path cũ.
    local oldRoot = Workspace:FindFirstChild("MimicCurrencySpawns")
    add(oldRoot and oldRoot:FindFirstChild("Yen"))

    -- Workspace mới theo finder: workspace.Yen.YenCoin.
    add(Workspace:FindFirstChild("Yen"))

    -- Fallback nhẹ cho các biến thể tên folder, không GetDescendants toàn map.
    add(Workspace:FindFirstChild("YenSpawns"))
    add(Workspace:FindFirstChild("CurrencyYen"))

    return out
end

local function getYenFolder()
    local folders = getYenFolders()
    return folders[1]
end

local function getLocalDistance(part)
    local hrp = getHRP(getChar())
    if not hrp or not part or not part:IsA("BasePart") then return math.huge end
    return (part.Position - hrp.Position).Magnitude
end

local function findYenPrompt(yen)
    if not yen or not yen.Parent then return nil end
    if yen:IsA("ProximityPrompt") then return yen end

    local direct = yen:FindFirstChildWhichIsA("ProximityPrompt")
    if direct then return direct end

    for _, d in ipairs(yen:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            return d
        end
    end
    return nil
end

local function getYenAnchor(yen)
    if not yen or not yen.Parent then return nil end
    if yen:IsA("BasePart") then return yen end

    local prompt = findYenPrompt(yen)
    local p = prompt and prompt.Parent
    if p and p:IsA("BasePart") then return p end
    if p and p:IsA("Attachment") and p.Parent and p.Parent:IsA("BasePart") then return p.Parent end

    return rootOf(yen)
end

local function fireYenPrompt(prompt)
    if not prompt or prompt.Enabled == false then return false end
    local ok = false
    pcall(function() prompt.HoldDuration = 0 end)
    ok = pcall(function() fireproximityprompt(prompt, 1, true) end) or ok
    ok = pcall(function() fireproximityprompt(prompt, 1) end) or ok
    ok = pcall(function() fireproximityprompt(prompt) end) or ok
    return ok
end

local function touchYenAnchor(anchor)
    local hrp = getHRP(getChar())
    if not hrp or not anchor or not validPart(anchor) then return false end
    local ok = false
    if type(firetouchinterest) == "function" then
        ok = pcall(function() firetouchinterest(hrp, anchor, 0) end) or ok
        task.wait()
        ok = pcall(function() firetouchinterest(hrp, anchor, 1) end) or ok
    end
    return ok
end

local function scanYenSupport()
    local folders = getYenFolders()
    if #folders == 0 then
        if States.AutoYenESP then clearPool("Yen") end
        return
    end

    local seen = {}
    for _, folder in ipairs(folders) do
        for _, yen in ipairs(folder:GetChildren()) do
            if yen and yen.Parent and not seen[yen] then
                seen[yen] = true
                local anchor = getYenAnchor(yen)
                if anchor and validPart(anchor) then
                    if States.AutoYenCollect and getLocalDistance(anchor) <= YEN_COLLECT_RANGE then
                        local prompt = findYenPrompt(yen)
                        local fired = prompt and fireYenPrompt(prompt)
                        if not fired then
                            touchYenAnchor(anchor)
                        end
                    end

                    if States.AutoYenESP then
                        local adornee = (yen:IsA("Model") or yen:IsA("BasePart")) and yen or anchor
                        local key = makeUniqueKey("Yen", yen)
                        createESPEntry("Yen", key, adornee, anchor, "Yen", C_YEN)
                    end
                end
            end
        end
    end

    if States.AutoYenESP then
        prunePool("Yen")
    end
end

local function isYenSupportActive()
    return States.AutoYenESP or States.AutoYenCollect
end

local function startYenSupportLoop()
    if pollConns.Yen then return end
    local t = 0
    pollConns.Yen = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        if t < 0.20 then return end
        t = 0

        if not isYenSupportActive() then
            clearPool("Yen")
            stopPoll("Yen")
            return
        end

        scanYenSupport()
    end)
end

local function setYenESP(state)
    States.AutoYenESP = state and true or false
    if States.AutoYenESP then
        scanYenSupport()
        startYenSupportLoop()
    else
        clearPool("Yen")
        if not isYenSupportActive() then stopPoll("Yen") end
    end
end

local function setYenCollect(state)
    States.AutoYenCollect = state and true or false
    if States.AutoYenCollect then
        startYenSupportLoop()
    elseif not isYenSupportActive() then
        stopPoll("Yen")
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- LOGIC: TPWALK
-- ══════════════════════════════════════════════════════════════════════════════
local tpwalkConn
local function applyTPWalk()
    if tpwalkConn then tpwalkConn:Disconnect(); tpwalkConn = nil end
    if not States.TPWalk then return end
    tpwalkConn = RunService.Heartbeat:Connect(function(dt)
        pcall(function()
            local char = getChar()
            if not char then return end
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0 then
                char:TranslateBy(hum.MoveDirection * TPWalkSpeed * dt * 10)
            end
        end)
    end)
end
local function toggleTPWalk(e) States.TPWalk = e; applyTPWalk() end

-- ══════════════════════════════════════════════════════════════════════════════
-- LOGIC: NOCLIP
-- ══════════════════════════════════════════════════════════════════════════════
local noclipConn
local noclipDescConn
local noclipOrig = setmetatable({}, { __mode = "k" })

local function stopNoclipMotion(char)
    char = char or getChar()
    if not char then return end

    local hum = char:FindFirstChildWhichIsA("Humanoid")
    local hrp = getHRP(char)

    if hum then
        pcall(function() hum.Sit = false end)
        pcall(function() hum.PlatformStand = false end)
        pcall(function() hum.AutoRotate = true end)
        pcall(function() hum:Move(Vector3.zero, true) end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        task.defer(function()
            pcall(function()
                if hum and hum.Parent then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end)
    end

    if hrp then
        pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
        pcall(function() hrp.AssemblyAngularVelocity = Vector3.zero end)
        pcall(function() hrp.Velocity = Vector3.zero end)
        pcall(function() hrp.RotVelocity = Vector3.zero end)
    end
end

local function cacheNoclipPart(part)
    if part and part:IsA("BasePart") and noclipOrig[part] == nil then
        noclipOrig[part] = part.CanCollide
    end
end

local function restoreNoclipCollisions(char)
    if noclipDescConn then noclipDescConn:Disconnect(); noclipDescConn = nil end

    char = char or getChar()
    for part, oldState in pairs(noclipOrig) do
        if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent then
            if (not char) or part:IsDescendantOf(char) then
                pcall(function() part.CanCollide = oldState and true or false end)
            end
        end
    end

    noclipOrig = setmetatable({}, { __mode = "k" })
    stopNoclipMotion(char)
end

local function applyNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end

    if not States.Noclip then
        restoreNoclipCollisions(getChar())
        return
    end

    local char = getChar()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            cacheNoclipPart(part)
            if part:IsA("BasePart") then
                pcall(function() part.CanCollide = false end)
            end
        end

        if noclipDescConn then noclipDescConn:Disconnect(); noclipDescConn = nil end
        noclipDescConn = char.DescendantAdded:Connect(function(part)
            task.defer(function()
                cacheNoclipPart(part)
                if States.Noclip and part and part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end)
        end)
    end

    noclipConn = RunService.Stepped:Connect(function()
        if not States.Noclip then
            applyNoclip()
            return
        end

        local c = getChar()
        if not c then return end

        for _, part in ipairs(c:GetDescendants()) do
            if part:IsA("BasePart") then
                cacheNoclipPart(part)
                if part.CanCollide then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end
    end)
end
local function toggleNoclip(e) States.Noclip = e and true or false; applyNoclip() end

-- ══════════════════════════════════════════════════════════════════════════════
-- LOGIC: INFINITE JUMP
-- ══════════════════════════════════════════════════════════════════════════════
local ijConn
local function toggleInfiniteJump(e)
    States.InfiniteJump = e
    if ijConn then ijConn:Disconnect(); ijConn = nil end
    if not e then return end
    ijConn = UserInputService.JumpRequest:Connect(function()
        local char = getChar()
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- LOGIC: FULLBRIGHT
-- ══════════════════════════════════════════════════════════════════════════════
local fbConn
local function applyFullbright()
    if fbConn then fbConn:Disconnect(); fbConn = nil end
    if not States.Fullbright then return end
    fbConn = RunService.Heartbeat:Connect(function()
        Lighting.Brightness     = 2
        Lighting.GlobalShadows  = false
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Ambient        = Color3.new(1,1,1)
        Lighting.FogEnd         = 100000
    end)
end
local function toggleFullbright(e)
    States.Fullbright = e
    if e then applyFullbright()
    else
        if fbConn then fbConn:Disconnect(); fbConn = nil end
        Lighting.Brightness     = OrigLighting.Brightness
        Lighting.GlobalShadows  = OrigLighting.GlobalShadows
        Lighting.OutdoorAmbient = OrigLighting.OutdoorAmbient
        Lighting.Ambient        = OrigLighting.Ambient
        Lighting.FogEnd         = OrigLighting.FogEnd
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- LOGIC: VFLY TỰ DO (camera-direction, không cần nút lên/xuống)
-- ══════════════════════════════════════════════════════════════════════════════
local Camera = workspace.CurrentCamera
local vflyBV, vflyBG, vflyConn, vflyStateConn
local VFlySpeed = getNumberSetting("VFlySpeed", DEFAULT_SETTINGS.VFlySpeed, 0, 99999)

local function cleanVFly()
    if vflyConn      then vflyConn:Disconnect();      vflyConn      = nil end
    if vflyStateConn then vflyStateConn:Disconnect(); vflyStateConn = nil end
    pcall(function() if vflyBV and vflyBV.Parent then vflyBV:Destroy() end end)
    pcall(function() if vflyBG and vflyBG.Parent then vflyBG:Destroy() end end)
    vflyBV = nil; vflyBG = nil
end

local function applyVFly()
    cleanVFly()
    if not States.VFly then return end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hrp or not hum then return end

    vflyBG = Instance.new("BodyGyro")
    vflyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
    vflyBG.P = 9e4; vflyBG.D = 1e3
    vflyBG.CFrame = hrp.CFrame; vflyBG.Parent = hrp

    vflyBV = Instance.new("BodyVelocity")
    vflyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
    vflyBV.Velocity = Vector3.zero; vflyBV.P = 1e4; vflyBV.Parent = hrp

    hum.WalkSpeed = 0
    hum:ChangeState(Enum.HumanoidStateType.Physics)

    vflyStateConn = hum.StateChanged:Connect(function(_, new)
        if States.VFly and new ~= Enum.HumanoidStateType.Physics then
            task.defer(function()
                if States.VFly then hum:ChangeState(Enum.HumanoidStateType.Physics) end
            end)
        end
    end)

    vflyConn = RunService.RenderStepped:Connect(function()
        if not States.VFly then cleanVFly(); return end
        if not vflyBV or not vflyBV.Parent then cleanVFly(); applyVFly(); return end

        Camera = workspace.CurrentCamera or Camera
        local camCF = Camera.CFrame
        local look  = camCF.LookVector
        local right = camCF.RightVector
        local flatL = Vector3.new(look.X, 0, look.Z)
        local flatR = Vector3.new(right.X, 0, right.Z)
        if flatL.Magnitude > 0 then flatL = flatL.Unit end
        if flatR.Magnitude > 0 then flatR = flatR.Unit end

        local move = Vector3.zero
        local md = hum.MoveDirection
        if md.Magnitude > 0.16 and flatL.Magnitude > 0 and flatR.Magnitude > 0 then
            -- Mobile joystick: lấy hướng input ngang rồi chiếu lại theo hướng camera đầy đủ.
            -- Nhìn lên trời + kéo tới = bay lên; nhìn xuống + kéo tới = bay xuống.
            local forward = math.clamp(md:Dot(flatL), -1, 1)
            local strafe  = math.clamp(md:Dot(flatR), -1, 1)
            if math.abs(forward) < 0.18 then forward = 0 end
            if math.abs(strafe) < 0.18 then strafe = 0 end
            if forward ~= 0 or strafe ~= 0 then
                move = move + (look * forward) + (right * strafe)
            end
        else
            -- PC fallback: vẫn dùng WASD, nhưng W/S đi theo LookVector 3D của camera.
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + look end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - look end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - right end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + right end
        end

        -- Phím phụ cho PC; mobile không cần nút riêng.
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then
            move = move + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            move = move - Vector3.new(0,1,0)
        end

        if move.Magnitude > 0.08 then
            vflyBV.Velocity = move.Unit * VFlySpeed
            if look.Magnitude > 0 then
                vflyBG.CFrame = CFrame.new(hrp.Position, hrp.Position + look)
            end
        else
            -- Không còn trượt/giật khi đứng im: giữ vị trí, không decay vận tốc cũ.
            vflyBV.Velocity = Vector3.zero
            vflyBG.CFrame = hrp.CFrame
        end
    end)
end

local function toggleVFly(e)
    States.VFly = e
    if e then applyVFly()
    else
        cleanVFly()
        local char = getChar()
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = 16; hum:ChangeState(Enum.HumanoidStateType.Running) end
        end
    end
end
States.VFly = false  -- khai báo sau vì toggleVFly dùng

-- ── Respawn ───────────────────────────────────────────────────────────────────
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.7)
    noclipOrig = setmetatable({}, { __mode = "k" })
    if States.TPWalk       then applyTPWalk()            end
    if States.Noclip       then applyNoclip()            end
    if States.InfiniteJump then toggleInfiniteJump(true) end
    if States.Fullbright   then applyFullbright()        end
    if States.VFly         then applyVFly()              end
    if States.ESPPlayer    then setPlayerESP(true)       end
    if States.ESPMonster   then setMonsterESP(true)      end
    if States.ESPTaskBody      then setTaskBodyESP(true)      end
    if States.ESPTaskSpider    then setTaskSpiderESP(true)    end
    if States.ESPTaskGenerator then setTaskGeneratorESP(true) end
    if States.ESPTaskTerminal  then setTaskTerminalESP(true)  end
    if States.ESPTaskValve     then setTaskValveESP(true)     end
    if States.ESPTaskWire      then setTaskWireESP(true)      end
    if States.ESPTaskDirector  then setTaskDirectorESP(true)  end
    if States.AutoYenESP       then setYenESP(true)            end
    if States.AutoYenCollect   then startYenSupportLoop()      end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- AUTO ACTIONS
-- Bản này giữ UI/Fly gốc, chỉ sửa Auto: không TP, chỉ xử lý object gần nhất
-- và dùng flow gần nhất với script 229. Không dùng chỉnh cự li client-side.
-- ══════════════════════════════════════════════════════════════════════════════
local function packetHasServerCall(packet)
    if not packet then return false end
    if typeof(packet) == "Instance" then
        return packet:IsA("RemoteEvent") or packet:IsA("RemoteFunction")
    end
    return type(packet) == "table" and (type(packet.FireServer) == "function" or type(packet.InvokeServer) == "function")
end

local function safeRequirePacket(module)
    if not module or not module:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, module)
    if ok then return result end
    return nil
end

local function getReliablePacket()
    -- Giữ path gốc: ReplicatedStorage.modules.Packet.Reliable, thêm fallback require để tránh miss Packet module.
    local modules = ReplicatedStorage:FindFirstChild("modules")
    local packet = modules and modules:FindFirstChild("Packet")

    if packet then
        local directReliable = packet:FindFirstChild("Reliable")
        if packetHasServerCall(directReliable) then
            return directReliable
        end

        local requiredPacket = safeRequirePacket(packet)
        if type(requiredPacket) == "table" and packetHasServerCall(requiredPacket.Reliable) then
            return requiredPacket.Reliable
        end

        for _, obj in ipairs(packet:GetDescendants()) do
            if obj.Name == "Reliable" and packetHasServerCall(obj) then
                return obj
            end
        end
    end

    -- Fallback từ bản cũ nếu executor/game đã có biến R global ở ngoài.
    local ok, reliable = pcall(function()
        return R.modules.Packet.Reliable
    end)
    if ok and packetHasServerCall(reliable) then return reliable end

    return nil
end

local function getDistance(part)
    local hrp = getHRP(getChar())
    if not hrp or not part then return math.huge end
    return (part.Position - hrp.Position).Magnitude
end

local function isNearEnough(part)
    -- Đã bỏ mục cự li: chỉ cần object tồn tại; việc prompt có fire được hay không để game/executor xử lý.
    return part ~= nil
end

local function promptAnchor(prompt)
    if not prompt then return nil end
    local p = prompt.Parent
    if p and p:IsA("BasePart") then return p end
    if p and p:IsA("Attachment") and p.Parent and p.Parent:IsA("BasePart") then return p.Parent end
    return rootOf(p)
end

local function preparePromptForAuto(prompt, extraRange)
    if not prompt then return end

    -- Đã loại bỏ toàn bộ chỉnh cự li. Không sửa MaxActivationDistance/RequiresLineOfSight
    -- để tránh tình trạng UI/task hoạt động khác logic gốc. Chỉ rút HoldDuration cho thao tác nhanh hơn.
    pcall(function() prompt.HoldDuration = 0 end)
end

local function pressPrompt(prompt, holdTime)
    if not prompt then return false end

    preparePromptForAuto(prompt)

    local ok = false
    local duration = tonumber(holdTime) or 1

    ok = pcall(function()
        fireproximityprompt(prompt, duration, true)
    end) or ok

    ok = pcall(function()
        fireproximityprompt(prompt, duration)
    end) or ok

    ok = pcall(function()
        fireproximityprompt(prompt)
    end) or ok

    return ok
end

local function pressPromptOriginalOnce(prompt)
    if not prompt then return false end
    preparePromptForAuto(prompt)

    -- Dành riêng cho Generator: script mẫu chỉ gọi fireproximityprompt(prompt) đúng 1 lần.
    -- Không dùng chuỗi fallback nhiều kiểu ở đây để tránh tạo nhiều task UI chồng lên nhau.
    local ok = pcall(function()
        fireproximityprompt(prompt)
    end)

    if not ok then
        ok = pcall(function()
            fireproximityprompt(prompt, 1, true)
        end)
    end

    return ok
end

local function closeTaskUI(kind)
    task.defer(function()
        task.wait(0.08)
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not pg then return end

        local patterns
        if kind == "Generator" then
            patterns = {"circuit", "generator"}
        elseif kind == "Terminal" then
            patterns = {"terminal", "shape"}
        else
            return
        end

        local function matched(name)
            local n = tostring(name or ""):lower()
            for _, pat in ipairs(patterns) do
                if n:find(pat, 1, true) then return true end
            end
            return false
        end

        for _, gui in ipairs(pg:GetDescendants()) do
            if gui ~= ScreenGui and not gui:IsDescendantOf(ScreenGui) and matched(gui.Name) then
                pcall(function()
                    if gui:IsA("ScreenGui") then
                        gui.Enabled = false
                    elseif gui:IsA("GuiObject") then
                        gui.Visible = false
                    end
                end)
            end
        end
    end)
end

local function nearestFrom(list, getPart, filter)
    local nearest, nearestPart, best = nil, nil, math.huge
    for _, item in ipairs(list) do
        if (not filter or filter(item)) then
            local part = getPart(item)
            if part and validPart(part) then
                local d = getDistance(part)
                if d < best then
                    nearest, nearestPart, best = item, part, d
                end
            end
        end
    end
    return nearest, nearestPart, best
end

local GeneratorAutoRunning = false

local function collectCircuitPillars(folder)
    local list = {}
    if not folder then return list end

    -- Script gốc đặt CircuitPillar trực tiếp trong Circuits; dùng GetDescendants làm fallback để không miss khi map đổi folder con.
    for _, obj in ipairs(folder:GetChildren()) do
        if obj.Name == "CircuitPillar" then
            table.insert(list, obj)
        end
    end

    if #list == 0 then
        for _, obj in ipairs(folder:GetDescendants()) do
            if obj.Name == "CircuitPillar" then
                table.insert(list, obj)
            end
        end
    end

    return list
end

local function getGeneratorPromptPart(pillar)
    if not pillar then return nil end
    -- Generator gốc dùng CollisionPart làm điểm thao tác, nên ưu tiên nó để chọn đúng máy phát gần nhất.
    return pillar:FindFirstChild("CollisionPart")
        or pillar:FindFirstChild("PromptPart")
        or rootOf(pillar)
end

local function getGeneratorPrompt(pillar)
    local pp = pillar and pillar:FindFirstChild("PromptPart")
    if pp then
        local prompt = pp:FindFirstChildWhichIsA("ProximityPrompt")
        if prompt then return prompt end
    end

    if pillar then
        for _, d in ipairs(pillar:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                return d
            end
        end
    end

    return nil
end

local function nearestGenerator(folder)
    local best, bestPart, bestDist = nil, nil, math.huge
    local fallback, fallbackPart, fallbackDist = nil, nil, math.huge

    for _, pillar in ipairs(collectCircuitPillars(folder)) do
        local part = getGeneratorPromptPart(pillar)
        if part and validPart(part) then
            local dist = getDistance(part)
            if dist < fallbackDist then
                fallback, fallbackPart, fallbackDist = pillar, part, dist
            end

            local prompt = getGeneratorPrompt(pillar)
            if prompt and prompt.Enabled ~= false and dist < bestDist then
                best, bestPart, bestDist = pillar, part, dist
            end
        end
    end

    -- Ưu tiên prompt enabled như script gốc, nhưng vẫn fallback direct remote nếu prompt bị ẩn.
    if best then return best, bestPart, bestDist end
    return fallback, fallbackPart, fallbackDist
end

local function fireReliablePacket(reliable, key, target)
    if not reliable then return false end

    if typeof(reliable) == "Instance" then
        if reliable:IsA("RemoteEvent") then
            reliable:FireServer(key, target)
            return true
        elseif reliable:IsA("RemoteFunction") then
            reliable:InvokeServer(key, target)
            return true
        end
    elseif type(reliable) == "table" then
        if type(reliable.FireServer) == "function" then
            reliable:FireServer(key, target)
            return true
        elseif type(reliable.InvokeServer) == "function" then
            reliable:InvokeServer(key, target)
            return true
        end
    else
        local ok = pcall(function()
            reliable:FireServer(key, target)
        end)
        return ok
    end

    return false
end

local function autoGenerator()
    if GeneratorAutoRunning then
        return warn("[Nevoirs] Auto máy phát đang chạy, đợi hoàn tất rồi bấm lại nếu cần")
    end

    GeneratorAutoRunning = true
    task.spawn(function()
        local okRun, errRun = pcall(function()
            local folder = safeFolder({"Section3","OBJECTIVE","Circuits"})
            if not folder then return warn("[Nevoirs] Không tìm thấy thư mục máy phát") end

            -- Chỉ lấy 1 CircuitPillar gần nhất, không teleport, không dùng cự li tự chỉnh.
            local pillar, anchor, dist = nearestGenerator(folder)
            if not pillar or not anchor then return warn("[Nevoirs] Không tìm thấy máy phát") end

            local reliable = getReliablePacket()
            if not reliable then return warn("[Nevoirs] Không tìm thấy Packet Reliable") end

            local collisionPart = pillar:FindFirstChild("CollisionPart")
            local prompt = getGeneratorPrompt(pillar)

            -- Copy lại flow gốc sát nhất có thể nhưng bỏ TP:
            -- CollisionPart.CanCollide = false -> fire prompt 1 LẦN -> wait(1) -> FireServer 3 lần.
            -- Không lặp pressPrompt theo phase nữa, vì đó là nguyên nhân tạo nhiều UI generator chồng lên nhau.
            pcall(function()
                if collisionPart and collisionPart:IsA("BasePart") then
                    collisionPart.CanCollide = false
                end
            end)

            if prompt then
                preparePromptForAuto(prompt)
                pressPromptOriginalOnce(prompt)
            else
                warn("[Nevoirs] Không tìm thấy ProximityPrompt của máy phát gần nhất; vẫn thử gửi packet gốc")
            end

            task.wait(1)

            local sent = 0
            for i = 1, 3 do
                local okFire = pcall(function()
                    if fireReliablePacket(reliable, "Section3/CircuitRoundComplete", pillar) then
                        sent = sent + 1
                    end
                end)
                if not okFire then
                    warn("[Nevoirs] Gửi packet máy phát lỗi lần", i)
                end
                task.wait(0.08)
            end

            if sent > 0 then
                print(("[Nevoirs] Đã chạy generator gần nhất: %d packet | %.1f studs | không TP | không cự li"):format(sent, dist or 0))
            else
                warn("[Nevoirs] Không gửi được packet máy phát")
            end
        end)

        if not okRun then
            warn("[Nevoirs] Auto máy phát lỗi:", errRun)
        end
        GeneratorAutoRunning = false
    end)
end
local function autoTerminal()
    local folder = safeFolder({"Section4","Lab","CleanseRoomObjective","ShapeTerminals"})
    if not folder then return warn("[Nevoirs] Không tìm thấy thư mục terminal") end

    local terminal, pp = nearestFrom(folder:GetChildren(), function(v)
        if v.Name ~= "Terminal" then return nil end
        return v:FindFirstChild("PromptPart") or rootOf(v)
    end, function(v)
        if v.Name ~= "Terminal" then return false end
        return (v:FindFirstChild("PromptPart") or rootOf(v)) ~= nil
    end)

    if not terminal or not pp then return warn("[Nevoirs] Không tìm thấy terminal") end

    local reliable = getReliablePacket()
    if not reliable then return warn("[Nevoirs] Không tìm thấy Packet Reliable") end

    local prompt = pp:FindFirstChildWhichIsA("ProximityPrompt")
    if prompt and prompt.Enabled ~= false then
        pressPrompt(prompt)
        task.wait(0.35)
    else
        task.wait(0.12)
    end

    for _ = 1, 3 do
        pcall(function() reliable:FireServer("ShapeTerminal/RoundComplete", terminal) end)
        task.wait(0.08)
    end
    pcall(function() reliable:FireServer("ShapeTerminal/Release", terminal) end)
    closeTaskUI("Terminal")
end

local function getValveIcon(valve)
    if not valve then return nil end
    local notif = valve:FindFirstChild("Notification") or valve:FindFirstChild("Notification", true)
    return notif and (notif:FindFirstChild("Icon") or notif:FindFirstChild("Icon", true))
end

local function valveIconEnabled(valve)
    local foundIcon = false
    for _, d in ipairs(valve:GetDescendants()) do
        if d.Name == "Icon" and d:IsA("BillboardGui") then
            foundIcon = true
            if d.Enabled then return true end
        elseif d.Name == "Icon" and d:IsA("GuiObject") then
            foundIcon = true
            if d.Visible then return true end
        end
    end

    if not foundIcon then
        for _, d in ipairs(valve:GetDescendants()) do
            if d:IsA("ProximityPrompt") and d.Enabled then
                return true
            end
        end
    end

    return false
end

local function valveHasTurnerPrompt(valve)
    for _, d in ipairs(valve:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local n = string.lower(d.Name)
            local pn = d.Parent and string.lower(d.Parent.Name) or ""
            if n == "right" or pn == "right" or d:FindFirstAncestor("Turners") then
                return true
            end
        end
    end
    return false
end

local function getValvePrompts(valve)
    local prompts = {}
    for _, d in ipairs(valve:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local n = string.lower(d.Name)
            local pn = d.Parent and string.lower(d.Parent.Name) or ""
            local inTurners = d:FindFirstAncestor("Turners") ~= nil
            if n == "right" or pn == "right" or inTurners then
                table.insert(prompts, d)
            end
        end
    end
    table.sort(prompts, function(a, b)
        local aa = promptAnchor(a)
        local bb = promptAnchor(b)
        return getDistance(aa) < getDistance(bb)
    end)
    return prompts
end

local function pressValvePrompt(prompt)
    if not prompt then return false end
    local ok = false
    preparePromptForAuto(prompt, 18)
    ok = pcall(function()
        local hold = tonumber(prompt.HoldDuration) or 0
        fireproximityprompt(prompt, math.max(hold + 0.05, 1), true)
    end) or ok
    ok = pcall(function() fireproximityprompt(prompt, 1, true) end) or ok
    ok = pcall(function() fireproximityprompt(prompt, 1) end) or ok
    ok = pcall(function() fireproximityprompt(prompt) end) or ok
    return ok
end

local function autoValve()
    local folder = safeFolder({"Section4","Lab","CleanseRoomObjective","Valves"})
    if not folder then return warn("[Nevoirs] Không tìm thấy thư mục van") end

    local valve, anchor = nearestFrom(folder:GetChildren(), function(v)
        if not v:IsA("Model") then return nil end
        local icon = getValveIcon(v)
        if icon and icon.Parent and icon.Parent:IsA("BasePart") then return icon.Parent end
        local prompt = getValvePrompts(v)[1]
        return promptAnchor(prompt) or rootOf(v)
    end, function(v)
        return v:IsA("Model") and valveHasTurnerPrompt(v) and valveIconEnabled(v)
    end)

    if not valve or not anchor then return warn("[Nevoirs] Không tìm thấy van") end

    local started = os.clock()
    local prompts = getValvePrompts(valve)

    if #prompts == 0 then
        return warn("[Nevoirs] Van gần nhất không có prompt xoay")
    end

    while os.clock() - started < 35 do
        if not valveIconEnabled(valve) then
            break
        end

        for _, prompt in ipairs(prompts) do
            if prompt and prompt.Parent then
                pressValvePrompt(prompt)
                task.wait(0.12)
            end
        end

        prompts = getValvePrompts(valve)
        task.wait(0.08)
    end
end

local function autoWire()
    local folder = safeFolder({"Section5","MainObjective","Boxes"})
    if not folder then return warn("[Nevoirs] Không tìm thấy thư mục hộp dây") end

    local box, pp = nearestFrom(folder:GetChildren(), function(v)
        if v.Name ~= "WireBox" then return nil end
        return v:FindFirstChild("PromptPart") or rootOf(v)
    end, function(v)
        if v.Name ~= "WireBox" then return false end
        local part = v:FindFirstChild("PromptPart")
        local prompt = part and part:FindFirstChildWhichIsA("ProximityPrompt")
        return prompt ~= nil and prompt.Enabled ~= false
    end)

    if not box or not pp then return warn("[Nevoirs] Không tìm thấy hộp dây") end

    local reliable = getReliablePacket()
    if not reliable then return warn("[Nevoirs] Không tìm thấy Packet Reliable") end
    -- Sát script gốc: không mở UI hộp dây, claim 2 lần rồi gửi screw/cut/complete.
    pcall(function() reliable:FireServer("Section5/WireBoxClaim", box) end)
    task.wait(0.03)
    pcall(function() reliable:FireServer("Section5/WireBoxClaim", box) end)
    task.wait(0.03)

    local bolt = box:FindFirstChild("Bolt")
    if bolt then
        for _, screw in ipairs(bolt:GetChildren()) do
            if screw.Name == "Screw" then
                pcall(function() reliable:FireServer("Section5/WireBoxScrewDone", screw) end)
                task.wait(0.015)
            end
        end
    end

    local cuttable = box:FindFirstChild("Cuttable")
    if cuttable then
        for _, cut in ipairs(cuttable:GetChildren()) do
            if cut.Name == "Cut" then
                pcall(function() reliable:FireServer("Section5/WireBoxCutDone", cut) end)
                task.wait(0.015)
            end
        end
    end

    pcall(function() reliable:FireServer("Section5/WireBoxComplete", box) end)
    pcall(function()
        local prompt = box.PromptPart and box.PromptPart:FindFirstChildWhichIsA("ProximityPrompt")
        if prompt then prompt.Enabled = false end
    end)
end


-- ══════════════════════════════════════════════════════════════════════════════
-- AUTO NEARBY KILL: GATAS / GRUNTS / MUKI / HOGOGUNTAI / FLESHBLOCK / SPIDER, KHÔNG TELEPORT
-- Bám logic B3C1 gốc: GunAction("fire") + RemoteEvent target + CAMERAREPLICA.
-- Bản này sửa lại target-acquire: không phụ thuộc 1 remote cố định, tự refresh remote/part
-- để tránh lỗi "lúc đầu shoot, những lần sau báo không có target".
-- ══════════════════════════════════════════════════════════════════════════════
local WindUI -- forward declaration để notification trong Auto block dùng đúng WindUI local
local AutoNearbyKillRunning = false
local AutoNearbyKillTarget = nil
local CameraReplicaHookInstalled = false
local CameraReplicaLastTry = 0

local AUTO_KILL_ICON = NEVOIRS_UI_ICON
local TARGET_RELOCK_INTERVAL = 1.35

local AutoKillConfig = {
    FireDelay = getNumberSetting("AutoKillFireDelay", DEFAULT_SETTINGS.AutoKillFireDelay, 0.01, 10),
    RangeGata = getNumberSetting("AutoKillRangeGata", DEFAULT_SETTINGS.AutoKillRangeGata, 0, 9999),
    RangeHogo = getNumberSetting("AutoKillRangeHogo", DEFAULT_SETTINGS.AutoKillRangeHogo, 0, 9999),
    RangeFleshBlock = getNumberSetting("AutoKillRangeFleshBlock", DEFAULT_SETTINGS.AutoKillRangeFleshBlock, 0, 9999),
    RangeSpider = getNumberSetting("AutoKillRangeSpider", DEFAULT_SETTINGS.AutoKillRangeSpider, 0, 9999),
}

local function normalizeKillKind(kind)
    local k = tostring(kind or ""):lower()
    if k:find("spider", 1, true) then return "Spider" end
    if k:find("flesh", 1, true) or k:find("block", 1, true) then return "FleshBlock" end
    if k:find("hogo", 1, true) then return "Hogo" end
    if k:find("muki", 1, true) then return "Muki" end
    return "Gata"
end

local function getKillRange(kind)
    local k = normalizeKillKind(kind)
    if k == "Spider" then return AutoKillConfig.RangeSpider end
    if k == "FleshBlock" then return AutoKillConfig.RangeFleshBlock end
    if k == "Hogo" then return AutoKillConfig.RangeHogo end
    if k == "Muki" then return AutoKillConfig.RangeGata end
    return AutoKillConfig.RangeGata
end

local function getAutoKillFireDelay()
    local n = tonumber(AutoKillConfig.FireDelay) or DEFAULT_SETTINGS.AutoKillFireDelay
    if n < 0.01 then n = 0.01 end
    return n
end

local setFireSettingsPanelVisible = function() end

local function smallNotify(title, content, icon)
    pcall(function()
        if WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = title or "Nevoirs",
                Content = content or "",
                Icon = icon or AUTO_KILL_ICON,
                Duration = 2,
            })
        end
    end)
end

local function getGunActionRemote()
    local r = ReplicatedStorage:FindFirstChild("GunAction")
    if r and r:IsA("RemoteEvent") then return r end

    local okGG, ggRemote = pcall(function()
        return GG and GG.R and GG.R.GunAction
    end)
    if okGG and ggRemote and typeof(ggRemote) == "Instance" and ggRemote:IsA("RemoteEvent") then
        return ggRemote
    end

    for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
        if d.Name == "GunAction" and d:IsA("RemoteEvent") then
            return d
        end
    end

    return nil
end

local function collectRemoteEvents(obj)
    local remotes, seen = {}, {}

    local function add(r)
        if r and typeof(r) == "Instance" and r:IsA("RemoteEvent") and not seen[r] then
            seen[r] = true
            table.insert(remotes, r)
        end
    end

    if not obj or not obj.Parent then return remotes end

    if obj:IsA("RemoteEvent") then
        add(obj)
        return remotes
    end

    add(obj:FindFirstChildWhichIsA("RemoteEvent"))

    local hitbox = obj:FindFirstChild("Hitbox", true)
    if hitbox then
        add(hitbox:FindFirstChild("RemoteEvent"))
        add(hitbox:FindFirstChildWhichIsA("RemoteEvent"))
    end

    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("RemoteEvent") then
            add(d)
            if #remotes >= 12 then break end -- chặn trường hợp model có quá nhiều remote phụ
        end
    end

    return remotes
end

local function nearestBasePartOf(obj)
    if not obj or not obj.Parent then return nil, math.huge end
    local hrp = getHRP(getChar())
    if not hrp then return nil, math.huge end

    local best, bestDist = nil, math.huge

    local function try(part)
        if part and validPart(part) then
            local d = (part.Position - hrp.Position).Magnitude
            if d < bestDist then
                best, bestDist = part, d
            end
        end
    end

    if obj:IsA("BasePart") then
        try(obj)
    elseif obj:IsA("Model") or obj:IsA("Folder") then
        -- Ưu tiên Hitbox/HumanoidRootPart nhưng vẫn fallback part gần nhất.
        try(obj:FindFirstChild("Hitbox", true))
        try(obj:FindFirstChild("HumanoidRootPart", true))
        try(obj:FindFirstChild("Head", true))
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("BasePart") then
                try(d)
            end
        end
    else
        try(rootOf(obj))
        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("BasePart") then
                try(d)
            end
        end
    end

    return best, bestDist
end

local function getAimDot(targetPos)
    local cam = Workspace.CurrentCamera
    if not cam or not targetPos then return 0 end
    local delta = targetPos - cam.CFrame.Position
    if delta.Magnitude <= 0.01 then return 1 end
    return math.clamp(cam.CFrame.LookVector:Dot(delta.Unit), -1, 1)
end

local function getLookRayHit(maxDistance)
    local cam = Workspace.CurrentCamera
    if not cam then return nil end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local ignore = {}
    local char = getChar()
    if char then table.insert(ignore, char) end
    params.FilterDescendantsInstances = ignore

    local ok, result = pcall(function()
        return Workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * (tonumber(maxDistance) or 250), params)
    end)
    if ok and result then
        return result.Instance, result.Position
    end
    return nil
end

local function isLookingAtFleshBody(body)
    if not validPart(body) then return false end
    local hit = getLookRayHit(260)
    if not hit then
        return getAimDot(body.Position) >= 0.86
    end

    if hit == body or hit:IsDescendantOf(body) then return true end
    local block = body.Parent
    if block and (hit == block or hit:IsDescendantOf(block)) then return true end

    return false
end

local function installCameraReplicaHook()
    if CameraReplicaHookInstalled then return true end
    if os.clock() - CameraReplicaLastTry < 3 then return false end
    CameraReplicaLastTry = os.clock()

    local okGG = pcall(function()
        if GG and GG.LowerC then
            local modules = ReplicatedStorage:FindFirstChild("modules")
            local packetModule = modules and modules:FindFirstChild("Packet")
            if not packetModule then return end
            local packet = require(packetModule)
            local updateState = packet.unreliablesend.ReplicationService.Character.updateState
            local mt = getmetatable(updateState)
            if not mt or type(mt.__call) ~= "function" then return end
            local old
            old = GG.LowerC(mt.__call, function(...)
                local args = {...}
                if CAMERAREPLICA and args[1] and args[1].__name == "updateState" then
                    local cam = Workspace.CurrentCamera
                    if cam then
                        args[2] = CFrame.lookAt(cam.CFrame.Position, CAMERAREPLICA.Position)
                        return old(table.unpack(args))
                    end
                end
                return old(...)
            end)
            CameraReplicaHookInstalled = true
        end
    end)
    if okGG and CameraReplicaHookInstalled then return true end

    local okHook = pcall(function()
        local env = (getfenv and getfenv()) or _G
        local hookFn = rawget(env, "hookfunction") or hookfunction
        local newClosure = rawget(env, "newcclosure") or function(fn) return fn end
        if type(hookFn) ~= "function" then return end

        local modules = ReplicatedStorage:FindFirstChild("modules")
        local packetModule = modules and modules:FindFirstChild("Packet")
        if not packetModule then return end
        local packet = require(packetModule)
        local updateState = packet.unreliablesend.ReplicationService.Character.updateState
        local mt = getmetatable(updateState)
        if not mt or type(mt.__call) ~= "function" then return end

        local old
        old = hookFn(mt.__call, newClosure(function(...)
            local args = {...}
            if CAMERAREPLICA and args[1] and args[1].__name == "updateState" then
                local cam = Workspace.CurrentCamera
                if cam then
                    args[2] = CFrame.lookAt(cam.CFrame.Position, CAMERAREPLICA.Position)
                    return old(table.unpack(args))
                end
            end
            return old(...)
        end))
        CameraReplicaHookInstalled = true
    end)

    return okHook and CameraReplicaHookInstalled
end

local function addKillTarget(out, inst, kind, maxRange)
    if not inst or not inst.Parent then return end
    local hum = inst:IsA("Model") and inst:FindFirstChildOfClass("Humanoid") or nil
    if hum and hum.Health <= 0 then return end

    local anchor, dist = nearestBasePartOf(inst)
    if not anchor or dist > maxRange then return end

    local pos = anchor.Position
    local dot = getAimDot(pos)
    local remotes = collectRemoteEvents(inst)

    table.insert(out, {
        kind = kind or tostring(inst.Name or "Monster"),
        instance = inst,
        anchor = anchor,
        cframe = CFrame.new(pos),
        dist = dist,
        dot = dot,
        maxRange = maxRange,
        remoteCount = #remotes,
        remotes = remotes,
        lockStarted = os.clock(),
        lastNoRemoteNotice = 0,
    })
end

local function collectGataTargets(out)
    local grunts = safeFolder({"Section1", "Grunts"})
    if not grunts then return end

    for _, gata in ipairs(grunts:GetChildren()) do
        if gata:IsA("Model") and gata:FindFirstChildOfClass("Humanoid") then
            addKillTarget(out, gata, "Gata", getKillRange("Gata"))
        end
    end
end

local function collectGruntTargets(out)
    -- Grunts mở rộng: ví dụ Section2.Grunts.Grunt1. Dùng chung range với Gata/Creep.
    local seen = {}

    local function scanFolder(folder)
        if not folder then return end
        local pool = folder:GetDescendants()
        table.insert(pool, 1, folder)
        for _, obj in ipairs(pool) do
            if obj:IsA("Model") and not seen[obj] then
                local n = tostring(obj.Name or ""):lower()
                if n:find("grunt", 1, true) and (obj:FindFirstChildOfClass("Humanoid") or rootOf(obj)) then
                    seen[obj] = true
                    addKillTarget(out, obj, obj.Name, getKillRange("Gata"))
                end
            end
        end
    end

    scanFolder(safeFolder({"Section2", "Grunts"}))
    scanFolder(safeFolder({"Section3", "Grunts"}))
    scanFolder(safeFolder({"Section4", "Grunts"}))
    scanFolder(safeFolder({"Section5", "Grunts"}))
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name:match("^Section%d+") and obj.Name ~= "Section1" then
            scanFolder(obj:FindFirstChild("Grunts"))
        end
    end
end

local function collectMukiTargets(out)
    local roots = {
        safeFolder({"Section4", "Lab", "Floor1", "Objective2", "MukiSpawn"}),
        safeFolder({"Section4", "Lab", "Floor1", "Objective2"}),
    }
    local seen = {}

    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("Model") and not seen[obj] then
                    local n = tostring(obj.Name or ""):lower()
                    if n:find("muki", 1, true) then
                        seen[obj] = true
                        addKillTarget(out, obj, obj.Name, getKillRange(obj.Name))
                    end
                end
            end
        end
    end
end

local function collectHogoGuntaiTargets(out)
    local paths = {
        {"Section5", "StairsSection", "Monster"},
        {"Section4", "Monster"},
        {"Section4"},
    }
    local seen = {}

    for _, path in ipairs(paths) do
        local folder = safeFolder(path)
        if folder then
            for _, obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("Model") and not seen[obj] then
                    local n = tostring(obj.Name or ""):lower()
                    if n:find("hogoguntai", 1, true) or n:find("hogo", 1, true) then
                        seen[obj] = true
                        addKillTarget(out, obj, obj.Name, getKillRange(obj.Name))
                    end
                end
            end
        end
    end
end


local function collectFleshBlockTargets(out)
    -- Theo path bạn gửi: Section5.StairsSection.FleshBlock.Block.body
    -- Bản này CHỈ lấy đúng BasePart tên body làm anchor/range.
    -- Không lấy Block/Screen/SurfaceGui/parent để tránh remote global làm bắn toàn bộ FleshBlock.
    local roots = {
        safeFolder({"Section5", "StairsSection", "FleshBlock"}),
        safeFolder({"Section5", "StairsSection"}),
    }
    local seenBody = {}

    local function tryAddBody(body)
        if not body or not validPart(body) then return end
        if tostring(body.Name or ""):lower() ~= "body" then return end
        if seenBody[body] then return end

        local hrp = getHRP(getChar())
        if not hrp then return end

        local range = getKillRange("FleshBlock")
        local dist = (body.Position - hrp.Position).Magnitude
        if dist > range then return end

        -- FleshBlock bắt buộc phải là body bạn đang nhìn/raycast trúng.
        -- Việc này chặn lỗi quét cả cụm FleshBlock dài rồi fire toàn bộ từ xa.
        if not isLookingAtFleshBody(body) then return end

        seenBody[body] = true

        local block = body.Parent or body
        local remotes = collectRemoteEvents(body)

        table.insert(out, {
            kind = "FleshBlock",
            instance = block,
            anchor = body,
            fleshBody = body,
            cframe = body.CFrame,
            dist = dist,
            dot = getAimDot(body.Position),
            maxRange = range,
            remoteCount = #remotes,
            remotes = remotes,
            lockStarted = os.clock(),
            lastNoRemoteNotice = 0,
        })
    end

    for _, root in ipairs(roots) do
        if root then
            -- Ưu tiên path chính xác trước.
            local directBlock = root:FindFirstChild("Block")
            local directBody = directBlock and (directBlock:FindFirstChild("body") or directBlock:FindFirstChild("Body"))
            tryAddBody(directBody)

            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("BasePart") and tostring(obj.Name or ""):lower() == "body" then
                    local path = tostring(obj:GetFullName() or ""):lower()
                    if path:find("fleshblock", 1, true) then
                        tryAddBody(obj)
                    end
                end
            end
        end
    end
end

local function collectSpiderTargets(out)
    local spiders = safeFolder({"Section2", "MAINOBJECTIVE2", "Spiders"})
    if not spiders then return end

    for _, spider in ipairs(spiders:GetChildren()) do
        if spider.Name == "AkariSpider" then
            local hitbox = spider:FindFirstChild("Hitbox")
            local remote = hitbox and hitbox:FindFirstChild("RemoteEvent")
            if hitbox and validPart(hitbox) and getDistance(hitbox) <= getKillRange("Spider") then
                table.insert(out, {
                    kind = "Spider",
                    instance = spider,
                    anchor = hitbox,
                    cframe = hitbox.CFrame,
                    dist = getDistance(hitbox),
                    dot = getAimDot(hitbox.Position),
                    maxRange = getKillRange("Spider"),
                    remoteCount = (remote and remote:IsA("RemoteEvent")) and 1 or 0,
                    remotes = (remote and remote:IsA("RemoteEvent")) and {remote} or {},
                    lockStarted = os.clock(),
                    lastNoRemoteNotice = 0,
                })
            end
        end
    end
end

local function refreshKillTarget(target)
    if not target or not target.instance or not target.instance.Parent then return false end

    local maxRange = getKillRange(target.kind)
    local anchor, dist

    local nk = normalizeKillKind(target.kind)
    if nk == "Spider" then
        anchor = target.instance:FindFirstChild("Hitbox")
        if anchor then dist = getDistance(anchor) end
    elseif nk == "FleshBlock" then
        -- FleshBlock chỉ được tính theo body chính đã lock. Không fallback sang nearest part/parent.
        anchor = target.fleshBody
        if not validPart(anchor) then
            anchor = target.instance:FindFirstChild("body", true) or target.instance:FindFirstChild("Body", true)
        end
        if anchor and validPart(anchor) and tostring(anchor.Name or ""):lower() == "body" then
            dist = getDistance(anchor)
            if not isLookingAtFleshBody(anchor) then return false end
        else
            return false
        end
    else
        local hum = target.instance:IsA("Model") and target.instance:FindFirstChildOfClass("Humanoid") or nil
        if hum and hum.Health <= 0 then return false end
        anchor, dist = nearestBasePartOf(target.instance)
    end

    if not anchor or not validPart(anchor) or not dist or dist > maxRange then return false end

    local pos = anchor.Position
    target.anchor = anchor
    target.dist = dist
    target.dot = getAimDot(pos)
    target.cframe = (normalizeKillKind(target.kind) == "Spider" or normalizeKillKind(target.kind) == "FleshBlock") and anchor.CFrame or CFrame.new(pos)
    if normalizeKillKind(target.kind) == "Spider" then
        target.remotes = collectRemoteEvents(anchor)
    elseif normalizeKillKind(target.kind) == "FleshBlock" then
        -- Không merge remote từ Block/FleshBlock parent vì có thể là remote global bắn toàn bộ khối.
        target.fleshBody = anchor
        target.remotes = collectRemoteEvents(anchor)
    else
        target.remotes = collectRemoteEvents(target.instance)
    end
    target.remoteCount = #target.remotes

    return true
end

local function chooseNearbyKillTarget()
    local targets = {}
    collectGataTargets(targets)
    collectGruntTargets(targets)
    collectMukiTargets(targets)
    collectHogoGuntaiTargets(targets)
    collectFleshBlockTargets(targets)
    collectSpiderTargets(targets)
    if #targets == 0 then return nil end

    table.sort(targets, function(a, b)
        local ak = normalizeKillKind(a.kind)
        local bk = normalizeKillKind(b.kind)

        -- Nếu có Hogo và FleshBlock cùng hợp lệ, ưu tiên Hogo trước.
        if (ak == "Hogo" and bk == "FleshBlock") or (ak == "FleshBlock" and bk == "Hogo") then
            return ak == "Hogo"
        end

        -- Ưu tiên mục tiêu đang gần tâm màn hình hơn; nếu tương đương thì lấy gần hơn.
        local aLook = a.dot >= 0.45
        local bLook = b.dot >= 0.45
        if aLook ~= bLook then return aLook end
        if math.abs(a.dot - b.dot) > 0.12 then return a.dot > b.dot end

        -- Với creep/boss lớn, part gần nhất đáng tin hơn pivot. Spider giữ gần nhất.
        return a.dist < b.dist
    end)

    return targets[1]
end

local function fireNearbyKillOnce(target, gunAction)
    if not refreshKillTarget(target) then return false end

    -- Silent camera replica: không xoay camera thật, chỉ cấp vị trí target cho hook updateState.
    CAMERAREPLICA = target.cframe

    pcall(function()
        if gunAction and gunAction.Parent then
            gunAction:FireServer("fire")
        end
    end)

    local fired = false
    local remotes = target.remotes or {}

    for i, remote in ipairs(remotes) do
        if i > 8 then break end
        if remote and remote.Parent then
            local ok = pcall(function()
                remote:FireServer()
            end)
            fired = ok or fired
        end
    end

    if not fired and target.kind ~= "Spider" then
        -- FleshBlock chủ yếu dùng GunAction + camera replica vào body; không fire remote parent để tránh bắn toàn bộ.
        if normalizeKillKind(target.kind) ~= "FleshBlock" and os.clock() - (target.lastNoRemoteNotice or 0) > 4 then
            target.lastNoRemoteNotice = os.clock()
            warn(("[Nevoirs] %s trong range nhưng chưa tìm thấy RemoteEvent target; vẫn thử GunAction."):format(tostring(target.kind)))
        end
        fired = true
    end

    return fired
end

local function toggleAutoNearbyKill(enabled)
    States.AutoNearbyKill = enabled and true or false

    if not States.AutoNearbyKill then
        AutoNearbyKillTarget = nil
        CAMERAREPLICA = nil
        pcall(function() setFireSettingsPanelVisible(false) end)
        smallNotify("Auto Nearby Kill", "Đã tắt", AUTO_KILL_ICON)
        return
    end

    if AutoNearbyKillRunning then
        smallNotify("Auto Nearby Kill", "Đang chạy", AUTO_KILL_ICON)
        return
    end

    AutoNearbyKillRunning = true
    pcall(function() setFireSettingsPanelVisible(true) end)
    smallNotify("Auto Nearby Kill", ("Bật | Delay %.2fs | Creep/Hogo %.0f/%.0f | Flesh/Spider %.0f/%.0f"):format(getAutoKillFireDelay(), AutoKillConfig.RangeGata, AutoKillConfig.RangeHogo, AutoKillConfig.RangeFleshBlock, AutoKillConfig.RangeSpider), AUTO_KILL_ICON)

    task.spawn(function()
        local gunAction = getGunActionRemote()
        local hookOk = installCameraReplicaHook()
        if not gunAction then
            smallNotify("Auto Nearby Kill", "Không thấy GunAction remote", AUTO_KILL_ICON)
        elseif not hookOk then
            warn("[Nevoirs] Không hook được updateState; script vẫn không xoay camera thật.")
        end

        local lastNotice = 0
        while States.AutoNearbyKill do
            local now = os.clock()
            local target = AutoNearbyKillTarget

            if (not refreshKillTarget(target)) or (target.lockStarted and now - target.lockStarted > TARGET_RELOCK_INTERVAL) then
                local oldTarget = AutoNearbyKillTarget
                target = chooseNearbyKillTarget()
                AutoNearbyKillTarget = target
                if target then
                    local sameTarget = oldTarget and oldTarget.instance == target.instance and oldTarget.kind == target.kind
                    target.lockStarted = now
                    if not sameTarget or (not target.lastLockNotice) or now - target.lastLockNotice > 5 then
                        target.lastLockNotice = now
                        local suffix = target.remoteCount and target.remoteCount > 0 and (" | R:" .. tostring(target.remoteCount)) or " | no remote"
                        smallNotify("Auto Nearby Kill", ("Lock %s %.0fst%s"):format(tostring(target.kind), tonumber(target.dist) or 0, suffix), AUTO_KILL_ICON)
                    end
                end
            end

            if target and gunAction then
                fireNearbyKillOnce(target, gunAction)
                task.wait(getAutoKillFireDelay())
            else
                CAMERAREPLICA = nil
                if now - lastNotice > 5 then
                    lastNotice = now
                    smallNotify("Auto Nearby Kill", "Chưa có target hợp lệ gần bạn", AUTO_KILL_ICON)
                end
                task.wait(0.25)
            end
        end

        AutoNearbyKillTarget = nil
        CAMERAREPLICA = nil
        AutoNearbyKillRunning = false
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- UI: WindUI compact layout (mobile + PC balanced)
-- Logic phía trên được giữ nguyên; block này chỉ đổi giao diện và input tốc độ.
-- ══════════════════════════════════════════════════════════════════════════════

-- ══════════════════════════════════════════════════════════════════════════════
-- LOGIC: QUICK TP / LOOPGOTO
-- ══════════════════════════════════════════════════════════════════════════════
TweenService = game:GetService("TweenService")

QuickTPPoints = {
    Mika1 = CFrame.new(150.696, 7.016, -503.982, -0.978, 0, 0.211, 0, 1, 0, -0.211, 0, -0.978),
    Mika2 = CFrame.new(139.844, 7.137, -296.144, 0.410, 0, 0.912, 0, 1, 0, -0.912, 0, 0.410),
    Mika3 = CFrame.new(-259.616, 7.186, -291.817, 0.235, 0, 0.972, 0, 1, 0, -0.972, 0, 0.235),

    SafeSchool = CFrame.new(175.817, 7.586, 336.826, -0.538, 0, 0.843, 0, 1, 0, -0.843, 0, -0.538),
    SafeLab    = CFrame.new(-3359.014, -298.448, 4511.557, -0.263, 0, 0.965, 0, 1, 0, -0.965, 0, -0.263),
    TriggerLab = CFrame.new(-3379.398, -300.115, 4516.708, 0.911, 0, -0.412, 0, 1, 0, 0.412, 0, 0.911),
    Gate       = CFrame.new(-3375.969, -299.601, 4682.964, -0.338, 0, -0.941, 0, 1, 0, 0.941, 0, -0.338),
}

function zeroCharacterVelocity(char)
    char = char or getChar()
    if not char then return end

    local hrp = getHRP(char)
    local hum = char:FindFirstChildWhichIsA("Humanoid")

    if hum then
        pcall(function() hum.Sit = false end)
        pcall(function() hum.PlatformStand = false end)
        pcall(function() hum.AutoRotate = true end)
        pcall(function() hum:Move(Vector3.zero, true) end)
    end

    if hrp then
        pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
        pcall(function() hrp.AssemblyAngularVelocity = Vector3.zero end)
        pcall(function() hrp.Velocity = Vector3.zero end)
        pcall(function() hrp.RotVelocity = Vector3.zero end)
    end
end

function setCharacterCFrame(cf)
    local char = getChar()
    local hrp = getHRP(char)
    if not char or not hrp then
        smallNotify("Quick TP", "Chưa thấy nhân vật/HRP", NEVOIRS_UI_ICON)
        return false
    end

    zeroCharacterVelocity(char)
    pcall(function() hrp.CFrame = cf end)
    task.wait(0.03)
    zeroCharacterVelocity(char)
    return true
end

function tweenCharacterTo(cf, studsPerSecond, maxSegmentDistance)
    local char = getChar()
    local hrp = getHRP(char)
    if not char or not hrp then
        smallNotify("Quick TP", "Chưa thấy nhân vật/HRP", NEVOIRS_UI_ICON)
        return false
    end

    studsPerSecond = tonumber(studsPerSecond) or 145
    maxSegmentDistance = tonumber(maxSegmentDistance) or 110

    local from = hrp.CFrame
    local totalDist = (cf.Position - from.Position).Magnitude
    local steps = math.max(1, math.ceil(totalDist / maxSegmentDistance))

    for i = 1, steps do
        char = getChar()
        hrp = getHRP(char)
        if not char or not hrp then return false end

        local current = hrp.CFrame
        local target = from:Lerp(cf, i / steps)
        local dist = (target.Position - current.Position).Magnitude
        local duration = math.clamp(dist / studsPerSecond, 0.08, 2.35)

        zeroCharacterVelocity(char)
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = target })
        local done = false
        local conn
        conn = tween.Completed:Connect(function()
            done = true
            if conn then conn:Disconnect(); conn = nil end
        end)
        tween:Play()

        local started = os.clock()
        while not done and os.clock() - started < duration + 0.35 do
            if not getHRP(getChar()) then break end
            task.wait()
        end

        pcall(function() if conn then conn:Disconnect() end end)
        zeroCharacterVelocity(char)
    end

    setCharacterCFrame(cf)
    return true
end

function tweenCharacterThrough(points, studsPerSecond, maxSegmentDistance)
    for _, cf in ipairs(points) do
        if not tweenCharacterTo(cf, studsPerSecond, maxSegmentDistance) then
            return false
        end
        task.wait(0.04)
    end
    return true
end

QuickTPBusy = false
function runQuickTP(title, fn)
    if QuickTPBusy then
        smallNotify(title or "Quick TP", "Đang chạy tween khác", NEVOIRS_UI_ICON)
        return
    end

    QuickTPBusy = true
    task.spawn(function()
        local ok, err = pcall(fn)
        if not ok then warn("[Nevoirs - Rage] Quick TP lỗi:", title, err) end
        QuickTPBusy = false
    end)
end

function tpMika()
    runQuickTP("TP Mika", function()
        smallNotify("TP Mika", "Đang đi 1 → 2 → 3", NEVOIRS_UI_ICON)
        tweenCharacterThrough({ QuickTPPoints.Mika1, QuickTPPoints.Mika2, QuickTPPoints.Mika3 }, 145, 95)
    end)
end

function tpSafeSchool()
    runQuickTP("Safe School", function()
        setCharacterCFrame(QuickTPPoints.SafeSchool)
        smallNotify("Safe School", "Đã TP", NEVOIRS_UI_ICON)
    end)
end

function tpGate()
    runQuickTP("Gate", function()
        smallNotify("Gate", "Đang tween nhanh theo đoạn", NEVOIRS_UI_ICON)
        tweenCharacterTo(QuickTPPoints.Gate, 175, 85)
    end)
end

function tpTriggerLab()
    runQuickTP("Trigger Lab", function()
        setCharacterCFrame(QuickTPPoints.TriggerLab)
        smallNotify("Trigger Lab", "Đã TP", NEVOIRS_UI_ICON)
    end)
end

function tpSafeLab()
    runQuickTP("Safe Lab", function()
        setCharacterCFrame(QuickTPPoints.SafeLab)
        smallNotify("Safe Lab", "Đã TP", NEVOIRS_UI_ICON)
    end)
end

LoopGotoSelected = nil
LoopGotoDropdown = nil
loopGotoConn = nil
loopGotoLastNotice = 0

function normalizeLoopGotoChoice(choice)
    if type(choice) == "table" then
        for _, key in ipairs({"Value", "value", "Title", "title", "Name", "name", 1}) do
            local v = choice[key]
            if type(v) == "string" and v ~= "" then choice = v; break end
        end
    end

    choice = tostring(choice or "")
    choice = choice:gsub("^%s+", ""):gsub("%s+$", "")
    choice = choice:gsub("%s+%(@.-%)$", "")
    return choice
end

function getLoopGotoPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local label = plr.Name
            if plr.DisplayName and plr.DisplayName ~= "" and plr.DisplayName ~= plr.Name then
                label = plr.Name .. " (@" .. plr.DisplayName .. ")"
            end
            table.insert(list, label)
        end
    end
    table.sort(list, function(a, b) return tostring(a):lower() < tostring(b):lower() end)
    if #list == 0 then table.insert(list, "Không có player khác") end
    return list
end

function resolveLoopGotoTarget()
    local selected = normalizeLoopGotoChoice(LoopGotoSelected)
    if selected == "" or selected == "Không có player khác" then return nil end

    local lower = selected:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local name = tostring(plr.Name or "")
            local display = tostring(plr.DisplayName or "")
            if name:lower() == lower or display:lower() == lower then
                return plr
            end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local name = tostring(plr.Name or "")
            local display = tostring(plr.DisplayName or "")
            if name:lower():find(lower, 1, true) or display:lower():find(lower, 1, true) then
                return plr
            end
        end
    end

    return nil
end

function refreshLoopGotoPlayers()
    local list = getLoopGotoPlayerList()
    if (not LoopGotoSelected) or LoopGotoSelected == "" or LoopGotoSelected == "Không có player khác" or (not resolveLoopGotoTarget()) then
        LoopGotoSelected = list[1]
    end

    if LoopGotoDropdown then
        pcall(function() LoopGotoDropdown:Refresh(list) end)
        pcall(function() LoopGotoDropdown:SetValues(list) end)
        pcall(function() LoopGotoDropdown:Update({ Values = list, Value = LoopGotoSelected }) end)
        pcall(function() LoopGotoDropdown:Set(LoopGotoSelected) end)
    end

    smallNotify("LoopGoto", "Đã refresh danh sách player", NEVOIRS_UI_ICON)
    return list
end

function stopLoopGoto()
    if loopGotoConn then loopGotoConn:Disconnect(); loopGotoConn = nil end
    States.LoopGoto = false
    zeroCharacterVelocity()
end

function startLoopGoto()
    if loopGotoConn then loopGotoConn:Disconnect(); loopGotoConn = nil end
    States.LoopGoto = true

    if (not LoopGotoSelected) or LoopGotoSelected == "" or LoopGotoSelected == "Không có player khác" then
        refreshLoopGotoPlayers()
    end

    loopGotoConn = RunService.Heartbeat:Connect(function()
        if not States.LoopGoto then stopLoopGoto(); return end

        local myChar = getChar()
        local myRoot = getHRP(myChar)
        local target = resolveLoopGotoTarget()
        local targetRoot = target and getHRP(target.Character)

        if not myRoot or not target or not targetRoot then
            local now = os.clock()
            if now - loopGotoLastNotice > 2.5 then
                loopGotoLastNotice = now
                refreshLoopGotoPlayers()
                smallNotify("LoopGoto", "Target lỗi/out, đã refresh lại", NEVOIRS_UI_ICON)
            end
            return
        end

        zeroCharacterVelocity(myChar)
        pcall(function()
            myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
        end)
    end)

    smallNotify("LoopGoto", "Đang follow: " .. tostring(normalizeLoopGotoChoice(LoopGotoSelected)), NEVOIRS_UI_ICON)
end

function toggleLoopGoto(enabled)
    if enabled then
        startLoopGoto()
    else
        stopLoopGoto()
        smallNotify("LoopGoto", "Đã tắt", NEVOIRS_UI_ICON)
    end
end

function clampNumber(value, minValue, maxValue, fallback)
    local n
    local t = typeof(value)

    if t == "number" then
        n = value
    elseif t == "string" then
        n = tonumber((value:gsub(",", ".")))
    elseif t == "Instance" then
        pcall(function()
            if value:IsA("TextBox") or value:IsA("TextLabel") or value:IsA("TextButton") then
                n = tonumber((value.Text or ""):gsub(",", "."))
            end
        end)
    elseif t == "table" then
        for _, key in ipairs({"Value", "value", "Text", "text", "Input", "input", "CurrentValue", "currentValue"}) do
            local ok, raw = pcall(function() return value[key] end)
            if ok and raw ~= nil then
                local got = clampNumber(raw, minValue, maxValue, nil)
                if got ~= nil then
                    n = got
                    break
                end
            end
        end
    else
        n = tonumber(tostring(value or ""):gsub(",", "."))
    end

    if not n then return fallback end
    if n ~= n or n == math.huge or n == -math.huge then return fallback end
    return math.clamp(n, minValue, maxValue)
end

function loadWindUI()
    local sources = {
        "https://raw.githubusercontent.com/eystearisdown/nevoirs/main/main.lua",
        "https://raw.githubusercontent.com/eystearisdown/nevoirs/refs/heads/main/main.lua",
    }

    for _, url in ipairs(sources) do
        local ok, lib = pcall(function()
            local source = game:HttpGet(url)
            local fn = loadstring(source)
            return fn()
        end)
        if ok and lib then
            return lib
        end
    end

    return nil
end


function __InstallCompactNotify(ui, fallbackTitle)
    if not ui or ui.__FiHonCompactNotifyInstalled then return end
    ui.__FiHonCompactNotifyInstalled = true

    local Players_Notify = game:GetService("Players")
    local TweenService_Notify = game:GetService("TweenService")
    local UserInputService_Notify = game:GetService("UserInputService")
    local LocalPlayer_Notify = Players_Notify.LocalPlayer
    local DEFAULT_NOTIFY_ICON = rawget(_G, "NEVOIRS_UI_ICON") or (typeof(NEVOIRS_UI_ICON) == "string" and NEVOIRS_UI_ICON) or "rbxassetid://17617869383"

    local function resolveNotifyIcon(icon)
        icon = tostring(icon or "")
        if icon:find("rbxassetid://", 1, true) then return icon end
        if icon:match("^%d+$") then return "rbxassetid://" .. icon end
        return DEFAULT_NOTIFY_ICON
    end

    local function getNotifyHolder()
        local pg = LocalPlayer_Notify and LocalPlayer_Notify:FindFirstChildOfClass("PlayerGui")
        if not pg then return nil end

        local gui = pg:FindFirstChild("FiHon_CompactNotifications")
        if not gui then
            gui = Instance.new("ScreenGui")
            gui.Name = "FiHon_CompactNotifications"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.DisplayOrder = 999999
            gui.Parent = pg
        end

        local holder = gui:FindFirstChild("Holder")
        if not holder then
            holder = Instance.new("Frame")
            holder.Name = "Holder"
            holder.AnchorPoint = Vector2.new(1, 1)
            holder.Position = UDim2.new(1, -8, 1, -12)
            holder.BackgroundTransparency = 1
            holder.BorderSizePixel = 0
            holder.Parent = gui

            local layout = Instance.new("UIListLayout")
            layout.Name = "Layout"
            layout.FillDirection = Enum.FillDirection.Vertical
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 4)
            layout.Parent = holder
        end

        local width = UserInputService_Notify.TouchEnabled and 206 or 224
        holder.Size = UDim2.new(0, width, 1, -24)
        return holder
    end

    local function compactNotify(payload)
        payload = (typeof(payload) == "table") and payload or { Content = tostring(payload or "") }
        local holder = getNotifyHolder()
        if not holder then return end

        local touch = UserInputService_Notify.TouchEnabled
        local w = touch and 206 or 224
        local h = touch and 44 or 48
        local duration = 2

        local card = Instance.new("Frame")
        card.Name = "CompactNotify"
        card.Size = UDim2.fromOffset(w, h)
        card.LayoutOrder = math.floor(os.clock() * 100000)
        card.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = holder

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = card

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Transparency = 1
        stroke.Color = Color3.fromRGB(78, 158, 230)
        stroke.Parent = card

        local iconImg = Instance.new("ImageLabel")
        iconImg.Name = "Icon"
        iconImg.BackgroundTransparency = 1
        iconImg.Position = UDim2.fromOffset(10, touch and 10 or 11)
        iconImg.Size = UDim2.fromOffset(touch and 22 or 24, touch and 22 or 24)
        iconImg.Image = resolveNotifyIcon(payload.Icon)
        iconImg.ImageTransparency = 1
        iconImg.ScaleType = Enum.ScaleType.Crop
        iconImg.Parent = card
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.fromOffset(touch and 39 or 43, 5)
        title.Size = UDim2.new(1, touch and -48 or -54, 0, touch and 15 or 17)
        title.Font = Enum.Font.GothamSemibold
        title.TextSize = touch and 11 or 12
        title.TextColor3 = Color3.fromRGB(245, 247, 255)
        title.TextTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = Enum.TextYAlignment.Center
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.RichText = true
        title.Text = tostring(payload.Title or fallbackTitle or "Notification")
        title.Parent = card

        local content = Instance.new("TextLabel")
        content.Name = "Content"
        content.BackgroundTransparency = 1
        content.Position = UDim2.fromOffset(touch and 39 or 43, touch and 22 or 24)
        content.Size = UDim2.new(1, touch and -48 or -54, 0, touch and 17 or 18)
        content.Font = Enum.Font.Gotham
        content.TextSize = touch and 9 or 10
        content.TextColor3 = Color3.fromRGB(215, 222, 235)
        content.TextTransparency = 1
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.TextYAlignment = Enum.TextYAlignment.Top
        content.TextWrapped = false
        content.TextTruncate = Enum.TextTruncate.AtEnd
        content.RichText = true
        content.Text = tostring(payload.Content or payload.Text or "")
        content.Parent = card

        pcall(function()
            TweenService_Notify:Create(card, TweenInfo.new(0.12), {BackgroundTransparency = 0.36}):Play()
            TweenService_Notify:Create(stroke, TweenInfo.new(0.12), {Transparency = 0.50}):Play()
            TweenService_Notify:Create(iconImg, TweenInfo.new(0.12), {ImageTransparency = 0.05}):Play()
            TweenService_Notify:Create(title, TweenInfo.new(0.12), {TextTransparency = 0}):Play()
            TweenService_Notify:Create(content, TweenInfo.new(0.12), {TextTransparency = 0}):Play()
        end)

        task.delay(duration, function()
            if not card or not card.Parent then return end
            pcall(function()
                TweenService_Notify:Create(card, TweenInfo.new(0.16), {BackgroundTransparency = 1}):Play()
                TweenService_Notify:Create(stroke, TweenInfo.new(0.16), {Transparency = 1}):Play()
                TweenService_Notify:Create(iconImg, TweenInfo.new(0.16), {ImageTransparency = 1}):Play()
                TweenService_Notify:Create(title, TweenInfo.new(0.16), {TextTransparency = 1}):Play()
                TweenService_Notify:Create(content, TweenInfo.new(0.16), {TextTransparency = 1}):Play()
            end)
            task.wait(0.18)
            pcall(function() card:Destroy() end)
        end)

        return card
    end

    ui.__FiHonOriginalNotify = ui.Notify
    ui.Notify = function(self, payload)
        if payload == nil and typeof(self) == "table" and (self.Title or self.Content or self.Text or self.Duration) then
            payload = self
        end
        return compactNotify(payload)
    end
end

WindUI = loadWindUI()
if not WindUI then
    warn("[Nevoirs - Rage] Không tải được WindUI. Hãy kiểm tra HttpGet/GitHub trong executor.")
    return
end

pcall(function() WindUI:SetTheme("Dark") end)
pcall(function() WindUI.TransparencyValue = 0.12 end)
pcall(function() __InstallCompactNotify(WindUI, "Nevoirs") end)

-- Setting Auto Nearby Kill giờ nằm trực tiếp trong WindUI (không còn overlay riêng).
setFireSettingsPanelVisible = function(_) end

function getWindowSize()
    local camera = Workspace.CurrentCamera or workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(900, 600)
    local touch = UserInputService.TouchEnabled
    local small = touch or viewport.X < 760 or viewport.Y < 460
    local ratio = 1.55 -- gần 4:3 nhưng kéo ngang dài hơn một chút; sidebar đã thu gọn để nhường main

    if small then
        local h = math.clamp(math.floor(viewport.Y * 0.78), 320, 430)
        local maxW = math.max(420, math.min(math.floor(viewport.X * 0.92), 680))
        local minW = math.min(480, maxW)
        local w = math.clamp(math.floor(h * ratio), minW, maxW)
        return UDim2.fromOffset(w, h), Vector2.new(w, h), Vector2.new(w, h), 118, false
    end

    return UDim2.fromOffset(650, 420), Vector2.new(650, 420), Vector2.new(650, 420), 122, false
end

windowSize, minSize, maxSize, sidebarWidth, canResize = getWindowSize()
openButtonScale = UserInputService.TouchEnabled and 0.72 or 0.66
DEFAULT_UI_SCALE = UserInputService.TouchEnabled and 0.62 or 0.60

Window = WindUI:CreateWindow({
    Title = "Nevoirs - Rage",
    Icon = NEVOIRS_UI_ICON,
    Author = "Nevoirs",
    Folder = "Nevoirs_Rage",
    Size = windowSize,
    MinSize = minSize,
    MaxSize = maxSize,
    ToggleKey = Enum.KeyCode.RightControl,
    Transparent = true,
    Theme = "Dark",
    Resizable = canResize,
    SideBarWidth = sidebarWidth,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    Topbar = {
        Height = UserInputService.TouchEnabled and 64 or 58,
        ButtonsType = "Default",
    },
    OpenButton = {
        Enabled = false,
    },
})

MENU_AVATAR_SIZE = UserInputService.TouchEnabled and 56 or 52

function __isUiChromeAvatar(obj)
    local a = obj
    while a do
        local n = tostring(a.Name or "")
        if n == "FiHon_LeftToggle_UI" or n == "Nevoirs_LeftToggle_UI" or n == "Nevoirs_WorkspaceFinder_Toggle" or n == "FiHon_CompactNotifications" then
            return true
        end
        a = a.Parent
    end
    return false
end

function __isMenuIcon(obj)
    if not (obj and (obj:IsA("ImageLabel") or obj:IsA("ImageButton"))) then return false end
    local image = tostring(obj.Image or "")
    return image == tostring(NEVOIRS_UI_ICON) or image:find("106478063464970", 1, true) ~= nil
end

function styleMenuAvatarImage(obj)
    if not __isMenuIcon(obj) then return end
    -- Giữ màu asset gốc, không tint tím/xanh lên ảnh.
    obj.ImageColor3 = Color3.fromRGB(255, 255, 255)
    obj.ImageTransparency = 0
    obj.ScaleType = Enum.ScaleType.Crop
    obj.ClipsDescendants = true

    local c = obj:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = obj

    if not __isUiChromeAvatar(obj) then
        obj.Size = UDim2.fromOffset(MENU_AVATAR_SIZE, MENU_AVATAR_SIZE)
        local st = obj:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
        st.Thickness = 1.2
        st.Transparency = 0.15
        st.Color = Color3.fromRGB(78, 158, 230)
        st.Parent = obj
    end
end

function applyMenuAvatarChrome()
    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end
    for _, obj in ipairs(playerGui:GetDescendants()) do
        pcall(styleMenuAvatarImage, obj)
    end
end

applyMenuAvatarChrome()
task.delay(0.25, applyMenuAvatarChrome)
task.delay(0.8, applyMenuAvatarChrome)
pcall(function()
    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        playerGui.DescendantAdded:Connect(function(obj)
            task.defer(function()
                pcall(styleMenuAvatarImage, obj)
            end)
        end)
    end
end)

pcall(function()
    Window:SetUIScale(DEFAULT_UI_SCALE)
end)

pcall(function()
    if Window.EditOpenButton then
        Window:EditOpenButton({ Enabled = false })
    end
end)



-- Toggle tròn bên trái, cùng style Workspace Finder.
windowOpen = true
function toggleNevoirsWindow()
    local ok = false
    pcall(function()
        if Window.Toggle then
            Window:Toggle()
            ok = true
        end
    end)
    if ok then return end

    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
        task.wait()
        vim:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
        ok = true
    end)
    if ok then return end

    windowOpen = not windowOpen
    pcall(function() if Window.SetVisible then Window:SetVisible(windowOpen) end end)
    pcall(function() if windowOpen and Window.Open then Window:Open() elseif (not windowOpen) and Window.Close then Window:Close() end end)
    pcall(function() if windowOpen and Window.Show then Window:Show() elseif (not windowOpen) and Window.Hide then Window:Hide() end end)
end

function createNevoirsLeftToggle()
    local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return end
    local old = pg:FindFirstChild("Nevoirs_LeftToggle_UI")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "Nevoirs_LeftToggle_UI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999998
    gui.Parent = pg

    local hitSize = UserInputService.TouchEnabled and 46 or 42
    local visualSize = UserInputService.TouchEnabled and 20 or 18 -- tăng lại 2 lần so với bản đã thu nhỏ
    local btn = Instance.new("ImageButton")
    btn.Name = "NevoirsToggle"
    btn.AnchorPoint = Vector2.new(0, 0.5)
    -- Dịch toggle lên trên một chút, giữ vùng bấm trong suốt để mobile vẫn dễ chạm.
    btn.Position = UDim2.new(0, 12, 0.5, -70)
    btn.Size = UDim2.fromOffset(hitSize, hitSize)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Image = ""
    btn.Parent = gui

    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Position = UDim2.fromScale(0.5, 0.5)
    logo.Size = UDim2.fromOffset(visualSize, visualSize)
    logo.BackgroundTransparency = 1
    logo.Image = NEVOIRS_UI_ICON
    logo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    logo.ImageTransparency = 0
    logo.ScaleType = Enum.ScaleType.Crop
    logo.Parent = btn

    local co = Instance.new("UICorner")
    co.CornerRadius = UDim.new(1, 0)
    co.Parent = logo
    local st = Instance.new("UIStroke")
    st.Thickness = 1
    st.Transparency = 0.25
    st.Color = Color3.fromRGB(78, 158, 230)
    st.Parent = logo

    btn.MouseButton1Click:Connect(toggleNevoirsWindow)
end

createNevoirsLeftToggle()

-- Không ép icon rbxasset thành hình tròn nữa; giữ nguyên style ảnh gốc/WindUI.


pcall(function()
    WindUI:Notify({
        Title = "Nevoirs - Rage",
        Content = "WindUI đã tải. RightCtrl hoặc nút tròn bên trái để ẩn/hiện menu.",
        Icon = "check",
        Duration = 2,
    })
end)

PlayerTab = Window:Tab({ Title = "Cá nhân", Icon = "user" })
ESPTab    = Window:Tab({ Title = "ESP", Icon = "eye" })
AutoTab   = Window:Tab({ Title = "Main", Icon = "zap" })
SettingTab = Window:Tab({ Title = "Setting", Icon = "settings" })

function safeParagraph(tab, title, desc, icon)
    pcall(function()
        tab:Paragraph({
            Title = title,
            Desc = desc,
            Image = icon,
            ImageSize = 26,
            Color = Color3.fromRGB(78, 158, 230),
        })
    end)
end

function safeDivider(tab)
    pcall(function() tab:Divider() end)
end

COMPACT_CONTROLS = true

function setElementVisible(element, visible)
    if not element then return end
    pcall(function()
        if element.SetVisible then element:SetVisible(visible) end
    end)
    pcall(function()
        if element.Visible ~= nil then element.Visible = visible end
    end)
    pcall(function()
        if element.Instance and element.Instance.Visible ~= nil then element.Instance.Visible = visible end
    end)
    pcall(function()
        if element.Frame and element.Frame.Visible ~= nil then element.Frame.Visible = visible end
    end)
    pcall(function()
        if element.Container and element.Container.Visible ~= nil then element.Container.Visible = visible end
    end)
end


function addToggle(tab, title, desc, value, callback)
    local ok, element = pcall(function()
        local options = {
            Title = title,
            Value = value and true or false,
            Callback = function(state)
                local okCb, err = pcall(callback, state and true or false)
                if not okCb then warn("[Nevoirs - Rage] Toggle lỗi:", title, err) end
            end,
        }
        if not COMPACT_CONTROLS and desc and desc ~= "" then options.Desc = desc end
        return tab:Toggle(options)
    end)
    if not ok then warn("[Nevoirs - Rage] Không tạo được toggle:", title, element) end
    return element
end

function addButton(tab, title, desc, callback)
    local ok, element = pcall(function()
        local options = {
            Title = title,
            Callback = function()
                task.spawn(function()
                    local okCb, err = pcall(callback)
                    if not okCb then warn("[Nevoirs - Rage] Auto lỗi:", title, err) end
                end)
            end,
        }
        if not COMPACT_CONTROLS and desc and desc ~= "" then options.Desc = desc end
        return tab:Button(options)
    end)
    if not ok then warn("[Nevoirs - Rage] Không tạo được button:", title, element) end
    return element
end


function addDropdown(tab, title, desc, values, defaultValue, callback)
    local ok, element = pcall(function()
        local options = {
            Title = title,
            Values = values,
            Value = defaultValue,
            Multi = false,
            AllowNone = false,
            Callback = function(choice)
                local okCb, err = pcall(callback, choice)
                if not okCb then warn("[Nevoirs - Rage] Dropdown lỗi:", title, err) end
            end,
        }
        if not COMPACT_CONTROLS and desc and desc ~= "" then options.Desc = desc end
        return tab:Dropdown(options)
    end)

    if ok and element then return element end

    warn("[Nevoirs - Rage] Không tạo được dropdown, dùng input fallback:", title, element)
    local okInput, inputElement = pcall(function()
        local options = {
            Title = title .. " (nhập tay)",
            Value = tostring(defaultValue or ""),
            Type = "Input",
            Placeholder = "Nhập username/display name",
            Callback = function(choice)
                local okCb, err = pcall(callback, choice)
                if not okCb then warn("[Nevoirs - Rage] Input fallback lỗi:", title, err) end
            end,
        }
        if not COMPACT_CONTROLS and desc and desc ~= "" then options.Desc = desc end
        return tab:Input(options)
    end)
    if not okInput then warn("[Nevoirs - Rage] Không tạo được input fallback:", title, inputElement) end
    return inputElement
end

function applyNumeric(title, rawValue, minValue, maxValue, callback)
    local value = clampNumber(rawValue, minValue, maxValue, nil)
    if value == nil then
        warn("[Nevoirs - Rage] Giá trị không hợp lệ:", title, tostring(rawValue))
        return
    end

    local okCb, err = pcall(callback, value)
    if not okCb then warn("[Nevoirs - Rage] Number lỗi:", title, err) end
end

function addNumberInput(tab, title, desc, defaultText, minValue, maxValue, callback, stepValue, settingKey)
    local defaultValue = clampNumber(defaultText, minValue, maxValue, minValue)

    -- Từ bản này các setting dùng ô nhập tay hoàn toàn, hỗ trợ số thập phân.
    local function handle(input)
        local value = clampNumber(input, minValue, maxValue, defaultValue)
        if value == nil then value = defaultValue end
        if settingKey then setSetting(settingKey, value) end
        applyNumeric(title, value, minValue, maxValue, callback)
    end

    local okInput, inputElement = pcall(function()
        local options = {
            Title = title,
            Value = tostring(defaultValue),
            Type = "Input",
            Placeholder = tostring(defaultValue),
            Callback = handle,
        }
        if not COMPACT_CONTROLS and desc and desc ~= "" then options.Desc = desc end
        return tab:Input(options)
    end)

    if not okInput then
        warn("[Nevoirs - Rage] Không tạo được input:", title, inputElement)
    end

    handle(defaultValue)
    return inputElement
end


safeParagraph(SettingTab, "UI Scale", "Chỉnh kích cỡ tổng thể UI. Mặc định đặt thấp để tránh chèn ép màn hình.", "settings")
addNumberInput(SettingTab, "UI Scale", "Kéo/nhập scale UI.", DEFAULT_UI_SCALE, 0.58, 0.90, function(v)
    pcall(function() Window:SetUIScale(math.clamp(tonumber(v) or DEFAULT_UI_SCALE, 0.58, 0.90)) end)
end, 0.01)

-- Cá nhân
safeParagraph(PlayerTab, "Cá nhân", "Giữ nguyên logic local player: TPWalk, Noclip, Jump, Fullbright, VFly.", "user")
TPWalkSpeedInput, VFlySpeedInput = nil, nil

addToggle(PlayerTab, "TPWalk", "Dịch chuyển theo hướng di chuyển hiện tại.", false, function(v)
    toggleTPWalk(v)
    setElementVisible(TPWalkSpeedInput, v)
end)
TPWalkSpeedInput = addNumberInput(PlayerTab, "TPWalk • Tốc", "0 = chưa cấu hình. Nhập số thủ công, hỗ trợ thập phân.", TPWalkSpeed, 0, 9999, function(v)
    TPWalkSpeed = v
end, 0.1, "TPWalkSpeed")
setElementVisible(TPWalkSpeedInput, false)

addToggle(PlayerTab, "Noclip", "Tắt va chạm nhân vật khi bật.", false, toggleNoclip)
addToggle(PlayerTab, "Nhảy vô hạn", "Nhảy lại bằng JumpRequest, hỗ trợ mobile/PC.", false, toggleInfiniteJump)
addToggle(PlayerTab, "Sáng map", "Fullbright liên tục, tắt sẽ khôi phục ánh sáng gốc.", false, toggleFullbright)

addToggle(PlayerTab, "VFly", "Bay theo hướng camera, joystick mobile và WASD PC.", false, function(v)
    toggleVFly(v)
    setElementVisible(VFlySpeedInput, v)
end)
VFlySpeedInput = addNumberInput(PlayerTab, "VFly • Tốc", "0 = chưa cấu hình. Nhập số thủ công, hỗ trợ thập phân.", VFlySpeed, 0, 99999, function(v)
    VFlySpeed = v
end, 0.1, "VFlySpeed")
setElementVisible(VFlySpeedInput, false)

-- ESP
safeParagraph(ESPTab, "ESP người chơi", "Charm + text nhỏ như logic hiện tại.", "eye")
addToggle(ESPTab, "Người chơi", "Bật ESP cho player khác.", false, setPlayerESP)

safeDivider(ESPTab)
safeParagraph(ESPTab, "ESP quái", "Bật/tắt quái tổng và lọc Creep/Boss.", "skull")
addToggle(ESPTab, "Quái", "Bật ESP quái đang có trong map.", false, setMonsterESP)
addToggle(ESPTab, "Creep", "Cho phép quét Gata + Grunts + Muki/Muki2 cùng nhánh Creep.", true, function(v)
    MonsterAllows.Gata = v
    if States.ESPMonster then setMonsterESP(true) end
end)
addToggle(ESPTab, "Boss", "Cho phép quét boss theo path hiện tại.", true, function(v)
    MonsterAllows.Boss = v
    if States.ESPMonster then setMonsterESP(true) end
end)

safeDivider(ESPTab)
safeParagraph(ESPTab, "ESP nhiệm vụ", "Master bật theo các mục con đang cho phép.", "list-check")
addToggle(ESPTab, "Nhiệm vụ", "Bật ESP nhiệm vụ theo danh sách bên dưới.", false, setTaskMasterESP)
addToggle(ESPTab, "Xác", "DeadCivilians / Body.", true, function(v) setTaskAllow("Body", v) end)
addToggle(ESPTab, "Nhện", "AkariSpider.", true, function(v) setTaskAllow("Spider", v) end)
addToggle(ESPTab, "Máy phát", "CircuitPillar / Generator.", true, function(v) setTaskAllow("Generator", v) end)
addToggle(ESPTab, "Terminal", "ShapeTerminals.", true, function(v) setTaskAllow("Terminal", v) end)
addToggle(ESPTab, "Van", "Valves có icon/prompt.", true, function(v) setTaskAllow("Valve", v) end)
addToggle(ESPTab, "Dây điện", "WireBox.", true, function(v) setTaskAllow("Wire", v) end)
addToggle(ESPTab, "Director", "Director + ID Card.", true, function(v) setTaskAllow("Director", v) end)

-- Auto
safeParagraph(AutoTab, "Main", "Chỉ xử lý object gần nhất, không TP, không dùng mục cự li.", "zap")

AutoKillSettingElements = {}
function addAutoKillSettingInput(title, settingKey, configKey, defaultValue, minValue, maxValue)
    local element = addNumberInput(AutoTab, "Auto Nearby Kill • " .. title, "Nhập số thủ công, hỗ trợ số thập phân.", defaultValue, minValue, maxValue, function(v)
        AutoKillConfig[configKey] = v
        AutoNearbyKillTarget = nil
    end, 0.01, settingKey)
    table.insert(AutoKillSettingElements, element)
    setElementVisible(element, false)
    return element
end

setFireSettingsPanelVisible = function(visible)
    for _, element in ipairs(AutoKillSettingElements) do
        setElementVisible(element, visible and true or false)
    end
end

addToggle(AutoTab, "Auto Nearby Kill", "Tự xử lý Creep(Gata/Grunts/Muki), Hogo, Flesh, Spider gần bạn, không teleport và không kéo camera thật.", false, toggleAutoNearbyKill)
addAutoKillSettingInput("Tốc fire (giây)", "AutoKillFireDelay", "FireDelay", AutoKillConfig.FireDelay, 0.01, 10)
addAutoKillSettingInput("Stud Creep", "AutoKillRangeGata", "RangeGata", AutoKillConfig.RangeGata, 0, 9999)
addAutoKillSettingInput("Stud HogoGuntai", "AutoKillRangeHogo", "RangeHogo", AutoKillConfig.RangeHogo, 0, 9999)
addAutoKillSettingInput("Stud FleshBlock", "AutoKillRangeFleshBlock", "RangeFleshBlock", AutoKillConfig.RangeFleshBlock, 0, 9999)
addAutoKillSettingInput("Stud Spider", "AutoKillRangeSpider", "RangeSpider", AutoKillConfig.RangeSpider, 0, 9999)

safeDivider(AutoTab)
safeParagraph(AutoTab, "Yen phụ trợ", "ESP Yen + tự nhặt Yen gần bạn, tách riêng khỏi tab ESP để UI đỡ rối.", "coins")
addToggle(AutoTab, "Auto ESP Yen", "Charm + title nhỏ màu vàng cho Yen.", false, setYenESP)
addToggle(AutoTab, "Auto Collect Yen", "Tự nhặt Yen khi ở gần, theo logic gốc <= 10 studs.", false, setYenCollect)

safeDivider(AutoTab)
addButton(AutoTab, "Máy phát", "Auto Generator gần nhất.", autoGenerator)
addButton(AutoTab, "Terminal", "Auto Shape Terminal gần nhất.", autoTerminal)
addButton(AutoTab, "Van", "Auto xoay van gần nhất còn icon/prompt.", autoValve)
addButton(AutoTab, "Dây điện", "Auto WireBox gần nhất.", autoWire)

safeDivider(AutoTab)
safeParagraph(AutoTab, "Quick TP / LoopGoto", "Các nút TP theo tọa độ log; Mika/Gate dùng tween chia đoạn, Safe/Trigger TP trực tiếp.", "map-pin")
addButton(AutoTab, "TP Mika", "Đi lần lượt 1 → 2 → 3, đoạn xa sẽ tự chia tween.", tpMika)
addButton(AutoTab, "Safe School", "TP trực tiếp tọa độ 4.", tpSafeSchool)
addButton(AutoTab, "Gate", "Tween nhanh tới tọa độ 7, chia nhiều đoạn nhỏ.", tpGate)
addButton(AutoTab, "Trigger Lab", "TP trực tiếp tọa độ 6.", tpTriggerLab)
addButton(AutoTab, "Safe Lab", "TP trực tiếp tọa độ 5.", tpSafeLab)

initialLoopGotoPlayers = getLoopGotoPlayerList()
LoopGotoSelected = initialLoopGotoPlayers[1]
LoopGotoDropdown = addDropdown(AutoTab, "LoopGoto • Player", "Chọn người trong server để follow liên tục.", initialLoopGotoPlayers, LoopGotoSelected, function(choice)
    LoopGotoSelected = normalizeLoopGotoChoice(choice)
    smallNotify("LoopGoto", "Đã chọn: " .. tostring(LoopGotoSelected), NEVOIRS_UI_ICON)
end)
addButton(AutoTab, "Refresh Player", "Cập nhật lại danh sách nếu có người out/vào hoặc dropdown lỗi.", refreshLoopGotoPlayers)
addToggle(AutoTab, "LoopGoto", "Liên tục đi theo player đã chọn, tắt để dừng.", false, toggleLoopGoto)

pcall(function() PlayerTab:Select() end)

print("[Nevoirs - Rage] ✅ Đã tải WindUI")
