local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({ Title = 'Pooh Shiesty Hub V2', Center = true, AutoShow = true })
local Tabs = {Main = Window:AddTab('Main'),['UI Settings'] = Window:AddTab('UI Settings')}



local VirtualUser = game:GetService('VirtualUser')
local StarterGui = game:GetService('StarterGui')

StarterGui:SetCore("SendNotification", { Title = "Anti-AFK", Text = "Script Activated", Duration = 5 })

game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local player = game.Players.LocalPlayer

local function disableAFKCheck()
    local function disableScriptInGui(gui)
        local afkCheckScript = gui:FindFirstChild("AFK.Check")
        if afkCheckScript and afkCheckScript:IsA("LocalScript") then
            afkCheckScript.Disabled = true
        end
    end

    local starterGuiAFKUi = StarterGui:FindFirstChild("AFK.Ui")
    if starterGuiAFKUi then
        disableScriptInGui(starterGuiAFKUi)
    end

    local playerGuiAFKUi = player.PlayerGui:FindFirstChild("AFK.Ui")
    if playerGuiAFKUi then
        disableScriptInGui(playerGuiAFKUi)
    end
end

disableAFKCheck()

-----------------------------------------------------------[READY-UP SETUP]-----------------------------------------------------------------------------------
if game.PlaceId == 15297128281 then
    local reclobby = Tabs.Main:AddLeftGroupbox('Lobby')
    
    reclobby:AddToggle('AutoReady', { Text = 'Auto Ready', Default = false, Callback = function(state)
        _G.AutoReady = state
    end})

    spawn(function()
        while true do
            if _G.AutoReady then
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local Remotes = ReplicatedStorage:WaitForChild("Remotes")
                local MainRE = Remotes:WaitForChild("Main.RE")
                
                local args = {
                    [1] = "Change Ready Settings",
                    [2] = true
                }
                
                MainRE:FireServer(unpack(args))
            end
            wait(1) 
        end
    end)

    reclobby:AddInput('JoinParty', {Text = 'Join Party', Default = '', Callback = function(playerName)
        if playerName and playerName ~= '' then
            local args = {
                [1] = "Accept Squad Invite",
                [2] = game:GetService("Players"):WaitForChild(playerName) 
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Main.RE"):FireServer(unpack(args))
        end
    end})
end

-----------------------------------------------------------[REC SET-UP]-----------------------------------------------------------------------------------
if game.PlaceId == 14269621394 then
    local Config = Tabs.Main:AddLeftGroupbox('Config')
    Config:AddToggle("Xp", { Text = "Multi / ⚠️USE AT YOUR OWN RISK⚠️", Callback = function(state)
        if state then
            spawn(function()
                while Toggles.Xp.Value do
                    Library:Notify("TURN IT OFF", 1)
                    wait(1)
                end
            end)
        end
    end })
    Config:AddSlider("ChangeValue", { Text = "Value", Default = 50, Min = 1, Max = 100, Rounding = 1, Compact = true })
    Config:AddDropdown('Multiplier', { Values = { '1', '2', '5', '65' }, Default = 100, Multi = false, Text = 'Ammount' })
    
    local Farm = Tabs.Main:AddLeftGroupbox('Farm')
    local Misc = Tabs.Main:AddLeftGroupbox('Misc')

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local localPlayer = Players.LocalPlayer

    local backpack = localPlayer:WaitForChild("Backpack")
    local actionValues = backpack:WaitForChild("ActionValues")
    local power = actionValues:WaitForChild("Power")

    local connection

    local function onPowerChanged()
        if power.Value >= Options.ChangeValue.Value and _G.Xp then
            local args = {
                [1] = false,
                [2] = "Shooting",
                [3] = "Standing Shot"
            }

            local shotMultiplier = _G.Multiplier

            local playerEvents = backpack:FindFirstChild("PlayerEvents") or ReplicatedStorage:FindFirstChild("PlayerEvents")

            if playerEvents then
                local shootingEvent = playerEvents:FindFirstChild("Shooting")
                if shootingEvent then
                    for i = 1, shotMultiplier do
                        shootingEvent:FireServer(unpack(args))
                    end
                end
            end
        end
    end

    connection = power:GetPropertyChangedSignal("Value"):Connect(onPowerChanged)

    Toggles.Xp:OnChanged(function() _G.Xp = Toggles.Xp.Value end)
    Toggles.Xp:SetValue(false)
    Options.Multiplier:OnChanged(function() _G.Multiplier = Options.Multiplier.Value end) 
    _G.Multiplier = Options.Multiplier.Value
    Options.ChangeValue:OnChanged(function() _G.ChangeValue = Options.ChangeValue.Value end) 
    _G.ChangeValue = Options.ChangeValue.Value

    Misc:AddButton({ Text = 'Anti 3 Sec', Func = function() 
        local hitbox = workspace:FindFirstChild("Hitboxes") and workspace.Hitboxes:FindFirstChild("3SEC")
        if hitbox then
            hitbox:Destroy()
        end
    end })

    local freethrowThread

    Misc:AddToggle("AntiCherry", { Text = "AntiCherry (If your going afk)" }, function(state)
        if state then
            -- Start Freethrow in a new thread
            freethrowThread = coroutine.create(function()
                Freethrow(game.Players.LocalPlayer)
            end)
            coroutine.resume(freethrowThread)
        else
            -- Stop Freethrow by breaking the loop (add a stop flag)
            _G.StopFreethrow = true
        end
    end)

    function Freethrow(v)
        _G.StopFreethrow = false
        while not _G.StopFreethrow do
            local freethrowActive = false
            if v and v.Character and v.Character:FindFirstChild("Currently_ShootingFreethrows") then
                print("Active - Team: " .. (v.Team and v.Team.Name or "No Team") .. ", Username: " .. v.Name)
                freethrowActive = true
            end

            if not freethrowActive then
                if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local currentPos = v.Character.HumanoidRootPart.Position
                    local targetPos = Vector3.new(-26, 4, -421)
                    if (currentPos - targetPos).Magnitude > 1 then
                        wait(3) 
                        v.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                    end
                end
            end

            wait(1)
        end
    end


    local Test = Tabs.Main:AddLeftGroupbox('Badge Progress')
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local RightHand = Character:WaitForChild("RightHand")
    local HumanoidsFolder = workspace:WaitForChild("Humanoids")

    local badgeEXP = {
        Defending = ReplicatedStorage:WaitForChild("GameValues"):WaitForChild("Players")
                    :WaitForChild(LocalPlayer.Name):WaitForChild("BadgeEXP"):WaitForChild("Defending_Rebounding"),
        Shooting = ReplicatedStorage:WaitForChild("GameValues"):WaitForChild("Players")
                    :WaitForChild(LocalPlayer.Name):WaitForChild("BadgeEXP"):WaitForChild("Shooting"),
        Finishing = ReplicatedStorage:WaitForChild("GameValues"):WaitForChild("Players")
                    :WaitForChild(LocalPlayer.Name):WaitForChild("BadgeEXP"):WaitForChild("Finishing"),
        Playmaking = ReplicatedStorage:WaitForChild("GameValues"):WaitForChild("Players")
                    :WaitForChild(LocalPlayer.Name):WaitForChild("BadgeEXP"):WaitForChild("Playmaking")
    }

    local warmupFinished = ReplicatedStorage:WaitForChild("GameValues"):WaitForChild("WarmupFinished")

    local progressLabels = {
        Defending = Test:AddLabel("Defensive XP: 0", true),
        Shooting = Test:AddLabel("Shooting XP: 0", true),
        Finishing = Test:AddLabel("Finishing XP: 0", true),
        Playmaking = Test:AddLabel("Playmaking XP: 0", true)
    }

    local function updateXPDisplay(badgeType, value)
        progressLabels[badgeType]:SetText(badgeType .. " XP: " .. tostring(value))
    end

    for badgeType, badgeValue in pairs(badgeEXP) do
        updateXPDisplay(badgeType, badgeValue.Value)
        badgeValue:GetPropertyChangedSignal("Value"):Connect(function()
            updateXPDisplay(badgeType, badgeValue.Value)
        end)
    end

    local function getNearestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end

        return closestPlayer
    end

    Farm:AddToggle('AutoDefensive', { Text = 'Auto Defensive', Default = false, Callback = function(state)
		 _G.AutoDefensive = state
        if state then
            spawn(function()
                while _G.AutoDefensive do
                    if badgeEXP.Defending.Value >= 10300 then
                        print("Stopping loop: Defending/Rebounding XP reached 1300.")
                        _G.AutoDefensive = false
                        break
                    end

                    local humanoid = HumanoidsFolder:FindFirstChild(LocalPlayer.Name)
                    if humanoid and Character then
                        local args = {
                            [1] = true,
                            [2] = "Steal",
                            [3] = humanoid,
                            [4] = RightHand
                        }
                        ReplicatedStorage:WaitForChild("PlayerEvents"):WaitForChild("Physical"):FireServer(unpack(args))
                    end
                    wait(0.01) -- more realistic wait
                end
            end)
        end
    end})
end


--------------------------------------------------------------[SETTINGS SETUP]-------------------------------------------------------------------------------------
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'K', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Hippo Hub')
SaveManager:SetFolder('Hippo Hub/Project Hippo')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
