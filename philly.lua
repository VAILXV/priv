local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({ Title = 'Waffi [Pihlly Streetz 2]', Center = true, AutoShow = true })
local Tabs = {Main = Window:AddTab('Main'),['UI Settings'] = Window:AddTab('UI Settings')}

local VirtualUser = game:GetService('VirtualUser')
local StarterGui = game:GetService('StarterGui')

StarterGui:SetCore("SendNotification", { Title = "Anti-AFK", Text = "Script Activated", Duration = 5 })

game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local ShootGroupBox = Tabs.Main:AddLeftGroupbox('Shooting')
local Main = Tabs.Main:AddLeftGroupbox('Farms (More Soon)')
local Misc = Tabs.Main:AddRightGroupbox('Misc')


local TrashFarmEnabled = false

Main:AddToggle('Trash Farm', {Text = 'Trash Farm', Default = false, Tooltip = 'USE SCRIPT ON ALT ONLY!!', Callback = function(value) TrashFarmEnabled = value end})

spawn(function()
    local PathfindingService = game:GetService("PathfindingService")
    local player = game.Players.LocalPlayer

    local function walkTo(part)
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid or not part then return false end

        local path = PathfindingService:CreatePath({
            AgentRadius = 2,
            AgentHeight = 5,
            AgentCanJump = true,
            AgentJumpHeight = 10,
            AgentMaxSlope = 45,
            })
        path:ComputeAsync(hrp.Position, part.Position)
        if path.Status == Enum.PathStatus.Complete then
            local waypoints = path:GetWaypoints()
            for _, waypoint in ipairs(waypoints) do
                humanoid:MoveTo(waypoint.Position)
                humanoid.MoveToFinished:Wait()
            end
            return true
        else
            -- fallback: direct move
            humanoid:MoveTo(part.Position)
            humanoid.MoveToFinished:Wait()
            return false
        end
    end

    while true do
        if TrashFarmEnabled then
            local char = player.Character or player.CharacterAdded:Wait()
            local trashPart = workspace.Interactions.toolInteractions.TrashPart
            walkTo(trashPart)

            wait(1)
            local trashPrompt = trashPart.Interaction
            trashPrompt.HoldDuration = 0
            trashPrompt.Enabled = true
            trashPrompt.RequiresLineOfSight = false
            trashPrompt.MaxActivationDistance = 10

            trashPrompt:InputHoldBegin()
            wait(0.1)
            trashPrompt:InputHoldEnd()

            wait(0.5)
            local backpack = player.Backpack
            local trashBag = backpack:FindFirstChild("Trash Bag")
            if trashBag then
                trashBag.Parent = char
            end
            wait(0.5)
            local sellPart = workspace.Interactions.sellInteractions.trashPart
            walkTo(sellPart)

            local sellPrompt = sellPart.Interaction
            sellPrompt.HoldDuration = 0
            sellPrompt.Enabled = true
            sellPrompt.RequiresLineOfSight = false
            sellPrompt.MaxActivationDistance = 10

            wait(0.5)

            sellPrompt:InputHoldBegin()
            wait(0.1)
            sellPrompt:InputHoldEnd()

            wait(1)
        else
            wait(0.5)
        end
    end
end)



local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:FindFirstChild("HumanoidRootPart")

local Teleport = Tabs.Main:AddRightGroupbox('Teleports')
Teleport:AddButton({ Text = 'Clothing Store', Func = function() if hrp then hrp.CFrame = CFrame.new(887, 317, -318) end end })
Teleport:AddButton({ Text = 'Gun Store', Func = function() if hrp then hrp.CFrame = CFrame.new(192, 318, 957) end end })
Teleport:AddButton({ Text = 'Shoe Store', Func = function() if hrp then hrp.CFrame = CFrame.new(2468, 284, -374) end end })
Teleport:AddButton({ Text = 'P Mobile', Func = function() if hrp then hrp.CFrame = CFrame.new(693, 317, -77) end end })
Teleport:AddButton({ Text = 'Printer Guy ', Func = function() if hrp then hrp.CFrame = CFrame.new(-134, 317, 161) end end })
Teleport:AddButton({ Text = 'Guapo', Func = function() if hrp then hrp.CFrame = CFrame.new(177, 317, -165) end end })
Teleport:AddButton({ Text = 'Apartments', Func = function() if hrp then hrp.CFrame = CFrame.new(214, 317, 83) end end })
Teleport:AddButton({ Text = 'ATM', Func = function() if hrp then hrp.CFrame = CFrame.new(172, 317, 270) end end })
Teleport:AddButton({ Text = 'Wash Money', Func = function() if hrp then hrp.CFrame = CFrame.new(2449, 286, -1332) end end })
Teleport:AddButton({ Text = 'Gun Store', Func = function() if hrp then hrp.CFrame = CFrame.new(192, 318, 957) end end })
Teleport:AddButton({ Text = 'Trash Job', Func = function() if hrp then hrp.CFrame = CFrame.new(288, 317, 794) end end })
Teleport:AddButton({ Text = 'Mask', Func = function() if hrp then hrp.CFrame = CFrame.new(900, 318, -338) end end })

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


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function createESP(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "ESPLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Text = player.Name
    textLabel.Parent = billboard

    billboard.Parent = head
end

local function removeAllESP()
    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local esp = head:FindFirstChild("ESP")
                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end

-- ESP Update Loop
RunService.RenderStepped:Connect(function()
    if not _G.ESP then return end

    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local esp = head:FindFirstChild("ESP")
            if not esp then
                createESP(player)
            else
                local label = esp:FindFirstChild("ESPLabel")
                if label and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                    local distance = (LocalPlayer.Character.Head.Position - head.Position).Magnitude
                    label.Text = player.Name .. " | " .. math.floor(distance) .. " studs"
                end
            end
        end
    end
end)

-- 🔘 Linoria Toggle
local Esp = ShootGroupBox:AddToggle('ESP', {
    Text = 'ESP',
    Default = false,
    Callback = function(state)
        _G.ESP = state
        if not state then
            removeAllESP()
        end
    end
})


local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'Z', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind
