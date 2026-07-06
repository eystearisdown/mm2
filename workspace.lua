-- Nevoirs - Workspace Finder Pro
-- Style WindUI giống Nevoirs, chức năng: dò Workspace/Remote, gom object lớn, Look object, Highlight/TP, Remote logger để phục vụ FireServer.

pcall(function()
    local pg = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then
        for _, name in ipairs({
            "Nevoirs_Workspace_Finder_UI",
            "Nevoirs_Workspace_Finder_WindUI",
            "Nevoirs_WorkspaceFinder_Selected",
            "Nevoirs_WorkspaceFinder_Toggle",
            "FiHon_CompactNotifications",
        }) do
            local old = pg:FindFirstChild(name)
            if old then old:Destroy() end
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local LocalPlayer = Players.LocalPlayer

local NEVOIRS_UI_ICON = "rbxassetid://106478063464970"
local WORKSPACE_DEV_ICON = "code-xml"
local GUI_FOLDER = "Nevoirs_Workspace_Finder"

local C_DIM = Color3.fromRGB(120, 120, 145)
local C_ACCENT = Color3.fromRGB(78, 158, 230)
local C_MOB = Color3.fromRGB(232, 82, 82)
local C_PROMPT = Color3.fromRGB(95, 215, 145)
local C_EVENT = Color3.fromRGB(255, 166, 70)
local C_OBJECT = Color3.fromRGB(168, 176, 195)
local C_LOG = Color3.fromRGB(255, 210, 88)

local MAX_ROWS_PER_TAB = 55
local MAX_EVENT_ROWS = 70
local MAX_REMOTE_LOGS = 24
local SCAN_YIELD_STEP = 650

-- ══════════════════════════════════════════════════════════════════════════════
-- Basic helpers
-- ══════════════════════════════════════════════════════════════════════════════
local function getChar()
    return LocalPlayer and LocalPlayer.Character
end

local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function validInstance(obj)
    return typeof(obj) == "Instance" and obj.Parent ~= nil and obj:IsDescendantOf(game)
end

local function validPart(p)
    return validInstance(p) and p:IsA("BasePart")
end

local function isEventLike(obj)
    return validInstance(obj) and (
        obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or
        obj:IsA("BindableEvent") or obj:IsA("BindableFunction")
    )
end

local function getPrompt(obj)
    if not validInstance(obj) then return nil end
    if obj:IsA("ProximityPrompt") then return obj end
    return obj:FindFirstChildWhichIsA("ProximityPrompt", true)
end

local function rootOf(obj)
    if not validInstance(obj) then return nil end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") or obj:IsA("Folder") then
        return obj:FindFirstChild("HumanoidRootPart", true)
            or obj:FindFirstChild("Hitbox", true)
            or obj:FindFirstChild("body", true)
            or obj:FindFirstChild("Body", true)
            or obj:FindFirstChild("Head", true)
            or obj:FindFirstChild("PromptPart", true)
            or obj:FindFirstChildWhichIsA("BasePart", true)
    end
    return obj:FindFirstChildWhichIsA("BasePart", true)
end

local function distanceOf(obj)
    local r, hrp = rootOf(obj), getHRP()
    if r and hrp then
        return math.floor((r.Position - hrp.Position).Magnitude + 0.5)
    end
    return nil
end

local function pathOf(obj)
    if not validInstance(obj) then return "" end
    local ok, full = pcall(function() return obj:GetFullName() end)
    full = tostring((ok and full) or obj.Name or obj)
    if full == "Workspace" then return "workspace" end
    if full:sub(1, 10) == "Workspace." then return "workspace." .. full:sub(11) end
    return "game." .. full:gsub("^game%.", "")
end

local function luaKey(seg)
    seg = tostring(seg or "")
    if seg:match("^[%a_][%w_]*$") then return "." .. seg end
    return "[" .. string.format("%q", seg) .. "]"
end

local function luaPathOf(obj)
    if not validInstance(obj) then return "nil" end
    local chain = {}
    local cur = obj
    while cur and cur ~= game do
        table.insert(chain, 1, tostring(cur.Name or cur.ClassName))
        cur = cur.Parent
    end
    if #chain == 0 then return "game" end

    local first = chain[1]
    local out
    if first == "Workspace" then
        out = "workspace"
    else
        out = "game:GetService(" .. string.format("%q", first) .. ")"
    end
    for i = 2, #chain do
        out = out .. luaKey(chain[i])
    end
    return out
end

local function shortPath(path, maxParts)
    path = tostring(path or "")
    local parts = {}
    for part in path:gmatch("[^%.]+") do table.insert(parts, part) end
    maxParts = maxParts or 7
    if #parts <= maxParts then return path end
    local keep = {}
    for i = math.max(1, #parts - maxParts + 1), #parts do table.insert(keep, parts[i]) end
    return "…" .. table.concat(keep, ".")
end

local function copyText(text)
    local copied = false
    pcall(function()
        if setclipboard then
            setclipboard(tostring(text or ""))
            copied = true
        end
    end)
    return copied
end

local function normalizeName(s)
    return tostring(s or ""):lower()
end

local MOB_KEYWORDS = {
    "monster", "mobs", "mob", "enemy", "enemies", "grunts", "grunt",
    "gata", "muki", "hogo", "akarispider", "spider", "fleshblock", "boss",
    "isamu", "hideo", "snare", "creep"
}

local PROMPT_KEYWORDS = {
    "objective", "prompt", "task", "terminal", "valve", "wire", "generator",
    "circuitpillar", "deadcivilians", "director", "idcard", "ammo", "pick", "interact",
    "cleanse", "lockdown", "shape", "minigame", "save", "heal", "skillcheck", "skill"
}

local GENERIC_FOLDERS = {
    Workspace = true, workspace = true, Section1 = true, Section2 = true, Section3 = true,
    Section4 = true, Section5 = true, MAIN = true, Main = true, Map = true, Folder = true,
    Objective = true, Objectives = true, MainObjective = true, MAINOBJECTIVE = true,
    MAINOBJECTIVE2 = true, Monster = true, Monsters = true, Mobs = true, Mob = true,
    Grunts = true, Spiders = true, Prompts = true, Parts = true, Models = true,
}

local function containsAny(text, list)
    text = normalizeName(text)
    for _, key in ipairs(list) do
        if text:find(key, 1, true) then return true end
    end
    return false
end

local function nearestAncestor(raw, predicate)
    local cur = raw
    while cur and cur ~= Workspace and cur ~= game do
        if predicate(cur) then return cur end
        cur = cur.Parent
    end
    return nil
end

local function bestModelAncestor(raw)
    return nearestAncestor(raw, function(o)
        return o:IsA("Model")
    end)
end

local function mobAncestor(raw)
    local modelHum = nearestAncestor(raw, function(o)
        return o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") ~= nil
    end)
    if modelHum then return modelHum end

    return nearestAncestor(raw, function(o)
        if not (o:IsA("Model") or o:IsA("Folder")) then return false end
        local full = pathOf(o)
        local name = tostring(o.Name or "")
        return containsAny(name .. " " .. full, MOB_KEYWORDS)
    end)
end

local function promptAncestor(raw)
    local prompt = raw:IsA("ProximityPrompt") and raw or getPrompt(raw)
    if prompt and prompt.Parent then
        local m = bestModelAncestor(prompt.Parent)
        if m then return m end
        return prompt.Parent
    end

    return nearestAncestor(raw, function(o)
        if o == Workspace then return false end
        if o:IsA("Model") then return containsAny(o.Name .. " " .. pathOf(o), PROMPT_KEYWORDS) end
        if o:IsA("Folder") then
            local name = tostring(o.Name or "")
            return (not GENERIC_FOLDERS[name]) and containsAny(name .. " " .. pathOf(o), PROMPT_KEYWORDS)
        end
        return false
    end)
end

local function meaningfulObjectAncestor(raw)
    local mob = mobAncestor(raw)
    if mob then return mob end
    local prompt = promptAncestor(raw)
    if prompt then return prompt end
    local m = bestModelAncestor(raw)
    if m then return m end

    local cur = raw
    local lastGood = raw
    while cur and cur ~= Workspace and cur ~= game do
        if cur:IsA("Folder") and not GENERIC_FOLDERS[tostring(cur.Name or "")] then
            lastGood = cur
            break
        end
        lastGood = cur
        cur = cur.Parent
    end
    return lastGood or raw
end

local function classifyRaw(raw)
    if not validInstance(raw) then return "object", "Object", C_OBJECT end
    if isEventLike(raw) then return "event", raw.ClassName, C_EVENT end

    local full = pathOf(raw)
    local name = tostring(raw.Name or "")
    if mobAncestor(raw) or containsAny(name .. " " .. full, MOB_KEYWORDS) then
        return "mob", "Mob", C_MOB
    end
    if raw:IsA("ProximityPrompt") or getPrompt(raw) or containsAny(name .. " " .. full, PROMPT_KEYWORDS) then
        return "prompt", "Prompt/Task", C_PROMPT
    end
    return "object", "Object", C_OBJECT
end

local function chooseGroupRoot(raw, forcedMode)
    if not validInstance(raw) then return nil end
    if forcedMode == "event" or isEventLike(raw) then return raw end -- Event phải giữ đúng remote để copy/fire.
    local cat = classifyRaw(raw)
    if cat == "mob" then return mobAncestor(raw) or meaningfulObjectAncestor(raw) end
    if cat == "prompt" then return promptAncestor(raw) or meaningfulObjectAncestor(raw) end
    return meaningfulObjectAncestor(raw)
end

local function groupColor(group)
    if group.kind == "mob" then return C_MOB end
    if group.kind == "event" then return C_EVENT end
    if group.kind == "prompt" then return C_PROMPT end
    if group.kind == "log" then return C_LOG end
    return C_OBJECT
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Highlight / teleport / look
-- ══════════════════════════════════════════════════════════════════════════════
local lookOn = false
local lookConn = nil
local lookHighlight = nil
local selectedObject = nil
local selectedPath = nil
local selectedHit = nil

local function highlight(obj, color, permanent)
    if not validInstance(obj) then return nil end
    local adornee = obj:IsA("Model") and obj or rootOf(obj) or obj
    if not validInstance(adornee) then return nil end

    local hl = Instance.new("Highlight")
    hl.Name = "Nevoirs_Workspace_Highlight"
    hl.Adornee = adornee
    hl.FillColor = color or C_ACCENT
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = permanent and 0.62 or 0.48
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = adornee

    if not permanent then
        task.delay(5, function()
            pcall(function() hl:Destroy() end)
        end)
    end
    return hl
end

local function clearLookHighlight()
    if lookHighlight then
        pcall(function() lookHighlight:Destroy() end)
        lookHighlight = nil
    end
end

local function setLookHighlight(obj)
    clearLookHighlight()
    if validInstance(obj) then
        local cat = classifyRaw(obj)
        local color = cat == "mob" and C_MOB or cat == "prompt" and C_PROMPT or C_ACCENT
        lookHighlight = highlight(obj, color, true)
    end
end

local function teleport(obj)
    local hrp, r = getHRP(), rootOf(obj)
    if hrp and r then
        hrp.CFrame = r.CFrame + Vector3.new(0, 3, 0)
        return true
    end
    return false
end

local function getLookObject()
    local cam = Workspace.CurrentCamera
    if not cam then return nil end
    local v = cam.ViewportSize
    local ray = cam:ViewportPointToRay(v.X / 2, v.Y / 2)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.IgnoreWater = true
    local ignore = {}
    local char = getChar()
    if char then table.insert(ignore, char) end
    params.FilterDescendantsInstances = ignore
    local result = Workspace:Raycast(ray.Origin, ray.Direction * 900, params)
    if result and result.Instance then
        local root = chooseGroupRoot(result.Instance) or result.Instance
        return root, result.Instance
    end
    return nil
end

-- ══════════════════════════════════════════════════════════════════════════════
-- WindUI loader/style
-- ══════════════════════════════════════════════════════════════════════════════
local function loadWindUI()
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
        if ok and lib then return lib end
    end
    return nil
end

local function __InstallCompactNotify(ui, fallbackTitle)
    if not ui or ui.__FiHonCompactNotifyInstalled then return end
    ui.__FiHonCompactNotifyInstalled = true

    local function getHolder()
        local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
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
            layout.FillDirection = Enum.FillDirection.Vertical
            layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 4)
            layout.Parent = holder
        end
        holder.Size = UDim2.new(0, UserInputService.TouchEnabled and 206 or 224, 1, -24)
        return holder
    end

    ui.__FiHonOriginalNotify = ui.Notify
    ui.Notify = function(self, payload)
        if payload == nil and typeof(self) == "table" and (self.Title or self.Content or self.Text) then payload = self end
        payload = typeof(payload) == "table" and payload or {Content = tostring(payload or "")}
        local holder = getHolder()
        if not holder then return end
        local touch = UserInputService.TouchEnabled
        local w, h = touch and 206 or 224, touch and 44 or 48
        local card = Instance.new("Frame")
        card.Size = UDim2.fromOffset(w, h)
        card.LayoutOrder = math.floor(os.clock() * 100000)
        card.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = holder
        local co = Instance.new("UICorner"); co.CornerRadius = UDim.new(0, 10); co.Parent = card
        local st = Instance.new("UIStroke"); st.Thickness = 1; st.Transparency = 1; st.Color = C_ACCENT; st.Parent = card
        local icon = Instance.new("ImageLabel")
        icon.BackgroundTransparency = 1
        icon.Position = UDim2.fromOffset(10, touch and 10 or 11)
        icon.Size = UDim2.fromOffset(touch and 22 or 24, touch and 22 or 24)
        icon.ImageTransparency = 1
        icon.Image = NEVOIRS_UI_ICON
        icon.ScaleType = Enum.ScaleType.Crop
        icon.Parent = card
        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Position = UDim2.fromOffset(touch and 39 or 43, 5)
        title.Size = UDim2.new(1, touch and -48 or -54, 0, touch and 15 or 17)
        title.Font = Enum.Font.GothamSemibold
        title.TextSize = touch and 11 or 12
        title.TextColor3 = Color3.fromRGB(245, 247, 255)
        title.TextTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.RichText = true
        title.Text = tostring(payload.Title or fallbackTitle or "Notification")
        title.Parent = card
        local content = Instance.new("TextLabel")
        content.BackgroundTransparency = 1
        content.Position = UDim2.fromOffset(touch and 39 or 43, touch and 22 or 24)
        content.Size = UDim2.new(1, touch and -48 or -54, 0, touch and 17 or 18)
        content.Font = Enum.Font.Gotham
        content.TextSize = touch and 9 or 10
        content.TextColor3 = Color3.fromRGB(215, 222, 235)
        content.TextTransparency = 1
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.TextTruncate = Enum.TextTruncate.AtEnd
        content.Text = tostring(payload.Content or payload.Text or "")
        content.Parent = card
        pcall(function()
            TweenService:Create(card, TweenInfo.new(0.12), {BackgroundTransparency = 0.36}):Play()
            TweenService:Create(st, TweenInfo.new(0.12), {Transparency = 0.50}):Play()
            TweenService:Create(icon, TweenInfo.new(0.12), {ImageTransparency = 0.05}):Play()
            TweenService:Create(title, TweenInfo.new(0.12), {TextTransparency = 0}):Play()
            TweenService:Create(content, TweenInfo.new(0.12), {TextTransparency = 0}):Play()
        end)
        task.delay(2, function()
            if not card or not card.Parent then return end
            pcall(function()
                TweenService:Create(card, TweenInfo.new(0.16), {BackgroundTransparency = 1}):Play()
                TweenService:Create(st, TweenInfo.new(0.16), {Transparency = 1}):Play()
                TweenService:Create(icon, TweenInfo.new(0.16), {ImageTransparency = 1}):Play()
                TweenService:Create(title, TweenInfo.new(0.16), {TextTransparency = 1}):Play()
                TweenService:Create(content, TweenInfo.new(0.16), {TextTransparency = 1}):Play()
            end)
            task.wait(0.18)
            pcall(function() card:Destroy() end)
        end)
    end
end

local WindUI = loadWindUI()
if not WindUI then
    warn("[Nevoirs - Workspace Finder] Không tải được WindUI. Hãy kiểm tra HttpGet/GitHub trong executor.")
    return
end

pcall(function() WindUI:SetTheme("Dark") end)
pcall(function() WindUI.TransparencyValue = 0.12 end)
pcall(function() __InstallCompactNotify(WindUI, "Workspace") end)

local function getWindowSize()
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

local windowSize, minSize, maxSize, sidebarWidth, canResize = getWindowSize()
local DEFAULT_UI_SCALE = UserInputService.TouchEnabled and 0.62 or 0.60
local windowOpen = true

local Window = WindUI:CreateWindow({
    Title = "Nevoirs - Workspace",
    Icon = NEVOIRS_UI_ICON,
    Author = "Workspace Finder",
    Folder = GUI_FOLDER,
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

local MENU_AVATAR_SIZE = UserInputService.TouchEnabled and 56 or 52

local function __isUiChromeAvatar(obj)
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

local function __isMenuIcon(obj)
    if not (obj and (obj:IsA("ImageLabel") or obj:IsA("ImageButton"))) then return false end
    local image = tostring(obj.Image or "")
    return image == tostring(NEVOIRS_UI_ICON) or image:find("106478063464970", 1, true) ~= nil
end

local function styleMenuAvatarImage(obj)
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

local function applyMenuAvatarChrome()
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

pcall(function() Window:SetUIScale(DEFAULT_UI_SCALE) end)

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local MobTab = Window:Tab({ Title = "Mob", Icon = "skull" })
local PromptTab = Window:Tab({ Title = "Prompt", Icon = "mouse-pointer-click" })
local EventTab = Window:Tab({ Title = "Event", Icon = "radio" })
local SettingTab = Window:Tab({ Title = "Setting", Icon = "settings" })

local function safeParagraph(tab, title, desc, icon, color)
    local ok, element = pcall(function()
        return tab:Paragraph({
            Title = title,
            Desc = desc,
            Image = icon or WORKSPACE_DEV_ICON,
            ImageSize = 26,
            Color = color or C_ACCENT,
        })
    end)
    if ok then return element end
    return nil
end

local function safeDivider(tab)
    local ok, element = pcall(function() return tab:Divider() end)
    if ok then return element end
    return nil
end

local function addButton(tab, title, desc, callback)
    local ok, element = pcall(function()
        return tab:Button({
            Title = tostring(title or "Button"),
            Desc = tostring(desc or ""),
            Callback = function()
                task.spawn(function()
                    local okCb, err = pcall(callback)
                    if not okCb then warn("[Workspace Finder] Button lỗi:", title, err) end
                end)
            end,
        })
    end)
    if not ok then warn("[Workspace Finder] Không tạo được button:", title, element) end
    return element
end

local function addToggle(tab, title, desc, value, callback)
    local ok, element = pcall(function()
        return tab:Toggle({
            Title = tostring(title or "Toggle"),
            Desc = tostring(desc or ""),
            Value = value and true or false,
            Callback = function(state)
                local okCb, err = pcall(callback, state and true or false)
                if not okCb then warn("[Workspace Finder] Toggle lỗi:", title, err) end
            end,
        })
    end)
    if not ok then warn("[Workspace Finder] Không tạo được toggle:", title, element) end
    return element
end

local function addInput(tab, title, placeholder, callback)
    local ok, element = pcall(function()
        return tab:Input({
            Title = tostring(title or "Input"),
            Value = "",
            Type = "Input",
            Placeholder = tostring(placeholder or ""),
            Callback = function(value)
                local okCb, err = pcall(callback, tostring(value or ""))
                if not okCb then warn("[Workspace Finder] Input lỗi:", title, err) end
            end,
        })
    end)
    if not ok then warn("[Workspace Finder] Không tạo được input:", title, element) end
    return element
end

local function destroyElement(element)
    if not element then return end
    pcall(function() if element.Destroy then element:Destroy() end end)
    pcall(function() if element.Remove then element:Remove() end end)
    pcall(function() if element.Instance then element.Instance:Destroy() end end)
    pcall(function() if element.Frame then element.Frame:Destroy() end end)
    pcall(function() if element.Container then element.Container:Destroy() end end)
end

local function clearElementList(list)
    for _, element in ipairs(list) do destroyElement(element) end
    table.clear(list)
end

local function smallNotify(title, content)
    pcall(function()
        WindUI:Notify({Title = title, Content = content, Icon = "check", Duration = 2})
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- Custom left circular toggle button
-- ══════════════════════════════════════════════════════════════════════════════
local function toggleWindow()
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

local function createLeftToggle()
    local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "Nevoirs_WorkspaceFinder_Toggle"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999998
    gui.Parent = pg

    local hitSize = UserInputService.TouchEnabled and 46 or 42
    local visualSize = UserInputService.TouchEnabled and 20 or 18 -- tăng lại 2 lần so với bản đã thu nhỏ
    local btn = Instance.new("TextButton")
    btn.Name = "DevToggle"
    btn.AnchorPoint = Vector2.new(0, 0.5)
    -- Dịch toggle lên trên một chút, giữ vùng bấm trong suốt để mobile vẫn dễ chạm.
    btn.Position = UDim2.new(0, 12, 0.5, -10)
    btn.Size = UDim2.fromOffset(hitSize, hitSize)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.Parent = gui

    local mark = Instance.new("TextLabel")
    mark.Name = "Logo"
    mark.AnchorPoint = Vector2.new(0.5, 0.5)
    mark.Position = UDim2.fromScale(0.5, 0.5)
    mark.Size = UDim2.fromOffset(visualSize + 6, visualSize)
    mark.BackgroundTransparency = 1
    mark.Text = "</>"
    mark.Font = Enum.Font.GothamBold
    mark.TextSize = visualSize
    mark.TextColor3 = Color3.fromRGB(245, 248, 255)
    mark.Parent = btn

    local st = Instance.new("UIStroke")
    st.Thickness = 1
    st.Transparency = 0.25
    st.Color = C_ACCENT
    st.Parent = mark

    btn.MouseButton1Click:Connect(toggleWindow)
end

createLeftToggle()

-- ══════════════════════════════════════════════════════════════════════════════
-- Scan/cache/render
-- ══════════════════════════════════════════════════════════════════════════════
local searchText = ""
local scanning = false
local cache = {mob = {}, prompt = {}, event = {}}
local counts = {mob = 0, prompt = 0, event = 0, log = 0}
local rowsByTab = {mainStatic = {}, mainInfo = {}, mob = {}, prompt = {}, event = {}}
local remoteLogs = {}
local remoteLogSet = {}
local remoteLogEnabled = false
local remoteHookInstalled = false
local renderEventPending = false

local function passSearchGroup(group)
    if searchText == "" then return true end
    local blob = tostring(group.name or "") .. " " .. tostring(group.path or "") .. " " .. tostring(group.class or "") .. " " .. tostring(group.kind or "") .. " " .. tostring(group.extra or "")
    return blob:lower():find(searchText, 1, true) ~= nil
end

local function addGroup(kind, root, groupsByKey, raw)
    if not validInstance(root) then return end
    local key = pathOf(root)
    if key == "" or groupsByKey[key] then return end
    groupsByKey[key] = {
        kind = kind,
        root = root,
        name = tostring(root.Name or root.ClassName),
        class = tostring(root.ClassName),
        path = key,
        distance = distanceOf(root),
        extra = raw and tostring(raw.Name or raw.ClassName) or "",
    }
end

local function sortGroups(list)
    table.sort(list, function(a, b)
        local da, db = distanceOf(a.root), distanceOf(b.root)
        a.distance, b.distance = da, db
        if da and db and da ~= db then return da < db end
        if da and not db then return true end
        if db and not da then return false end
        return tostring(a.path) < tostring(b.path)
    end)
end

local function buildScan()
    local mobByKey, promptByKey, eventByKey = {}, {}, {}

    -- Workspace scan: chỉ giữ object lớn Mob/Prompt, không lưu chi tiết part con.
    local desc = Workspace:GetDescendants()
    for i, raw in ipairs(desc) do
        if validInstance(raw) then
            local cat = classifyRaw(raw)
            if cat == "mob" then
                addGroup("mob", chooseGroupRoot(raw), mobByKey, raw)
            elseif cat == "prompt" then
                addGroup("prompt", chooseGroupRoot(raw), promptByKey, raw)
            elseif isEventLike(raw) then
                addGroup("event", raw, eventByKey, raw)
            end
        end
        if i % SCAN_YIELD_STEP == 0 then task.wait() end
    end

    -- Event scan mở rộng: remotes thường nằm ở ReplicatedStorage, không nằm trong workspace.
    local roots = {ReplicatedStorage, ReplicatedFirst, Workspace}
    local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then table.insert(roots, pg) end

    for _, root in ipairs(roots) do
        if validInstance(root) then
            if isEventLike(root) then addGroup("event", root, eventByKey, root) end
            local ok, list = pcall(function() return root:GetDescendants() end)
            if ok and list then
                for i, obj in ipairs(list) do
                    if isEventLike(obj) then
                        addGroup("event", obj, eventByKey, obj)
                    end
                    if i % SCAN_YIELD_STEP == 0 then task.wait() end
                end
            end
        end
    end

    local mobs, prompts, events = {}, {}, {}
    for _, g in pairs(mobByKey) do table.insert(mobs, g) end
    for _, g in pairs(promptByKey) do table.insert(prompts, g) end
    for _, g in pairs(eventByKey) do table.insert(events, g) end
    sortGroups(mobs)
    sortGroups(prompts)
    table.sort(events, function(a, b) return tostring(a.path) < tostring(b.path) end)

    cache.mob, cache.prompt, cache.event = mobs, prompts, events
    counts.mob, counts.prompt, counts.event, counts.log = #mobs, #prompts, #events, #remoteLogs
end

local function selectedDesc()
    if not validInstance(selectedObject) then return "Chưa có object đang chọn/đang nhìn." end
    local dist = distanceOf(selectedObject)
    local cat, label = classifyRaw(selectedObject)
    local hit = validInstance(selectedHit) and ("\nHit: " .. selectedHit.ClassName .. " | " .. pathOf(selectedHit)) or ""
    return ("Loại: %s | Class: %s | Stud: %s\n%s%s"):format(label, selectedObject.ClassName, dist and tostring(dist) or "--", selectedPath or pathOf(selectedObject), hit)
end

local function renderSelectedPanel()
    clearElementList(rowsByTab.mainInfo)
    table.insert(rowsByTab.mainInfo, safeParagraph(MainTab, "Main", ("Mob:%d | Prompt:%d | Event:%d | Log:%d | Search:%s"):format(counts.mob or 0, counts.prompt or 0, counts.event or 0, #remoteLogs, searchText ~= "" and searchText or "--"), "home", C_ACCENT))
    table.insert(rowsByTab.mainInfo, safeDivider(MainTab))
    table.insert(rowsByTab.mainInfo, safeParagraph(MainTab, "Đang chọn / Đang nhìn", selectedDesc(), "crosshair", C_ACCENT))
    table.insert(rowsByTab.mainInfo, addButton(MainTab, "Copy path đang chọn", "Copy nếu path thuộc workspace/game service hợp lệ.", function()
        if selectedPath and selectedPath ~= "" then
            smallNotify("Copy", copyText(selectedPath) and selectedPath or "Executor không hỗ trợ setclipboard")
        else
            smallNotify("Copy", "Chưa có path hợp lệ")
        end
    end))
    table.insert(rowsByTab.mainInfo, addButton(MainTab, "Highlight đang chọn", "Đánh dấu object đang chọn/đang nhìn.", function()
        if selectedObject and validInstance(selectedObject) then
            highlight(selectedObject, C_ACCENT, false)
        else
            smallNotify("Highlight", "Không có object để highlight")
        end
    end))
    table.insert(rowsByTab.mainInfo, addButton(MainTab, "TP tới đang chọn", "Dịch tới root part nếu object có part trong workspace.", function()
        if not (selectedObject and teleport(selectedObject)) then
            smallNotify("TP", "Object không có part để TP")
        end
    end))
end

local function buildMainControls()
    clearElementList(rowsByTab.mainStatic)
    table.insert(rowsByTab.mainStatic, addButton(MainTab, "Refresh", "Quét lại Workspace + ReplicatedStorage. Không auto scan khi load để tránh lag.", function()
        if scanning then
            smallNotify("Workspace", "Đang quét, đợi một chút...")
            return
        end
        task.spawn(function()
            scanning = true
            smallNotify("Workspace", "Đang refresh...")
            buildScan()
            scanning = false
            if renderSelectedPanel then renderSelectedPanel() end
            if _G.__NevoirsWorkspaceRenderMob then _G.__NevoirsWorkspaceRenderMob() end
            if _G.__NevoirsWorkspaceRenderPrompt then _G.__NevoirsWorkspaceRenderPrompt() end
            if _G.__NevoirsWorkspaceRenderEvent then _G.__NevoirsWorkspaceRenderEvent() end
            smallNotify("Workspace", ("Mob:%d | Prompt:%d | Event:%d"):format(counts.mob, counts.prompt, counts.event))
        end)
    end))
    table.insert(rowsByTab.mainStatic, addInput(MainTab, "Search", "Muki / RemoteEvent / Hideo / Reliable ...", function(text)
        searchText = tostring(text or ""):lower()
        if _G.__NevoirsWorkspaceRenderMob then _G.__NevoirsWorkspaceRenderMob() end
        if _G.__NevoirsWorkspaceRenderPrompt then _G.__NevoirsWorkspaceRenderPrompt() end
        if _G.__NevoirsWorkspaceRenderEvent then _G.__NevoirsWorkspaceRenderEvent() end
        renderSelectedPanel()
    end))
    table.insert(rowsByTab.mainStatic, addToggle(MainTab, "Nhìn object", "Raycast từ tâm màn hình, highlight object lớn đang nhìn.", lookOn, function(state)
        lookOn = state and true or false
        if lookConn then lookConn:Disconnect(); lookConn = nil end
        clearLookHighlight()
        if not lookOn then
            smallNotify("Nhìn object", "Đã tắt")
            return
        end
        smallNotify("Nhìn object", "Đã bật")
        local lastRoot = nil
        local acc = 0
        lookConn = RunService.RenderStepped:Connect(function(dt)
            if not lookOn then return end
            acc = acc + dt
            if acc < 0.14 then return end
            acc = 0
            local root, hit = getLookObject()
            if root ~= lastRoot then
                lastRoot = root
                clearLookHighlight()
                if validInstance(root) then
                    selectedObject = root
                    selectedHit = hit
                    selectedPath = pathOf(root)
                    setLookHighlight(root)
                else
                    selectedObject, selectedHit, selectedPath = nil, nil, nil
                end
                renderSelectedPanel()
            end
        end)
    end))
    table.insert(rowsByTab.mainStatic, safeDivider(MainTab))
end

local function fireSnippet(remoteObj, method, argsCode)
    method = method or (remoteObj and remoteObj:IsA("RemoteFunction") and "InvokeServer" or "FireServer")
    argsCode = argsCode or ""
    return ("%s:%s(%s)"):format(luaPathOf(remoteObj), method, argsCode)
end

local function renderObjectRows(tab, rowList, groups, title, mode, limit, append)
    if not append then clearElementList(rowList) end
    local total, shown = 0, 0
    for _, group in ipairs(groups or {}) do
        if passSearchGroup(group) then
            total = total + 1
            if shown < limit then
                shown = shown + 1
                local dist = distanceOf(group.root)
                local path = group.path
                local lineTitle = ("%02d. %s [%s] %s"):format(shown, group.name, group.class or "Object", dist and (dist .. "st") or "")
                local desc = shortPath(path, 9)
                table.insert(rowList, safeParagraph(tab, lineTitle, desc, mode == "mob" and "skull" or mode == "prompt" and "mouse-pointer-click" or "radio", groupColor(group)))

                if mode == "event" then
                    table.insert(rowList, addButton(tab, "Copy path", "Copy đường dẫn remote/event.", function()
                        smallNotify("Copy", copyText(path) and path or "Executor không hỗ trợ setclipboard")
                    end))
                    table.insert(rowList, addButton(tab, "Copy mẫu fire", "Tạo mẫu FireServer/InvokeServer rỗng cho remote này.", function()
                        local snippet = fireSnippet(group.root)
                        smallNotify("Copy fire", copyText(snippet) and shortPath(snippet, 8) or "Executor không hỗ trợ setclipboard")
                    end))
                else
                    table.insert(rowList, addButton(tab, "Highlight", "Đánh dấu object này.", function()
                        highlight(group.root, groupColor(group), false)
                    end))
                    table.insert(rowList, addButton(tab, "TP", "Dịch tới root part của object này.", function()
                        if not teleport(group.root) then smallNotify("TP", "Object không có part để TP") end
                    end))
                    table.insert(rowList, addButton(tab, "Copy path", "Copy path object lớn.", function()
                        smallNotify("Copy", copyText(path) and path or "Executor không hỗ trợ setclipboard")
                    end))
                end
            end
        end
    end
    if append then
        table.insert(rowList, safeParagraph(tab, title, ("Tổng: %d | Hiện: %d | Search: %s"):format(total, shown, searchText ~= "" and searchText or "--"), "list", mode == "mob" and C_MOB or mode == "prompt" and C_PROMPT or C_EVENT))
    else
        table.insert(rowList, 1, safeParagraph(tab, title, ("Tổng: %d | Hiện: %d | Search: %s"):format(total, shown, searchText ~= "" and searchText or "--"), "list", mode == "mob" and C_MOB or mode == "prompt" and C_PROMPT or C_EVENT))
    end
    if total > shown then
        table.insert(rowList, safeParagraph(tab, "Đã giới hạn hiển thị", ("Có %d object, chỉ hiện %d dòng để giảm lag. Dùng Search ở Main để lọc chính xác hơn."):format(total, shown), "info", C_DIM))
    end
end

local function argToCode(v, depth)
    depth = depth or 0
    local t = typeof(v)
    if t == "string" then return string.format("%q", v) end
    if t == "number" or t == "boolean" then return tostring(v) end
    if t == "nil" then return "nil" end
    if t == "Instance" then return luaPathOf(v) end
    if t == "Vector3" then return ("Vector3.new(%s, %s, %s)"):format(tostring(v.X), tostring(v.Y), tostring(v.Z)) end
    if t == "CFrame" then
        local c = v
        return ("CFrame.new(%s, %s, %s)"):format(tostring(c.X), tostring(c.Y), tostring(c.Z))
    end
    if t == "table" then
        if depth > 1 then return "{...}" end
        local out = {}
        local n = 0
        for k, val in pairs(v) do
            n = n + 1
            if n > 6 then table.insert(out, "..."); break end
            local key
            if typeof(k) == "string" and k:match("^[%a_][%w_]*$") then
                key = k
            else
                key = "[" .. argToCode(k, depth + 1) .. "]"
            end
            table.insert(out, key .. " = " .. argToCode(val, depth + 1))
        end
        return "{" .. table.concat(out, ", ") .. "}"
    end
    return tostring(v)
end

local function argsToCode(args)
    local parts = {}
    for i = 1, math.min(#args, 8) do
        table.insert(parts, argToCode(args[i]))
    end
    if #args > 8 then table.insert(parts, "...") end
    return table.concat(parts, ", ")
end

local function addRemoteLog(remoteObj, method, args)
    if not remoteLogEnabled or not isEventLike(remoteObj) then return end
    if method ~= "FireServer" and method ~= "InvokeServer" and method ~= "Fire" and method ~= "Invoke" then return end
    local argsCode = argsToCode(args or {})
    local path = pathOf(remoteObj)
    local sig = path .. "|" .. method .. "|" .. argsCode
    if remoteLogSet[sig] then return end
    remoteLogSet[sig] = true
    table.insert(remoteLogs, 1, {
        obj = remoteObj,
        method = method,
        path = path,
        argsCode = argsCode,
        time = os.clock(),
    })
    while #remoteLogs > MAX_REMOTE_LOGS do
        local old = table.remove(remoteLogs)
        if old then remoteLogSet[old.path .. "|" .. old.method .. "|" .. old.argsCode] = nil end
    end
    counts.log = #remoteLogs
    if not renderEventPending then
        renderEventPending = true
        task.delay(0.28, function()
            renderEventPending = false
            if _G.__NevoirsWorkspaceRenderEvent then _G.__NevoirsWorkspaceRenderEvent() end
            if renderSelectedPanel then renderSelectedPanel() end
        end)
    end
end

local function installRemoteLogger()
    if remoteHookInstalled then return true end
    if not (hookmetamethod and getnamecallmethod and newcclosure) then
        return false
    end
    remoteHookInstalled = true
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if remoteLogEnabled and isEventLike(self) and (method == "FireServer" or method == "InvokeServer" or method == "Fire" or method == "Invoke") then
            local args = {...}
            task.defer(function()
                pcall(addRemoteLog, self, method, args)
            end)
        end
        return oldNamecall(self, ...)
    end))
    return true
end

local function renderEventTab()
    clearElementList(rowsByTab.event)
    table.insert(rowsByTab.event, safeParagraph(EventTab, "Event / Remote", ("Remote scan: %d | Log: %d | Logger: %s"):format(#cache.event, #remoteLogs, remoteLogEnabled and "ON" or "OFF"), "radio", C_EVENT))
    table.insert(rowsByTab.event, addToggle(EventTab, "Log Remote khi tương tác", "Bật rồi thao tác minigame. Script sẽ bắt FireServer/InvokeServer + args để copy mẫu fire.", remoteLogEnabled, function(state)
        if state then
            local ok = installRemoteLogger()
            remoteLogEnabled = ok
            smallNotify("Remote Logger", ok and "Đã bật. Hãy bấm/tương tác minigame." or "Executor không hỗ trợ hookmetamethod")
        else
            remoteLogEnabled = false
            smallNotify("Remote Logger", "Đã tắt log")
        end
        renderEventTab()
    end))
    table.insert(rowsByTab.event, addButton(EventTab, "Xóa log", "Xóa các remote đã bắt được.", function()
        table.clear(remoteLogs)
        table.clear(remoteLogSet)
        counts.log = 0
        renderEventTab()
        renderSelectedPanel()
    end))
    table.insert(rowsByTab.event, safeDivider(EventTab))

    local logShown = 0
    for _, log in ipairs(remoteLogs) do
        if logShown >= MAX_REMOTE_LOGS then break end
        local blob = (log.path .. " " .. log.method .. " " .. log.argsCode):lower()
        if searchText == "" or blob:find(searchText, 1, true) then
            logShown = logShown + 1
            local snippet = fireSnippet(log.obj, log.method, log.argsCode)
            table.insert(rowsByTab.event, safeParagraph(EventTab, ("LOG %02d. %s"):format(logShown, log.method), shortPath(log.path, 8) .. "\nArgs: " .. (log.argsCode ~= "" and log.argsCode or "--"), "radio", C_LOG))
            table.insert(rowsByTab.event, addButton(EventTab, "Copy mẫu log", "Copy lại đầy đủ remote + args vừa bắt được.", function()
                smallNotify("Copy log", copyText(snippet) and shortPath(snippet, 8) or "Executor không hỗ trợ setclipboard")
            end))
        end
    end

    if #remoteLogs > 0 then table.insert(rowsByTab.event, safeDivider(EventTab)) end
    renderObjectRows(EventTab, rowsByTab.event, cache.event, "Remote/Event đã quét", "event", MAX_EVENT_ROWS, true)
end

_G.__NevoirsWorkspaceRenderMob = function()
    renderObjectRows(MobTab, rowsByTab.mob, cache.mob, "Mob", "mob", MAX_ROWS_PER_TAB)
end

_G.__NevoirsWorkspaceRenderPrompt = function()
    renderObjectRows(PromptTab, rowsByTab.prompt, cache.prompt, "Prompt / Task", "prompt", MAX_ROWS_PER_TAB)
end

_G.__NevoirsWorkspaceRenderEvent = renderEventTab

-- ══════════════════════════════════════════════════════════════════════════════
-- Static controls
-- ══════════════════════════════════════════════════════════════════════════════
safeParagraph(SettingTab, "UI Scale", "Giữ style giống Nevoirs. Scale mặc định thấp để gọn trên mobile.", "settings")
addInput(SettingTab, "UI Scale", tostring(DEFAULT_UI_SCALE), function(text)
    local n = tonumber((tostring(text or ""):gsub(",", ".")))
    if n then
        pcall(function() Window:SetUIScale(math.clamp(n, 0.50, 1.00)) end)
    end
end)

-- Render rỗng ban đầu, không auto refresh để tránh lag lúc execute.
buildMainControls()
renderSelectedPanel()
_G.__NevoirsWorkspaceRenderMob()
_G.__NevoirsWorkspaceRenderPrompt()
_G.__NevoirsWorkspaceRenderEvent()

pcall(function()
    WindUI:Notify({Title = "Nevoirs - Workspace", Content = "Đã tải. Nhấn Refresh ở Main để quét.", Icon = "check", Duration = 2})
end)

pcall(function() MainTab:Select() end)

print("[Nevoirs - Workspace Finder Pro] Loaded - Event logger + low-lag refresh")
