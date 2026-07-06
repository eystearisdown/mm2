local GG=GG; if not GG then return game:GetService("Players").LocalPlayer:Kick("[TTJY Studio] : Really? Your account is now at risk for the next ban wave."); end;

local QUEUE_INFO = GG.QUEUE_INFO or {};
local ScriptCache = GG.ScriptCache;
local LoaderSettings = GG.LoaderSettings;
local userIdentify = ScriptCache.userIdentify;
local Instancen = Instance.new;
local Vec3 = Vector3.new;
local Col3 = Color3;
local tble = table;
local math = math;
local str = string;
local CF = CFrame;
local tk = task;
local W = GG.W;
local H = GG.H;
local R = GG.R;

local PlaceId = game.PlaceId;

local IsA = game.IsA;
local twait = tk.wait;
local CFr = CFrame.new;
local GetPivot = W.GetPivot;
local GetChildren = game.GetChildren;
local GetAttribute = game.GetAttribute;
local WaitForChild = game.WaitForChild;
local GetDescendants = game.GetDescendants;
local FindFirstChild = game.FindFirstChild;
local TTeleport = GG.TeleportService.Teleport;
local FindFirstChildOfClass = game.FindFirstChildOfClass;
local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA;
local FindFirstAncestorWhichIsA = game.FindFirstAncestorWhichIsA;

local CAMERAREPLICA = nil;

local SAFESPOT = CFr(-176.64, 4.8, -328.34);

local RED = Col3.new(255,0,0);
local GREEN = Col3.new(0, 255, 0);
local YELLOW = Col3.new(255, 255, 0);

local VEC343 = Vec3(3,4,3);
local VEC10 = Vec3(10,10,10);
local VEC2 = Vec3(2,2,2);
local VEC1 = Vec3(1,1,1);

local DIM0010 = UDim2.new(0,0,1,0);

local ScriptData = {
    AutoData = {};
    Sections = {
        B1C1 = {
            [1] = { i = "Map1", dat = {
                [1] = { i = "Spawn", C = CFr(269.3022155761719, 3, -1.3705496788024902) };
                [2] = { i = "Jigoku", C = CFr(316.1304626464844, 3.2333202362060547, 316.0523681640625) };
                [3] = { i = "Key 1", C = CFr(670.4268798828125, 3.049999713897705, 484.9584655761719) };
                [4] = { i = "Key 2", C = CFr(860.452880859375, 3.1949996948242188, 219.03762817382812) };
                [5] = { i = "Entrance Maze", C = CFr(3164.7529296875, 37.40338134765625, -1586.5648193359375) };
                [6] = { i = "Key 3", C = CFr(3317.523681640625, 37.64610290527344, -1764.0106201171875) };
                [7] = { i = "Exit Maze", C = CFr(3416.580322265625, 37.646121978759766, -1538.938720703125) };
            }};
            [2] = { i = "Map2", dat = {
                [1] = { i = "Spawn", C = CFr(284.4999084472656, 73.06249237060547, 101.47504425048828) };
                [2] = { i = "Cave House", C = CFr(32.434173583984375, 94.35484313964844, -1233.511962890625) };
                [3] = { i = "Entrance Main House", C = CFr(-112.36238861083984, 91.99998474121094, -2021.73974609375) };
                [4] = { i = "Spawn Hotel", C = CFr(-268.7034606933594, 91.63571166992188, -3243.083251953125) };
                [5] = { i = "Spawn Hotel 2nd Floor", C = CFr(-248.93421936035156, 128.62155151367188, -2547.898193359375) };
                [6] = { i = "Spawn Hotel 3rd Floor", C = CFr(237.497314453125, 199.52268981933594, -2568.7646484375) };
                [7] = { i = "Exit Hotel", C = CFr(1274.949951171875, 199.5399932861328, -2537.929931640625) };
                [8] = { i = "Spawn Outside Hotel", C = CFr(2139.439453125, 257.1267395019531, -2504.615966796875) };
                [9] = { i = "Chapter 2 Entrance Gate", C = CFr(2138.8232421875, 257.12353515625, -2742.88427734375) };
            }};
        };
        B1C2 = {
            [1] = { i = "Map1", dat = {
                [1] = { i = "Spawn", C = CFr(31.30192756652832, 14.765870094299316, -50.99848937988281) };
                [2] = { i = "Key 1", C = CFr(146.7581329345703, 26.52265739440918, -429.7537841796875) };
                [3] = { i = "Lever Room", C = CFr(136.9575653076172, 14.773530006408691, -340.3115234375) };
                [4] = { i = "Exit Hallway", C = CFr(196.88290405273438, 26.39544677734375, -703.8648071289062) };
                [5] = { i = "Exit Samurai", C = CFr(234.37767028808594, 51.09593200683594, -1297.229736328125) };
                [6] = { i = "Butterfly 1", C = CFr(234.37767028808594, 51.09593200683594, -1297.229736328125) };
                [7] = { i = "Butterfly 2", C = CFr(220.61093139648438, 52.18296813964844, -1644.1612548828125) };
            }};
            [2] = { i = "Map2", dat = {
                [1] = { i = "Spawn", C = CFr(400.1822814941406, -47.07728958129883, 909.1865234375) };
                [2] = { i = "Butterfly Outside", C = CFr(431.97601318359375, 60.81093215942383, 380.8719787597656) };
                [3] = { i = "Key", C = CFr(161.5194091796875, 101.88359069824219, -562.4013671875) };
                [4] = { i = "Butterfly Inside", C = CFr(258.27105712890625, 94.61199188232422, -848.0752563476562) };
                [5] = { i = "Exit Door", C = CFr(235.35060119628906, 101.9432373046875, -551.535888671875) };
            }};
            [3] = { i = "Map3", dat = {
                [1] = { i = "Spawn", C = CFr(-96.32198333740234, 75.3413314819336, -22.335594177246094) };
                [2] = { i = "Butterfly", C = CFr(671.8909912109375, 78.17596435546875, -115.32154083251953) };
                [3] = { i = "Exit", C = CFr(827.9335327148438, 75.3413314819336, -352.0482482910156) };
            }};
        };
        B1C3 = {
            [1] = { i = "Map1", dat = {
                [1] = { i = "Spawn", C = CFr(1112.6671142578125, 83.19374084472656, -359.1717834472656) };
                [2] = { i = "Cave Spawn", C = CFr(1899.2449951171875, 4.8473639488220215, 281.3607177734375) };
                [3] = { i = "Kaito Entrance", C = CFr(2047.682861328125, -0.4862976670265198, 561.9852294921875) };
                [4] = { i = "Kaito Exit", C = CFr(2314.2900390625, 5.150242328643799, 818.3004760742188) };
                [5] = { i = "Hand Entrance", C = CFr(2408.81396484375, -23.031116485595703, 1459.683837890625) };
                [6] = { i = "Hand Exit", C = CFr(2413.467529296875, -23.03111457824707, 1816.749267578125) };
            }};
            [2] = { i = "Map2", dat = {
                [1] = { i = "Spawn", C = CFr(39.31187057495117, 36.4764518737793, 84.27843475341797) };
                [2] = { i = "Blade", C = CFr(79.64765930175781, 36.359718322753906, 87.4922866821289) };
                [3] = { i = "Butterfly", C = CFr(128.96363830566406, 36.35921859741211, 98.9471435546875) };
                [4] = { i = "Rose", C = CFr(322.61297607421875, 37.51033401489258, 78.7746810913086) };
                [5] = { i = "Bell Safe Spot", C = CFr(210.59703063964844, 31.717370986938477, 407.951416015625) };
            }};
        };
    };
    B1C4M3ItemPos = {
        CFr(665.63, 18.17, 2108.62),
        CFr(620.22, 17.87, 2340.73),
        CFr(756.75, 40, 2538.24),
        CFr(756.75, 16.39, 2538.24),
        CFr(860.18, 24.85, 2548.28),
        CFr(855.96, 15.47, 2388.36),
        CFr(836.29, 19.01, 2247.34)
    };
    SamaHeartPos = {
        ["32"] = CFr(3209, 132, 2193),
        ["25"] = CFr(2589, 132, 2408),
        ["28"] = CFr(2802, 115, 2418)
    };
    SamaHeartCam = {
        ["32"] = CFr(3209.01807, 133.388229, 2192.93799, 0.959981084, -0.139965221, -0.242582455, 0.00294077187, 0.871154189, -0.491000861, 0.280049741, 0.470638156, 0.836703002),
        ["25"] = CFr(2589.01733, 133.500214, 2408.00513, -0.252294064, -0.260695487, -0.93187207, -0.00756763248, 0.963527501, -0.267502367, 0.967621028, -0.060437195, -0.245065123),
        ["28"] = CFr(2802.03345, 116.452713, 2417.99463, 0.152567074, -0.359060764, -0.920759797, 0.00740486849, 0.932055831, -0.362238824, 0.988265336, 0.0484476127, 0.144859836)
    };
};

GG.Configs = GG.Configs or {
    ["Yen"] = {};
    ["B1C1"] = {["ESP"]={}};
    ["B1C2"] = {["ESP"]={}};
    ["B1C3"] = {["ESP"]={}};
    ["B1C4"] = {["ESP"]={}};
    ["B2C2"] = {["ESP"]={}};
    ["B2C3"] = {["ESP"]={}};
    ["B2C4"] = {["ESP"]={}};
    ["B3C1"] = {["ESP"]={}};
    ["CT"] = {["ESP"]={}};
    ["NightmareCircus"] = {
        ["Jukebox"] = {["ESP"]={}};
        ["Ringmaster"] = {};  
    };
    ["Emote"] = {["Select Emote"]="None"};
    ["Client"] = {
        ["Client"] = {
            ["FlySpeed"] = 1,
        };
    },
};

local Storing_AUTHENTICATION, PremiumCheck = nil, false;
local encrypt = function(text, key)
    local encryptedText = ""; for i = 1, #text do
        local char = str.byte(text, i);
        local encryptedChar = (char + key) % 256;
        encryptedText = encryptedText .. str.char(encryptedChar);
    end; return encryptedText;
end;
local decrypt = function(encryptedText ,key)
	local decryptedText = ""; for i = 1, #encryptedText do
		local char = str.byte(encryptedText, i);
		local decryptedChar = (char - key) % 256;
		if decryptedChar < 0 then
			decryptedChar = decryptedChar + 256;
		end; decryptedText = decryptedText .. str.char(decryptedChar);
	end; return decryptedText;
end;

return {
    Version = "TheMimicV3.A8";
    Function = function(CorePackage, WindLib, IntroLib, Windy, ClientPackage, PromptPackage, CoruTask, ESPF, CommonF, TheMimicPaints, QueuePack)
        local CoreConnection    = {};
        local CoreDestroyed     = false;
        local ForceFloat        = "None";
        local WindUI            = nil;

        local Cam               = GG.W.CurrentCamera;
        local selff             = GG.P.LocalPlayer;
        local Backpack          = selff.Backpack;
        local PSG               = selff.PlayerGui;
        local selc              = selff.Character or selff.CharacterAdded:Wait();
        local HumSelf           = FindFirstChildOfClass(selc, "Humanoid");
        local HumRSelf          = HumSelf.RootPart;

        local cmdm              = selff:GetMouse();
        local YenCon            = GG.Configs.Yen;
        local B1C4Con           = GG.Configs.B1C4;
        local B2C2Con           = GG.Configs.B2C2;
        local B2C3Con           = GG.Configs.B2C3;
        local B2C4Con           = GG.Configs.B2C4;
        local NMCSCon           = GG.Configs.NightmareCircus;
        local ClientCon         = GG.Configs.Client.Client;
        local Control           = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0};

        local GameAI            = FindFirstChild(W, "GameAI");
        local GameAI2           = FindFirstChild(W, "GameAI2");
        local GrabbedUI         = FindFirstChild(PSG, "QuickTime");

        local CTQuests          = nil;

        local dist              = CommonF.dist;

        local Paints            = TheMimicPaints.Init();
        local ArgsCraft         = {[1] = 0;[2] = {["__args"] = {};["__tree"] = {[1] = "CraftingService";[2] = "Interact"};["__callType"] = 0}};
        
        local Functions = {
            AnsweredMother = {
                ["cult name?"] = "Kiiroibara Cult";
                ["I bloom"] = "Cherry Blossom";
                ["Four I shaped in shadows dire—"] = "Evil God";
                ["pink"] = " Hiachi Masashige";
                ["quietly"] = "Torii Gate";
                ["pathetic"] = "Me";
                ["in ink"] = "A brush";
                ["Flames"] = "Enzukai";
                ["guard"] = "A komainu";
            };
        };

        Functions.KeyDown = IB_NO_VIRTUALIZE(function(key)
            if not ClientCon["Enable Fly"] then return; end;
            if key == "w" then Control.F =  1 * ClientCon.FlySpeed; end;
            if key == "d" then Control.R =  1 * ClientCon.FlySpeed; end;
            if key == "s" then Control.B = -1 * ClientCon.FlySpeed; end;
            if key == "a" then Control.L = -1 * ClientCon.FlySpeed; end;
        end);
        Functions.KeyUp = IB_NO_VIRTUALIZE(function(key)
            if not ClientCon["Enable Fly"] then return; end;
            if key == "w" then Control.F = 0; end;
            if key == "s" then Control.B = 0; end;
            if key == "a" then Control.L = 0; end;
            if key == "d" then Control.R = 0; end;
        end);

        Functions.PairingSections = function(tab, data, p)
            local sectionDats = {}; for _, mapEntry in ipairs(data) do
                local btns = {}; 
                if mapEntry.dat then
                    for _, btn in ipairs(mapEntry.dat) do
                        tble.insert(btns, {
                            type = btn.type or "Button";
                            EN = btn.Title or btn.i;
                            Callback = function()
                                return CommonF.Tp(HumRSelf, btn.C);
                            end;
                        });
                    end;
                end; tble.insert(sectionDats, {
                    dat = btns,
                    Title = mapEntry.Title or mapEntry.i,
                });
            end; tab:Divider(); tab:Space();
            Windy:CreateComponent(tab, {{type="Group", dats={{
                dat = {{
                    type = "Group",
                    dats = sectionDats
                }, { type = "Space" }
                }, Title = "Sections"
            }}}}, p);
        end;
        Functions.GiveLantern = function()
            for _,v in pairs(GetChildren(R.Inventory.SkinsInfo)) do
                v.Parent = Backpack;
            end;
        end;
        Functions.YenFunc = function(MimicCurrencySpawns)
            local Yens = GetChildren(MimicCurrencySpawns.Yen);
            for i=1, #Yens do
                local yen = Yens[i]; if yen then
                    if YenCon.Aura then
                        local Prompt = FindFirstChildWhichIsA(yen, "ProximityPrompt");
                        if dist(yen.Position) <= 10 then
                            fireproximityprompt(Prompt, 1, true);
                        end;
                    end;
                    
                    if YenCon.ESP then
                        if not FindFirstChild(yen, "BoxHandleAdornment") then
                            ESPF.ESP("Yen", yen, YELLOW, VEC2, nil, nil, false, false);
                        end;
                    end;
                end;
            end;
        end;
        Functions.PlayEmote = function()
            local Animator = HumSelf and FindFirstChildOfClass(HumSelf,"Animator");
            if not Animator then return; end; local Anim = Instancen("Animation");
            Anim.AnimationId = TheMimicPaints.Emotes[Configs.Emote["Select Emote"]];
            Animator:LoadAnimation(Anim):Play();
        end;
        Functions.StopEmote = function()
            if not HumSelf then return; end; for _, track in pairs(HumSelf:GetPlayingAnimationTracks()) do
                track:Stop();
            end;
        end;
        Functions.isNeedHelp = function()
            return if not GrabbedUI then false else GrabbedUI.Visible;
        end;
        Functions.FreeYourself = function(self)
            if self.isNeedHelp() then
                return CommonF:CKey(Enum.KeyCode.E, 0.03);
            end;
        end;
        Functions.AutoCompleteBook1 = function()
            if PlaceId == 6296321810 or PlaceId == 6479231833 then
                return CommonF.Tp(HumRSelf, CFr(3507, 37.65, -1539.45));
            elseif PlaceId == 6301638949 or PlaceId == 6480994221 then
                return CommonF.Tp(HumRSelf, CFr(1274.95, 199.54, -2537.93));
            end;
            if PlaceId == 6373539583 or PlaceId == 6485055338 then
                return CommonF.Tp(HumRSelf, CFr(64.88, 55.28, -1590));
            elseif PlaceId == 6406571212 or PlaceId == 6485055836 then
                return CommonF.Tp(HumRSelf, CFr(235.17, 101.94, -590));
            elseif PlaceId == 6425178683 or PlaceId == 6485056556 then
                return CommonF.Tp(HumRSelf, CFr(829.97, 72.49, -353.46));
            end;
            if PlaceId == 6472459099 or PlaceId == 6688734180 then
                return CommonF.Tp(HumRSelf, CFr(2411.93, -23.03, 2300));
            elseif  PlaceId == 6682163754 or PlaceId == 6688734313 then
                return CommonF.Tp(HumRSelf, CFr(245.69, 31.72, 450));
            elseif  PlaceId == 6682164423 or PlaceId == 6688734395 then
                return CommonF.Tp(HumRSelf, CFr(-651, 648.99, -1014.35), 5), CommonF.Tp(HumRSelf, CFr(-644.07, 947.82, -1490));
            end;
        end;
        Functions.B1C4AutoComplete = function()
            if PlaceId == 7251865082 or PlaceId == 7265396387 then
                return CommonF.Tp(HumRSelf, CFr(91, -48.35, -1416.24), nil);
            elseif PlaceId == 7251866503 or PlaceId == 7265396805 then
                for i, v in pairs(GetChildren(W.Butterflies)) do
                    if v.Name == "Butterfly" then
                        CommonF.Tp(HumRSelf, CFr(v.Position.X, v.Position.Y, v.Position.Z), 0.3);
                        fireproximityprompt(v.ProximityPrompt, 1);
                    end;
                end; return;
            elseif PlaceId == 7251867155 or PlaceId == 7265397072 then
                for i,v in ipairs(ScriptData.B1C4M3ItemPos) do
                    if i == 3 then CommonF.Tp(HumRSelf, v, 0.3); else
                        CommonF.Tp(HumRSelf, v, 0.3);
                        for i, v in pairs(GetChildren(W.GameInfo.PuzzleItems)) do
                            local prompt = IsA(v, "BasePart") and FindFirstChildWhichIsA(v, "ProximityPrompt");
                            if prompt then
                                fireproximityprompt(prompt, 1);
                            end;
                        end;
                    end;
                end; CommonF.Tp(HumRSelf, CFr(688.41, 28.37, 2251.57), 0.3);
                for i, v in pairs(GetChildren(W)) do
                    if IsA(v, "Model") and v.Name == "Well" then
                        fireproximityprompt(v.Burner.ProximityPrompt, 1, true);
                        fireproximityprompt(v.Burner.ProximityPrompt, 1, true);
                        fireproximityprompt(v.Burner.ProximityPrompt, 1, true);
                        fireproximityprompt(v.Burner.ProximityPrompt, 1, true);
                        fireproximityprompt(v.Burner.ProximityPrompt, 1, true);
                        fireproximityprompt(v.Burner.ProximityPrompt, 1, true);
                    end;
                end;
            end; return;
        end;
        Functions.ESPMonsterBook1 = function(state)
            if state then
                if GameAI then
                    for _,v in pairs(GetChildren(GameAI)) do
                        ESPF.ESP("Monster", v.HumanoidRootPart, RED, VEC10, nil, nil, false, false);
                    end;
                end; if GameAI2 then
                    for _,v in pairs(GetChildren(GameAI2)) do
                        if not IsA(v, "Model") then continue; end;
                        ESPF.ESP("Monster", v.HumanoidRootPart, RED, VEC10, nil, nil, false, false);
                    end;
                end; return;
            end; ESPF.Destroy("Monster");
        end;
        Functions.ESPItemBook1 = function(state)
            if state then
                if PlaceId == 6373539583 or PlaceId == 6485055338 or PlaceId == 6406571212 or PlaceId == 6485055836 or PlaceId == 6425178683 or PlaceId == 6485056556 then
                    for _, v in pairs(GetChildren(W)) do
                        if (v.Name == "Key1" or v.Name == "Butterfly") and FindFirstChild(v, "ProxPart") and FindFirstChild(v, "butterfly") then
                            ESPF.ESP("Item", v.ProxPart, GREEN, VEC2, nil, nil, false, false);
                        end;
                    end; return;
                elseif PlaceId == 6472459099 or PlaceId == 6688734180 then
                    for _, v in pir(GetChildren(W)) do
                        if (v.Name == "Blade" or v.Name == "Butterfly") and FindFirstChild(v, "ProxPart") and FindFirstChild(v, "butterfly") then
                            ESPF.ESP("Item", v, GREEN, VEC2, nil, nil, false, false);
                        end;
                    end; return;
                elseif PlaceId == 6682163754 or PlaceId == 6688734313 then
                    for _, v in pir(GetDescendants(W)) do
                        if v.Parent.Name == "Givers" or v.Name == "Rose" or v.Parent.Name == "BellFolder" or v.Name == "Key" or v.Name == "Key1" then
                            ESPF.ESP("Item", v.ProxPart, GREEN, VEC2, nil, nil, false, false);
                        end;
                    end; return;
                elseif PlaceId == 6682164423 or PlaceId == 6688734395 then
                    for _, v in pir(GetChildren(W)) do
                        if v.Name == "Key1" or v.Name == "CodeDoor" then
                            ESPF.ESP("Item", v.ProxPart, GREEN, VEC2, nil, nil, false, false);
                        end;
                    end; return;
                elseif PlaceId == 7251865082 or PlaceId == 7265396387 then
                    for _,Model in pairs(GetChildren(W)) do
                        if Model.ClassName == "Model" then
                            local Mol2 = FindFirstChild(Model, "Model"); if not Mol2 then
                                local ProxPart = FindFirstChild(Model, "ProxPart");
                                if ProxPart then
                                    local _, Bill = ESPF.ESP("Item", ProxPart, GREEN, VEC2, nil, nil, false, false);
                                    local Prompt = FindFirstChild(ProxPart, "ProximityPrompt");
                                    Bill.TextLabel.Text = Prompt and Prompt.ObjectText or "Item";
                                end; continue;
                            end;
                            local ProxPart = FindFirstChild(Mol2, "ProxPart", true);
                            if ProxPart then
                                local _, Bill = ESPF.ESP("Item", ProxPart, GREEN, VEC2, nil, nil, false, false);
                                local Prompt = FindFirstChild(ProxPart, "ProximityPrompt");
                                Bill.TextLabel.Text = Prompt and Prompt.ObjectText or "Item";
                            end;
                        end;
                    end; return;
                elseif PlaceId == 7251866503 or PlaceId == 7265396805 then
                    for _,v in pairs(GetChildren(W.Butterflies)) do
                        ESPF.ESP("Item", v, GREEN, VEC2, nil, nil, false, false);
                    end; return;
                elseif PlaceId == 7251867155 or PlaceId == 7265397072 then
                    for _,v in pairs(GetChildren(W.GameInfo.PuzzleItems)) do
                        ESPF.ESP("Item", v, GREEN, VEC2, nil, nil, false, false);
                    end; return;
                elseif PlaceId == 7251867574 or PlaceId == 7265397848 then
                    for _,v in pairs(GetChildren(W.GameHearts)) do
                        ESPF.ESP("Item", v, GREEN, VEC2, nil, nil, false, false);
                    end; return;
                end;
            end; ESPF.Destroy("Item");
        end;
        Functions.B2C1Func = function(self, where)
            self.B2C1_Cahce = self.B2C1_Cahce or {};
            if where == "City/Complete" then
                return CommonF.Tp(HumRSelf, CFr(-1783, 11, -4297));
            elseif where == "Rat/Read" then
                if self.ReadBook then return; end; self.ReadBook = true;
                for _, v in pairs(GetDescendants(W)) do
                    if IsA(v, "ProximityPrompt") and v.Parent.Name == "Interact" and v.Parent.Parent.Name == "Book" then
                        return CommonF.Tp(HumRSelf, CFr(v.Parent.Position.X, v.Parent.Position.Y + 5, v.Parent.Position.Z), 0.3), fireproximityprompt(v, 1);
                    end;
                end;
            elseif where == "Rat/Auto" then
                local RatDescendants = (self.B2C1_Cahce.RatF and GetDescendants(self.B2C1_Cahce.RatF)) or {};
                local WellChildren = (self.B2C1_Cahce.Well and GetChildren(self.B2C1_Cahce.Well)) or {};
                local BellChildren = (self.B2C1_Cahce.Bell and GetChildren(self.B2C1_Cahce.Bell)) or {};
                if #BellChildren == 0 then local AllDescendants = GetDescendants(W);
                    RatDescendants, WellChildren, BellChildren = AllDescendants, AllDescendants, AllDescendants;
                end; local ratPrompt = CommonF.findPrompt(RatDescendants, function(v)
                    return v.Parent.Name == "Cube"
                    and v.Parent.MeshId == "https://assetdelivery.roblox.com/v1/asset/?id=8569135676";
                end); if ratPrompt then
                    self.B2C1_Cahce.RatF = ratPrompt.Parent.Parent.Parent;
                    CommonF.Tp(HumRSelf, ratPrompt.Parent.CFrame, 0.3);
                    fireproximityprompt(ratPrompt, 1);
                end; local wellPrompt = CommonF.findPrompt(WellChildren, function(v)
                    return v.ObjectText == "Old Well";
                end); if wellPrompt then
                    self.B2C1_Cahce.Well = wellPrompt.Parent;
                    CommonF.Tp(HumRSelf, wellPrompt.Parent.CFrame, 0.3);
                    fireproximityprompt(wellPrompt, 1);
                end; WindUI:Notify({
                    Title = "<font color='rgb(255,0,0)'>ALERT</font>",
                    Content = "Wait...",
                    Icon = "circle-alert",
                    Duration = 5,
                }); twait(5); local bellPrompt = CommonF.findPrompt(BellChildren, function(v)
                    return v.ObjectText == "Bell";
                end); if bellPrompt then
                    self.B2C1_Cahce.Bell = bellPrompt.Parent;
                    CommonF.Tp(HumRSelf, bellPrompt.Parent.CFrame, 0.3);
                    fireproximityprompt(bellPrompt, 1);
                end; return WindUI:Notify({
                    Title = "<font color='rgb(255,0,0)'>ALERT</font>",
                    Content = "Press again to do another rat",
                    Icon = "circle-alert",
                    Duration = 5,
                });
            elseif where == "Rat/Exit" then
                local Target = CommonF.findPrompt(GetDescendants(W), function(v)
                    return v.ActionText == "Exit";
                end); if Target then
                    return CommonF.Tp(HumRSelf, Target.Parent.CFrame, 0.3), fireproximityprompt(Target, 1);
                end;
            elseif where == "Rat/Run" then
                return CommonF.Tween({primary = HumRSelf; goal = { CFrame = CFr(-960.842529, -44.0736237, -3597.06372) }});
            elseif where == "Nagisa/Auto" then
                ForceFloat = true; CommonF.Tween({ primary = HumRSelf; goal = { CFrame = CFr(208.665894, 573.239563, -345.685211) } });
                twait(3); CommonF.Tween({ primary = HumRSelf; goal = { CFrame = CFr(595.243896, 582.230713, -344.577911) } });
                ForceFloat = "None"; return;
            elseif where == "Nagisa/Run" then
                ForceFloat = true; CommonF.Tween({ primary = HumRSelf; goal = { CFrame = CFr(3868.31982, 153.007477, 17.1698914) } });
                ForceFloat = "None"; return;
            elseif where == "Vil/Zone" then
                return CommonF.Tween({primary = HumRSelf; goal = { CFrame = CFr(4590.5249, 507.557373, 4480.6499) }});
            elseif where == "Vil/Talk" then
                return CommonF.Tp(HumRSelf, CFr(-326.344421, 23.1051254, 3662.32056));
            elseif where == "Vil/Key" then
                CommonF.Tp(HumRSelf, CFr(-401.797424, 3070.25, 3864.77979), 1);
                local Prompt = CommonF.findPrompt(GetDescendants(W), function(v)
                    return IsA(v, "ProximityPrompt") and v.ActionText == "Obtain" and v.Parent.Name == "Key1";
                end); if Prompt then
                    return CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3), fireproximityprompt(Prompt, 1);
                end; return;
            elseif where == "Vil/Paint" then
                return CommonF.Tp(HumRSelf, CFr(-249.45462, 3067.58838, 4218.84766));
            elseif where == "Vil/Pics" then
                local Descen, AlreadySpecial = GetDescendants(W), false;
                self.pic4 = {}; local coords, HitpicParent = {
                    {-267.697571, 3070.85718, 4213.41504},
                    {590.236572, 3070.94922, 4420.93457},
                    {-675.159424, 3071.0813, 4998.77686},
                    {-392.277039, 3071.03931, 3888.39697},
                    {-10.6637068, 3070.17041, 4711.52637}
                }, nil; CommonF.Tp(HumRSelf, CFr(-267.697571, 3070.85718, 4213.41504), 2);
                for _, v in pairs(Descen) do
                    if v.Name == "specialpic" and FindFirstChild(v, "Image") then
                        HitpicParent = v.Parent;
                        tble.insert(self.pic4, v.Image.Decal.Texture);
                    end;
                end; for _, pos in ipairs(coords) do
                    CommonF.Tp(HumRSelf, CFr(pos[1], pos[2], pos[3]), 2);
                    for _, v in pairs(GetChildren(HitpicParent)) do
                        if v.Name == "hintpic" and FindFirstChild(v, "Image") then
                            tble.insert(self.pic4, v.Image.Decal.Texture);
                        elseif v.Name == "specialpic" and FindFirstChild(v, "Image") and not AlreadySpecial then
                            AlreadySpecial = true;
                            tble.insert(self.pic4, v.Image.Decal.Texture);
                        end;
                    end;
                end; return;
            elseif where == "Vil/Room" then
                local Prompt = CommonF.findPrompt(GetDescendants(W), function(v)
                    return IsA(v, "ProximityPrompt") and v.Parent.Name == "Teleporter" and v.ActionText == "Enter" and v.Parent.Parent.Name == "Enter" and v.Parent.Parent.Parent.Name == "MainHouse";
                end); if Prompt then
                    return CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3), fireproximityprompt(Prompt, 1), twait(0.3), fireproximityprompt(Prompt, 1);
                end; return;
            elseif where == "Vil/Candles" then
                local Descen = GetDescendants(W); self.listofcandle = {};
                for _, v in pairs(Descen) do
                    if v.Name == "Orb" and v.Parent.Name == "Seishin" and v.Transparency == 0 then
                        local p = CommonF.findPrompt(Descen, function(p)
                            return p.Parent.Name == "Orb";
                        end); if p then
                            CommonF.Tp(HumRSelf, p.Parent.CFrame, 0.3);
                            fireproximityprompt(p, 1);
                            CommonF.Tp(HumRSelf, CFr(-326.344421, 23.1051254, 3662.32056), 0.28);
                            local q = CommonF.findPrompt(Descen, function(q)
                                return q.Parent.Name == "Quest";
                            end); if q then
                                return fireproximityprompt(q, 1);
                            end;
                        end;
                    else
                        for _, x in pairs(Descen) do
                            if str.gmatch(x.Name, "%d") and FindFirstChild(x, "Image") and tble.find(self.pic4, x.Image.Decal.Texture) then
                                tble.insert(self.listofcandle, x.Name);
                            end;
                        end; for _, p in pairs(Descen) do
                            if IsA(p, "ProximityPrompt") and p.Parent.Name == "Wax" and tble.find(self.listofcandle, p.Parent.Parent.Parent.Name) then
                                CommonF.Tp(HumRSelf, p.Parent.CFrame, 0.3);
                                fireproximityprompt(p, 1);
                            end;
                        end;

                        local p = CommonF.findPrompt(Descen, function(p)
                            return p.Parent.Name == "Orb";
                        end); if p then
                            CommonF.Tp(HumRSelf, p.Parent.CFrame, 0.3);
                            fireproximityprompt(p, 1);
                        end; CommonF.Tp(HumRSelf, CFr(-326.344421, 23.1051254, 3662.32056), 0.28);
                        local q = CommonF.findPrompt(Descen, function(q)
                            return q.Parent.Name == "Quest";
                        end); if q then
                            return fireproximityprompt(q, 1);
                        end;
                    end; break;
                end; return;
            elseif where == "Ship/Zone" then
                return CommonF.Tp(HumRSelf, CFr(-1250, 4, 6299.65));
            elseif where == "Ship/Run" then
                return CommonF.Tp(HumRSelf, CFr(-6318.51, 418.696014, 6332.39));
            end;
        end;
        Functions.GetPot = function(des)
            if not B2C2Con.AutoCook then return; end;
            local Prompt = CommonF.findPrompt(des, function(v)
                return v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "Pot" and IsA(v.Parent, "BasePart")
            end); if Prompt then
                CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                return fireproximityprompt(Prompt, 1);
            end;
        end;
        Functions.PlaceCoun = function(des)
            if not B2C2Con.AutoCook then return; end;
            local Prompt = CommonF.findPrompt(des, function(v)
                return v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "WoodenCounter" and IsA(v.Parent, "BasePart")
            end); if Prompt then
                CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                return fireproximityprompt(Prompt, 1);
            end;
        end;
        Functions.ToPot = function(des)
            if not B2C2Con.AutoCook then return; end;
            local Prompt = CommonF.findPrompt(des, function(v)
                return v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "WoodenCounter" and IsA(v.Parent, "BasePart")
            end); if Prompt then
                CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                return fireproximityprompt(Prompt, 1);
            end;
        end;
        Functions.ToStove = function()
            if not B2C2Con.AutoCook then return; end;
            local Prompt = CommonF.findPrompt(GetDescendants(W), function(v)
                return v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "stove" and IsA(v.Parent, "BasePart");
            end); if Prompt then
                CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                return fireproximityprompt(Prompt, 1);
            end;
        end;
        Functions.GetBowl = function(des)
            if not B2C2Con.AutoCook then return; end;
            local Prompt = CommonF.findPrompt(des, function(v)
                return v and v.Parent and v.Parent.Parent.Name == "Bowl" and IsA(v.Parent, "BasePart");
            end); if Prompt then
                CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                return fireproximityprompt(Prompt, 1);
            end;
        end;
        Functions.TurnInFood = function(des)
            if not B2C2Con.AutoCook then return; end;
            local Prompt = CommonF.findPrompt(des, function(v)
                return v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "TurnInFood";
            end); if Prompt then
                Prompt.Parent.Parent.CanCollide = false; Prompt.Enabled = true;
                CommonF.Tp(HumRSelf, Prompt.Parent.Parent.CFrame * CFr(0, -3, 0), 0.3);
                return twait(0.33), fireproximityprompt(Prompt, 1);
            end;
        end;
        Functions.GrabFood = function(value)
            if not B2C2Con.AutoCook then return; end;
            local Prompt = CommonF.findPrompt(GetDescendants(W), function(v)
                return v.Parent and v.Parent.Parent and v.Parent.Parent.Name == value and IsA(v.Parent.Parent, "Model");
            end); if Prompt then
                CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.33);
                return fireproximityprompt(Prompt, 1);
            end;
        end;
        Functions.GetBallGiver = function(self)
            return self.BallGiverPart or (function()
                local Prompt = CommonF.findPrompt(GetDescendants(W), function(v)
                    return v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "BallGiver" and IsA(v.Parent, "BasePart");
                end); if Prompt then
                    return Prompt;
                end;
            end)();
        end;
        Functions.GetNagisaLaser = function(self)
            return (self.NagisaLaser and (function()
                for i, v in pairs(GetChildren(self.NagisaLaser)) do
                    if v.Name == "POISON" then
                        return v;
                    end;
                end;
            end)()) or (function()
                for i, v in pairs(GetDescendants(W)) do
                    if v.Name == "POISON" then
                        self.NagisaLaser = v.Parent;
                        return v;
                    end;
                end;
            end)();
        end;
        Functions.GetCannonBalls = function(self)
            local BallGiver = self:GetBallGiver();
            local NagisaLaser = self:GetNagisaLaser();
            if BallGiver and NagisaLaser then
                if PSG.BossFight.Ammo.Text == "0" and NagisaLaser.Transparency ~= 0.5 then
                    CommonF.Tp(HumRSelf, BallGiver.Parent.CFrame, 0.3); for i=1, 5 do
                        fireproximityprompt(BallGiver, 1);
                    end; return;
                end
            end;
        end;
        Functions.AntiNagisaLaser = function(self)
            local NagisaLaser = self:GetNagisaLaser();
            if NagisaLaser and NagisaLaser.Transparency ~= 1 then
                return CommonF.Tp(HumRSelf, CFr(1982.58, 100, -4780.12));
            end
        end;
        Functions.B2C2Func = function(self, where)
            if where == "Statue" then
                for _, v in pairs(GetDescendants(W)) do
                    if (IsA(v, "TouchTransmitter") or IsA(v, "TouchInterest")) and v.Parent.Name == "Hitbox_Entrance" then
                        firetouchinterest(HumRSelf or selc.Torso, FindFirstAncestorWhichIsA(v, "Part"), 0);
                        break;
                    end;
                end;
                CommonF.Tween({
                    primary = HumRSelf; goal = {CFrame = CFr(-520, 30, -87.29)};
                });
                CommonF.Tp(HumRSelf, CFr(-520, 30, -87.2), 0.3)
                CommonF.Anchored(HumRSelf, true);
                CommonF.Tp(HumRSelf, CFr(-520, 30, -87.2), 30);
                CommonF.Anchored(HumRSelf, false);
                CommonF.Tp(HumRSelf, CFr(-551, 30, -87.29));
            elseif where == "Crounch" then
                local Descen = GetDescendants(W); ForceFloat = true;
                CommonF.Tp(HumRSelf, CFr(-3576.7, 602.74, 886.94), 1);
                local PromptA, PromptB = CommonF.findPrompt(Descen, function(v)
                    return v.Parent.Parent.Name == "ProxDoorA" and IsA(v.Parent, "BasePart");
                end), CommonF.findPrompt(Descen, function(v)
                    return v.Parent.Parent.Name == "ProxDoorB" and IsA(v.Parent, "BasePart");
                end); if PromptA and PromptB then
                    fireproximityprompt(PromptA, 1);
                    twait(1);
                    CommonF.Tp(HumRSelf, CFr(-3576.7, 800, 886.94), 0.3);
                    CommonF.Tp(HumRSelf, CFr(GetPivot(PromptB.Parent.Parent).Position.X, PromptB.Parent.CFrame.Position.Y + 6.5, GetPivot(PromptB.Parent.Parent).Position.Z), 0.3);
                    fireproximityprompt(PromptB, 1);
                    CommonF.Tp(HumRSelf, CFr(-3952.85, 700, 317.7), 0.001);
                    CommonF.Anchored(HumRSelf, true); WindUI:Notify({
                        Title = "<font color='rgb(255,0,0)'>Anti Cheat</font>",
                        Content = "Waiting 70 seconds...",
                        Icon = "circle-alert",
                        Duration = 70,
                    }); twait(70); CommonF.Anchored(HumRSelf, false); ForceFloat = "None";
                    PromptA = CommonF.findPrompt(GetDescendants(W), function(v)
                        return v.Parent.Parent.Name == "TeleportDoor" and IsA(v.Parent, "BasePart");
                    end); if PromptA then
                        CommonF.Tp(HumRSelf, CFr(-3952.85, 594.22, 317.7), 1.3);
                        return fireproximityprompt(PromptA, 1);
                    end;
                end; return;
            elseif where == "Meat/Talk" then
                return CommonF.Tp(HumRSelf, CFr(-4443, 711, 1164)), WindUI:Notify({
                    Title = "<font color='rgb(255,0,0)'>ALERT</font>",
                    Content = "if you just collect a meat, wait 11 seconds before talk to this NPC",
                    Icon = "circle-alert",
                    Duration = 11,
                });
            elseif where == "Meat/TpMeat" then
                local MeatRF = FindFirstChild(W, "RestaurantRoom", true);
                local MeatRF = MeatRF.Parent;
                if MeatRF then
                    for _, v in pairs(GetChildren(MeatRF)) do
                        if v.Name == "RestaurantRoom" then
                            local MeatF = FindFirstChild(v, "Meat");
                            if MeatF then
                                local MeatFChild = GetChildren(MeatF);
                                for i=1, #MeatFChild do
                                    if MeatFChild[i].Transparency == 0 then
                                        return CommonF.Tp(HumRSelf, MeatFChild[i].CFrame);
                                    end;
                                end;
                            end;
                        end;
                    end;
                end; return;
            elseif where == "Meat/Exit" then
                for i,v in pairs(GetDescendants(W)) do
                    if IsA(v, "Model") and v.Name == "DoorTele" then
                        return CommonF.Tp(HumRSelf, v.Frame.CFrame);
                    end;
                end; return;
            elseif where == "Chase/Full" then
                ForceFloat = false; self:B2C2Func("Chase/Enter");
                return twait(14), self:B2C2Func("Chase/Run");
            elseif where == "Chase/Enter" then
                return CommonF.Tp(HumRSelf, CFr(-4590, 843.64, -35.54));
            elseif where == "Chase/Run" then
                ForceFloat = true; tk.spawn(function()
                    CommonF.Tween({primary = HumRSelf; goal = {CFrame = CFr(-5364, 682.12, 29.63)}});
                end); twait(2); ForceFloat = "None"; return;
            elseif where == "Lever/Enter" then
                return CommonF.Tp(HumRSelf, CFr(-11035, -81.4, -12.56));
            elseif where == "Lever/Auto" then
                for i, v in pairs(GetDescendants(W)) do
                    if IsA(v, "ProximityPrompt") and IsA(v.Parent, "BasePart") and v.Parent.Name == "Lever" then
                        CommonF.Tp(HumRSelf, v.Parent.CFrame, 0.3);
                        fireproximityprompt(v, 1);
                    end;
                end; return twait(6), CommonF.Tp(HumRSelf, CFr(-10060, 484.1, -9.52), nil);
            elseif where == "Math" then
                return CommonF.Tp(HumRSelf, CFr(-2005.8, 968.25, -4909.48));
            elseif where == "Cook/AfterCook" then
                return CommonF.Tween({primary = HumRSelf; goal = {
                    CFrame = CFr(-3345.78, 1205, -6794.84)};
                    info = TweenInfo.new(
                        3,
                        Enum.EasingStyle.Linear,
                        Enum.EasingDirection.Out,
                        0,
                        false,
                        0
                    )
                }), twait(4), CommonF.Tp(HumRSelf, CFr(-3347.32, 1205, -6824));
            elseif where == "Cursed/1" then
                return CommonF.Tween({primary = HumRSelf; goal = {CFrame = CFr(-4250.71, 613.7, -968.13)}});
            elseif where == "Cursed/2" then
                return CommonF.Tween({primary = HumRSelf; goal = {CFrame = CFr(-4079.71, 613.7, -968.13)}});
            elseif where == "Cursed/Remove" then
                for i, v in pairs(GetDescendants(W)) do
                    if IsA(v.Parent, "BasePart") and v.Parent.Name == "GAMESTART" then
                        return v:Destroy();
                    end;
                end; return;
            elseif where == "Kid/Files" then
                for i,v in pairs(GetDescendants(W)) do
                    if v.Name == "SquidGames" then
                        return v:Destroy();
                    end;
                end; return;
            elseif where == "Kid/Find" then
                self.Kid = self.Kid or (function()
                    for i,v in pairs(GetDescendants(W)) do
                        if IsA(v, "BasePart") and v.Name == "IndicatorPic" then
                            return v;
                        end;
                    end; return nil;
                end)();
                return CommonF.Tp(HumRSelf, self.Kid.CFrame, 0.3), CommonF.Tp(HumRSelf, CFr(-4334.81299, 690.94397, -2363.2771));
            elseif where == "Kid/Gate" then
                for i,v in pairs(GetDescendants(W)) do
                    if IsA(v, "BasePart") and v.Name == "Formation" then
                        return CommonF.Tp(HumRSelf, v.CFrame);
                    end;
                end; return;
            elseif where == "Kid/Notes" then
                self.NOTESCache = self.NOTESCache or GetDescendants(W);
                self.NOTECounts = (self.NOTECounts and self.NOTECounts + 1) or 0;
                self.NOTESCache = (self.NOTECounts >= 3 and GetDescendants(W)) or self.NOTESCache;
                for _, v in pairs(self.NOTESCache) do
                    if IsA(v, "ProximityPrompt") and IsA(v.Parent, "BasePart") and v.Parent.Name == "Note" then
                        CommonF.Tp(HumRSelf, v.Parent.CFrame, 0.3);
                        fireproximityprompt(v, 1);
                    end;
                end; return;
            end;
        end;
        Functions.B2C2ESP = function(self, where, state)
            if not state then
                return ESPF.Destroy(where);
            elseif where == "Meat/Monster" then
                self.Ashina = self.Ashina or FindFirstChild(W, "Ashina", true);
                if self.Ashina then
                    return ESPF.ESP(where, self.Ashina, RED, VEC10, false, true, false, false);
                end; return;
            elseif where == "Meat/Meats" then
                for _,v in pairs(GetDescendants(W)) do
                    if v.Name == "RestaurantRoom" then
                        local MeatRF = v.Parent; if MeatRF then
                            for _, v2 in pairs(GetChildren(MeatRF)) do
                                if v2.Name == "RestaurantRoom" then
                                    local MeatF = FindFirstChild(v2, "Meat");
                                    if MeatF then
                                        local MeatFChild = GetChildren(MeatF);
                                        for i=1, #MeatFChild do
                                            if MeatFChild[i].Transparency == 0 then
                                                ESPF.ESP(where, MeatFChild[i], GREEN, VEC2, false, false, false, false);
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end; return;
            elseif where == "Math" then
                local MidANumber, MidBNumber = nil;
                local SymbolsAImage1, SymbolsAImage2 = nil;
                local SymbolsBImage1, SymbolsBImage2 = nil;
                local SymbolsANumber1, SymbolsANumber2 = nil;
                local SymbolsBNumber1, SymbolsBNumber2 = nil;
                local Descen = GetDescendants(W);
                for i,v in ipairs(Descen) do
                    if v.ClassName == "TextLabel" and v.Parent.ClassName == "SurfaceGui" and v.Parent.Parent.Name == "MiddleNumber" and v.Parent.Parent.Parent.Name == "SymbolsA" then
                        MidANumber = v.Text;
                    end;
                    if v.ClassName == "TextLabel" and v.Parent.ClassName == "SurfaceGui" and v.Parent.Parent.Name == "MiddleNumber" and v.Parent.Parent.Parent.Name == "SymbolsB" then
                        MidBNumber = v.Text;
                    end;
                    if v.ClassName == "ImageLabel" and v.Parent.ClassName == "SurfaceGui" and v.Parent.Parent.Name == "SymbolHolder" and v.Parent.Parent.Parent.Name == "SymbolsA" then
                        SymbolsAImage1 = v.Image;
                    end;
                    if v.ClassName == "ImageLabel" and v.Parent.ClassName == "SurfaceGui" and v.Parent.Parent.Name == "SymbolHolder" and v.Parent.Parent.Parent.Name == "SymbolsB" then
                        SymbolsBImage1 = v.Image;
                    end;
                end; for i,v in ipairs(Descen) do
                    if v.ClassName == "ImageLabel" and v.Parent.ClassName == "SurfaceGui" and v.Parent.Parent.Name == "SymbolHolder" and v.Parent.Parent.Parent.Name == "SymbolsA" then
                        if v.Image ~= SymbolsAImage1 then
                            SymbolsAImage2 = v.Image;
                        end;
                    end;
                    if v.ClassName == "ImageLabel" and v.Parent.ClassName == "SurfaceGui" and v.Parent.Parent.Name == "SymbolHolder" and v.Parent.Parent.Parent.Name == "SymbolsB" then
                        if v.Image ~= SymbolsBImage1 then
                            SymbolsBImage2 = v.Image;
                        end;
                    end;
                end; for i,v in ipairs(Descen) do
                    if v.ClassName == "ImageLabel" and FindFirstChild(v.Parent, "TextLabel") then
                        if v.Image == SymbolsAImage1 then
                            SymbolsANumber1 = v.Parent:WaitForChild("TextLabel").Text;
                        end;
                    end;
                    if v.ClassName == "ImageLabel" and FindFirstChild(v.Parent, "TextLabel") then
                        if v.Image == SymbolsAImage2 then
                            SymbolsANumber2 = v.Parent:WaitForChild("TextLabel").Text;
                        end;
                    end;
                    if v.ClassName == "ImageLabel" and FindFirstChild(v.Parent, "TextLabel") then
                        if v.Image == SymbolsBImage1 then
                            SymbolsBNumber1 = v.Parent:WaitForChild("TextLabel").Text;
                        end;
                    end;
                    if v.ClassName == "ImageLabel" and FindFirstChild(v.Parent, "TextLabel") then
                        if v.Image == SymbolsBImage2 then
                            SymbolsBNumber2 = v.Parent:WaitForChild("TextLabel").Text;
                        end;
                    end;
                end;
                local Answer1 = tostring(MidANumber - (SymbolsANumber1 + SymbolsANumber2));
                local Answer2 = tostring(MidBNumber - (SymbolsBNumber1 + SymbolsBNumber2));
                for i,v in ipairs(Descen) do
                    if v.ClassName == "TextLabel" and v.Parent.Parent.Parent.Name == "Kanji" then
                        for _, sec in ipairs(Descen) do
                            if sec.Name == "SymbolHolder[Empty]" and sec.Parent.Name == "SymbolsA" then
                                if v.Text == Answer1 then
                                    local HackImage1 = v.Parent:Clone();
                                    HackImage1.Parent = sec;
                                end;
                            end;
                            if sec.Name == "SymbolHolder[Empty]" and sec.Parent.Name == "SymbolsB" then
                                if v.Text == Answer2 then
                                    local HackImage2 = v.Parent:Clone();
                                    HackImage2.Parent = sec;
                                end;
                            end;
                        end;
                    end;
                end;
            elseif where == "Kid/Mother" then
                local mother = nil;
                
                for _, part in pairs(GetDescendants(W)) do
                    if part.Name == "HumanoidRootPart" and part.Parent.Name == "Mother" then
                        mother = part;
                    end;
                end;

                if mother then
                    ESPF.ESP(where, mother, RED, VEC10, false, true, false, false);
                end;
            end;
        end;
        Functions.B2C3Func = function(self, where)
            if where == "Gozu" then
                return CommonF.Tp(HumRSelf, CFr(-582, 38, 417));
            elseif where == "Heart/Talk" then
                return CommonF.Tp(HumRSelf, CFr(-138, 45, 79));
            elseif where == "Heart/Auto" then
                for i, v in pairs(GetChildren(W.Section1.Puzzle.Hearts)) do
                    if v then
                        if FindFirstChild(v, "ProximityPrompt") and v.Heart.Transparency == 0 then
                            CommonF.Tp(HumRSelf, GetPivot(v), 0.3);
                            fireproximityprompt(v.ProximityPrompt, 1, true)
                        end;
                    end;
                end; for i, v in pairs(GetDescendants(W.Section1.Puzzle.SpinModel)) do
                    if IsA(v, "ProximityPrompt") and v.Parent.Name == "Heart" and v.Parent.Parent.Name == "BeatingHeart" then
                        CommonF.HumanoidEquip(HumSelf, FindFirstChild(Backpack, "Heart"));
                        CommonF.Tp(HumRSelf, v.Parent.CFrame, 0.3);
                        fireproximityprompt(v, 1, true);
                    end;
                end; return;
            elseif where == "Heart/Run" then
                ForceFloat = true; CommonF.Tp(HumRSelf, CFr(-101, 42, -395), 0.3);
                for i, v in pairs(GetChildren(W.Section1.Maze.Doors2)) do
                    if FindFirstChild(v, "MAIN") then
                        if dist(v.MAIN.Position) <= 30 then
                            fireproximityprompt(v.MAIN.ProximityPrompt, 1, true);
                            break;
                        end;
                    end;
                end; ForceFloat = "None"; return WindUI:Notify({
                    Title = "<font color='rgb(255,0,0)'>ALERT</font>",
                    Content = "Waiting for chase sequence to finish.",
                    Icon = "circle-alert",
                    Duration = 10,
                });
            elseif where == "Maze/Craft" then
                ForceFloat = true; for i, v in pairs(GetDescendants(W.Section1.Maze.Holes)) do
                    if IsA(v, "ProximityPrompt") and v.Parent.Name == "Hole" then
                        CommonF.Tp(HumRSelf, v.Parent.CFrame * CFr(0, -5, 0), 0.3);
                        fireproximityprompt(v, 1, true);
                    end;
                end; CommonF.Tp(HumRSelf, CFr(-78, 4, -442), 1);
                local Prompt = CommonF.findPrompt(GetDescendants(W.Section1.Maze.Crafting.Tables), function(v)
                    return v.Parent.Name == "RootPart" and v.Parent.Parent.Name == "Monster" and dist(v.Parent.Position) <= 30;
                end); if Prompt then
                    CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                    fireproximityprompt(Prompt, 1, true);
                end; ForceFloat = "None";
                R.Packages.Packet.PacketFunction:InvokeServer(unpack(ArgsCraft));
                twait(0.3); PSG.Crafting.Frame.Visible = false;
            elseif where == "Maze/Fire" then
                for i, v in pairs(GetDescendants(W.Section1.Maze.Crafting.ArmFlames)) do
                    if IsA(v, "ProximityPrompt") and v.Parent.Name == "UndyingFlame" and not CommonF.distOf(v.Parent, W.Section1.Maze.GrinDemonNM.Hitbox, 20) then
                        return CommonF.Tp(HumRSelf, v.Parent.CFrame, 0.3), fireproximityprompt(v, 1, true);
                    end;
                end; return;
            elseif where == "Maze/Escape" then
                return CommonF.Tp(HumRSelf, CFr(-74, 5.2, -880));
            elseif where == "Bell/Zone" then
                return CommonF.Tp(HumRSelf, CFr(-325.5, 15, -1114));
            elseif where == "Bell/Flys" then
                for i=1, 2 do
                    for i, v in pairs(GetDescendants(W)) do
                        if v.Name == "FlyHitbox" and v.Parent.eyes.Transparency ~= 1 then
                            pcall(function()
                                if not FindFirstChild(selc, "Bone Sword") then
                                    CommonF.HumanoidEquip(HumSelf, FindFirstChild(Backpack, "Bone Sword"));
                                end; CommonF.Tp(HumRSelf, v.CFrame);
                                selc["Bone Sword"]:Activate(); twait(3);
                            end); twait();
                        end;
                    end; twait(0.5);
                end; return;
            elseif where == "Bell/Auto" then
                local Bells = WaitForChild(WaitForChild(W, 'Section2',999),'Bells',10);
                local Colors = ({
                    Black = Col3.fromRGB(17, 17, 17);
                    White = Col3.fromRGB(248, 248, 248); 
                    Red = Col3.fromRGB(248, 0, 0);
                }); local IsSoundPlay = function(sound)
                    return sound.IsPlaying or sound.TimePosition > 0;
                end; local AddChild = function(Bell)
                    local Buttons = WaitForChild(Bell, "2", 10);
                    local Base = WaitForChild(Buttons, "Base");
                    local Select = WaitForChild(Base, "Select");
                    local PlayerSelect = WaitForChild(Base, "PlayerSelect");
                    local ProximityPrompt = WaitForChild(Base, "ProximityPrompt");
                    local BellModel = WaitForChild(Bell, "BellModel");
                    local BellAnimationController = WaitForChild(BellModel, "AnimationController");
                    local HandMinions = WaitForChild(Bell, "HandMinions");
                    local IsFinished = false; BellAnimationController.AnimationPlayed:Connect(function()
                        IsFinished = true;
                    end); local ThreadLoop, Pattern, Threads = false, {}, {};
                    for i,Button in next, GetChildren(Buttons) do
                        if Button.Name == "Buttons" then
                            Threads[#Threads + 1] = Button:GetPropertyChangedSignal("Color"):Connect(function()
                                if Button.Color == Colors.White then
                                    tk.delay(0.1,function()
                                        if IsSoundPlay(Select) then
                                            tble.insert(Pattern,Button);
                                        end;
                                    end);
                                elseif Button.Color == Colors.Red then
                                    Pattern = {};
                                end;
                            end);
                        end;
                    end; Threads[#Threads + 1] = H.Heartbeat:Connect(function()
                        if GetAttribute(HandMinions, "Health") <= 0 or GetAttribute(HandMinions, "CanDamage") then
                            IsFinished = true;
                        end; if IsFinished then
                            return;	
                        end; if #Pattern >= 5 and not ThreadLoop then
                            ThreadLoop = true; twait(1);
                            for index = 1,#Pattern do
                                local Button = Pattern[index];
                                R.Packages.Packet.PacketFunction:InvokeServer(0, {
                                    ["__args"] = {
                                        [1] = Button,
                                    },
                                    ["__tree"] = {
                                        [1] = "PuzzleService",
                                        [2] = "Clicked",
                                    },
                                    ["__callType"] = 0,
                                }); twait();
                            end; twait(0.1);
                            Pattern = {};
                            ThreadLoop = false;
                            CommonF:CKey(Enum.KeyCode.S, 0.3);
                        end;
                    end);
                end; for _, bell in pairs(GetChildren(W.Section2.Bells)) do
                    if bell["2"] and FindFirstChild(bell["2"], "Base") and FindFirstChild(bell["2"].Base, "ProximityPrompt") then
                        AddChild(bell);
                    end;
                end; twait(5); local OneRunCFrameDodo = W.Section2.Monster.Dodomeki.Head.CFrame;
                repeat for _, v in pairs(GetChildren(W.Section2.Bells)) do
                        if v["2"] and FindFirstChild(v["2"], "Base") and FindFirstChild(v["2"].Base, "ProximityPrompt") and GetAttribute(v.HandMinions, "Health") > 0 then
                            if not ThreadLoop then
                                if not GetAttribute(v.HandMinions, "CanDamage") then
                                    CommonF.Tp(HumRSelf, v["2"].Model.Part.CFrame, 0.5);
                                    if v["2"].Base.ProximityPrompt.Enabled then
                                        fireproximityprompt(v["2"].Base.ProximityPrompt, 1, true);
                                        twait(5.3);
                                    end;
                                end; if GetAttribute(v.HandMinions, "CanDamage") then
                                    repeat if not PSG.QuickTime.GrabbedUI.Visible then
                                            pcall(function()
                                                CommonF.Tp(HumRSelf, v.HandMinions.Hitbox1.CFrame)
                                                if not FindFirstChild(selc, "Bone Sword") then
                                                    CommonF.HumanoidEquip(HumSelf, FindFirstChild(Backpack, "Bone Sword"));
                                                end; CommonF.Tp(HumRSelf, v.HandMinions.Hitbox1.CFrame); twait();
                                                selc["Bone Sword"]:Activate();
                                            end);
                                        end; twait();
                                    until GetAttribute(v.HandMinions, "Health") <= 0;
                                end;
                            end; twait();
                        end;
                    end; twait();
                until W.Section2.Monster.Dodomeki.Head.CFrame.Position.Y <= 60; return;
            elseif where == "Bell/Puzzle" then
                for i, v in pairs(GetDescendants(W.Section2.PuzzleDoor.Doors)) do
                    if v.Name == "SurfaceGui" and v.Parent.Name == "Combos" and v.Parent.Position.Y >= 0 then
                        local Shapesss = {}; for _, obj in pairs(GetChildren(v)) do
                            if obj then
                                tble.insert(Shapesss, tostring(obj.Name));
                            end;
                        end; twait(); if #Shapesss == 4 then
                            CommonF.Tp(HumRSelf, v.Parent.CFrame, 0.3); fireproximityprompt(v.Parent.Parent.Parent.DoorDetector.ProximityPrompt, 1, true);
                            return R.Packages.Packet.PacketFunction:InvokeServer(0, {
                                ["__args"] = {
                                    [1] = {
                                        [1] = Shapesss[1],
                                        [2] = Shapesss[2],
                                        [3] = Shapesss[3],
                                        [4] = Shapesss[4],
                                        },
                                    },
                                ["__tree"] = {
                                    [1] = "DoorPuzzleService",
                                    [2] = "Clicked",
                                    },
                                ["__callType"] = 0,
                            }), twait(0.3);
                        end;
                    end;
                end; return;
            elseif where == "Bell/TpDoor" then
                for i, v in pairs(GetDescendants(W.Section2.PuzzleDoor.Doors)) do
                    if v.Name == "SurfaceGui" and v.Parent.Name == "Combos" and v.Parent.Position.Y >= 0 then
                        local Shapesss = {}; for _, obj in pairs(GetChildren(v)) do
                            if obj then
                                tble.insert(Shapesss, tostring(obj.Name));
                            end;
                        end; twait(); if #Shapesss == 4 then
                            CommonF.Tp(HumRSelf, v.Parent.CFrame);
                        end;
                    end;
                end; return;
            elseif where == "Bell/Run" then
                return CommonF.Tp(HumRSelf, CFr(-3888, -55, -2289));
            elseif where == "Enzukai/Auto" then
                for _, v in pairs(GetDescendants(W["Section2.5"].MindGame.Boats)) do
                    if IsA(v, "ProximityPrompt") and v.Parent.Parent.Name == "RootPart" then
                        if dist(v.Parent.Parent.Position) <= 100 then
                            while true do
                                if not v then break; end;
                                if v.Enabled then
                                    fireproximityprompt(v, 1, true);
                                end; twait(0.1);
                            end; twait();
                        end;
                    end;
                end; return;
            elseif where == "Father/Isamu" then
                W.Section3.IsamuAI.Hitbox.CanTouch = false; return;
            elseif where == "Father/Auto" then
                return CommonF.Tp(HumRSelf, CFr(1136, 30, -2400));
            elseif where == "Train" then
                return CommonF.Tp(HumRSelf, W["Section3.5"].GhostTrain.TrainTrigger.CFrame);
            elseif where == "Larves" then
                for _,v in pairs(GetChildren(W.Section4.Map.BabyFaceNPC.ProxPart)) do
                    if IsA(v, "ProximityPrompt") and v.Enabled then
                        CommonF.Tp(HumRSelf, v.Parent.CFrame, 0.3);
                        fireproximityprompt(v, 1, true); break;
                    end;
                end; twait(); for _,v in pairs(GetChildren(W.Section4.HotPotato.Givers)) do
                    if v.Name == "LarvaeGiver" and FindFirstChild(v, "RootPart") then
                        CommonF.Tp(HumRSelf, v.RootPart.CFrame, 0.3);
                        fireproximityprompt(v.RootPart.ProximityPrompt, 1, true); break;
                    end;
                end; twait(); for _,v in pairs(GetChildren(W.Section4.DogWall.RootPart)) do
                    if IsA(v, "ProximityPrompt") then
                        CommonF.Tp(HumRSelf, v.Parent.CFrame, 0.3);
                        return fireproximityprompt(v, 1, true);
                    end;
                end; return;
            elseif where == "Mud" then
                return CommonF.Tp(HumRSelf, W["Section4.5"].TeleportToSection5.CFrame);
            elseif where == "Yurei/House" then
                for _,v in pairs(GetDescendants(W.Section5.ISPY.Houses)) do
                    if v.Name == "LightSpotter" and v.Parent and FindFirstChild(v.Parent, "HumanoidRootPart") then
                        if FindFirstChild(v.Parent.HumanoidRootPart, "ProximityPrompt") and v.Parent.HumanoidRootPart.ProximityPrompt.Enabled then
                            return CommonF.Tp(HumRSelf, v.CFrame);
                        end;
                    end;
                end; return;
             elseif where == "Yurei/Click" then
                local OneRunHouseClicked, House1Run = {}, nil;
                for _,v in pairs(GetChildren(W.Section5.ISPY.Houses)) do
                    if dist(v.Player.HumanoidRootPart.Position) <= 30 then
                        House1Run = v.Name;
                    end;
                end; local function clickItem(itemName, house)
                    if not tble.find(OneRunHouseClicked, itemName) then
                        tble.insert(OneRunHouseClicked, itemName);
                        R.Packages.Packet.PacketFunction:InvokeServer(0, {
                            ["__args"] = { [1] = itemName },
                            ["__tree"] = { [1] = "IspyService", [2] = "Clicked" },
                            ["__callType"] = 0
                        }); twait();
                    end;
                end; for _, v in pairs(GetChildren(W.Section5.ISPY.Houses[House1Run].Items)) do
                    local itemName = v.Name; if str.find(PSG.Section5.TextLabel.Text, itemName) then
                        clickItem(itemName, House1Run);
                    elseif str.find(PSG.Section5.TextLabel.Text, "Teddy Bear") and itemName == "TeddyBear" then
                        clickItem("TeddyBear", House1Run);
                    elseif str.find(PSG.Section5.TextLabel.Text, "Traditional Lantern") and itemName == "TraditionalLantern" then
                        clickItem("TraditionalLantern", House1Run);
                    elseif str.find(PSG.Section5.TextLabel.Text, "Japanese Stone Lantern") and itemName == "JapaneseStoneLantern" then
                        clickItem("JapaneseStoneLantern", House1Run);
                    elseif str.find(PSG.Section5.TextLabel.Text, "Rubber Duck") and itemName == "RubberDuck" then
                        clickItem("RubberDuck", House1Run);
                    elseif str.find(PSG.Section5.TextLabel.Text, "Working Lantern") and itemName == "WorkingLantern" then
                        clickItem("WorkingLantern", House1Run);
                    elseif str.find(PSG.Section5.TextLabel.Text, "Sun Symbol") and itemName == "SunSymbol" then
                        clickItem("SunSymbol", House1Run);
                    elseif str.find(PSG.Section5.TextLabel.Text, "Kintoru Head") and itemName == "KintoruHead" then
                        clickItem("KintoruHead", House1Run);
                    elseif str.find(PSG.Section5.TextLabel.Text, "Mail Box") and itemName == "MailBox" then
                        clickItem("MailBox", House1Run);
                    elseif str.find(PSG.Section5.TextLabel.Text, "Rice Barrel") and itemName == "RiceBarrel" then
                        clickItem("RiceBarrel", House1Run);
                    end;
                end; return;
            elseif where == "Boss/ClearMap" then
                if self.MapClear then return; end;
                for _, v in pairs(GetChildren(W.Section5.Boss.Build)) do
                    if (v and v.Name == "c01-15k") or (v and v.Name == "InvisWall") then
                        v:Destroy();
                    end;
                end; self.MapClear = true; return;
            elseif where == "Boss/TpSafe" then
                return self:B2C3Func("Boss/ClearMap"), CommonF.Tp(HumRSelf, CFr(3078, 17, -540));
            elseif where == "Boss/Katanas" then
                self:B2C3Func("Boss/ClearMap"); local KatanaData = 0; ForceFloat = true;
                for _,v in pairs(GetChildren(W.Section5.Boss.Katanas)) do
                    if v.Transparency == 0 and KatanaData < 4 then
                        CommonF.Tp(HumRSelf, v.CFrame * CFr(15,0,0), 0.3);
                        fireproximityprompt(v.ProximityPrompt, 1, true);
                        KatanaData = KatanaData + 1;
                    end;
                end; ForceFloat = "None"; return CommonF.Tp(HumRSelf, CFr(3078, 18, -540));
            elseif where == "Hell/Run" then
                return CommonF.Tp(HumRSelf, CFr(-1697, 246, 7806));
            end;
        end;
        Functions.B2C3ESP = function(self, where, state)
            if not state then
                return ESPF.Destroy(where);
            elseif where == "Maze" then
                for _,v in pairs(GetChildren(W.Section1.Maze)) do
                    if v.Name == "GrinDemon" or v.Name == "GrinDemonNM" then
                        ESPF.ESP("Maze", v.HumanoidRootPart, RED, VEC10, nil, nil, false, false);
                    end;
                end; return;
            end; return;
        end;
        Functions.B2C4BP1 = function()
            local script = workspace.Section1.PlayerObjective.Local
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")

            -- GUI and dependencies
            local ScreenGui = PSG:FindFirstChild("ScreenGui")
            local spr = require(ReplicatedStorage:WaitForChild("_Libraries"):WaitForChild("spr"))
            local PacketFactory = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packet.d")).Factory:GetClient("raw")
            local FadeService = PacketFactory:GetService("Fade")
            local QuickTimeService = PacketFactory:GetService("QuickTime") -- Purpose unclear, retained as is
            local PlayerCamera = PacketFactory:GetService("PlayerCamera")
            local DialogueService = PacketFactory:GetService("Dialogue")

            -- Local player and GUI references
            local LocalPlayer = Players.LocalPlayer
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            local CutsceneScript = script.Parent
            local NPCCamera = CutsceneScript:WaitForChild("NPCCam", 1/0)
            local CutsceneCamera = CutsceneScript:WaitForChild("CutsceneCam")
            local BlockedEntrance = CutsceneScript:WaitForChild("BlockedEntrance")
            local RemoteEvent = CutsceneScript:WaitForChild("Remote")

            -- Reference to CurrentCamera (unused in original, retained for completeness)
            local CurrentCamera = workspace.CurrentCamera

            -- Function to fire the remote event
            local function FireSkipEvent()
                RemoteEvent:FireServer(1)
            end

            -- Wait for the "Play" attribute to be set if not already
            if not CutsceneScript:GetAttribute("Play") then
                CutsceneScript:GetAttributeChangedSignal("Play"):Wait()
            end

            -- State variables
            local isCutscenePlaying = false
            local isSkipRequested = CutsceneScript:GetAttribute("SkipCutscene") == true
            local skipConnection = nil

            -- Update skip button text based on number of players who skipped
            local function UpdateSkipButtonText()
                if not isCutscenePlaying then
                    local skippedCount = CutsceneScript:GetAttribute("Skipped") or 0
                    local totalPlayers = #Players:GetPlayers()
                    ScreenGui.Border2.TextButton.Text = string.format("Skip (%d/%d)", skippedCount, totalPlayers)
                end
            end

            -- Monitor SkipCutscene attribute changes
            skipConnection = CutsceneScript:GetAttributeChangedSignal("SkipCutscene"):Connect(function()
                isSkipRequested = CutsceneScript:GetAttribute("SkipCutscene") == true
                if isSkipRequested then
                    DialogueService.__public.Display({})
                    if skipConnection.Connected then
                        skipConnection:Disconnect()
                    end
                end
            end)

            -- Store original positions of rocks
            for _, rock in BlockedEntrance:WaitForChild("Rocks"):GetChildren() do
                rock:SetAttribute("OldCF", rock:GetPivot())
            end

            -- Main cutscene logic
            local function PlayCutscene()
                local function ExecuteCutscene()
                    if isSkipRequested then
                        return
                    end

                    -- Set camera and fade
                    PlayerCamera.__public.SetTarget(NPCCamera:GetPivot())
                    FadeService.__public.Off(0.5)

                    -- Dialogue sequence
                    local dialogueSequence = {}
                    local dialogues = {
                        {
                            Message = "You: Oh god… there’s no way everyone is...",
                            Time = 3,
                            Typewriter = { Speed = 0.01 }
                        },
                        {
                            Message = "Boss: Detective Uchiumi? *cough* Is that really you?",
                            Time = 3,
                            Typewriter = { Speed = 0.01 }
                        },
                        {
                            Message = "You: Mr. Ishitoku? Don’t worry, I’ll help you! Thank god you’re still alive.",
                            Time = 4,
                            Typewriter = { Speed = 0.01 }
                        },
                        {
                            Message = "Boss: *cough* Not for long. It’s getting harder to— God— what happened to your body?",
                            Time = 5,
                            Typewriter = { Speed = 0.01 }
                        },
                        {
                            Message = "You: It's a long story. Hang on, I’m gonna call for help. *reaches for the landline telephone*",
                            Time = 5,
                            Typewriter = { Speed = 0.01 }
                        },
                        {
                            Message = "Don’t even bother using that *cough* the dang thing’s busted.",
                            Time = 5,
                            Typewriter = { Speed = 0.01 }
                        },
                        {
                            Message = "Boss: You know the mall near the office? Last I remembered it hasn’t been knocked down yet, so you can try to go there and maybe find something you could use.",
                            Time = 6,
                            Typewriter = { Speed = 0.01 }
                        },
                        {
                            Message = "You: Alright, I’ll go check it out. Hang in there sir.",
                            Time = 3,
                            Typewriter = { Speed = 0.01 }
                        },
                        {
                            Message = "Boss: I don't- think I’m gonna make it. Promise me something. The twisted hyakki yagyō out there is dangerous. Their rampage is cough far from over. Watch your back and save anyone you can. That’s all I ask. cough It’s been nice working with you, Isamu. I--",
                            Time = 9,
                            Typewriter = { Speed = 0.01 }
                        },
                        {
                            Message = "You: No no no- Mr. Ishitoku, wake up! Please!",
                            Time = 4,
                            Typewriter = { Speed = 0.01 }
                        }
                    }

                    -- Note: __set_list is undefined in the provided script. Please verify its implementation.
                    __set_list(dialogueSequence, 1, dialogues)
                    DialogueService.__public.Display(dialogueSequence)

                    if not isSkipRequested then
                        print("DONE")
                        PlayerCamera.__public.SetTarget(CutsceneCamera:GetPivot())
                        local impactSound = BlockedEntrance:WaitForChild("Impact")
                        local dustFalling = BlockedEntrance:WaitForChild("DustFalling")
                        dustFalling:WaitForChild("ParticleEmitter").Enabled = true
                        dustFalling:WaitForChild("ParticleEmitter2").Enabled = true
                        dustFalling.ParticleEmitter:Emit(20)
                        dustFalling.ParticleEmitter2:Emit(20)

                        local rocks = BlockedEntrance:WaitForChild("Rocks"):GetChildren()
                        table.sort(rocks, function(a, b)
                            return a.Position.Y < b.Position.Y
                        end)

                        for _, rock in rocks do
                            if isSkipRequested then
                                dustFalling.ParticleEmitter.Enabled = false
                                dustFalling.ParticleEmitter2.Enabled = false
                                task.delay(2, function()
                                    dustFalling:Destroy()
                                end)
                                return
                            end
                            task.wait(0.4)
                            spr.target(rock, 0.9, 8, {
                                CFrame = rock:GetAttribute("OldCF") * CFrame.new(0, -12, 0)
                            })
                            task.wait(0.2)
                            local clonedImpact = impactSound:Clone()
                            clonedImpact.Parent = BlockedEntrance
                            clonedImpact.Ended:Once(function()
                                clonedImpact:Destroy()
                            end)
                            clonedImpact:Play()
                            PlayerCamera.__public.Shake("Section1", "RockDrop")
                        end

                        dustFalling.ParticleEmitter.Enabled = false
                        dustFalling.ParticleEmitter2.Enabled = false
                        task.delay(2, function()
                            dustFalling:Destroy()
                        end)
                    end
                end

                -- Fade in and set up GUI
                FadeService.__public.On(0.5)
                task.wait(1.5)
                ScreenGui.Parent = PlayerGui
                ExecuteCutscene()
                FadeService.__public.On(0.5)
                task.wait(0.5)

                -- Move rocks to collapsed position
                for _, rock in BlockedEntrance:WaitForChild("Rocks"):GetChildren() do
                    rock.CFrame = rock:GetAttribute("OldCF") * CFrame.new(0, -12, 0)
                end

                isCutscenePlaying = true
                ScreenGui:Destroy()
                if skipConnection.Connected then
                    skipConnection:Disconnect()
                end
                PlayerCamera.__public.Free()
                FadeService.__public.Off(0.5)
                task.wait(0.5)

                -- Final dialogue
                local finalDialogue = {}
                local dialogues = {
                    {
                        Message = "You: The entrance collapsed! How am I gonna- wait... There should be a shovel in the storage room. That’ll help me clear out the debris.",
                        Time = 7,
                        Typewriter = { Speed = 0.01 }
                    },
                    {
                        Message = "You: They must’ve changed the code. I wonder if I could find the new one around the office",
                        Time = 4,
                        Typewriter = { Speed = 0.01 }
                    }
                }
            end

            -- Handle skip input (Space or ButtonA)
            UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
                if not gameProcessedEvent then
                    if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
                        FireSkipEvent()
                    end
                end
            end)

            -- Connect skip button
            ScreenGui:WaitForChild("Border2"):WaitForChild("TextButton").Activated:Connect(FireSkipEvent)

            -- Update skip button text initially
            if not isCutscenePlaying then
                UpdateSkipButtonText()
            end

            -- Connect attribute change for skip count
            CutsceneScript:GetAttributeChangedSignal("Skipped"):Connect(UpdateSkipButtonText)

            PlayCutscene()
        end;
        Functions.B2C4BP2 = function()
            -- Services
            local RunService = game:GetService("RunService")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")

            -- Dependencies
            local spr = require(ReplicatedStorage._Libraries.spr)
            local Controllers = require(ReplicatedStorage.Client.Controllers)

            local script = game:GetService("Players").LocalPlayer.PlayerGui["S2.5"].LocalScript;
            local Section = workspace:WaitForChild("Section2.5")
            local TriviaGame = Section:WaitForChild("ChihiroMinigame"):WaitForChild("Trivia")
            local MonsterMother = TriviaGame:WaitForChild("Monster", math.huge):WaitForChild("Mother", math.huge)
            local SignalRemote = TriviaGame:WaitForChild("Signal")
            local TriviaUI = script.Parent

            -- Creates a corner element for the trivia UI with animated frames
            local function CreateCornerElement(isTop, isLeft)
                local canvasGroup = Instance.new("CanvasGroup")
                canvasGroup.BackgroundTransparency = 1
                canvasGroup.BorderSizePixel = 0
                canvasGroup.ZIndex = 2
                canvasGroup.Size = UDim2.fromScale(0.5, 0.5)
                canvasGroup.Position = UDim2.fromScale(isLeft and 0 or 1, isTop and 0 or 1)
                canvasGroup.Name = ""

                local aspectRatio = Instance.new("UIAspectRatioConstraint")
                aspectRatio.AspectRatio = 1
                aspectRatio.Parent = canvasGroup

                local function CreateFrame(isHorizontal)
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.fromScale(isHorizontal and 1 or 0.1, isHorizontal and 0.1 or 1)
                    frame.BorderSizePixel = 0
                    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    frame.Name = ""

                    local corner = Instance.new("UICorner")
                    corner.CornerRadius = UDim.new(0.5, 0)
                    corner.Parent = frame
                    return frame
                end

                local horizontalFrame = CreateFrame(false)
                horizontalFrame.Position = UDim2.fromScale(isLeft and 0 or 1, 0)
                horizontalFrame.AnchorPoint = Vector2.new(isLeft and 0 or 1, 0)
                horizontalFrame.Parent = canvasGroup

                local verticalFrame = CreateFrame(true)
                verticalFrame.Position = UDim2.fromScale(0, isTop and 0 or 1)
                verticalFrame.AnchorPoint = Vector2.new(0, isTop and 0 or 1)
                verticalFrame.Parent = canvasGroup

                return {
                    group = canvasGroup,
                    x = horizontalFrame,
                    y = verticalFrame,
                    top = isTop,
                    left = isLeft
                }
            end

            -- Creates a folder with animated corner elements
            local function CreateCornerFolder(parent)
                local folder = Instance.new("Folder")
                folder.Name = ""

                local cornerData = { corners = {} }

                for i = 1, 4 do
                    local corner = CreateCornerElement(i < 3, i % 2 ~= 0)
                    local group = corner.group
                    local offset = Vector2.new(0, 0)
                    group.AnchorPoint = Vector2.new(corner.left and 0 or 1, corner.top and 0 or 1) +
                        offset * Vector2.new(corner.left and 1 or -1, corner.top and 1 or -1)
                    group.GroupTransparency = 1
                    group.Parent = folder
                    table.insert(cornerData.corners, corner)
                end

                function cornerData:animatePop()
                    for _, corner in self.corners do
                        local animOffset = Vector2.new(0.2, 0.2)
                        spr.target(corner.group, 0.5, 2, {
                            AnchorPoint = Vector2.new(corner.left and 0 or 1, corner.top and 0 or 1) +
                                animOffset * Vector2.new(corner.left and 1 or -1, corner.top and 1 or -1)
                        })
                        task.delay(0.25, function()
                            local nextOffset = Vector2.new(0.25, 0.25)
                            spr.target(corner.group, 0.5, 3, {
                                AnchorPoint = Vector2.new(corner.left and 0 or 1, corner.top and 0 or 1) +
                                    nextOffset * Vector2.new(corner.left and 1 or -1, corner.top and 1 or -1)
                            })
                        end)
                    end
                end

                function cornerData:animateIn()
                    for _, corner in self.corners do
                        local animOffset = Vector2.new(0, 0)
                        spr.target(corner.group, 1, 2, {
                            AnchorPoint = Vector2.new(corner.left and 0 or 1, corner.top and 0 or 1) +
                                animOffset * Vector2.new(corner.left and 1 or -1, corner.top and 1 or -1),
                            GroupTransparency = 1
                        })
                    end
                end

                function cornerData:animateOut()
                    for _, corner in self.corners do
                        local animOffset = Vector2.new(0.25, 0.25)
                        spr.target(corner.group, 0.9, 2, {
                            AnchorPoint = Vector2.new(corner.left and 0 or 1, corner.top and 0 or 1) +
                                animOffset * Vector2.new(corner.left and 1 or -1, corner.top and 1 or -1),
                            GroupTransparency = 0
                        })
                    end
                end

                function cornerData:animateOutDrag()
                    for _, corner in self.corners do
                        local animOffset = Vector2.new(0.4, 0.4)
                        spr.target(corner.group, 1, 2, {
                            AnchorPoint = Vector2.new(corner.left and 0 or 1, corner.top and 0 or 1) +
                                animOffset * Vector2.new(corner.left and 1 or -1, corner.top and 1 or -1),
                            GroupTransparency = 0
                        })
                        task.delay(0.1, function()
                            spr.target(corner.group, 1, 3, {
                                GroupTransparency = 1
                            })
                        end)
                    end
                end

                folder.Parent = parent
                return cornerData
            end

            -- Initialize corner animations
            local cornerAnimation1 = CreateCornerFolder(TriviaUI.Questions)
            local cornerAnimation2 = CreateCornerFolder(TriviaUI.Questions)
            local cornerAnimation3 = CreateCornerFolder(TriviaUI.Questions)

            -- Button and animation management
            local buttons = {}
            local buttonCallbacks = {}
            local isInteractionEnabled = true

            -- Reset button states
            local function ResetButtons()
                for _, callback in buttonCallbacks do
                    callback()
                end
                for _, buttonData in buttons do
                    spr.stop(buttonData.Button)
                    spr.stop(buttonData.Button.UIStroke)
                    buttonData.Button.BackgroundTransparency = 0.1
                    buttonData.Button.UIStroke.Transparency = 0.3
                    buttonData.Button.UIStroke.Color = Color3.fromRGB(255, 255, 255)
                    buttonData.Button.Size = UDim2.fromScale(1, 1)
                    spr.target(buttonData.Button.UIStroke, 1, 3, {
                        Color = Color3.fromRGB(0, 0, 0)
                    })
                    spr.target(buttonData.Button, 1, 3, {
                        Size = UDim2.fromScale(0.8, 0.8)
                    })
                    buttonData:SetAttribute("Selected", false)
                end
            end

            -- Set up button interactions
            for index, buttonFrame in TriviaUI.Selectors:GetChildren() do
                if buttonFrame:IsA("Frame") then
                    local function UpdateButtonState()
                        local isSelected = buttonFrame:GetAttribute("Selected")
                        spr.target(buttonFrame.Button.UIStroke, 1, 3, {
                            Color = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
                        })
                        spr.target(buttonFrame.Button, 1, 3, {
                            Size = isSelected and UDim2.fromScale(0.9, 0.9) or UDim2.fromScale(0.8, 0.8)
                        })
                    end

                    table.insert(buttonCallbacks, UpdateButtonState)
                    buttonFrame:GetAttributeChangedSignal("Selected"):Connect(UpdateButtonState)

                    buttonFrame.Button.Activated:Connect(function()
                        if not isInteractionEnabled then
                            isInteractionEnabled = true
                            SignalRemote:FireServer(1, index)
                            buttonFrame:SetAttribute("Selected", true)
                            cornerAnimation1:animatePop()
                            task.wait(0.4)
                            cornerAnimation1:animateIn()
                        end
                    end)

                    table.insert(buttons, buttonFrame)
                end
            end

            -- Store initial button positions
            local buttonPositions = {}
            for index, button in buttons do
                buttonPositions[index] = {
                    Position = button.Position,
                    AnchorPoint = button.AnchorPoint,
                    From = button
                }
            end

            -- Trivia game state
            local timerValue = 0
            local isGlitchActive = false

            -- Main trivia game function
            local function StartTriviaGame(questionText, answers, glitchEnabled)
                if isInteractionEnabled then
                    task.delay(0.1, function()
                        cornerAnimation2:animateOutDrag()
                        task.wait(0.1)
                        cornerAnimation3:animateOutDrag()
                        task.wait(0.6)
                        cornerAnimation2:animateIn()
                        cornerAnimation3:animateIn()
                    end)
                end

                TriviaUI.Questions.Visible = true
                TriviaUI.Selectors.Visible = true
                isInteractionEnabled = false
                ResetButtons()
                isGlitchActive = glitchEnabled or false

                for _, buttonData in buttonPositions do
                    buttonData.From.Position = buttonData.Position
                    buttonData.From.AnchorPoint = buttonData.AnchorPoint
                end

                if timerValue == 0 then
                    task.defer(function()
                        while timerValue > 0 do
                            task.wait(1)
                            TriviaUI.Questions.Timer.Text = tostring(timerValue)
                            if isGlitchActive and (timerValue % 5 == 0 and #buttonPositions > 1) then
                                script.GlitchSFX:Play()
                                local index1 = math.random(1, #buttonPositions)
                                local index2
                                repeat
                                    index2 = math.random(1, #buttonPositions)
                                until index2 and index2 ~= index1

                                local button1 = buttonPositions[index1]
                                local button2 = buttonPositions[index2]
                                local tempPos = button2.From.Position
                                local tempAnchor = button2.From.AnchorPoint
                                button2.From.Position = button1.From.Position
                                button2.From.AnchorPoint = button1.From.AnchorPoint
                                button1.From.Position = tempPos
                                button1.From.AnchorPoint = tempAnchor
                                button1.From.Button.Label.TextColor3 = Color3.fromRGB(0, 123, 255)
                                button2.From.Button.Label.TextColor3 = Color3.fromRGB(0, 123, 255)
                                task.delay(0.08333333333333333, function()
                                    button1.From.Button.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    button2.From.Button.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                end)
                            end
                            timerValue = timerValue - 1
                        end
                    end)
                end

                timerValue = 20
                TriviaUI.Questions.Timer.Text = tostring(timerValue)
                cornerAnimation1:animateOut()
                cornerAnimation1:animatePop()
                spr.target(TriviaUI.Questions, 1, 3, {
                    BackgroundTransparency = 0.2
                })
                spr.target(TriviaUI.Questions.UIStroke, 1, 3, {
                    Transparency = 0.3
                })
                spr.target(TriviaUI.Questions.Question, 1, 3, {
                    TextTransparency = 0
                })
                spr.target(TriviaUI.Questions.Question.UIStroke, 1, 3, {
                    Transparency = 0
                })
                TriviaUI.Questions.Question.Text = questionText

                for index, answer in answers do
                    buttons[index].Button.Label.Text = answer
                end
            end

            -- Camera control
            local CurrentCamera = workspace.CurrentCamera
            local cameraConnection = nil

            local function UpdateCamera()
                if TriviaGame:GetAttribute("Game") then
                    if not (cameraConnection and cameraConnection.Connected) then
                        cameraConnection = RunService.Heartbeat:Connect(function()
                            local cameraCFrame = CFrame.new(CurrentCamera.CFrame.Position, MonsterMother:GetPivot().Position + Vector3.new(0, 3, 0))
                            local x, y, _ = cameraCFrame:ToOrientation()
                            Controllers.camera:Enforce(Vector2.new(math.deg(x), math.deg(y)))
                        end)
                    end
                else
                    if cameraConnection then
                        cameraConnection:Disconnect()
                        cameraConnection = nil
                    end
                    return
                end
            end

            -- Initialize
            TriviaGame:GetAttributeChangedSignal("Game"):Connect(UpdateCamera)
            UpdateCamera()

            -- Set initial UI transparency
            TriviaUI.Questions.BackgroundTransparency = 1
            TriviaUI.Questions.UIStroke.Transparency = 1
            TriviaUI.Questions.Question.TextTransparency = 1
            TriviaUI.Questions.Question.UIStroke.Transparency = 1

            -- Handle remote events
            SignalRemote.OnClientEvent:Connect(function(eventType, ...)
                if eventType == 0 then
                    StartTriviaGame(...)
                elseif eventType == 1 then
                    spr.target(TriviaUI.Questions, 1, 3, {
                        BackgroundTransparency = 1
                    })
                    spr.target(TriviaUI.Questions.UIStroke, 1, 3, {
                        Transparency = 1
                    })
                    spr.target(TriviaUI.Questions.Question, 1, 3, {
                        TextTransparency = 1
                    })
                    spr.target(TriviaUI.Questions.Question.UIStroke, 1, 3, {
                        Transparency = 1
                    })
                    TriviaUI.Selectors.Visible = false
                elseif eventType == 2 then
                    TriviaUI:Destroy()
                elseif eventType == 3 then
                    local isCorrect = ...
                    if isCorrect then
                        TriviaGame.Correct:Play()
                    else
                        TriviaGame.Wrong:Play()
                    end
                end
            end)
        end;
        Functions.GetLVecFromCLook = function(basePart, spr)
            if not basePart or not IsA(basePart, "BasePart") then return Vec3(0, -1, 0); end;
            local eye = spr.Handle.MagicArrow.CFrame.Position;
            local target = basePart.Position;
            return CFr(eye, target).LookVector;
        end;
        Functions.MagicArrowHit = function(self, SpiritBow, BasePart, time)
            if not self.OnGoingMagicArrow and SpiritBow then
                self.OnGoingMagicArrow = true;
                SpiritBow.RemoteEvent:FireServer(0, true);
                twait(time or 1);
                SpiritBow.RemoteEvent:FireServer(0, false, self.GetLVecFromCLook(BasePart, SpiritBow));
                self.OnGoingMagicArrow = false;
            end;
        end;
        Functions.B2C4Func = function(self, where)
            if where == "Cave" then
                return CommonF.Tp(HumRSelf, W.Section0.Cutscene.Trigger.CFrame);
            elseif where == "City/Auto" then
                return CommonF.Tp(HumRSelf, W.Section1.EnzukaiSneakSequence.GameStart.CFrame, 0.3), CommonF.Tp(HumRSelf, W.Section1.OfficeTeleA.CFrame);
            elseif where == "City/Glass" then
                for _,v in pairs(GetChildren(W.Section1.EnzukaiSneakSequence.Activators)) do
                    if v.Name == "GLASS" then
                        v:Destroy();
                    end;
                end; return;
            elseif where == "Floor/Talk" then
                return CommonF.Tp(HumRSelf, CFr(4449, 44, 1660));
            elseif where == "Floor/Auto" then
                local codextxt = {
                    [6] = W.Section1.PlayerObjective.CodeNumbers["1stFloor"].SurfaceGui.Random,
                    [5] = W.Section1.PlayerObjective.CodeNumbers["2ndFloor"].SurfaceGui.Random,
                    [4] = W.Section1.PlayerObjective.CodeNumbers["3rdFloor"].SurfaceGui.Random,
                    [3] = W.Section1.PlayerObjective.CodeNumbers["4thFloor"].SurfaceGui.Random,
                    [2] = W.Section1.PlayerObjective.CodeNumbers["5thFloor"].SurfaceGui.Random,
                    [1] = W.Section1.PlayerObjective.CodeNumbers["6thFloor"].SurfaceGui.Random,
                }; W.Section1.PlayerObjective.CodeDoor.Remote:FireServer(1, {});
                local c = {}; for i=1, 6 do
                    tble.insert(c, tonumber(codextxt[i].Text));
                end; return W.Section1.PlayerObjective.CodeDoor.Remote:FireServer(1, c);
            elseif where == "Floor/Top" then
                for _,v in pairs(GetChildren(W.Section1.Map.Barriers)) do
                    if IsA(v, "Basepart") then
                        v:Destroy();
                    end;
                end; return CommonF.Tp(HumRSelf, W.WHITE_FLAME_LANTERN.PieceA.CFrame, 0.3), fireproximityprompt(W.WHITE_FLAME_LANTERN.PieceA.ProximityPrompt, 1),
                CommonF.Tp(HumRSelf, W.Section1.PlayerObjective.LADDERPROMPT.CFrame, 0.3), fireproximityprompt(W.Section1.PlayerObjective.LADDERPROMPT.ProximityPrompt, 1);
            elseif where == "Mall/Talk" then
                for _,v in pairs(GetChildren(W.Section2.WalkieTalkis)) do
                    if v.Name == "WalkieTalkie" then
                        CommonF.Tp(HumRSelf, v.CFrame, 0.3);
                        fireproximityprompt(v.ProximityPrompt, 1);
                    end;
                end; return;
            elseif where == "Mall/Trigger" then
                return CommonF.Tp(HumRSelf, W.Section2.Floor1.TRIGGER.CFrame);
            elseif where == "Mall/Eyes" then
                for _,folder in pairs(GetChildren(W.Section2.Floor1.TimedTrial)) do
                    if not IsA(folder, "Folder") then continue; end;
                    for i,v in pairs(GetChildren(folder)) do
                        if v.Name == "EyePunch" and v.RootPart.ProximityPrompt.Enabled then
                            CommonF.Tp(HumRSelf, v.RootPart.CFrame, 0.3);
                            fireproximityprompt(v.RootPart.ProximityPrompt, 1);
                        end;
                    end;
                end; return;
            elseif where == "Mall/Grab" then
                CommonF.Tp(HumRSelf, W.Section2.Speaker.SPEAKER.CFrame, 0.3);
                return fireproximityprompt(W.Section2.Speaker.SPEAKER["Pick Up"], 1);
            elseif where == "Mall/Place" then
                CommonF.Tp(HumRSelf, CFr(-1351, -120, -942), 0.3);
                return W.Section2.Speaker.Signal:FireServer();
            elseif where == "Mall/Chase1" then
                CommonF.Tp(HumRSelf, W["Section2.5"].ChaseSequence.StartPoint.CFrame, 0.3); local Childs = {
                    [1] = CFr(-2925.8701171875, -154.732421875, -117.2448501586914);
                    [2] = CFr(-2925.55322265625, -152.5728302001953, 20.614896774291992);
                    [3] = CFr(-2971.525146484375, -153.9412384033203, 90.89044189453125);
                    [4] = CFr(-3010.700927734375, -156.6041259765625, 58.39167404174805);
                    [5] = CFr(-3010.75244140625, -157.75314331054688, 1.8988595008850098);
                    [6] = CFr(-3075.739990234375, -161.36264038085938, 0.6227156519889832);
                    [7] = CFr(-3078.3828125, -156.6250457763672, 44.571590423583984);
                    [8] = CFr(-3147.58203125, -163.94522094726562, 67.51239776611328);
                    [9] = CFr(-3156.453369140625, -165.38812255859375, 6.998199939727783);
                    [10] = CFr(-3231.25341796875, -169.45045471191406, 8.74213981628418);
                    [11] = CFr(-3325.708740234375, -174.62559509277344, 8.160916328430176);
                    [12] = CFr(-3373.989013671875, -177.52252197265625, -8.055093765258789);
                    [13] = CFr(-3452.03466796875, -182.31747436523438, -41.35819625854492);
                    [14] = CFr(-3444.965576171875, -182.68017578125, -88.05886840820312);
                    [15] = CFr(-3424.7978515625, -182.53289794921875, -148.58685302734375);
                    [16] = CFr(-3393.530029296875, -181.83245849609375, -212.43533325195312);
                    [17] = CFr(-3353.872802734375, -181.00228881835938, -297.08447265625);
                    [18] = CFr(-3319.7666015625, -180.35232543945312, -374.1950988769531);
                    [19] = CFr(-3343.15869140625, -183.03562927246094, -464.2373352050781);
                    [20] = CFr(-3343.15869140625, -183.03561401367188, -464.2373352050781);
                    [21] = CFr(-3401.28271484375, -186.8765106201172, -505.9891357421875);
                    [22] = CFr(-3392.020751953125, -187.16282653808594, -558.0235595703125);
                    [23] = CFr(-3441.10498046875, -191.2901153564453, -584.5067138671875);
                    [24] = CFr(-3468.38818359375, -190.95130920410156, -531.4642333984375);
                    [25] = CFr(-3543.703369140625, -195.39503479003906, -551.8636474609375);
                    [26] = CFr(-3582.680908203125, -197.112060546875, -524.4652099609375);
                    [27] = CFr(-3619.18701171875, -200.43113708496094, -608.3489990234375);
                    [28] = CFr(-3656.057861328125, -203.60781860351562, -680.4982299804688);
                    [29] = CFr(-3710.418212890625, -208.19607543945312, -784.3978881835938);
                    [30] = CFr(-3671.24462890625, -207.56741333007812, -880.4503173828125);
                    [31] = CFr(-3601.3994140625, -206.583740234375, -1059.983642578125);
                    [32] = CFr(-3449.1181640625, -197.33131408691406, -999.8219604492188);
                    [33] = CFr(-3449.1181640625, -197.31771850585938, -999.8219604492188);
                    [34] = CFr(-3241.165771484375, -200.42782592773438, -902.1727294921875);
                }; local HumRSelfS = HumRSelf; for i = 2, 34 do
                    CommonF.Tween({
                        primary = HumRSelfS,
                        goal = {CFrame = Childs[i]}
                    });
                end; return CommonF.Tween({
                    primary = HumRSelfS,
                    goal = {CFrame = W["Section2.5"].ChaseSequence.EndPoint.CFrame}
                });
            elseif where == "Mall/Chase2" then
                return CommonF.Tp(HumRSelf, W["Section2.5"].ChaseSequence.SecondChaseStuff.ElevatorHit.CFrame);
            elseif where == "Car/Collect" then
                for _,v in pairs(GetChildren(W["Section2.5"].ChihiroMinigame.CarFixObjective.CarParts)) do
                    if IsA(v, "BasePart") then
                        CommonF.Tp(HumRSelf, v.CFrame, 0.3);
                        fireproximityprompt(v.ProximityPrompt, 1);
                    end;
                end; local V8 = FindFirstChild(W["Section2.5"].ChihiroMinigame.CarFixObjective.CarParts, "V8 Engine");
                V8 = V8 and V8["Meshes/ls9_Cube (2)"]; if V8 then
                    CommonF.Tp(HumRSelf, V8.CFrame, 0.3);
                    return fireproximityprompt(V8.ProximityPrompt, 1);
                end; return;
            elseif where == "Car/Answer" then
                self.MotherLabels = self.MotherLabels or {
                    PSG["S2.5"].Selectors["3"].Button.Label,
                    PSG["S2.5"].Selectors["2"].Button.Label,
                    PSG["S2.5"].Selectors["1"].Button.Label,
                }; for i, v in pairs(self.AnsweredMother) do
                    if str.find(PSG["S2.5"].Questions.Question.Text, i) then
                        local answer_ = self.AnsweredMother[i]; WindUI:Notify({
                            Title = "<font color='rgb(255,255,0)'>Answer</font>",
                            Content = "Answer: " .. answer_,
                            Icon = "circle-alert",
                            Duration = 20,
                        }); for _, p in pairs(self.MotherLabels) do
                            if p.Text == answer_ then
                                return W["Section2.5"].ChihiroMinigame.Trivia.Signal:FireServer(1, tonumber(p.Parent.Parent.Name));
                            end;
                        end;
                    end;
                end;
            elseif where == "Draw/Draw" then
                local nearestpad = nil; for _,v in pairs(GetChildren(W.Section3.PaintPuzzle)) do
                    if FindFirstChild(v, "Pad") and dist(v.Pad.Position) <= 10 then
                        nearestpad = v;
                        break;
                    end;
                end; if nearestpad then
                    local obj = FindFirstChildWhichIsA(nearestpad.Pad, "Decal");
                    local Text = obj.Texture;
                    local tonn = Text:gsub("rbxassetid://", "");
                    for _,v in ipairs(Paints[tonumber(tonn)]) do
                        nearestpad.Pad.Controls.Draw:FireServer(v[1], v[2], v[3]);
                    end;
                end;
            elseif where == "Draw/Item" then
                for _,v in pairs(GetChildren(W.WHITE_FLAME_LANTERN.PieceDnE)) do
                    if v.Name == "PieceD" or v.Name == "PieceE" then
                        CommonF.Tp(HumRSelf, v.CFrame, 0.3);
                        fireproximityprompt(v.ProximityPrompt, 1);
                    end;
                end; return;
            elseif where == "Survivors" then
                for _,v in pairs(GetChildren(W.Section4.Rescue.NPCs)) do
                    if v.Name == "Pose" then
                        CommonF.Tp(HumRSelf, v.HumanoidRootPart.CFrame, 0.3);
                        fireproximityprompt(v.HumanoidRootPart.ProximityPrompt, 1);
                    end;
                end; return CommonF.Tp(HumRSelf, CFr(-98, 3, -2338));
            end;
        end;
        Functions.B2C4ESP = function(self, where, state)
            if not state then
                return ESPF.Destroy(where);
            else
                if where == "City/Glass" then
                    for _,v in pairs(GetChildren(W.Section1.EnzukaiSneakSequence.Activators)) do
                        if v.Name == "GLASS" then
                            ESPF.ESP(where, v, RED, VEC2, false, true);
                        end;
                    end; return;
                elseif where == "City/Enzukai" then
                    return ESPF.ESP(where, W.Section1.EnzukaiSneakSequence.Monster.Enzukai.Hitbox, RED, VEC10, false, true);
                elseif where == "Mall/Coins" then
                    for _, v in pairs(GetChildren(W.Section2.Floor2.Coins)) do
                        if v.Name == "Coin" and v.ProximityPrompt.Enabled then
                            ESPF.ESP(where, v, YELLOW, VEC1, false, false);
                        end;
                    end; return;
                elseif where == "Mall/Talk" then
                    for _, v in pairs(GetChildren(W.Section2.WalkieTalkis)) do
                        if v.Name == "WalkieTalkie" then
                            ESPF.ESP(where, v, GREEN, VEC2, false, false);
                        end;
                    end; return;
                elseif where == "Mall/Monsters" then
                    return ESPF.ESP(where, W.Section2.Floor3.Monster.Tsukiya.Hitbox, RED, VEC343, false, false),
                    ESPF.ESP(where, W.Section2.Floor1.Monster.Tenome.Hitbox, RED, VEC343, false, false),
                    ESPF.ESP(where, W.Section2.Floor2.Monster.Rin.Hitbox, RED, VEC343, false, false);
                elseif where == "Draw/Senzai" then
                    return ESPF.ESP(where, W.Section3.Monster.Senzai.Hitbox, RED, VEC343, false, false);
                elseif where == "Draw/Ingredients" then
                    for _,v in pairs(GetChildren(W.Section3.PaintPuzzle.Ingredients)) do
                        if v.Name == "Orchid" and v.ProximityPrompt.Enabled then
                            ESPF.ESP(where, v.Part, Col3.fromRGB(77, 23, 129), VEC1, false, false);
                        elseif v.Name == "Water" and v.ProximityPrompt.Enabled then
                            ESPF.ESP(where, v, BLUE, VEC1, false, false);
                        end;
                    end; return ESPF.ESP(where, W.Section3.PaintPuzzle.Ingredients.PlaceInkHere, YELLOW, VEC1, false, false);
                elseif where == "Draw/Drawings" then
                    return ESPF.ESP(where, W.Section3.PaintPuzzle.PaintStation_A.Pad, GREEN, VEC1),
                    ESPF.ESP(where, W.Section3.PaintPuzzle.PaintStation_B.Pad, GREEN, VEC1),
                    ESPF.ESP(where, W.Section3.PaintPuzzle.PaintStation_C.Pad, GREEN, VEC1),
                    ESPF.ESP(where, W.Section3.PaintPuzzle.PaintStation_D.Pad, GREEN, VEC1);
                elseif where == "Survivors" then
                    for _,v in pairs(GetChildren(W.Section4.Rescue.NPCs)) do
                        if v.Name == "Pose" then
                            ESPF.ESP(where, v.HumanoidRootPart, GREEN, VEC2);
                        end;
                    end; return;
                end;
            end;
        end;
        Functions.B3C1GetGatas = function()
            local Grunts, Gatas = GetChildren(W.Section1.Grunts), {};
            for i=1, #Grunts do
                local v = Grunts[i];
                if IsA(v, "Model") and FindFirstChildOfClass(v, "Humanoid") then
                    tble.insert(Gatas, v);
                end;
            end; return Gatas;
        end;
        Functions.B3C1FireGata = function(Gata, sRE)
            while Gata and Gata.Parent and sRE and sRE.Parent do
                local Pivot = GetPivot(Gata);
                CommonF.Tp(HumRSelf, Pivot*CFr(0, 40, 0), 0.1);
                CAMERAREPLICA = Pivot;
                R.GunAction:FireServer("fire");
                sRE:FireServer();
            end; CAMERAREPLICA = nil;
        end;
        Functions.B3C1Func = function(self, where)
            if where == "Gata/Kill" then
                local Gatas = self.B3C1GetGatas(); for i=1, #Gatas do
                    local v = Gatas[i]; if v then
                        local sRE = FindFirstChildWhichIsA(v, "RemoteEvent"); if sRE then
                            self.B3C1FireGata(v, sRE);
                        end;
                    end;
                end;
            elseif where == "Gata/Body" then
                local Bodies = GetChildren(W.Section1.DeadCivilians); for i=1, #Bodies do
                    local v = Bodies[i]; if v and v.Parent then
                        local Prompt = FindFirstChild(v, "HumanoidRootPart");
                        Prompt = Prompt and FindFirstChild(Prompt, "ProximityPrompt");
                        if Prompt then
                            CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                            fireproximityprompt(Prompt, 1);
                        end;
                    end;
                end;
            elseif where == "Gata/Mika" then
                return CommonF.Tp(HumRSelf, W.Section1.Monster.Trigger.CFrame);
            elseif where == "Gata/Hideo" then
                return CommonF.Tp(HumRSelf, GetPivot(W.Section1.HideoScene.Hideo2));
            elseif where == "School/Med" then
                local Prompt = W.Section2.Items.Bandage.Handle.ProximityPrompt;
                CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                return fireproximityprompt(Prompt, 1);
            elseif where == "School/Hideo" then
                return CommonF.Tp(HumRSelf, CFr(175, 8, 338));
            elseif where == "School/Heal" then
                local sRE = R.modules.Packet.Reliable;
                sRE:FireServer("Section2/HideoMinigameStarted");
                sRE:FireServer("Section2/HideoHealed");
                return sRE:FireServer("Section2/HideoMinigameEnded");
            elseif where == "School/Locker" then
                return CommonF.Tp(HumRSelf, CFr(143, 20, 504));
            elseif where == "School/Spider" then
                for i,v in pairs(GetChildren(W.Section2.MAINOBJECTIVE2.Spiders)) do
                    if v.Name ~= "AkariSpider" then continue; end;
                    local Hitbox = v.Hitbox;
                    CommonF.Tp(HumRSelf, Hitbox.CFrame, 0.3);
                    for i=1, 20 do
                        if not Hitbox or not Hitbox.Parent then
                            break;
                        end;
                        CAMERAREPLICA = Hitbox.CFrame;
                        R.GunAction:FireServer("fire");
                        Hitbox.RemoteEvent:FireServer();
                        twait(0.1);
                    end;
                end; CAMERAREPLICA = nil; return;
            elseif where == "Forest/Egao" then
                if PlaceId == 6243699076 then
                    QueuePack.SetInfo("Egao", true);
                    QueuePack.Init();
                    R.MimicSaveSync:FireServer(0,1);
                else
                    if QUEUE_INFO.Egao then
                        CommonF.Tween({primary = HumRSelf; goal = { CFrame = CFr(-3658, 8, 372) }; info=TweenInfo.new(3)});
                        local ISEGAO = false; PSG.EgaoPulseText.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
                            ISEGAO = true;
                        end); tk.delay(5 + game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000, function()
                            if not ISEGAO then
                                QueuePack.SetInfo("Egao", true);
                                QueuePack.Init();
                                GG.TeleportService:Teleport(6243699076, selff);
                            else
                                WindUI:Notify({
                                    Title = "<font color='rgb(255,0,0)'>EGAO</font>",
                                    Content = "IS HERE!",
                                    Icon = "circle-alert",
                                    Duration = 5,
                                });
                            end;
                        end);
                    end;
                end;
            elseif where == "Forest/Cave" then
                return CommonF.Tp(HumRSelf, W.Section3.OBJECTIVE.Trigger2.CFrame);
            elseif where == "Forest/Generator" then
                for i,v in pairs(GetChildren(W.Section3.OBJECTIVE.Circuits)) do
                    if v.Name == "CircuitPillar" then
                        v.CollisionPart.CanCollide = false;
                        CommonF.Tp(HumRSelf, v.CollisionPart.CFrame, 0.3);
                        fireproximityprompt(v.PromptPart.ProximityPrompt);
                        twait(1); for i=1, 3 do
                            R.modules.Packet.Reliable:FireServer(
                                "Section3/CircuitRoundComplete",
                                v
                            );
                        end;
                    end;
                end; return;
            elseif where == "IJO/Keycard" then
                local Prompt = W.Section4.Lab.Floor1.Entrance.IDCARD.ProximityPrompt;
                CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                return fireproximityprompt(Prompt, 1);
            elseif where == "IJO/PASS" then
                local Director = FindFirstChild(W.Section4.Lab.Floor1.Objective.DirectorSpawn, "Director");
                if not Director then return WindUI:Notify({
                    Title = "<font color='rgb(255,0,0)'>ALERT</font>",
                    Content = "Turn on the computer first.",
                    Icon = "circle-alert",
                    Duration = 5,
                }); end;
                local Card = FindFirstChild(Director, "IDCARD2");
                if Card then
                    CommonF.Tp(HumRSelf, Card.CFrame, 0.3);
                    fireproximityprompt(Card.ProximityPrompt, 1);

                    local Prompt = W.Section4.Lab.LockedDoors.MetalDoor.IDSCAN.Prompt.ProximityPrompt;
                    CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                    fireproximityprompt(Prompt, 1);
                end; local PASS = W.Section4.Lab.Floor1.Objective.StickyNote.PASSWORD.SurfaceGui.RandomNumber;
                CommonF.Tp(HumRSelf, CFr(-3424, -300, 4315), 0.3);
                R.modules.Packet.Unreliable:FireServer(
                    "Section4/LaptopSubmit",
                    PASS.Text
                );
            elseif where == "IJO/C4" then
                for _,v in pairs(GetChildren(W.Section4.Lab.Floor1.Objective2.C4Explode)) do
                    if v.Name ~= "C4Bomb" then continue; end;
                    local Prompt = FindFirstChild(v, "ProximityPrompt");
                    if Prompt and Prompt.Enabled then
                        CommonF.Tp(HumRSelf, v.CFrame, 0.3);
                        fireproximityprompt(Prompt, 1);
                    end;
                end; return;
            elseif where == "IJO/C4_2" then
                CommonF.Tween({primary = HumRSelf; goal = { CFrame = CFr(-4147, 107, 2154) }, info=TweenInfo.new(3)});
                CommonF.Tween({primary = HumRSelf; goal = { CFrame = CFr(-4143, 107, 2501) }, info=TweenInfo.new(3)});
                for _,v in pairs(GetChildren(W.Section4.Lab.Floor1.Objective3.C4Explode)) do
                    if v.Name ~= "C4Bomb" then continue; end;
                    local Prompt = FindFirstChild(v, "ProximityPrompt");
                    if Prompt and Prompt.Enabled then
                        CommonF.Tp(HumRSelf, v.CFrame, 0.3);
                        fireproximityprompt(Prompt, 1);
                    end;
                end; return;
            elseif where == "IJO/Terminal" then
                for _,v in pairs(GetChildren(W.Section4.Lab.CleanseRoomObjective.ShapeTerminals)) do
                    if v.Name ~= "Terminal" then continue; end;
                    local Prompt = FindFirstChild(v, "PromptPart");
                    Prompt = Prompt and FindFirstChild(Prompt, "ProximityPrompt");
                    if Prompt and Prompt.Enabled then
                        CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                        fireproximityprompt(Prompt, 1); twait(0.3);
                        R.modules.Packet.Reliable:FireServer(
                            "ShapeTerminal/RoundComplete",
                            v
                        );
                        R.modules.Packet.Reliable:FireServer(
                            "ShapeTerminal/Release",
                            v
                        );
                    end;
                end; return;
            elseif where == "IJO/Valve" then
                for _,v in pairs(GetChildren(W.Section4.Lab.CleanseRoomObjective.Valves)) do
                    if not IsA(v, "Model") then continue; end;
                    local Icon = v.Notification.Icon;
                    if not Icon.Enabled then continue; end;
                    local Chs = GetChildren(v);
                    while Icon.Enabled do
                        CommonF.Tp(HumRSelf, Icon.Parent.CFrame, 0.3); for i=1, #Chs do
                            local v2 = Chs[i]; if v2 and v2.Name == "Turners" then
                                local Prompt = FindFirstChild(v2, "Right");
                                if Prompt then
                                    fireproximityprompt(Prompt, 1);
                                end;
                            end;
                        end;
                    end;
                end;
            elseif where == "IJO/Threat" then
                return R.modules.Packet.Reliable:FireServer("Section4/LockdownSkillCheckHit");
            elseif where == "Water/Main" then
                local MainSwitch = W.Section5.MainObjective.PowerSwitch.RootPart.ProximityPrompt;
                CommonF.Tp(HumRSelf, MainSwitch.Parent.CFrame, 0.3);
                return fireproximityprompt(MainSwitch, 1);
            elseif where == "Water/Wire" then
                local sRE = R.modules.Packet.Reliable;
                for _,box in pairs(GetChildren(W.Section5.MainObjective.Boxes)) do
                    if box.Name ~= "WireBox" then continue; end;
                    if box.PromptPart.ProximityPrompt.Enabled then
                        CommonF.Tp(HumRSelf, box.PromptPart.CFrame, 0.3);
                        sRE:FireServer("Section5/WireBoxClaim", box);
                        sRE:FireServer("Section5/WireBoxClaim", box);

                        for _,v in pairs(GetChildren(box.Bolt)) do
                            if v.Name == "Screw" then
                                sRE:FireServer("Section5/WireBoxScrewDone", v);
                            end;
                        end;

                        for _,v in pairs(GetChildren(box.Cuttable)) do
                            if v.Name == "Cut" then
                                sRE:FireServer("Section5/WireBoxCutDone", v);
                            end;
                        end;

                        sRE:FireServer("Section5/WireBoxComplete", box);

                        box.PromptPart.ProximityPrompt.Enabled = false;
                    end;
                end;
            end;
        end;
        Functions.B3C1ESP = function(self, where, state)
            if not state then
                return ESPF.Destroy(where);
            elseif where == "Gatas" then
                local Gatas = self.B3C1GetGatas(); for i=1, #Gatas do
                    local v = Gatas[i]; if v then
                        ESPF.ESP(where, v.Hitbox, RED, VEC10, nil, nil, false, false);
                    end;
                end; return;
            elseif where == "Bodies" then
                local Bodies = GetChildren(W.Section1.DeadCivilians); for i=1, #Bodies do
                    local v = Bodies[i]; if v and v.Parent then
                        local Prompt = FindFirstChild(v, "HumanoidRootPart");
                        Prompt = Prompt and FindFirstChild(Prompt, "ProximityPrompt");
                        if Prompt then
                            ESPF.ESP(where, Prompt.Parent, GREEN, VEC2, nil, nil, false, false);
                        end;
                    end;
                end;
            elseif where == "Akari" then
                ESPF.ESP(where, W.Section2.Monster.Akari.Hitbox, RED, VEC10, nil, nil, false, false);
            elseif where == "Mizuno" then
                ESPF.ESP(where, W.Section3.Monster.Mizuno.Hitbox, RED, VEC10, nil, nil, false, false);
            elseif where == "HogoGuntai" then
                ESPF.ESP(where, W.Section4.Monster.HogoGuntai.Hitbox, RED, VEC10, nil, nil, false, false);
            elseif where == "Baigai" then
                ESPF.ESP(where, W.Section5.Monster.Baigai.Hitbox, RED, VEC10, nil, nil, false, false);
            end;
        end;
        Functions.JigokuFunc = function(where)
            if where == "Talk" then
                return CommonF.Tp(HumRSelf, CFr(607.54, 11.91, 1080));
            elseif where == "Complete" then
                for _,v in pairs(GetChildren(GameAI.Souls)) do
                    local Prompt = FindFirstChild(v, "ProximityPrompt");
                    if not Prompt or not Prompt.Enabled then continue; end;
                    CommonF.Tp(HumRSelf, v.CFrame, 0.3);
                    fireproximityprompt(Prompt, 1);
                end;
            end;
        end;
        Functions.CTFunc = function(self, where)
            if where == "Repair" then
                local Q1 = CTQuests["1"]; self:CTFunc("Talk");
                if FindFirstChild(Q1.Items, "Controls") then
                    CommonF.Tp(HumRSelf, Q1.Items.Controls.CFrame, 0.3);
                    fireproximityprompt(Q1.Items.Controls.ProximityPrompt, 1, true);
                end; if FindFirstChild(Q1.Items, "Ropes") then
                    CommonF.Tp(HumRSelf, Q1.Items.Ropes.CFrame, 0.3);
                    fireproximityprompt(Q1.Items.Ropes.ProximityPrompt, 1, true);
                end; if FindFirstChild(Q1.Items, "Extinguisher") then
                    CommonF.Tp(HumRSelf, Q1.Items.Extinguisher.CFrame, 0.3)
                    fireproximityprompt(Q1.Items.Extinguisher.ProximityPrompt, 1, true);
                end; if FindFirstChild(Q1.Items, "RepairPoint") then
                    CommonF.Tp(HumRSelf, Q1.Items.RepairPoint.CFrame, 0.3);
                    fireproximityprompt(Q1.Items.RepairPoint.ProximityPrompt, 1, true);
                end; return CommonF.Tp(HumRSelf, SAFESPOT);
            elseif where == "Collect" then
                self:CTFunc("Talk"); for _, v in pairs(GetChildren(CTQuests["2"].CollectToys)) do
                    if v and FindFirstChild(v, "ProximityPrompt") then
                        CommonF.Tp(HumRSelf, v.CFrame, 0.3);
                        fireproximityprompt(v.ProximityPrompt, 1, true);
                    end;
                end; return CommonF.Tp(HumRSelf, SAFESPOT);
            elseif where == "Talk" then
                CommonF.Tp(HumRSelf, W.NPCs.Elf.Elf.RootPart.CFrame, 0.3);
                return fireproximityprompt(W.NPCs.Elf.Elf.RootPart.ProximityPrompt, 1, true);
            elseif where == "Key" then
                local krampusH = GameAI.Krampus.HumanoidRootPart;
                CommonF.Tp(HumRSelf, krampusH.CFrame + (krampusH.CFrame.LookVector * -9), 0.3);
                fireproximityprompt(krampusH.ProximityPrompt, 1, true);
                return CommonF.Tp(HumRSelf, SAFESPOT);
            end;
        end;
        Functions.CTESP = function(state, where)
            if not state then
                return ESPF.Destroy(where);
            elseif where == "Krampus" then
                ESPF.ESP(where, GameAI.Krampus, RED, VEC10, nil, nil, false, false);
            elseif where == "Toys" then
                for _,v in pairs(GetChildren(W.Quests["2"].CollectToys)) do
                    ESPF.ESP(where, v, GREEN, VEC2, nil, nil, false, false);
                end;
            end;
        end;
        Functions.NMCSFunc = function(where)
            if where == "Jukebox" then
                return CommonF.Tp(HumRSelf, W.Section2.Cutscene.CutsceneMagician.WorldPivot);
            elseif where == "Cards" then
                local stage = FindFirstChild(W, "stage");
                if stage then stage:Destroy(); end;
                for i,v in pairs(GetChildren(W.Section2.Objective.PassCode)) do
                    if v then
                        for x,c in pairs(GetChildren(W.Section2.Objective.Cards)) do
                            if c.Parent.Name == "Cards" then
                                if c.Order.SurfaceGui.TextLabel.Text == v.Name then
                                    if v[c.Name].Transparency == 0 then continue; end;
                                    CommonF.Tp(HumRSelf, v.CFrame, 0.3); repeat
                                        fireproximityprompt(v.PROMPT, 1);
                                        twait(0.5);
                                    until v[c.Name].Transparency == 0;
                                end;
                            end;
                        end;
                    end;
                end; return;
            end;
        end;
        Functions.NMCSESP = function(where, state)
            if not state then
                return ESPF.Destroy(where);
            elseif where == "Clown" then
                return ESPF.ESP(where, W.Section1.Monster.Clown.Hitbox, RED, VEC10, false, true, false, false);
            end;
        end;

        CoruTask.New("Sama", function()
            if PlaceId ~= 7251867574 and PlaceId ~= 7265397848 then
                return;
            end; while true do
                for i,v in pairs(GetChildren(W.GameHearts)) do
                    if not B1C4Con["Auto Kill Sama"] or CoreDestroyed then
                        CoruTask.Close("Sama");
                    end; repeat
                        if Cam.FieldOfView > 71 then
                            repeat
                                CommonF.Tp(HumRSelf, CFr(2823, 155, 2490)); twait(0.03);
                            until not B1C4Con["Auto Kill Sama"] or Cam.FieldOfView < 71 or CoreDestroyed;
                        end; local pos = tostring(v.Root.CFrame.Position); local prefix = str.sub(pos, 1, 2);
                        local tpCF, camCF = ScriptData.SamaHeartPos[prefix], ScriptData.SamaHeartCam[prefix];
                        local katana = FindFirstChild(Backpack, "Katana");
                        if katana then CommonF.HumanoidEquip(HumSelf, katana); end;
                        repeat
                            if tpCF then CommonF.Tp(HumRSelf, tpCF); end;
                            if camCF then Cam.CFrame = camCF; end;
                            local equippedKatana = selc and FindFirstChild(selc, "Katana");
                            if not equippedKatana then break; end;
                            equippedKatana:Activate();
                            if FindFirstChild(v, "Destroyed") then
                                break;
                            end; twait(0.1);
                        until Cam.FieldOfView > 71 or not B1C4Con["Auto Kill Sama"] or CoreDestroyed;
                        twait(0.1);
                    until FindFirstChild(v, "Destroyed") or not B1C4Con["Auto Kill Sama"] or CoreDestroyed;
                end; twait(0.1);
            end;
        end);
        CoruTask.New("Saigomo", function()
            if PlaceId ~= 7251867574 and PlaceId ~= 7265397848 then
                return;
            end; local BossBattle, Saigomo, HumRSai, Sound = nil, nil, nil, nil;
            while true do
                if not B1C4Con["Auto Kill Saigomo"] or CoreDestroyed then
                    CoruTask.Close("Saigomo");
                end; if Sound and Sound.Parent then break; end;
                BossBattle = FindFirstChild(W, "BossBattle");
                Saigomo = BossBattle and FindFirstChild(BossBattle, "Saigomo");
                HumRSai = Saigomo and FindFirstChild(Saigomo, "HumanoidRootPart");
                Sound = HumRSai and FindFirstChild(HumRSai, "roar");
                CommonF.Tp(HumRSelf, CFr(2718.18, 266.32, 2537.03), 0.3);
                if Sound and Sound.Parent then
                    for _,v in pairs(GetDescendants(Saigomo)) do
                        if v.Name == "SpiderHitbox" then
                            v.Size = Vec3(50, 50, 50);
                        end; if IsA(v, "TouchTransmitter") then
                            v:Destroy();
                        end;
                    end;
                end; twait(0.1);
            end; while true do
                if not B1C4Con["Auto Kill Saigomo"] or CoreDestroyed then
                    CoruTask.Close("Saigomo");
                end; if B1C4Con["Auto Kill Saigomo"] and ScriptCache.SaigomoKilling == nil then
                    local hb = nil; hb = H.Heartbeat:Connect(function()
                        if not selc or not selc.Parent then return; end;
                        if not HumRSelf or not HumRSelf.Parent then return; end;
                        if not HumRSai or not HumRSai.Parent then return; end;
                        if not Sound or not Sound.Parent then return; end;
                        if not B1C4Con["Auto Kill Saigomo"] or SystemStackDestroy then
                            ScriptCache.SaigomoKilling = nil;
                            return hb:Disconnect();
                        end; local Katana = FindFirstChild(Backpack, "Katana");
                        if Katana then CommonF.HumanoidEquip(HumSelf, Katana); end;
                        local KatanaSelc = FindFirstChild(selc, "Katana");
                        if not KatanaSelc or not KatanaSelc.Parent then return; end;
                        if Sound.IsPlaying then
                            CommonF.Tp(HumRSelf, CFr(2718.18, 266.32, 2537.03), 6.3);
                        else
                            CommonF.Tp(HumRSelf, HumRSai.CFrame + HumRSai.CFrame.RightVector * -20);
                            KatanaSelc:Activate();
                        end;
                    end); ScriptCache.SaigomoKilling = hb;
                end; twait(0.1);
            end;
        end);
        CoruTask.New("Cook", function()
            if PlaceId ~= 13489800654 then
                CoruTask.Close("Cook");
            end; while true do
                if not B2C2Con.AutoCook or CoreDestroyed then
                    CoruTask.Close("Cook");
                end; if not PSG.CookingUI.Timer.Visible then
                    twait(0.1); continue;
                end; if not ScriptCache.BarrierCook then
                    for _, v in pairs(GetDescendants(W)) do
                        if v.Name == "Barrier" and IsA(v, "Part") and dist(v.Position) <= 100 then
                            v:Destroy();
                        end;
                    end; ScriptCache.BarrierCook = true;
                end; local Descen, Order270 = GetDescendants(W), "nil";
                local matches, selectedObject = {}, nil; for _, v in pairs(Descen) do
                    if v.Name == "Orders" then
                        if FindFirstChild(v, "Ham Stew") then
                            Order270 = "Ham Stew";
                            tble.insert(matches, Order270);
                        elseif FindFirstChild(v, "Chicken Soup") then
                            Order270 = "Chicken Soup";
                            tble.insert(matches, Order270);
                        elseif FindFirstChild(v, "Spaghetti N Eyeballs") then
                            Order270 = "Spaghetti N Eyeballs";
                            tble.insert(matches, Order270);
                        end;
                    end;
                end; if #matches > 0 then
                    local selectedIndex = math.random(1, #matches);
                    selectedObject = matches[selectedIndex];
                    if selectedObject == "Ham Stew" then
                        Functions.GetPot(Descen);
                        Functions.PlaceCoun(Descen);
                        Functions.GrabFood("Ham");
                        Functions.ToPot(Descen);
                        Functions.GrabFood("Sausage");
                        Functions.ToPot(Descen);
                        Functions.PlaceCoun(Descen);
                        Functions.ToStove();
                        twait(10); if not B2C2Con.AutoCook or CoreDestroyed then
                            continue;
                        end; Functions.GetBowl(Descen);
                        Functions.PlaceCoun(Descen);
                        Functions.ToStove();
                        Functions.PlaceCoun(Descen);
                        Functions.PlaceCoun(Descen);
                        twait(0.3);
                        Functions.TurnInFood(Descen);
                        twait(0.3);
                    elseif selectedObject == "Chicken Soup" then
                        Functions.GetPot(Descen);
                        Functions.PlaceCoun(Descen);
                        Functions.GrabFood("Chicken");
                        Functions.ToPot(Descen);
                        Functions.GrabFood("Wrapped Meat");
                        Functions.ToPot(Descen);
                        Functions.GrabFood("Cheese");
                        Functions.ToPot(Descen);
                        Functions.ToPot(Descen);
                        Functions.ToStove();
                        twait(10); if not B2C2Con.AutoCook or CoreDestroyed then
                            continue;
                        end; Functions.GetBowl(Descen);
                        Functions.PlaceCoun(Descen);
                        Functions.ToStove();
                        Functions.PlaceCoun(Descen);
                        Functions.PlaceCoun(Descen);
                        twait(0.3);
                        Functions.TurnInFood(Descen);
                        twait(0.3);
                    elseif selectedObject == "Spaghetti N Eyeballs" then
                        Functions.GetBowl(Descen);
                        Functions.PlaceCoun(Descen);
                        Functions.GrabFood("Eyeball");
                        Functions.PlaceCoun(Descen);
                        Functions.GrabFood("Spaghetti");
                        Functions.PlaceCoun(Descen);
                        Functions.PlaceCoun(Descen);
                        twait(0.3);
                        Functions.TurnInFood(Descen);
                        twait(0.3);
                    end;
                end; twait(0.1);
            end;
        end);
        CoruTask.New("Mother", function()
            if PlaceId ~= 13489800654 then
                CoruTask.Close("Mother");
            end; local mother = nil; while true do
                if not B2C2Con["Anti Mother"] or CoreDestroyed then
                    CoruTask.Close("Mother");
                end; mother = mother or (function()
                    for _, part in pairs(GetDescendants(W)) do
                        if part.Name == "HumanoidRootPart" and part.Parent.Name == "Mother" then
                            return part;
                        end;
                    end;
                end)(); if mother then
                    if dist(mother.Position) <= 150 then
                        return CommonF.Tp(HumRSelf, CF.new(-4334.81299, 690.94397, -2363.2771));
                    end;
                end; twait(0.1);
            end;
        end);
        CoruTask.New("Cannon+Lazer", function()
            if PlaceId ~= 13489800654 then
                CoruTask.Close("Cannon+Lazer");
            end; while true do
                if (not B2C2Con["Auto Get Cannon Balls"] and not B2C2Con["Anti Nagisa Beam"]) or CoreDestroyed then
                    CoruTask.Close("Cannon+Lazer");
                end; if B2C2Con["Auto Get Cannon Balls"] then
                    Functions:GetCannonBalls();
                end; if B2C2Con["Anti Nagisa Beam"] then
                    Functions:AntiNagisaLaser();
                end; twait(0.1);
            end;
        end);
        CoruTask.New("Nagisa Serpent", function()
            if PlaceId ~= 13489800654 then
                CoruTask.Close("Nagisa Serpent");
            end;
            
            local NaConnection = nil;
            local TailHitbox   = nil;
            local DebNow       = false;

            while true do
                if not B2C2Con["Auto Kill Nagisa Serpent"] or CoreDestroyed then
                    if NaConnection then
                        NaConnection:Disconnect();
                        NaConnection = nil;
                        CommonF.Tp(HumRSelf, CFr(1982.58, 100, -4780.12));
                    end; CoruTask.Close("Nagisa Serpent");
                end; if not NaConnection then
                    NaConnection = H.RenderStepped:Connect(function()
                        if DebNow then return; end; if TailHitbox then
                            local Cutlass_BP = FindFirstChild(Backpack, "Cutlass");
                            local Cutlass_Char = selc and FindFirstChild(selc, "Cutlass");
                            if not Cutlass_BP and not Cutlass_Char then
                                DebNow = true; local Prompt = CommonF.findPrompt(GetDescendants(W), function(v)
                                    return v.Parent.Parent.Name == "CutlassGiverModel" and IsA(v.Parent, "BasePart");
                                end); if Prompt then
                                    CommonF.Tp(HumRSelf, Prompt.Parent.CFrame, 0.3);
                                    fireproximityprompt(Prompt, 1); twait(0.3);
                                    DebNow = false; return;
                                end;
                            elseif Cutlass_BP and Cutlass_BP.Parent == Backpack then
                                DebNow = true; CommonF.HumanoidEquip(HumSelf, Cutlass_BP);
                                DebNow = false; return;
                            elseif Cutlass_Char and Cutlass_Char.Parent == selc then
                                if TailHitbox then
                                    DebNow = true; repeat
                                        CommonF.Tp(HumRSelf, TailHitbox.CFrame);
                                        Cutlass_Char:Activate(); twait(0.1);
                                    until FindFirstChild(TailHitbox, "TouchInterest") or not Cutlass_Char or not Cutlass_Char.Parent or Cutlass_Char.Parent == Backpack or not B2C2Con["Auto Kill Nagisa Serpent"];
                                    if FindFirstChild(TailHitbox, "TouchInterest") then
                                        repeat
                                            CommonF.Tp(HumRSelf, CFr(1972, 100, -4772));
                                            twait(0.05);
                                        until not FindFirstChild(TailHitbox, "TouchInterest") or not B2C2Con["Auto Kill Nagisa Serpent"];
                                    end; DebNow = false;
                                end;
                            end;
                        else
                            for i, v in pairs(GetDescendants(W)) do
                                if v.Name == "TailHitbox1" then
                                    TailHitbox = v;
                                    break;
                                end;
                            end;
                        end;
                    end);
                end; twait(0.1);
            end;
        end);
        CoruTask.New("Yurei", function()
            if PlaceId ~= 15962819441 then
                CoruTask.Close("Yurei");
            end;
            
            local Yurei = nil;
            
            while true do
                if not B2C3Con["Auto Kill Yurei"] or CoreDestroyed then
                    PSG.PlayerScripts.Camera.Enabled = true;
                    CoruTask.Close("Yurei");
                end;

                if PSG.BossFight.Enabled then
                    Yurei = Yurei or FindFirstChild(W.Section5.Boss.MonsterFolder, "YureiNM") or FindFirstChild(W.Section5.Boss.MonsterFolder, "Yurei");
                    local KatanaData = 0; ForceFloat = true; if dist(Vec3(-2717, 172, 8059)) > 500 then
                        if not FindFirstChild(Backpack, "Katana") then
                            PSG.PlayerScripts.Camera.Enabled = true;
                            Functions:B2C3Func("Boss/Katanas");
                            ForceFloat = true;
                        end; if FindFirstChild(Backpack, "Katana") then
                            CommonF.HumanoidEquip(HumSelf, selff.Backpack.Katana);
                        end; if dist(Vec3(-2717, 172, 8059)) > 500 and FindFirstChild(selc, "Katana") then
                            PSG.PlayerScripts.Camera.Enabled = false; CommonF.Tp(HumRSelf, Yurei.Body.CFrame * CFr(0, -40, 0));
                            W.Camera.CFrame = CFr(selc.Head.Position, Yurei.Body.Position);
                            twait(0.3); if FindFirstChild(selc, "Katana") then
                                selc.Katana:Activate();
                            end;
                        end;
                    end;
                end; twait(0.1);
            end;
        end);
        CoruTask.New("EnzukaiRyu", function()
            if PlaceId ~= 96354063422506 then
                CoruTask.Close("EnzukaiRyu");
            end;

            local EnzukaiRyu = WaitForChild(W.Section4.BossMonster, "EnzukaiRyu", 9e9);
            
            while true do
                if not B2C4Con["Auto Kill Enzukai-Ryu"] or CoreDestroyed then
                    ForceFloat = "None";
                    CoruTask.Close("EnzukaiRyu");
                end;

                if not EnzukaiRyu or not EnzukaiRyu.Parent or PSG.S4.Health.Front.Size == DIM0010 then
                    twait(0.1);
                    continue;
                end;

                if GetAttribute(EnzukaiRyu, "State") == 0 then
                    CommonF.Tp(HumRSelf, CFr(46, 140, -2854));
                end; if GetAttribute(EnzukaiRyu, "Mover_StartPivot") == nil then
                    CommonF.Tp(HumRSelf, CFr(46, 140, -2854));
                else
                    local SpiritBow = FindFirstChild(Backpack, "SpiritBow") or FindFirstChild(selc, "SpiritBow");
                    ForceFloat = true; if PSG.S4.Frame.Visible then
                        local EnzukaiRyuPos = EnzukaiRyu.Hitbox.CFrame;
                        CommonF.Tp(HumRSelf, CFr(Vec3(EnzukaiRyuPos.Position.X, EnzukaiRyuPos.Position.Y + 10, EnzukaiRyuPos.Position.Z) - EnzukaiRyuPos.LookVector * 100));
                        if SpiritBow.Parent ~= selc then
                            CommonF.HumanoidEquip(HumSelf, SpiritBow);
                        else if not Functions.OnGoingMagicArrow then
                                tk.spawn(function()
                                    return Functions:MagicArrowHit(SpiritBow, EnzukaiRyu.Hitbox, 0.7);
                                end);
                            end;
                        end;
                    else local target = nil; for _,v in pairs(GetChildren(W.Section4.WeakPoints.Points)) do
                        if v then
                            if v.RootPart.Icon.Enabled then
                                target = v;
                            end;
                        end;
                    end; repeat
                            EnzukaiRyu = FindFirstChild(W.Section4.BossMonster, "EnzukaiRyu"); if target then
                                local TargetCF, Target = nil, nil;
                                if target.EyeA.Transparency == 0 then Target = target.HitBoxA; end;
                                if target.EyeB.Transparency == 0 then Target = target.HitBoxB; end;
                                if target.EyeC.Transparency == 0 then Target = target.HitBoxC; end;
                                if target.EyeD.Transparency == 0 then Target = target.HitBoxD; end;
                                if target.EyeE.Transparency == 0 then Target = target.HitBoxE; end;
                                if not Target then break; end;
                                TargetCF = Target.CFrame;
                                CommonF.Tp(HumRSelf, CFr(Vec3(TargetCF.Position.X, 50, TargetCF.Position.Z) + TargetCF.UpVector * 20));
                                if SpiritBow.Parent ~= selc then
                                    CommonF.HumanoidEquip(HumSelf, SpiritBow);
                                else
                                    SpiritBow.RemoteEvent:FireServer(0, true); twait(2.5);
                                    SpiritBow.RemoteEvent:FireServer(0, false, Functions.GetLVecFromCLook(Target, SpiritBow)); twait(0.3);
                                end;
                            end; twait();
                        until PSG.S4.Frame.Visible or target or not target.Parent or not FindFirstChild(target, "RootPart") or (FindFirstChild(target, "RootPart") and not target.RootPart.Icon.Enabled) or CoreDestroyed or not EnzukaiRyu or not EnzukaiRyu.Parent or not B2C4Con["Auto Kill Enzukai-Ryu"];
                    end;
                end; twait();
            end;
        end);
        CoruTask.New("EnzukaiMobs", function()
            if PlaceId ~= 96354063422506 then
                CoruTask.Close("EnzukaiMobs");
            end;

            local Tsukiya2 = WaitForChild(W.Section4.Monster4, "Tsukiya2", 9e9);
            local Rin2 = WaitForChild(W.Section4.Monster2, "Rin2", 9e9);
            local Tenome2 = WaitForChild(W.Section4.Monster3, "Tenome2", 9e9);

            while true do
                if not B2C4Con["Auto Kill Enzukai Followers"] or CoreDestroyed then
                    ForceFloat = "None";
                    CoruTask.Close("EnzukaiMobs");
                end;
                
                if PSG.S4.Health.Front.Size ~= DIM0010 then
                    WindUI:Notify({
                        Title = "<font color='rgb(255,0,0)'>ALERT</font>",
                        Content = "Kill Enzukai-Ryu first.",
                        Icon = "circle-alert",
                        Duration = 20,
                    }); twait(2); continue;
                end;

                local SpiritBow = FindFirstChild(Backpack, "SpiritBow") or FindFirstChild(selc, "SpiritBow");
                local TargetMob, TargetMobCFrame = nil; if Tsukiya2 and Tsukiya2.Parent then
                    if GetAttribute(Tsukiya2, "State") == 0 then
                        CommonF.Tp(HumRSelf, Tsukiya2.HumanoidRootPart.CFrame, 0.3);
                        fireproximityprompt(Tsukiya2.HumanoidRootPart.ProximityPrompt, 1);
                    else
                        TargetMob = Tsukiya2.HumanoidRootPart;
                    end;
                end; if Rin2 and Rin2.Parent then
                    if GetAttribute(Rin2, "State") == 0 then
                        CommonF.Tp(HumRSelf, Rin2.HumanoidRootPart.CFrame, 0.3);
                        fireproximityprompt(Rin2.HumanoidRootPart.ProximityPrompt, 1);
                    else
                        TargetMob = Rin2.HumanoidRootPart;
                    end;
                end; if Tenome2 and Tenome2.Parent then
                    if GetAttribute(Tenome2, "State") == 0 then
                        CommonF.Tp(HumRSelf, Tenome2.HumanoidRootPart.CFrame, 0.3);
                        fireproximityprompt(Tenome2.HumanoidRootPart.ProximityPrompt, 1);
                    else
                        TargetMob = Tenome2.HumanoidRootPart;
                    end;
                end; if not Tsukiya2.Parent and not Rin2.Parent and not Tenome2.Parent then
                    return;
                end; ForceFloat = true;
                
                if TargetMob and TargetMob.Parent then
                    TargetMobCFrame = TargetMob.CFrame;
                end; CommonF.Tp(HumRSelf, CFr(Vec3(TargetMobCFrame.Position.X, TargetMobCFrame.Position.Y, TargetMobCFrame.Position.Z) + TargetMobCFrame.LookVector * 20));

                if SpiritBow.Parent ~= selc then
                    CommonF.HumanoidEquip(HumSelf, SpiritBow);
                else
                    if not Functions.OnGoingMagicArrow then
                        tk.spawn(function()
                            return Functions:MagicArrowHit(SpiritBow, TargetMob, 0.7);
                        end);
                    end;
                end; twait();
            end;
        end);
        CoruTask.New("EnzukaiJin", function()
            if PlaceId ~= 96354063422506 then
                CoruTask.Close("EnzukaiJin");
            end;

            local IsPauseB      = false;
            local EnzukaiRyujin = WaitForChild(W.Section5.FinalForm, "EnzukaiRyujin", 9e9);

            tk.spawn(function()
                while true do
                    if not IsPauseB then
                        if GetAttribute(W.Section5.FinalForm.EnzukaiRyujin.VAnimator.Slam, "IsPlaying") == true then
                            CommonF.Tp(HumRSelf, CFr(53.280338287353516, 5.957849025726318, -0.8933286666870117));
                        end;
                    end; twait();
                end;
            end);

            while true do
                if not B2C4Con["Auto Kill Final Boss"] or CoreDestroyed then
                    IsPauseB = true;
                    ForceFloat = "None";
                    CoruTask.Close("EnzukaiJin");
                end;

                if EnzukaiRyujin and EnzukaiRyujin.Parent then
                    ForceFloat = true; IsPauseB = false;

                    local SpiritBow = FindFirstChild(Backpack, "SpiritBow") or FindFirstChild(selc, "SpiritBow");
                    
                    if GetAttribute(W.Section5.FinalForm.EnzukaiRyujin.VAnimator.Slam, "IsPlaying") == true then
                        CommonF.Tp(HumRSelf, CFr(53.280338287353516, 5.957849025726318, -0.8933286666870117));
                    else
                        if PSG.S5.Frame.Visible then
                            if EnzukaiRyujin and EnzukaiRyujin.Parent then
                                if SpiritBow and SpiritBow.Parent ~= selc then
                                    CommonF.HumanoidEquip(HumSelf, SpiritBow);
                                end; CommonF.Tp(HumRSelf, W.Section5.FinalForm.EnzukaiRyujin.HeadHitBox.CFrame * CFr(-20, 0, 0));              
                                if not Functions.OnGoingMagicArrow then
                                    tk.spawn(function()
                                        return Functions:MagicArrowHit(SpiritBow, EnzukaiRyujin.HeadHitBox, 0.5);
                                    end);
                                end;
                            end;
                        else
                            local target = nil; for _,v in pairs(GetChildren(W.Section5.WeakPoints.Points)) do
                                if v then
                                    if v.animated.Value ~= -40 then
                                        target = v;
                                    end;
                                end;
                            end; repeat
                                if GetAttribute(W.Section5.FinalForm.EnzukaiRyujin.VAnimator.Slam, "IsPlaying") == true then
                                    CommonF.Tp(HumRSelf, CFr(53.280338287353516, 5.957849025726318, -0.8933286666870117));
                                elseif target then
                                    local TargetCF, Target = nil;
                                    if target.EyeA.Transparency == 0 then Target = target.HitBoxA; end;
                                    if target.EyeB.Transparency == 0 then Target = target.HitBoxB; end;
                                    if target.EyeC.Transparency == 0 then Target = target.HitBoxC; end;
                                    if target.EyeD.Transparency == 0 then Target = target.HitBoxD; end;
                                    if target.EyeE.Transparency == 0 then Target = target.HitBoxE; end;
                                    if not Target then twait(0.1); continue; end;
                                    if Target then TargetCF = Target.CFrame; end;
                                    if TargetCF then
                                        local h = 50; if GetAttribute(W.Section5.FinalForm.Moves.EyeballLaser.Eyeball, "Active") == true then
                                            h = 80;
                                        end; CommonF.Tp(HumRSelf, CFr(Vec3(TargetCF.Position.X, TargetCF.Position.Y + h, TargetCF.Position.Z) + TargetCF.UpVector * 20));
                                        if SpiritBow and SpiritBow.Parent ~= selc then
                                            CommonF.HumanoidEquip(HumSelf, SpiritBow);
                                        else
                                            SpiritBow.RemoteEvent:FireServer(0, true); twait(1.7);
                                            SpiritBow.RemoteEvent:FireServer(0, false, Functions.GetLVecFromCLook(Target, SpiritBow)); twait(0.3);
                                        end;
                                    end;
                                end; twait();
                            until PSG.S5.Frame.Visible or not target or not target.Parent or (FindFirstChild(target, "animated") and target.animated.Value == -40) or CoreDestroyed;
                        end;
                    end;
                end; twait();
            end;
        end);
        CoruTask.New("Ringmaster", function()
            if PlaceId ~= 11126398230 then
                return;
            end;
            
            local AnimationControllerRing = nil;
            local LeftHitbox = WaitForChild(W.Section3.Boss.MagicianBoss, "LeftHitbox", 9e9);
            local RightHitbox = WaitForChild(W.Section3.Boss.MagicianBoss, "RightHitbox", 9e9);
            local DeathMic = WaitForChild(W.Section3.Boss.MagicianBoss.Parent, "Death", 9e9);
            local Knife, AnimationSpeed = nil, nil;
            local RingmasterSafePos = CFr(-1654.51294, 28.076046, -969.053711);

            while true do
                if not NMCSCon.Ringmaster.AutoKill or CoreDestroyed then
                    if AnimationControllerRing then
                        AnimationControllerRing:Disconnect();
                        AnimationControllerRing = nil;
                    end; CoruTask.Close("Ringmaster");
                end;

                if not AnimationControllerRing then
                    AnimationControllerRing = W.Section3.Boss.MagicianBoss.AnimationController.AnimationPlayed:Connect(function(anima)
                        if not LeftHitbox  or not RightHitbox then return; end;
                        ForceFloat = true; AnimationSpeed = anima;
                        AttackPart = ((RightHitbox.Position.Y > LeftHitbox.Position.Y) and RightHitbox) or ((LeftHitbox.Position.Y > RightHitbox.Position.Y) and LeftHitbox) or RightHitbox;
                    end);
                end;

                if DeathMic and (DeathMic.IsPlaying or DeathMic.Playing) then return; end;
                if AnimationSpeed and AnimationSpeed.Speed < 0.1 then
                    Knife = FindFirstChild(Backpack, "Knife") or FindFirstChild(selc, "Knife");
                    if Knife and Knife.Parent == Backpack then
                        CommonF.HumanoidEquip(HumSelf, Knife);
                        twait(0.3);
                    elseif not Knife or not Knife.Parent then
                        CommonF.Tp(HumRSelf, W.Section3.Boss.WeaponGiver.WorldPivot, 0.3);
                        fireproximityprompt(W.Section3.Boss.WeaponGiver.ProxPart.ProximityPrompt, 1);
                    end;
                    
                    if Knife and AttackPart and Knife.Parent == selc then
                        CommonF.Tp(HumRSelf, AttackPart.CFrame);
                        Knife:Activate();
                    end;
                else
                    CommonF.Tp(HumRSelf, RingmasterSafePos);
                end; twait();
            end;
        end);
        CoruTask.New("Fly", function()
            local BG = Instancen("BodyGyro", HumRSelf);
            local BV = Instancen("BodyVelocity", HumRSelf);
            local FSpeed = 0; while true do
                if not ClientCon["Enable Fly"] or CoreDestroyed then
                    Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0};
                    FSpeed = 0; BG:Destroy(); BV:Destroy(); CoruTask.Close("Fly");
                end;
                
                if not HumRSelf or not HumRSelf.Parent then
                    Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0};
                    FSpeed = 0; BG=nil; BV=nil; CoruTask.Close("Fly");
                end;

                if not BG or not BG.Parent then
                    BG = Instancen("BodyGyro", HumRSelf);
                    BV = Instancen("BodyVelocity", HumRSelf);
                    BG.P = 9e4; BG.CFrame = HumRSelf.CFrame;
                    BV.MaxForce = Vec3(9e9, 9e9, 9e9);
                    BG.MaxTorque = Vec3(9e9, 1e9, 9e9);
                    BV.Velocity = Vector3.zero;
                end; if isMobile then
                    local direction = controlModule:GetMoveVector();
                    Control.L = direction.X < 0 and -1 * ClientCon.FlySpeed or 0;
                    Control.R = direction.X > 0 and  1 * ClientCon.FlySpeed or 0;
                    Control.F = direction.Z < 0 and  1 * ClientCon.FlySpeed or 0;
                    Control.B = direction.Z > 0 and -1 * ClientCon.FlySpeed or 0;

                    if Control.R ~= 0 then
                        BV.Velocity = BV.Velocity + Cam.CFrame.RightVector * (Control.R * 50);
                    end
                    if Control.L ~= 0 then
                        BV.Velocity = BV.Velocity + Cam.CFrame.RightVector * (Control.L * 50);
                    end
                    if Control.B ~= 0 then
                        BV.Velocity = BV.Velocity - Cam.CFrame.LookVector * (-Control.B * 50);
                    end
                    if Control.F ~= 0 then
                        BV.Velocity = BV.Velocity - Cam.CFrame.LookVector * (-Control.F * 50);
                    end
                    if Control.R == 0 and Control.L == 0 and Control.F == 0 and Control.B == 0 then
                        BV.Velocity = Vector3.zero;
                    end;
                else
                    if (Control.L + Control.R) ~= 0 or (Control.F + Control.B) ~= 0 or (Control.Q + Control.E) ~= 0 then
                        FSpeed = 50;
                    elseif not (Control.L + Control.R ~= 0 or Control.F + Control.B ~= 0 or (Control.Q + Control.E) ~= 0) and FSpeed ~= 0 then
                        FSpeed = 0;
                    end;
                    if (Control.L + Control.R) ~= 0 or (Control.F + Control.B) ~= 0 or (Control.Q + Control.E) ~= 0 then
                        BV.Velocity = ((Cam.CFrame.LookVector * (Control.F + Control.B)) + 
                            ((Cam.CFrame * CFr(Control.L + Control.R, 
                            (Control.F + Control.B + Control.Q + Control.E) * 0.2, 0).p) - 
                            Cam.CFrame.p)) * FSpeed;
                    else
                        BV.Velocity = Vector3.zero;
                    end;
                end; twait(0.1);
            end;
        end);
        CoruTask.New("Yen", function()
            local MimicCurrencySpawns = WaitForChild(W, "MimicCurrencySpawns", 10);
            if not MimicCurrencySpawns then return; end;

            while true do
                if not YenCon.Aura and not YenCon.ESP then
                    ESPF.Destroy("Yen");
                    CoruTask.Close("Yen");
                end; Functions.YenFunc(MimicCurrencySpawns);
                twait(0.1);
            end;
        end);

        ScriptData.AutoData = {
            ClientTab = {
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Free Yourself", EN2="Auto free yourself if the game ask you to do the quick time event.", TH1="ออโต้หลบหนี", TH2="ออโต้กด E เวลามีมินิเกม Free yourself ขึ้นมา", Path="Client/Auto Free Yourself"},
                        {type="Button", EN="Visual Lantern", EN2="Give you all lanterns in lobby.", TH1="โคมไฟปลอมๆ", TH2="ใช้ใน Lobby", Callback=Functions.GiveLantern},
                        {type="Toggle", EN="Full Bright", EN2="Make the game brighter, easier to see or look around.", TH1="แมพสว่าง", TH2="มองเห็นง่ายขึ้น", Path="Client/Full Bright"},
                        {type="Toggle", EN="Instant Prompt", EN2="On some prompt/maps, this can flag anti cheat so remember to turn it off when you have to.", TH1="กด Prompt เร็วขึ้น", TH2="กดพวกปุ่มที่มันขึ้นมาให้กดเร็วขึ้น (Class:Prompt)", Path="Client/Instant Prompt"},
                        {type="Toggle", EN="Float", EN2="Make your character float in the air.", TH1="ลอย", TH2="ทำให้ตัวละครเดินบนอากาศได้", Path="Client/Float"},
                        {type="Toggle", EN="Noclip", EN2="Allow you to walk through walls.", TH1="เดินทะลุกำแพง", TH2="ต้องอธิบายด้วยหรอ", Path="Client/Noclip"},
                        {type="Slider", EN="Walk Speed", EN2="Change the speed of your walk.", TH1="ความเร็วในการเดิน", TH2="ปรับความเร็วการเดิน", Value={Min=1, Max=100}, Locked=PlaceId==128715637193371, Path="Client/WalkSpeed"},
                        {type="Toggle", EN="Enable Walk Speed", EN2="Enable walk speed modification.", TH1="เปิดใช้งานความเร็วในการเดิน", TH2="ปรับความเร็วในการเดิน", Locked=PlaceId==128715637193371, Path="Client/Enable WalkSpeed"},
                        {type="Slider", EN="Teleport Walk Speed", EN2="Change the speed of teleport walk.", TH1="ความเร็วในการเดินแบบวาร์ป", TH2="ปรับความเร็วในการเดินแบบวาร์ป", Value={Min=1, Max=10}, Path="Client/TeleportWalk Speed"},
                        {type="Toggle", EN="Enable Teleport Walk", EN2="Enable teleport walk.", TH1="เปิดใช้งานเดินแบบวาร์ป", TH2="เปิดใช้งานเดินโดยการวาร์ปไปเรื่อยๆ", Path="Client/Enable TeleportWalk"},
                        {type="Slider", EN="Jump Power", EN2="Change the power of your jump.", TH1="ความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Value={Min=1, Max=300}, Locked=PlaceId==128715637193371, Path="Client/JumpPower"},
                        {type="Toggle", EN="Enable Jump Power", EN2="Enable jump power modification.", TH1="เปิดใช้งานความแรงในการกระโดด", TH2="ปรับความแรงในการกระโดด", Locked=PlaceId==128715637193371, Path="Client/Enable JumpPower"},
                        {type="Slider", EN="Fly Speed", EN2="Change the speed of your flight.", TH1="ความเร็วในการบิน", TH2="ปรับความเร็วในการบิน", Value={Min=1, Max=10} , Locked=PlaceId==128715637193371, Path="Client/FlySpeed"},
                        {type="Toggle", EN="Enable Fly", EN2="Allow you to fly.", TH1="บิน", TH2="บินได้", Locked=PlaceId==128715637193371, Path="Client/Enable Fly"},
                    }, Title="Client", Open=true};
                }};
            };
            YenTab = {
                {type="Toggle", EN="Yen Aura", EN2="Auto collect nearby Yen.", TH1="ออโต้เก็บเงิน", TH2="ออโต้เก็บเงินในระยะ", Path="Aura"},
                {type="Toggle", EN="ESP Yen", EN2="Show Yen boxes.", TH1="ESP เงิน", TH2="มองเห็นเงิน", Path="ESP"},
            };
            EmoteTab = {
                {type="Group", dats={
                    {dat={
                        {type="Dropdown", Title="Select Emote", Values=(function()
                            local tbl={}; for i,_ in pairs(TheMimicPaints.Emotes) do
                                tble.insert(tbl, i);
                            end; return tbl;
                        end)(); Path="Select Emote"},
                        {type="Button", EN="Play Emote", EN2="Play selected emote.", TH1="เล่น Emote", TH2="เล่น Emote ที่เลือก", Callback=Functions.PlayEmote};
                        {type="Button", EN="Cancel Emote", EN2="Cancel selected emote.", TH1="หยุด Emote", TH2="หยุด Emote", Callback=Functions.StopEmote};
                    }, Title="Emote", Open=true};
                }};
            };
            B1C1Tab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete Game", EN2="Teleport to the end of the game.", TH1="ออโต้จบเกม", TH2="วาปไปที่ด่านสุดท้ายของเกม", Callback=Functions.AutoCompleteBook1};
                        {type="Toggle", EN="ESP Monsters", EN2="Show monster's hitbox & name", Path="ESP/Monsters", TH1="ESP ผี", TH2="มองเห็นผี", Callback=Functions.ESPMonsterBook1};
                    }, Title="All In One", Open=true};
                }}; {type="Space"};
            };
            B1C2Tab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete Game", EN2="Teleport to the end of the game.", TH1="ออโต้จบเกม", TH2="วาปไปที่ด่านสุดท้ายของเกม", Callback=Functions.AutoCompleteBook1};
                        {type="Toggle", EN="ESP Monsters", EN2="Show monster's hitbox & name", Path="ESP/Monsters", TH1="ESP ผี", TH2="มองเห็นผี", Callback=Functions.ESPMonsterBook1};
                        {type="Toggle", EN="ESP Items", EN2="Show item's box & name", Path="ESP/Items", TH1="ESP ไอเทม", TH2="มองเห็นไอเทม", Callback=Functions.ESPItemBook1};
                    }, Title="All In One", Open=true};
                }}; {type="Space"};
            };
            B1C4Tab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete Game", EN2="Teleport to the end of the game.", TH1="ออโต้จบเกม", TH2="วาปไปที่ด่านสุดท้ายของเกม", Callback=Functions.B1C4AutoComplete};
                        {type="Toggle", EN="ESP Monsters", EN2="Show monster's hitbox & name", Path="ESP/Monsters", TH1="ESP ผี", TH2="มองเห็นผี", Callback=Functions.ESPMonsterBook1};
                        {type="Toggle", EN="ESP Items", EN2="Show item's box & name", Path="ESP/Items", TH1="ESP ไอเทม", TH2="มองเห็นไอเทม", Callback=Functions.ESPItemBook1};
                    }, Title="Map 1"};
                }, Title="Map 1"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete Game", EN2="Teleport to the end of the game.", TH1="ออโต้จบเกม", TH2="วาปไปที่ด่านสุดท้ายของเกม", Callback=Functions.B1C4AutoComplete};
                        {type="Toggle", EN="ESP Monsters", EN2="Show monster's hitbox & name", Path="ESP/Monsters", TH1="ESP ผี", TH2="มองเห็นผี", Callback=Functions.ESPMonsterBook1};
                        {type="Toggle", EN="ESP Items", EN2="Show item's box & name", Path="ESP/Items", TH1="ESP ไอเทม", TH2="มองเห็นไอเทม", Callback=Functions.ESPItemBook1};
                    }, Title="Map 2"};
                }, Title="Map 2"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete Game", EN2="Teleport & Collect cursed items and burn them.", TH1="ออโต้จบเกม", TH2="วาปเก็บไอเทมแล้วเผา", Callback=Functions.B1C4AutoComplete};
                        {type="Toggle", EN="ESP Monsters", EN2="Show monster's hitbox & name", Path="ESP/Monsters", TH1="ESP ผี", TH2="มองเห็นผี", Callback=Functions.ESPMonsterBook1};
                        {type="Toggle", EN="ESP Items", EN2="Show item's box & name", Path="ESP/Items", TH1="ESP ไอเทม", TH2="มองเห็นไอเทม", Callback=Functions.ESPItemBook1};
                    }, Title="Map 3"};
                }, Title="Map 3"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Kill Sama", EN2="Automatically destroy hearts.", TH1="ออโต้ทำลายหัวใจ", TH2="ทำลายหัวใจผี", Path="Auto Kill Sama"};
                        {type="Toggle", EN="Auto Kill Saigomo", EN2="Automatically kill saigomo.", TH1="ออโต้ฆ่า Saigomo", TH2="ออโต้ฆ่าผี", Path="Auto Kill Saigomo"};
                        {type="Toggle", EN="ESP Monsters", EN2="Show monster's hitbox & name", Path="ESP/Monsters", TH1="ESP ผี", TH2="มองเห็นผี", Callback=Functions.ESPMonsterBook1};
                        {type="Toggle", EN="ESP Hearts", EN2="Show item's box & name", Path="ESP/Items", TH1="ESP ไอเทม", TH2="มองเห็นไอเทม", Callback=Functions.ESPItemBook1}; {type="Space"};
                    }, Title="Map 4"};
                }, Title="Map 4"};
            };
            B2C1Tab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Teleport to that one room.", TH1="ออโต้ผ่านด่าน", TH2="วาปไปในห้องนั้นแหละ เออห้องนั้นแหละ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("City/Complete");
                        end)};
                    }, Title="Section 1 | City"}
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Read Book", EN2="Read the book as it is part of the gameplay.", TH1="อ่านหนังสือ", TH2="อ่านหนังสือเพื่อเล่นต่อ", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C1Func("Rat/Read");
                                end)};
                                {type="Button", EN="Auto Rat", EN2="Grab rat and poisoned it then ring the bell.", TH1="ออโต้หนู", TH2="วาปเก็บหนูไปให้ผีกิน", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C1Func("Rat/Auto");
                                end)};
                                {type="Button", EN="Exit", EN2="Teleport to exit door and interact.", TH1="ออกจากที่นี่", TH2="วาปไปที่ประตูทางออกแล้วกดออก", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C1Func("Rat/Exit");
                                end)};
                                {type="Button", EN="Auto Run", EN2="Tween to the exit in the chase sequence.", TH1="ออโต้วิ่ง", TH2="ค่อยๆบินไปที่ทางออกในด่านวิ่ง", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C1Func("Rat/Run");
                                end)};
                            }, Title="Main"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="ESP Monster", EN2="Show monster's hitbox & name", TH1="ESP ผี", TH2="มองเห็นผี", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C1ESP("Rat/Monsters");
                                end)};
                                {type="Button", EN="ESP Objective Objects", EN2="Show object's box & name", TH1="ESP วัตถุสำหรับภารกิจนี้", TH2="มองเห็นวัตถุสำหรับภารกิจที่นี่", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C1ESP("Rat/Objects");
                                end)};
                            }, Title="ESP"}
                        }};
                    }, Title="Section 2 | Rat"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Tween to the entrance of the cave.", TH1="ออโต้ผ่านด่าน", TH2="ค่อยๆบินไปทางเข้าถ้ำ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("Nagisa/Auto");
                        end)};
                        {type="Button", EN="Auto Run", EN2="Tween to the exit of the cave in the chase sequence.", TH1="ออโต้วิ่ง", TH2="ค่อยๆบินไปที่ทางออกถ้ำในด่านวิ่ง", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("Nagisa/Run");
                        end)}; {type="Space"};
                    }, Title="Section 3 | Nagisa"}
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Enter Zone", EN2="Tween to the main village.", TH1="เข้าหมูบ้าน", TH2="ค่อยๆบินไปที่หมู่บ้านหลัก", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("Vil/Zone");
                        end)};
                        {type="Button", EN="Talk (1)", EN2="Talk to the NPC.", TH1="คุย (1)", TH2="คุยกับ NPC", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("Vil/Talk");
                        end)};
                        {type="Button", EN="Key (2)", EN2="Grab the key.", TH1="กุญแจ (2)", TH2="เก็บกุญแจ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("Vil/Key");
                        end)};
                        {type="Button", EN="Paint (3)", EN2="Teleport to painting where you have to paint but doesn not draw for you.", TH1="วาดรูป (3)", TH2="วาปอย่างเดียว ออโต้วาดอยู่ด่านอื่น อิอิ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("Vil/Paint");
                        end)};
                        {type="Button", EN="Picture Datas (4)", EN2="Teleport to all pictures to collect data, This is needed for auto candles.", TH1="รูปภาพ (4)", TH2="วาปเก็บข้อมูลเพื่อนำไปใช้ในออโต้จุดเทียน", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("Vil/Pics");
                        end)};
                        {type="Button", EN="Room (5)", EN2="Leave your current room first before use this, This will teleport you to the objective room.", TH1="ห้อง (5)", TH2="ออกจากห้องที่ตัวเองอยู่ก่อนค่อยกด กดแล้วจะพาวาปไปห้องที่ใช้ทำภารกิจ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("Vil/Room");
                        end)};
                        {type="Button", EN="Auto Candles (6)", EN2="Auto light all the candles.", TH1="จุดเทียน (6)", TH2="ออโต้จุดเทียนทั้งหมด", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C1Func("Vil/Candles");
                        end)}; {type="Space"};
                    }, Title="Section 4 | Village"}
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Enter Zone", EN2="Teleport to the ship entrance in the cave.", TH1="ทางเข้าเรือ", TH2="วาปไปที่ทางเข้าเรือตอนอยู่ในถ้ำ", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C1Func("Ship/Zone");
                                end)};
                                {type="Button", EN="Auto Run", EN2="Tween to the exit in the chase sequence.", TH1="ออโต้วิ่ง", TH2="ค่อยบินไปที่ทางออกในด่านวิ่ง", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C1Func("Ship/Run");
                                end)};
                            }, Title="Main"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="ESP Monsters", EN2="Show monster's hitbox & name", TH1="ESP ผี", TH2="มองเห็นผี", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C1ESP("Ship/Monsters");
                                end)};
                            }, Title="ESP"}
                        }};
                    }, Title="Section 5 | Ship"};
                }}; {type="Space"};
            };
            B2C2Tab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Tween to the gate and wait around 30 seconds.", TH1="ออโต้ผ่านด่าน", TH2="บินไปที่ประตูแล้วรอประมาณ 30 วินาที", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C2Func("Statue");
                        end)},
                    }, Title="Section 1 | Statue"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Tween to the door and wait around 70 seconds.", TH1="ออโต้ผ่านด่าน", TH2="บินไปที่ประตูแล้วรอประมาณ 70 วินาที", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C2Func("Crounch");
                        end)},
                    }, Title="Section 2 | Crounch"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Talk", EN2="Teleport to the NPC but does not talk for you due to anti cheat.", TH1="คุย", TH2="วาปไปหา NPC แต่จะไม่คุยให้เรื่องจากกันโปร", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Meat/Talk");
                                end)};
                                {type="Button", EN="Teleport To Meat", EN2="Teleport the meat but does not collect for you.", TH1="วาปไปหาเนื้อ", TH2="วาปไปหาเนื้อ แต่จะไม่เก็บให้", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Meat/TpMeat");
                                end)};
                                {type="Button", EN="Exit", EN2="Teleport to the exit door &  interact for you.", TH1="ออก", TH2="วาปไปที่ประตูทางออกแล้วกดออกให้", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Meat/Exit");
                                end)};
                            }, Title="Main"};
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Toggle", EN="ESP Monster", EN2="Show monster's hitbox", TH1="ESP ผี", TH2="มองเห็นผี", Path="Ashina", Callback=IB_NO_VIRTUALIZE(function(state)
                                    Configs.B2C2.ESP["Ashina"] = state;
                                    return Functions:B2C2ESP("Meat/Monster", state);
                                end)};
                                {type="Toggle", EN="ESP Meats", EN2="Show meat's box", TH1="ESP เนื้อ", TH2="มองเห็นเนื้อ", Path="Meats", Callback=IB_NO_VIRTUALIZE(function(state)
                                    Configs.B2C2.ESP["Meats"] = state;
                                    return Functions:B2C2ESP("Meat/Meats", state);
                                end)}
                            }, Title="ESP"};
                        }};
                    }, Title="Section 3 | Meat"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Auto Complete", EN2="Enter chase sequence and auto complete it.", TH1="ออโต้ผ่านด่าน", TH2="วาปเข้าด่านวิ่งแล้ววาปไปที่ทางออกให้", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Chase/Full");
                                end)};
                            }, Title="Main"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Enter Zone", EN2="Enter chase sequence for you.", TH1="วาปเข้าด่านวิ่ง", TH2="วาปเข้าด่านวิ่งเพื่อเริ่มคัทซีน", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Chase/Enter");
                                end)};
                                {type="Button", EN="Auto Run", EN2="Teleport to the exit.", TH1="ออโต้ผ่านด่าน", TH2="วาปไปที่ทางออก", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Chase/Run");
                                end)}
                            }, Title="Seperated"};
                        }};
                    }, Title="Section 4 | Chase"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Enter Zone", EN2="Teleport & Interact with white doo.", TH1="วาปเข้าด่าน", TH2="วาปไปที่ประตูสีขาวแล้วกดออกให้", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C2Func("Lever/Enter");
                        end)};
                        {type="Button", EN="Auto Levers", EN2="Teleport & Interact with levers.", TH1="ออโต้สับคันโยก", TH2="ออโต้สับคันโยกด้วยการวาป", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C2Func("Lever/Auto");
                        end)}
                    }, Title="Section 5 | Lever"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Auto Complete", EN2="Teleport you to the cooking area ( Skip current section ).", TH1="ออโต้ผ่านด่าน", TH2="วาปไปที่ด่านถัดไป ( ข้ามด่านปัจจุบัน )", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Math");
                                end)};
                            }, Title="Main"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Reveal Number", EN2="Create the correct symbol at the exit door.", TH1="แสดงตัวเลขที่ถูกต้อง", TH2="สร้างสัญลักษ์ที่ถูกต้องที่ประตูทางออก. ", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2ESP("Math", true);
                                end)};
                            }, Title="Seperated"};
                        }};
                    }, Title="Section 6 | Math"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Complete", EN2="Cooking food for you. This isn't instant toggle so if you want to turn it off; You have to wait. ( Singleplayer )", TH1="ออโต้ผ่านด่าน", TH2="ทำอาหารให้แต่ใช้ได้แค่เวลาเล่นคนเดียว เวลากดปิดจะไม่ปิดทันที", Path="AutoCook"};
                        {type="Button", EN="Auto Run", EN2="Tween to the exit of this cave.", TH1="ออโต้วิ่ง", TH2="ค่อยๆบินไปที่ทางออกถ้ำ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C2Func("Cook/AfterCook");
                        end)};
                    }, Title="Section 7 | Gordon Ramsey"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Auto Complete", EN2="Tween you to the entrance of Cursed Zone 2.", TH1="ออโต้ผ่านด่าน", TH2="วาปไปที่ประตูทางเข้าด่าน 2", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Cursed/1");
                                end)};
                            }, Title="Cursed Zone 1"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Enter Zone", EN2="Tween you to Cursed Zone 2.", TH1="เข้าด่าน2", TH2="บินไปที่ด่าน 2", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Cursed/2");
                                end)};
                                {type="Button", EN="Remove Monster", EN2="This is client side so if you are with your friend, tell them not to go to 2nd floor. You must click this before enter 2nd floor to make it work.", TH1="ลบผีทิ้ง", TH2="ต้องกดก่อนเดินขึ้นไปข้างบน และถ้ามากับเพื่อนบอกให้เพื่อนอยู่แต่ด้านล่าง", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C2Func("Cursed/Remove");
                                end)};
                            }, Title="Cursed Zone 2"};
                        }};
                    }, Title="Section 8 | Cursed"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Repair files", EN2="Only for people who load the game from save.", TH1="ซ่อมแซมไฟล์", TH2="ใช้เวลาโหลดเกมจากเซฟ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C2Func("Kid/Files");
                        end)};
                        {type="Button", EN="Find Kid", EN2="Teleport to the kid.", TH1="หาเด็ก", TH2="วาปไปหาเด็ก", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C2Func("Kid/Find");
                        end)}; {type="Space"}; {type="Space"};
                        {type="Toggle", EN="ESP Mother", EN2="Show mother's hitbox.", TH1="ESP แม่", TH2="มองเห็นแม่", Path="ESP/Mother", Callback=function(state)
                            Configs.B2C2.ESP["Mother"] = state;
                            return Functions:B2C2ESP("Kid/Mother", state);
                        end};
                        {type="Toggle", EN="Anti Mother", EN2="Teleport to safe spot when mother is near.", TH1="หลบแม่", TH2="วาปกลับจุดเกิดเวลาเจอแม่", Path="Anti Mother"}; {type="Space"}; {type="Space"};
                        {type="Button", EN="Teleport To Gate", EN2="Teleport & Interact with white door.", TH1="วาปเข้าประตู", TH2="วาปเข้าประตูสีขาว", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C2Func("Kid/Gate");
                        end)};
                        {type="Button", EN="Auto Collect Notes", EN2="Teleport & Collect notes.", TH1="ออโต้เก็บโน๊ต", TH2="วาปและเก็บโน๊ต", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C2Func("Kid/Notes");
                        end)}; {type="Space"};
                    }, Title="Section 9 | Kid"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Get Cannon Balls", EN2="Teleport & Grab cannon balls when out of it.", TH1="ออโต้หยิบลูกปืนใหญ่", TH2="วาปและหยิบลูกปืนใหญ่เมื่อเหลือ 0", Path="Auto Get Cannon Balls"};
                        {type="Toggle", EN="Anti Nagisa Beam", EN2="Teleport to safe spot when nagisa uses her beam.", TH1="ออโต้หลบกลิ่นปาก", TH2="วาปไปที่ปลอดภัยเวลามันพ่นกลิ่นปาก", Path="Anti Nagisa Beam"}; {type="Space"};
                    }, Title="Section 10 | Nagisa"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Kill Nagisa Serpent", EN2="Teleport & Spam katana", TH1="ออโต้ฆ่า Nagisa Serpent", TH2="วาปและสแปมดาบ", Path="Auto Kill Nagisa Serpent"}; {type="Space"};
                    }, Title="Section 10 | Nagisa Serpent"};
                }}; {type="Space"};
            };
            B2C3Tab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Teleport the the entrance", TH1="ออโต้ผ่านด่าน", TH2="วาปไปที่ทางเข้า", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Gozu");
                        end)};
                    }, Title="Section 1 | Gozu & Mezu"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Talk", EN2="Teleport to the NPC.", TH1="คุย", TH2="วาปไปหา NPC", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Heart/Talk");
                        end)};
                        {type="Button", EN="Auto Hearts", EN2="Teleport & Collect hearts.", TH1="ออโต้เก็บหัวใจ", TH2="วาปเก็บหัวใจ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Heart/Auto");
                        end)};
                        {type="Button", EN="Auto Run", EN2="Teleport to the exit in the chase sequence.", TH1="ออโต้วิ่ง", TH2="วาปไปที่ทางออกในด่านวิ่ง", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Heart/Run");
                        end)};
                    }, Title="Section 2 | Heart"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Auto Craft", EN2="Teleport, collect items and craft a torch for you.", TH1="ออโต้คราฟ", TH2="วาปเก็บไอเทมมาคราฟแท่งไฟ", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C3Func("Maze/Craft");
                                end)};
                                {type="Button", EN="Get Fire", EN2="Teleport & light up your torch. You must equip your torch to use this.", TH1="จุดไฟ", TH2="วาปไปจุดไฟแต่ต้องถือแท่งไฟก่อน", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C3Func("Maze/Fire");
                                end)};
                                {type="Button", EN="Escape", EN2="Teleport to the exit.", TH1="ออก", TH2="วาปไปที่ทางออก", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C3Func("Maze/Escape");
                                end)};
                            }, Title="Main"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Toggle", EN="ESP Monster", EN2="Show monster's hitbox.", TH1="ESP ผี", TH2="มองเห็นผี", Path="ESP/Maze", Callback=IB_NO_VIRTUALIZE(function(state)
                                    B2C3Con.ESP.Maze = state
                                    return Functions:B2C3ESP("Maze", state);
                                end)};
                            }, Title="ESP"};
                        }};
                    }, Title="Section 3 | Maze"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Enter Zone", EN2="Teleport to the cutscene.", TH1="วาปเข้าด่าน", TH2="วาปไปที่คัตซีน", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Bell/Zone");
                        end)};
                        {type="Button", EN="Kill All Flys", EN2="Teleport & kill all flys.", TH1="ออโต้ฆ่าแมลง", TH2="วาปฆ่าแมลง", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Bell/Flys");
                        end)};
                        {type="Button", EN="Auto Bell", EN2="Auto ring the bell and attack the monster.", TH1="ออโต้ระฆัง", TH2="ออโต้ตีระฆังและเดี่ยวกับผี", Callback=IB_NO_VIRTUALIZE(function()
                            return WindUI:Notify({
                                Title = "<font color='rgb(255,0,0)'>WARNING</font>",
                                Content = "Hold on, Script is Intilizing, Do not press again.",
                                Icon = "circle-alert",
                                Duration = 10,
                            }), tk.delay(15, function()
                                return WindUI:Notify({
                                    Title = "<font color='rgb(255,0,0)'>WARNING</font>",
                                    Content = "Trust the process lol, it seem like it's not working but it actually work.",
                                    Icon = "circle-alert",
                                    Duration = 10,
                                });
                            end), Functions:B2C3Func("Bell/Auto");
                        end)}; {type="Space"}; {type="Space"};
                        {type="Button", EN="Teleport To Door", EN2="Teleport to the puzzle door but does not complete for you.", TH1="วาปไปที่ประตู", TH2="วาปไปที่ประตูเพื่อแก้ปริศนา", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Bell/TpDoor");
                        end)};
                        {type="Button", EN="Auto Complete Puzzle", EN2="Auto complete the puzzle but you have to be near the door.", TH1="ออโต้แก้ปริศนา", TH2="ออโต้แก้ปริศนาแต่ต้องอยู่ใกล้ประตู", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Bell/Puzzle");
                        end)};
                        {type="Button", EN="Auto Run", EN2="Teleport to the exit.", TH1="ออโต้วิ่ง", TH2="วาปไปที่ทางออก", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Bell/Run");
                        end)};
                    }, Title="Section 4 | Bell"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Enter Zone", EN2="Teleport to enzukai.", TH1="วาปเข้าด่าน", TH2="วาปไปที่ผี", Locked=true};
                        {type="Button", EN="Auto Complete", EN2="Auto interact with Enzukai.", TH1="ออโต้ผ่านด่าน", TH2="ออโต้คุยกับผีตอนอยู่บนแพ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Enzukai/Auto");
                        end)};
                    }, Title="Section 5 | Enzukai"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Fix Black Screen", EN2="Hide the black screen.", TH1="แก้บัคหน้าจอดำ", TH2="ซ่อนหน้าจอดำ", Callback=IB_NO_VIRTUALIZE(function()
                            PSG.PlayerScripts.Camera.Enabled = false;
                            PSG["03_Handler"].Enabled = not PSG["03_Handler"].Enabled;
                            PSG.PlayerScripts.Camera.Enabled = true;
                        end)};
                        {type="Button", EN="Disable Isamu", EN2="Ignore his action bro he's not gonna kill us.", TH1="เพิกเฉยต่อการโจมตีของ Isamu", TH2="สนใจทำไมก็แค่ผีตัวนึง", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Father/Isamu");
                        end)};
                        {type="Button", EN="Teleport To Safe Spot", EN2="Your sanity will drain but last long enough to survive each night.", TH1="วาปไปจุดที่ปลอดภัย", TH2="ค่าสติจะลดไวขึ้นแต่ก็อยู่ได้นานพอสำหรับคืนถัดไป", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Father/Auto");
                        end)};
                    }, Title="Section 6 | Father"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Enter Zone", EN2="Teleport to the arrival area.", TH1="วาปเข้าด่าน", TH2="วาปไปที่รถไฟ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Train");
                        end)};
                    }, Title="Section 7 | Train"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Teleport & collect larves then feed to the... dog?", TH1="ออโต้ผ่านด่าน", TH2="วาปเก็บหนอนไปให้... หมา? กิน", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Larves");
                        end)};
                    }, Title="Section 8 | Larves"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Teleport to the exit.", TH1="ออโต้ผ่านด่าน", TH2="วาปไปทางออก", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Mud");
                        end)};
                    }, Title="Section 9 | Mud"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Teleport To House", EN2="Teleport to the house; right at the interaction.", TH1="วาปเข้าบ้าน", TH2="วาปไปที่บ้าน จุดที่เอาไว้แก้ปริศนา", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Yurei/House");
                        end)};
                        {type="Button", EN="Auto Click Items", EN2="Click all cursed items.", TH1="ออโต้กดไอเทม", TH2="ออโต้กดคลิกไอเทมที่ถูกต้อง", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Yurei/Click");
                        end)};
                    }, Title="Section 10 | Yurei"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Toggle", EN="Auto Complete", EN2="Auto kill Yurei. Do not turn this on before the fight has started.", TH1="ออโต้ผ่านด่าน", TH2="ออโต้ฆ่าผี ห้ามเปิดก่อนที่สงครามจะเริ่ม", Path="Auto Kill Yurei"};
                            }, Title="Main"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Clear Map", EN2="Remove map's border.", TH1="เคลียพื้นที่", TH2="ลบกำแพงแมพออก", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C3Func("Boss/Clear");
                                end)};
                                {type="Button", EN="Teleport To Safe Spot", EN2="Teleport you outside the border.", TH1="วาปไปจุดที่ปลอดภัย", TH2="วาปออกไปนอกกำแพงแมพ", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C3Func("Boss/TpSafe");
                                end)};
                                {type="Button", EN="Get Katanas", EN2="Teleport & grab katanas", TH1="เก็บดาบ", TH2="วาปเก็บดาบ", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C3Func("Boss/Katanas");
                                end)};
                            }, Title="Other"};
                        }};
                    }, Title="Section 11 | Boss"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Talk", EN2="Teleport to Shinigami.", TH1="คุย", TH2="วาปไปหาผี", Locked=true};
                        {type="Button", EN="Auto Run", EN2="Teleport to the exit.", TH1="ออโต้ผ่านด่าน", TH2="วาปไปทางออก", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C3Func("Hell/Run");
                        end)};
                    }, Title="Section 12 | Hell"};
                }}; {type="Space"};
            };
            B2C4Tab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Patched Reporter Cutscene", EN2="In the 6 floor building, there is an NPC for you to talk with but sometime the anti cheat can break your cutscene.", TH1="แก้บัคอัคซีนของนักข่าว", TH2="ในด่านตึก 6 ชั้นจะมี NPC ให้เราไปคุยแล้วในบางตัวรันมันโดนกันโปรทำบัค ให้กดปุ่มนี้เวลาบัค", Callback=Functions.B2C4BP1};
                        {type="Button", EN="Patched Mother's Game", EN2="In the minigame where mother will be asking you questions and you have to answer, the anti cheat will stop the answer from appearing, use this to fix it.", TH1="แก้บัคคำถามของแม่", TH2="ในด่านมินิเกมที่แม่จะถามคำถามแล้วเราต้องตอบ ในบางตัวรันมันโดนกันโปรทำบัค ให้กดปุ่มนี้เวลาบัค", Callback=Functions.B2C4BP2};
                    }, Title="Sepcial | Bypass"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Teleport to the exit of this cave.", TH1="ออโต้ผ่านด่าน", TH2="วาปไปที่ทางออกถ้ำ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C4Func("Cave");
                        end)};
                    }, Title="Section 1 | Cave"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Auto Complete", EN2="Teleport to the white door.", TH1="ออโต้ผ่านด่าน", TH2="วาปไปที่ประตูสีขาว", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C4Func("City/Auto");
                                end)};
                            }, Title="Main"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Destroy Glass", EN2="Remove glasses from the floor.", TH1="ลบกระจกออก", TH2="ลบกระจกที่อยู่บนพื้นออก", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C4Func("City/Glass");
                                end)};
                                {type="Toggle", EN="ESP Glass", EN2="Show glass's hitbox.", TH1="ESP กระจก", TH2="มองเห็นกระจก", Path="ESP/Glass", Callback=IB_NO_VIRTUALIZE(function(state)
                                    B2C4Con.ESP.Glass = state;
                                    return Functions:B2C4ESP("City/Glass", state);
                                end)};
                                {type="Toggle", EN="ESP Enzukai", EN2="Show Enzukai's hitbox.", TH1="ESP ผี", TH2="มองเห็นผี", Path="ESP/Enzukai", Callback=IB_NO_VIRTUALIZE(function(state)
                                    return Functions:B2C4ESP("City/Enzukai", state);
                                end)};
                            }, Title="Other"};
                        }};
                    }, Title="Section 2 | City"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Talk", EN2="Teleport to NPC.", TH1="คุย", TH2="วาปไปหา NPC", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C4Func("Floor/Talk");
                        end)};
                        {type="Button", EN="Auto Codes", EN2="You have to interact with the keypad first.", TH1="ออโต้ใส่โค้ด", TH2="ต้องกดปุ่มที่ประตูก่อน", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C4Func("Floor/Auto");
                        end)};
                    }, Title="Section 3 | 6 Floor"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Teleport, collect item, and escape.", TH1="ออโต้ผ่านด่าน", TH2="วาปเก็บไอเทมและออก", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C4Func("Floor/Top");
                        end)};
                    }, Title="Section 3.5 | Top Floor"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Auto Walkie Talkis", EN2="Teleport & interact with walkie talkie", TH1="ออโต้กดวอสื่อสาร", TH2="วาปและกดใช้งาน", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C4Func("Mall/Talk");
                                end)};
                                {type="Button", EN="Auto Trigger Escape", EN2="Teleport to the entrance to trigger the game event.", TH1="ออโต้หลบหนี", TH2="วาปไปที่ทางเข้าเพื่อเริ่คัตซีน", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C4Func("Mall/Trigger");
                                end)};
                                {type="Button", EN="Auto Punch Eyes", EN2="Teleport & punch eyes.", TH1="ออโต้ต่อยดวงตา", TH2="วาปและต่อยดวงตา", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C4Func("Mall/Eyes");
                                end)};
                                {type="Button", EN="Grab Speaker", EN2="Teleport & grab the speaker.", TH1="เก็บลำโพง", TH2="วาปและเก็บลำโพง", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C4Func("Mall/Grab");
                                end)};
                                {type="Button", EN="Place Speaker", EN2="Teleport & place the speaker.", TH1="วางลำโพลง", TH2="วาปและวางลำโพง", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C4Func("Mall/Place");
                                end)};
                            }, Title="Main"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Toggle", EN="ESP Coins", EN2="Show coin's box.", TH1="ESP เหรียญ", TH2="มองเห็นเหรียญ", Path="ESP/Coins", Callback=IB_NO_VIRTUALIZE(function(state)
                                    B2C4Con.ESP.Coins = state;
                                    return Functions:B2C4ESP("Mall/Coins", state);
                                end)};
                                {type="Toggle", EN="ESP Walkie Talkies", EN2="Show walkie talkie's box.", TH1="ESP วอสื่อสาร", TH2="มองเห็นวอสื่อสาร", Path="ESP/Glass", Callback=IB_NO_VIRTUALIZE(function(state)
                                    B2C4Con.ESP.Walkie = state;
                                    return Functions:B2C4ESP("Mall/Talk", state);
                                end)};
                                {type="Toggle", EN="ESP Monsters", EN2="Show monster's hitbox.", TH1="ESP ผี", TH2="มองเห็นผี", Path="ESP/Mall Monsters", Callback=IB_NO_VIRTUALIZE(function(state)
                                    B2C4Con.ESP.MallMonsters = state;
                                    return Functions:B2C4ESP("Mall/Monsters", state);
                                end)};
                            }, Title="Other"};
                        }};
                    }, Title="Section 4 | Mall"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Chase 1", EN2="The floor at the end of the chase must fall so that mean everything must be loaded before you use this. You can watch my YouTube tutorial to use this one.", TH1="ออโต้วิ่ง 1", TH2="พื้นห้างในตอนท้ายพัง หมายความว่าก่อนกดใช้งานต้องมั่นใจก่อนว่าแมพโหลดเสร็จแล้ว หรือลองเปิด YouTube ดูก็ได้", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C4Func("Mall/Chase1");
                        end)};
                        {type="Button", EN="Auto Chase 2", EN2="Teleport to the elevator.", TH1="ออโต้วิ่ง 2", TH2="วาปไปที่ลิฟ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C4Func("Mall/Chase2");
                        end)};
                    }, Title="Section 5 | Mall Chase"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Collect Car Parts", EN2="Teleport & collect all car parts.", TH1="ออโต้เก็บชิ้นส่วนรถ", TH2="วาปแล้วเก็บชิ้นส่วนรถทั้งหมด", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C4Func("Car/Collect");
                        end)};
                        {type="Button", EN="Answer", EN2="Give mother the correct answer.", TH1="ตอบคำถาม", TH2="แม่!!! ผมตอบถูกแล้ว", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C4Func("Car/Answer");
                        end)};
                    }, Title="Section 6 | Parking Area"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Group", dats={
                            {dat={
                                {type="Button", EN="Draw", EN2="This only draw for you; Enter by yourself.", TH1="วาดรูป", TH2="วาดอย่างเดียว ไม่มีการวาปให้", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C4Func("Draw/Draw");
                                end)};
                                {type="Button", EN="Collect Quest Items", EN2="Teleport & collect item dropped.", TH1="ออโต้เก็บไอเทมจากผี", TH2="วาปและเก็บไอเทมที่ดรอปจากผี", Callback=IB_NO_VIRTUALIZE(function()
                                    return Functions:B2C4Func("Draw/Item");
                                end)};
                            }, Title="Main"}
                        }}; {type="Space"}; {type="Space"};
                        {type="Group", dats={
                            {dat={
                                {type="Toggle", EN="ESP Senzai", EN2="Show Senzai's hitbox.", TH1="ESP ผี", TH2="มองเห็นผี", Callback=IB_NO_VIRTUALIZE(function(state)
                                    B2C4Con.ESP.Senzai = state;
                                    return Functions:B2C4ESP("Draw/Senzai", state);
                                end)};
                                {type="Toggle", EN="ESP Ingredients", EN2="Show ingredient's box.", TH1="ESP วัตถุดิบ", TH2="มองเห็นวัตถุดิบ", Path="ESP/Glass", Callback=IB_NO_VIRTUALIZE(function(state)
                                    B2C4Con.ESP.Ingredients = state;
                                    return Functions:B2C4ESP("Draw/Ingredients", state);
                                end)};
                                {type="Toggle", EN="ESP Drawings", EN2="Show pad's box.", TH1="ESP แท่นวาดรูป", TH2="มองเห็นแท่นวาดรูป", Callback=IB_NO_VIRTUALIZE(function(state)
                                    B2C4Con.ESP.Drawings = state;
                                    return Functions:B2C4ESP("Draw/Drawings", state);
                                end)};
                            }, Title="ESP"};
                        }};
                    }, Title="Section 7 | Drawing"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Help Survivors", EN2="Teleport & interact with survivors.", TH1="ออโต้ช่วยคน", TH2="วาปและช่วยเหลือ", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions:B2C4Func("Survivors");
                        end)};
                        {type="Toggle", EN="ESP Survivors", EN2="Show survivor's box.", TH1="ESP ผู้รอดชีวิต", TH2="มองเห็นผู้รอดชีวิต", Path="ESP/Survivors", Callback=IB_NO_VIRTUALIZE(function(state)
                            B2C4Con.ESP.Survivors = state;
                            return Functions:B2C4ESP("Survivors", state);
                        end)}; {type="Space"}; {type="Space"};
                        {type="Toggle", EN="Auto Kill Enzukai-Ryu", EN2="Auto get supercharge and kill Enzukai.", TH1="ออโต้ฆ่า Enzukai", TH2="ออโต้ชาจและฆ่า Enzukai", Path="Auto Kill Enzukai-Ryu"};
                        {type="Toggle", EN="Auto Kill Monsters", EN2="Auto kill Enzukai's follower.", TH1="ออโต้ฆ่าผี", TH2="ออโต้ฆ่าลูกน้อง Enzukai", Path="Auto Kill Enzukai Followers"};
                    }, Title="Section 8 | Enzuaki"};
                }}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Kill Final Boss", EN2="Auto kill EnzukaiRyu-Jin.", TH1="ออโต้ฆ่าบอส", TH2="ออโต้ฆ่า EnzukaiRyu-Jin", Path="Auto Kill Final Boss"};
                    }, Title="Section 9 | Boss"};
                }}; {type="Space"};
            };
            B3C1Tab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Kill All Gatas", EN2="Teleport & fire a shot with client validation.", TH1="ยิง Gatas", TH2="วาปไปยิง Gatas พร้อมการยืนยันจาก Client", Callback=function()
                            return Functions:B3C1Func("Gata/Kill");
                        end};
                        {type="Button", EN="Interact All Dead Bodies", EN2="Teleport to dead bodies and interact.", TH1="รายงานศพ", TH2="วาปไปรายงานศพ", Callback=function()
                            return Functions:B3C1Func("Gata/Body");
                        end};
                        {type="Button", EN="Teleport To Mika", EN2="Watch she's gone.", TH1="วาปไปหา Mika", TH2="ไปดูฉากสิ้นหวัง", Callback=function()
                            return Functions:B3C1Func("Gata/Mika");
                        end};
                        {type="Button", EN="Teleport To Hideo/Door", EN2="Tell Hideo a sad story.", TH1="วาปไปหา Hideo", TH2="ไปเล่าเรื่องราวสิ้นหวัง", Callback=function()
                            return Functions:B3C1Func("Gata/Hideo");
                        end}; {type="Space"}; {type="Space"};
                        {type="Toggle", EN="ESP Gatas", EN2="Show Gatas' hitbox", TH1="ESP Gatas", TH2="มองเห็น Gatas", Path="ESP/Gatas", Callback=function(state)
                            Configs.B3C1.ESP.Gatas = state;
                            return Functions:B3C1ESP("Gatas", state);
                        end};
                        {type="Toggle", EN="ESP Dead Bodies", EN2="Show dead bodies", TH1="ESP ศพ", TH2="มองเห็นศพ", Path="ESP/Bodies", Callback=function(state)
                            Configs.B3C1.ESP.Bodies = state;
                            return Functions:B3C1ESP("Bodies", state);
                        end};
                    }, Title="Section 1 | Gatas & Dead Bodies"};
                }}; {type="Space"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Grab Medical Kit", EN2="Teleport to Medical Kit and grab it.", TH1="หยิบกล่องปฐมพยาบาล", TH2="วาปไปหยิบกล่องปฐมพยาบาล", Callback=function()
                            return Functions:B3C1Func("School/Med");
                        end};
                        {type="Button", EN="Teleport To Hideo", EN2="Teleport to Hideo.", TH1="วาปไปหา Hideo", TH2="วาปไปหา Hideo", Callback=function()
                            return Functions:B3C1Func("School/Hideo");
                        end};
                        {type="Button", EN="Heal Hideo", EN2="Teleport to him before use this.", TH1="รักษา Hideo", TH2="วาปก่อน แล้วค่อยกด ไม่งั้นใช้ไม่ได้หรือโดนแบน", Callback=function()
                            return Functions:B3C1Func("School/Heal");
                        end};
                        {type="Button", EN="Teleport To Locker", EN2="Teleport to locker.", TH1="วาปไปที่ล็อกเกอร์", TH2="วาปไปที่ล็อกเกอร์", Callback=function()
                            return Functions:B3C1Func("School/Locker");
                        end};
                        {type="Button", EN="Auto Kill Spiders", EN2="Teleport & shoot at the spiders.", TH1="ออโต้ฆ่าแมงมุม", TH2="วาปไปยิงแมงมุม", Callback=function()
                            return Functions:B3C1Func("School/Spider");
                        end}; {type="Space"}; {type="Space"};
                        {type="Toggle", EN="ESP Akari", EN2="Show Akari's hitbox.", TH1="ESP Akari", TH2="มองเห็น Akari", Path="ESP/Akari", Callback=function(state)
                            Configs.B3C1.ESP.Akari = state;
                            return Functions:B3C1ESP("Akari", state);
                        end};
                    }, Title="Section 2 | School"};
                }}; {type="Space"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Find Egao", EN2="Press this in Lobby, This will not auto complete the event so you have to look at her by yourself. <font color=\"rgb(255,0,0)\">Forest must be the first saved.</font>", TH1="ออโต้หา Egao", TH2="กดปุ่มนี้ใน Lobby แล้วต้องดูจอตลอดเวลาเพราะไม่มีออโต้มองหา Egao แล้วก็อย่าลืมทำให้ Forest เป็น Save แรก", Callback=function()
                            return Functions:B3C1Func("Forest/Egao");
                        end};
                        {type="Button", EN="Teleport To IJO Entrance", EN2="Teleport to the cave entrance for cutscene.", TH1="วาปไปที่ทางเข้าถ้ำ", TH2="วาปไปที่ทางเข้าถ้ำเพื่อเริ่มฉากต่อสู้", Callback=function()
                            return Functions:B3C1Func("Forest/Cave");
                        end};
                        {type="Button", EN="Auto Fix Generators", EN2="Teleport & fix generators.", TH1="ซ่อม Generator", TH2="วาปไปซ่อม Generator", Callback=function()
                            return Functions:B3C1Func("Forest/Generator");
                        end}; {type="Space"}; {type="Space"};
                        {type="Toggle", EN="ESP Mizuno", EN2="Show Mizuno's hitbox.", TH1="ESP Mizuno", TH2="มองเห็น Mizuno", Path="ESP/Mizuno", Callback=function(state)
                            Configs.B3C1.ESP.Mizuno = state;
                            return Functions:B3C1ESP("Mizuno", state);
                        end};
                    }, Title="Section 3 | Forest"};
                }}; {type="Space"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Grab Keycard", EN2="Teleport & collect keycard.", TH1="เก็บคีย์การ์ด", TH2="วาปไปเก็บคีย์การ์ด", Callback=function()
                            return Functions:B3C1Func("IJO/Keycard");
                        end};
                        {type="Button", EN="Enter Codes", EN2="Teleport & enter the code.", TH1="ใส่รหัส", TH2="วาปและใส่รหัส", Callback=function()
                            return Functions:B3C1Func("IJO/PASS");
                        end}; {type="Space"}; {type="Space"};
                        {type="Button", EN="Place C4 (1)", EN2="Teleport & place C4.", TH1="วางระเบิด C4", TH2="วาปไปวางระเบิด C4", Callback=function()
                            return Functions:B3C1Func("IJO/C4");
                        end};
                        {type="Button", EN="Place C4 (2)", EN2="Teleport & place C4 at Netamo.", TH1="วางระเบิด C4 ที่ผี", TH2="วาปไปวางระเบิด C4 ที่ผี", Callback=function()
                            return Functions:B3C1Func("IJO/C4_2");
                        end}; {type="Space"}; {type="Space"};
                        {type="Button", EN="Activate Terminals", EN2="Teleport & activate terminals.", TH1="เปิด terminals", TH2="วาปไปเปิด terminals", Callback=function()
                            return Functions:B3C1Func("IJO/Terminal");
                        end};
                        {type="Button", EN="Turn Valves", EN2="Teleport & turn valves.", TH1="เปิดวาล์ว", TH2="วาปไปเปิดวาล์ว", Callback=function()
                            return Functions:B3C1Func("IJO/Valve");
                        end};
                        {type="Button", EN="Hit Skill Check", EN2="Enter the 'Lock Threat' minigame by yourself. Only press this button by the amout of circles on screen.", TH1="กดสกิล", TH2="กดเพื่อเริ่มมินิเกม 'Lock Threat' ด้วยตัวเองแล้วค่อยกดออโต้ตามจำนวนวงกลมบนหน้าจอ", Callback=function()
                            return Functions:B3C1Func("IJO/Threat");
                        end}; {type="Space"}; {type="Space"};
                        {type="Toggle", EN="ESP HogoGuntai", EN2="Show HogoGuntai's hitbox.", TH1="ESP HogoGuntai", TH2="มองเห็น HogoGuntai", Path="ESP/HogoGuntai", Callback=function(state)
                            Configs.B3C1.ESP.HogoGuntai = state;
                            return Functions:B3C1ESP("HogoGuntai", state);
                        end};
                    }, Title="Section 4 | IJO"};
                }}; {type="Space"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Main Switch", EN2="Teleport & interact with the main switch.", TH1="เปิดสวิตช์หลัก", TH2="วาปไปเปิดสวิตช์หลัก", Callback=function()
                            return Functions:B3C1Func("Water/Main");
                        end};
                        {type="Button", EN="Auto Wire", EN2="Teleport & interact with the all boxes.", TH1="เสียบสายไฟอัตโนมัติ", TH2="วาปไปเสียบสายไฟอัตโนมัติ", Callback=function()
                            return Functions:B3C1Func("Water/Wire");
                        end}; {type="Space"}; {type="Space"};
                        {type="Toggle", EN="ESP Baigai", EN2="Show Baigai's hitbox.", TH1="ESP Baigai", TH2="มองเห็น Baigai", Path="ESP/Baigai", Callback=function(state)
                            Configs.B3C1.ESP.Baigai = state;
                            return Functions:B3C1ESP("Baigai", state);
                        end};
                    }, Title="Section 5 | Water"};
                }};
            };
            JigokuTab = {
                {type="Button", Title="Teleport To Place", TH1="วาปไปที่แมพ Jigoku", Callback=IB_NO_VIRTUALIZE(function()
                    return TTeleport(GG.TeleportService, 7618863566, selff);
                end)}; {type="Space"};
                {type="Button", EN="Full Auto Complete", EN2="Talk & auto collect orbs with a perfect 5 seconds waiting time so you don't die.", TH1="ออโต้จบเกม", TH2="คุยและวาปเก็บ Orbs โดยมีการคำนวณเวลาเพื่อไม่ให้ตาย", Callback=IB_NO_VIRTUALIZE(function()
                    return Functions.JigokuFunc("Talk"), twait(11), Functions.JigokuFunc("Complete");
                end)}; {type="Space"};
                {type="Button", EN="Talk", EN2="Teleport to talk with Shinigami", TH1="คุย", TH2="วาปไปคุยกับ Shinigami", Callback=IB_NO_VIRTUALIZE(function()
                    return Functions.JigokuFunc("Talk");
                end)};
                {type="Button", EN="Auto Collect Orbs", EN2="Teleport & collect all orbs", TH1="ออโต้เก็บ Orbs", TH2="วาปเก็บ Orb ทั้งหมด", Callback=IB_NO_VIRTUALIZE(function()
                    return Functions.JigokuFunc("Complete");
                end)};
            };
            WitchTrialTab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Teleport to the exit.", TH1="ออโต้จบเกม", TH2="วาปไปที่ทางออก", Callback=IB_NO_VIRTUALIZE(function()
                            local GameTPTWT = FindFirstChild(W, "Game Teleporter", true);
                            if GameTPTWT then
                                ForceFloat = true;
                                return CommonF.Tp(HumRSelf, GameTPTWT.CFrame);
                            end;
                        end)}
                    }, Title="Main"};
                }}; {type="Space"}; {type="Space"};
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Teleport To Fireplace 1", EN2="This is where you burn the butterfly A.", TH1="วาปไปที่เตาเผา 1", TH2="เผาผีเสื้ออันแรก", Callback=IB_NO_VIRTUALIZE(function()
                            return CommonF.Tp(HumRSelf, CFr(2621.90186, 111.203804, 1453.71765));
                        end)};
                        {type="Button", EN="Teleport To Fireplace 2", EN2="This is where you burn the butterfly B.", TH1="วาปไปที่เตาเผา 2", TH2="เผาผีเสื้ออันที่สอง", Callback=IB_NO_VIRTUALIZE(function()
                            return CommonF.Tp(HumRSelf, CFr(2426.72583, 185.146057, 1457.37292));
                        end)}; {type="Space"};
                        {type="Button", EN="Get Butterfly", EN2="Teleport to witches and grab butterflies.", TH1="เก็บผีเสื้อ", TH2="วาปไปเก็บผีเสื้อจากแม่มด", Callback=IB_NO_VIRTUALIZE(function()
                            for i, v in pairs(GetChildren(GameAI)) do
                                if v then
                                    local TWTPRompt = FindFirstChildWhichIsA(v, "ProximityPrompt", true);
                                    if TWTPRompt then
                                        CommonF.Tp(HumRSelf, TWTPRompt.Parent.CFrame + (TWTPRompt.Parent.CFrame.LookVector * -9), 0.3);
                                        fireproximityprompt(TWTPRompt, 1);
                                    end;
                                end;
                            end;
                        end)}
                    }, Title="Seperated"};
                }};
            };
            ChristmasTrialTab = {
                {type="Toggle", EN="ESP Krampus", EN2="Show Krampus's hitbox", TH1="ESP Krampus", TH2="มองเห็น Krampus", Path="ESP/Krampus", Callback=function(state)
                    return Functions.CTESP(state,"Krampus");
                end};
                {type="Toggle", EN="ESP Toys", EN2="Show all Toys", TH1="ESP ของเล่น", TH2="มองเห็นของเล่น", Path="ESP/Toys", Callback=function(state)
                    return Functions.CTESP(state, "Toys");
                end}; {type="Space"}; {type="Space"};
                {type="Button", EN="Auto Repair", EN2="Teleport & repaire Santa's sleigh", TH1="ออโต้ซ่อม", TH2="วาปและซ่อมตุ๊กๆแซนต้า", Callback=function()
                    return Functions:CTFunc("Repair");
                end};
                {type="Button", EN="Collect Toys", EN2="Teleport & collect all toys", TH1="เก็บของเล่น", TH2="วาปและเก็บของเล่นทั้งหมด", Callback=function()
                    return Functions:CTFunc("Collect");
                end}; {type="Space"}; {type="Space"};
                {type="Button", EN="Talk", EN2="Teleport & talk with Elf", TH1="คุย", TH2="วาปไปคุยกับ Elf", Callback=function()
                    return Functions:CTFunc("Talk");
                end};
                {type="Button", EN="Get Key", EN2="Teleport & grab the key", TH1="เก็บกุญแจ", TH2="วาปไปเก็บกุญแจ", Callback=function()
                    return Functions:CTFunc("Key");
                end}; {type="Space"}; {type="Space"};
            };
            NightmareCircusTab = {
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Teleport to the next section.", TH1="ออโต้ผ่านด่าน", TH2="วาปไปที่ด่านต่อไป", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions.NMCSFunc("Jukebox");
                        end)}, {type="Space"}, {type="Space"},
                        {type="Toggle", EN="ESP Monster", EN2="Show monster's hitbox", TH1="ESP ผี", TH2="มองเห็นผี", Path="Jukebox/ESP/Clown", Callback=IB_NO_VIRTUALIZE(function(state)
                            NMCSCon.Jukebox.ESP.Clown = state;
                            return Functions.NMCSESP("Clown", state);
                        end)},
                    }, Title="Jukebox"};
                }}; {type="Space"},
                {type="Group", dats={
                    {dat={
                        {type="Button", EN="Auto Complete", EN2="Teleport & flip cards.", TH1="ออโต้ผ่านด่าน", TH2="วาปไปเปิดไพ่", Callback=IB_NO_VIRTUALIZE(function()
                            return Functions.NMCSFunc("Cards");
                        end)},
                    }, Title="Cards"};
                }}; {type="Space"},
                {type="Group", dats={
                    {dat={
                        {type="Toggle", EN="Auto Kill Ringmaster", EN2="You must enable Float so you don't fall at the end of this game.", TH1="ออโต้ฆ่านักมายากล", TH2="เปิดลอยก่อนใช้งานฟีเจอร์นี้ เพื่อไม่ให้ตกโลก", Path="Ringmaster/AutoKill"},
                    }, Title="Ringmaster"};
                }}; {type="Space"},
            };
        };

        local LSecureUI = function()
            WindUI = WindLib();
            local Window = WindUI:CreateWindow({
                Title = "The Mimic",
                Folder = "TTJYStudio",
                Transparent = true,
                Theme = "Dark",
                SideBarWidth = 200,
                HasOutline = true,
                NewElements = true,
                OpenButton = {
                    Title = "TTJY Hub",
                    CornerRadius = UDim.new(1,0),
                    StrokeThickness = 3,
                    Enabled = true,
                    Draggable = true,
                    OnlyMobile = false,
                    Color = ColorSequence.new(Col3.fromHex("#30FF6A"), Col3.fromHex("#e7ff2f"))
                }, Topbar = {
                    Height = 44,
                    ButtonsType = "Mac",
                },
            });
            local Tabs = {
                Welcome = Window:Tab({Title="Welcome", Icon="smile"}),
                Client = LoaderSettings.AllowClientTab and Window:Tab({Title="Client", Icon="user"}),
                Yen = Window:Tab({Title="Yen", Icon="coins"}),
                Emote = Window:Tab({Title="Emotes", Icon="accessibility"}),

                Div1 = Window:Divider(),
                B1C1 = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 6296321810 or PlaceId == 6479231833 or PlaceId == 6301638949 or PlaceId == 6480994221) and Window:Tab({ Title = "B1C1", Icon = "book-open" }),
                B1C2 = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 6373539583 or PlaceId == 6485055338 or PlaceId == 6406571212 or PlaceId == 6485055836 or PlaceId == 6425178683 or PlaceId == 6485056556) and Window:Tab({ Title = "B1C2", Icon = "book-open" }),
                B1C3 = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 6472459099 or PlaceId == 6688734180 or PlaceId == 6682163754 or PlaceId == 6688734313 or PlaceId == 6682164423 or PlaceId == 6688734395) and Window:Tab({ Title = "B1C3", Icon = "book-open" }),
                B1C4 = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 7251865082 or PlaceId == 7265396387 or PlaceId == 7251866503 or PlaceId == 7265396805 or PlaceId == 7251867155 or PlaceId == 7265397072 or PlaceId == 7251867574 or PlaceId == 7265397848) and Window:Tab({ Title = "B1C4", Icon = "book-open" }),
                B2C1 = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 8056702588) and Window:Tab({ Title = "B2C1", Icon = "book-open" }),
                B2C2 = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 13489800654) and Window:Tab({ Title = "B2C2", Icon = "book-open" }),
                B2C3 = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 15962819441) and Window:Tab({ Title = "B2C3", Icon = "book-open" }),
                B2C4 = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 96354063422506) and Window:Tab({ Title = "B2C4", Icon = "book-open" }),
                B3C1 = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 128715637193371) and Window:Tab({ Title = "B3C1", Icon = "book-open" }),

                Div2 = Window:Divider(),
                Jigoku = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 7618863566) and Window:Tab({ Title = "Jigoku", Icon = "skull" }),
                WitchTrial = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 7068738088 or PlaceId == 7068951438 or PlaceId == 7068739000 or PlaceId == 7068951914 or PlaceId == 7068740106 or PlaceId == 7068952294) and Window:Tab({ Title = "Witch Trial", Icon = "ghost" }),
                ChristmasTrial = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 8311299084 or PlaceId == 8311302084) and Window:Tab({ Title = "Christmas Trial", Icon = "snowflake" }),
                HalloweenTrial = Window:Tab({ Title = "Halloween Trial", Icon = "ghost" }),
                NightmareCircus = ((not LoaderSettings.TheMimicLoader.Load_WithPlaceID_Check) or PlaceId == 11126398230) and Window:Tab({ Title = "Nightmare Circus", Icon = "party-popper" }),
                
                ExtraDiv = Window:Divider(),
                AddOn = LoaderSettings.AllowAddOn and Window:Tab({ Title = "AddOn", Icon = "box" }),
                Themes = LoaderSettings.AllowThemesTab and Window:Tab({ Title = "Themes", Icon = "palette" }),
                Core = Window:Tab({ Title = "Core Settings", Icon = "settings" }),
            };IntroLib.Init(WindUI, Tabs.Welcome); IntroLib:Tutorial(WindUI);

            Window:SetToggleKey((LoaderSettings.UIKeybind and Enum.KeyCode[LoaderSettings.UIKeybind]) or Enum.KeyCode["V"]);

            Windy:CreateComponent(Tabs.Client, ScriptData.AutoData.ClientTab, "Client");
            Windy:CreateComponent(Tabs.Core, CorePackage());

            Windy:CreateComponent(Tabs.Yen, ScriptData.AutoData.YenTab, "Yen");
            Windy:CreateComponent(Tabs.Emote, ScriptData.AutoData.EmoteTab, "Emote");

            if Tabs.B1C1 then
                Windy:CreateComponent(Tabs.B1C1, ScriptData.AutoData.B1C1Tab, "B1C1");
                if LoaderSettings.TheMimicLoader.Load_Sections then
                    Functions.PairingSections(Tabs.B1C1, ScriptData.Sections.B1C1, "B1C1");
                end;
            end;

            if Tabs.B1C2 then
                Windy:CreateComponent(Tabs.B1C2, ScriptData.AutoData.B1C2Tab, "B1C2");
                if LoaderSettings.TheMimicLoader.Load_Sections then
                    Functions.PairingSections(Tabs.B1C2, ScriptData.Sections.B1C2, "B1C2");
                end;
            end;

            if Tabs.B1C3 then
                Windy:CreateComponent(Tabs.B1C3, ScriptData.AutoData.B1C2Tab, "B1C3");
                if LoaderSettings.TheMimicLoader.Load_Sections then
                    Functions.PairingSections(Tabs.B1C3, ScriptData.Sections.B1C3, "B1C3");
                end;
            end;

            if Tabs.B1C4 then
                Windy:CreateComponent(Tabs.B1C4, ScriptData.AutoData.B1C4Tab, "B1C4");
            end;

            if Tabs.B2C1 then
                Windy:CreateComponent(Tabs.B2C1, ScriptData.AutoData.B2C1Tab, "B2C1");
            end;

            if Tabs.B2C2 then
                Windy:CreateComponent(Tabs.B2C2, ScriptData.AutoData.B2C2Tab, "B2C2");
            end;

            if Tabs.B2C3 then
                Windy:CreateComponent(Tabs.B2C3, ScriptData.AutoData.B2C3Tab, "B2C3");
            end;

            if Tabs.B2C4 then
                Windy:CreateComponent(Tabs.B2C4, ScriptData.AutoData.B2C4Tab, "B2C4");
            end;

            if Tabs.B3C1 then
                Windy:CreateComponent(Tabs.B3C1, ScriptData.AutoData.B3C1Tab, "B3C1");
            end;

            if Tabs.Jigoku then
                Windy:CreateComponent(Tabs.Jigoku, ScriptData.AutoData.JigokuTab, "Jigoku");
            end;

            if Tabs.WitchTrial then
                Windy:CreateComponent(Tabs.WitchTrial, ScriptData.AutoData.WitchTrialTab, "Witch");
            end;

            if Tabs.ChristmasTrial then
                Windy:CreateComponent(Tabs.ChristmasTrial, ScriptData.AutoData.ChristmasTrialTab, "Christmas");
            end;

            if Tabs.NightmareCircus then
                Windy:CreateComponent(Tabs.NightmareCircus, ScriptData.AutoData.NightmareCircusTab, "NightmareCircus");
            end;

            Window:SelectTab(1); Window:OnDestroy(function()
                CoreDestroyed = true;
                PromptPackage.UpdateState(true);
            end);

            ScriptCache.WindUI = WindUI; ScriptCache.Window = Window;
        end; local LSecureLoad = function(AUTH_KEY)
            Storing_AUTHENTICATION = Storing_AUTHENTICATION or AUTH_KEY;
            if not Storing_AUTHENTICATION then return selff:Kick("Invalid Authentication 1PAC"); end;
            local Splited1 = str.split(Storing_AUTHENTICATION, "+++os()");
            local Splited2 = str.split(decrypt(Splited1[2], 3), "+++os()");
            local D1Auth = decrypt(Splited2[2], 3);
            local D2Auth = decrypt(Splited2[3], 2);
            D1Auth = D1Auth:gsub("emptyspace", "");
            D2Auth = D2Auth:gsub("emptyspace", "");
            if D1Auth == "200" then
                PremiumCheck = false;
            elseif D1Auth == "201" then
                PremiumCheck = true;
            else
                return selff:Kick("Invalid Authentication 2PAC");
            end; local OneRunCallMain, OneRunErrorMain = pcall(function()
                CoreDestroyed = false; PromptPackage.UpdateState(false);
                ClientCon.WalkSpeed = HumSelf and HumSelf.WalkSpeed or 16;
                ClientCon.JumpPower = HumSelf and HumSelf.JumpPower or 50;

                if userIdentify.unc_infos.fireproximityprompt == "Lua" then
                    PromptPackage.SwitchUNC("Lua");
                end;
                
                LSecureUI();

                if selc and FindFirstChild(selc, "AntiFly") then
                    selc.AntiFly:Destroy();
                end;

                tk.spawn(IB_NO_VIRTUALIZE(function()
                    while not CoreDestroyed do
                        if ClientCon["Enable Fly"] then
                            CoruTask.Handle("Fly");
                        end; if B1C4Con["Auto Kill Sama"] then
                            CoruTask.Handle("Sama");
                        end; if B1C4Con["Auto Kill Saigomo"] then
                            CoruTask.Handle("Saigomo");
                        end; if B2C2Con["AutoCook"] then
                            CoruTask.Handle("Cook");
                        end; if B2C2Con["Anti Mother"] then
                            CoruTask.Handle("Mother");
                        end; if B2C2Con["Auto Get Cannon Balls"] or B2C2Con["Anti Nagisa Beam"] then
                            CoruTask.Handle("Cannon+Lazer");
                        end; if B2C2Con["Auto Kill Nagisa Serpent"]  then
                            CoruTask.Handle("Nagisa Serpent");
                        end; if B2C3Con["Auto Kill Yurei"] then
                            CoruTask.Handle("Yurei");
                        end; if B2C4Con["Auto Kill Enzukai-Ryu"] then
                            CoruTask.Handle("EnzukaiRyu");
                        end; if B2C4Con["Auto Kill Enzukai Followers"] then
                            CoruTask.Handle("EnzukaiMobs");
                        end; if B2C4Con["Auto Kill Final Boss"] then
                            CoruTask.Handle("EnzukaiJin");
                        end; if NMCSCon.Ringmaster.AutoKill then
                            CoruTask.Handle("Ringmaster");
                        end; if YenCon.Aura or YenCon.ESP then
                            CoruTask.Handle("Yen");
                        end;
                        twait(0.1);
                    end;
                end));

                CoreConnection[1] = GG.H.Stepped:Connect(IB_NO_VIRTUALIZE(function()
                    if CoreDestroyed and CoreConnection[1] then
                        CoreConnection[1]:Disconnect(); CoreConnection[1] = nil;
                        return;
                    end;

                    Backpack = selff.Backpack;
                    selc = selff.Character;
                    HumSelf = selc and FindFirstChildOfClass(selc, "Humanoid");
                    HumRSelf = HumSelf and HumSelf.RootPart;

                    ClientPackage.UpdatePosition(ClientCon.Float, ForceFloat, HumRSelf);
                    ClientPackage.Noclip(ClientCon.Noclip, selc);
                    ClientPackage.Brightness(ClientCon["Full Bright"]);
                    ClientPackage.WalkSpeedC(ClientCon["Enable WalkSpeed"], ClientCon.WalkSpeed, HumSelf);
                    ClientPackage.JumpPower(ClientCon["Enable JumpPower"], ClientCon.JumpPower, HumSelf);

                    if ClientCon["Auto Free Yourself"] then
                        Functions:FreeYourself();
                    end;
                end));
                CoreConnection[2] = GG.H.Heartbeat:Connect(IB_NO_VIRTUALIZE(function(delta)
                    if CoreDestroyed and CoreConnection[2] then
                        CoreConnection[2]:Disconnect(); CoreConnection[2] = nil;
                        return;
                    end;

                    if ClientCon["Enable TeleportWalk"] and selc and HumSelf and HumSelf.MoveDirection.Magnitude > 0 then
                        selc:TranslateBy(HumSelf.MoveDirection * ClientCon["TeleportWalk Speed"] * delta * 10);
                    end;
                end));

                if userIdentify.device == "PC" then
                    if not ScriptCache.AlreadyCMDM then
                        ScriptCache.AlreadyCMDM = true;
                        cmdm.KeyDown:Connect(Functions.KeyDown);
                        cmdm.KeyUp:Connect(Functions.KeyUp);
                    end;
                end;

                if not CoruTask.Intialized then
                    GrabbedUI = GrabbedUI and FindFirstChild(GrabbedUI, "GrabbedUI");

                    CoruTask.Init(ScriptCache.WindUI);
                    CoruTask.Intialized = true;

                    if PlaceId == 128715637193371 then
                        if GG.LowerC then
                            local REQP = require(R.modules.Packet);
                            local o;o=GG.LowerC(getmetatable(REQP.unreliablesend.ReplicationService.Character.updateState).__call, function(...)
                                local args = {...};
                                if args[1].__name == "updateState" then
                                    if not CAMERAREPLICA then
                                        return o(...);
                                    end; args[2] = CF.lookAt(
                                        Cam.CFrame.Position,
                                        CAMERAREPLICA.Position
                                    ); return o(unpack(args));
                                end; return o(unpack(args));
                            end);
                        else
                            return selff:Kick("Solara does not work in this chapter.");
                        end;

                        if QUEUE_INFO.Egao then
                            local Intro = WaitForChild(W, "IntroCutscene", 9e9);
                            repeat twait(0.1); until not Intro or not Intro.Parent or not FindFirstChild(Intro, "SpawnBox");
                            Functions:B3C1Func("Forest/Egao");
                        end;
                    elseif PlaceId == 6243699076 and QUEUE_INFO.Egao then
                        Functions:B3C1Func("Forest/Egao");
                    elseif PlaceId == 8311299084 or PlaceId == 8311302084 then
                        CTQuests = WaitForChild(W, "Quests", 9e9);
                    end;
                end;
            end); if OneRunCallMain then
                return true, GG.LoadingSignal:Fire(100);
            end; return false, warn(OneRunErrorMain);
        end; GG.LSecureLoad = LSecureLoad; return LSecureLoad;
    end;
};
