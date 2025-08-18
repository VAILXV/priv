local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({ Title = 'Waffi [Pihlly Streetz 2]', Center = true, AutoShow = true })
local Tabs = {Main = Window:AddTab('Main'),['UI Settings'] = Window:AddTab('UI Settings')}

local VirtualUser = game:GetService('VirtualUser')
local StarterGui = game:GetService('StarterGui')

game:GetService("StarterPlayer").StarterCharacterScripts.Important.Disabled = true

StarterGui:SetCore("SendNotification", { Title = "Anti-AFK", Text = "Script Activated", Duration = 5 })

game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local ShootGroupBox = Tabs.Main:AddLeftGroupbox('Shooting')
local Main = Tabs.Main:AddLeftGroupbox('Farms (More Soon)')
local Misc = Tabs.Main:AddRightGroupbox('Misc')

local TrashFarm = false

Main:AddToggle('Trash Farm', {Text = 'Trash Farm', Default = false, Tooltip = 'USE SCRIPT ON ALT ONLY!!', Callback = function(value) TrashFarm = value end})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:FindFirstChild("HumanoidRootPart")

local TweenService = game:GetService("TweenService")

local trashPart = workspace.Interactions.toolInteractions.TrashPart
local sellTrashPart = workspace.Interactions.sellInteractions.trashPart

local speed = 300

local function tweenToCFrame(targetCFrame, callback)
    if hrp then
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local duration = distance / speed
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        if callback then
            tween.Completed:Connect(callback)
        end
        tween:Play()
    end
end

local function firePrompt(part)
    if part then
        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            prompt.HoldDuration = 0
            task.wait(0.1)
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end
    end
end

local function equip_Tool(toolName)
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        local tool = backpack:FindFirstChild(toolName)
        if tool then
            tool.Parent = character
        end
    end
end

task.spawn(function()
    while true do
        if TrashFarm then
            tweenToCFrame(CFrame.new(trashPart.Position), function()
                firePrompt(trashPart)
                task.wait(0.5)
                equip_Tool("Trash Bag")
                tweenToCFrame(CFrame.new(sellTrashPart.Position), function()
                    task.wait(0.1)
                    local prompt = sellTrashPart:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        prompt.HoldDuration = 0
                        task.wait(0.1)
                        prompt:InputHoldBegin()
                        task.wait(0.1)
                        prompt:InputHoldEnd()
                    end
                end)
            end)
            task.wait(2)
        else
            task.wait(0.5)
        end
    end
end)


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:FindFirstChild("HumanoidRootPart")

local Teleport = Tabs.Main:AddRightGroupbox('Teleports')
local TweenService = game:GetService("TweenService")

local function tweenToPosition(targetCFrame, speed)
    if hrp then
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local duration = distance / speed
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        tween:Play()
    end
end

Teleport:AddButton({ Text = 'Clothing Store', Func = function() tweenToPosition(CFrame.new(887, 317, -318), 350) end })
Teleport:AddButton({ Text = 'Gun Store', Func = function() tweenToPosition(CFrame.new(192, 318, 957), 350) end })
Teleport:AddButton({ Text = 'Shoe Store', Func = function() tweenToPosition(CFrame.new(2468, 284, -374), 350) end })
Teleport:AddButton({ Text = 'P Mobile', Func = function() tweenToPosition(CFrame.new(693, 317, -77), 350) end })
Teleport:AddButton({ Text = 'Printer Guy ', Func = function() tweenToPosition(CFrame.new(-134, 317, 161), 350) end })
Teleport:AddButton({ Text = 'Guapo', Func = function() tweenToPosition(CFrame.new(177, 317, -165), 350) end })
Teleport:AddButton({ Text = 'Apartments', Func = function() tweenToPosition(CFrame.new(214, 317, 83), 350) end })
Teleport:AddButton({ Text = 'ATM', Func = function() tweenToPosition(CFrame.new(172, 317, 270), 450) end })
Teleport:AddButton({ Text = 'Wash Money', Func = function() tweenToPosition(CFrame.new(2449, 286, -1332), 350) end })
Teleport:AddButton({ Text = 'Gun Store', Func = function() tweenToPosition(CFrame.new(192, 318, 957), 350) end })
Teleport:AddButton({ Text = 'Trash Job', Func = function() tweenToPosition(CFrame.new(288, 317, 794), 350) end })
Teleport:AddButton({ Text = 'Mask', Func = function() tweenToPosition(CFrame.new(900, 318, -338), 350) end })

Teleport:AddDivider()

Misc:AddButton('Get Low Server', function()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"

    local _place = game.PlaceId
    local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
    function ListServers(cursor)
        local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
        return Http:JSONDecode(Raw)
    end

    local Server, Next; repeat
        local Servers = ListServers(Next)
        Server = Servers.data[1]
        Next = Servers.nextPageCursor
    until Server

    TPS:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
end)



local AimLockToggle = ShootGroupBox:AddToggle('AimLock', { Text = 'Aim Lock',Tooltip = 'Hold RightMoue Button to lock on', Default = false })
local MaxAimDistanceSlider = ShootGroupBox:AddSlider('MaxAimDistance', { Text = 'Max Aim Distance', Default = 100, Min = 10, Max = 500, Rounding = 1, AutoRound = true, Suffix = 'Studs' })
local FOVRadiusSlider = ShootGroupBox:AddSlider('FOVRadius', { Text = 'FOV Radius', Default = 150, Min = 50, Max = 500, Rounding = 1, AutoRound = true, Suffix = 'px' })
local AimPartDropdown = ShootGroupBox:AddDropdown('AimPart', { Text = 'Aim Part', Default = 'UpperTorso', Values = { 'Head', 'UpperTorso', 'HumanoidRootPart' } })

local function AimLock()
    if _G.AimLock then
        local player = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")

        local lockOn = false
        local target = nil
        local isRightMouseButtonDown = false
        local whitelist = { "keihura" }

        pcall(function()
            for _, friend in pairs(player:GetFriendsOnline()) do
                table.insert(whitelist, friend.UserName)
            end
        end)

        local function isWhitelisted(playerName)
            for _, name in pairs(whitelist) do
                if playerName == name then
                    return true
                end
            end
            return false
        end

        local function findNearestTarget()
            local nearestScreenDistance = math.huge
            local nearestTarget = nil
            local maxWorldDistance = MaxAimDistanceSlider.Value
            local fovRadius = FOVRadiusSlider.Value
            local mouseLocation = UserInputService:GetMouseLocation()
            local aimPartName = AimPartDropdown.Value

            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player and not isWhitelisted(otherPlayer.Name) then
                    local character = otherPlayer.Character
                    if character and character:FindFirstChild("Humanoid") and character:FindFirstChild(aimPartName) then
                        local humanoid = character.Humanoid
                        local aimPart = character:FindFirstChild(aimPartName)
                        if humanoid.Health > 0 and aimPart then
                            local aimPartPosition = aimPart.Position
                            local screenPoint, onScreen = camera:WorldToScreenPoint(aimPartPosition)

                            if onScreen then
                                local worldDistance = (aimPartPosition - player.Character.Head.Position).Magnitude
                                if worldDistance <= maxWorldDistance then
                                    local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLocation).Magnitude

                                    if screenDistance <= fovRadius then
                                        if screenDistance < nearestScreenDistance then
                                            nearestScreenDistance = screenDistance
                                            nearestTarget = aimPart
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return nearestTarget
        end


        local fovCircle = nil

        local function createFOVCircle()
            if Drawing and Drawing.new then
                fovCircle = Drawing.new("Circle")
                fovCircle.Visible = false
                fovCircle.Color = Color3.new(1, 1, 1)
                fovCircle.Thickness = 2
                fovCircle.Transparency = 0.5
            end
        end

		local function updateFOVCircle() if fovCircle and fovCircle.Visible then fovCircle.Position, fovCircle.Radius = UserInputService:GetMouseLocation(), FOVRadiusSlider.Value end end

		local function destroyFOVCircle() if fovCircle then fovCircle:Remove() fovCircle = nil end end


        local inputBeganConnection
        local inputEndedConnection
        local renderSteppedConnection

        inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.UserInputType == Enum.UserInputType.MouseButton2 and not gameProcessedEvent then
                isRightMouseButtonDown = true

                if fovCircle then
                    fovCircle.Visible = true
                else
                    createFOVCircle()
                     if fovCircle then fovCircle.Visible = true end
                end


            end
        end)

        inputEndedConnection = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                isRightMouseButtonDown = false
                lockOn = false
                target = nil
                if fovCircle then
                    fovCircle.Visible = false
                end
            end
        end)

        renderSteppedConnection = RunService.RenderStepped:Connect(function()
            if isRightMouseButtonDown then
                 updateFOVCircle()
            end


            if isRightMouseButtonDown and not lockOn then
                local newTarget = findNearestTarget()
                if newTarget then
                    lockOn = true
                    target = newTarget
                end
            end


            if lockOn and target and target.Parent and target.Parent:FindFirstChild("Humanoid") and target.Parent.Humanoid.Health > 0 then
                local distanceToTarget = (target.Position - player.Character.Head.Position).Magnitude
                local fovRadius = FOVRadiusSlider.Value
                local mouseLocation = UserInputService:GetMouseLocation()
                local screenPoint, onScreen = camera:WorldToScreenPoint(target.Position)

                local isWithinFOV = false
                if onScreen then
                     local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLocation).Magnitude
                     if screenDistance <= fovRadius then
                         isWithinFOV = true
                     end
                end

                if distanceToTarget <= MaxAimDistanceSlider.Value and isWithinFOV then
                     local targetPosition = target.Position
                     camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition)
                else
                    lockOn = false
                    target = nil
                end
            else
                 if lockOn then
                    lockOn = false
                    target = nil
                 end
            end


        end)

        local cleanup = function()
            if inputBeganConnection then inputBeganConnection:Disconnect() end
            if inputEndedConnection then inputEndedConnection:Disconnect() end
            if renderSteppedConnection then renderSteppedConnection:Disconnect() end
            destroyFOVCircle()
            lockOn = false
            target = nil
            isRightMouseButtonDown = false
        end

        createFOVCircle()

        return cleanup
    end
end

local aimLockCleanup = nil

AimLockToggle:OnChanged(function()
    _G.AimLock = AimLockToggle.Value
    if _G.AimLock then
        aimLockCleanup = AimLock()
    elseif aimLockCleanup then
        aimLockCleanup()
        aimLockCleanup = nil
    end
end)

AimLockToggle:SetValue(false)


local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'Z', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind
