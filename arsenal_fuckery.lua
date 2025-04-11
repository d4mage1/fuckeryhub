print(" ")
print("=====================================")
print("     FUCKERY HUB - ARSENAL LOADED    ")
print("=====================================")
print(" ")
print([[
                      _         _                  _ _  _                             __ 
                     | |       | |                | | || |                           /_ |
  _ __ ___   __ _  __| | ___   | |__  _   _     __| | || |_ _ __ ___   __ _  __ _  ___| |
 | '_ ` _ \ / _` |/ _` |/ _ \  | '_ \| | | |   / _` |__   _| '_ ` _ \ / _` |/ _` |/ _ \ |
 | | | | | | (_| | (_| |  __/  | |_) | |_| |  | (_| |  | | | | | | | | (_| | (_| |  __/ |
 |_| |_| |_|\__,_|\__,_|\___|  |_.__/ \__, |   \__,_|  |_| |_| |_| |_|\__,_|\__, |\___|_|
                                       __/ |                                 __/ |       
                                      |___/                                 |___/        
]])__
print(" ")
print("Loaded by: d4mage1")
print("Version: 1.2 - Arsenal Edition")
print(" ")

-- Services
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local teams = game:GetService("Teams")
local uis = game:GetService("UserInputService")

-- Load Rayfield UI Library
local Rayfield
local rayfieldUrl = "https://sirius.menu/rayfield"
local success, rawScript = pcall(function()
    return game:HttpGet(rayfieldUrl)
end)
if not success then
    print("Failed to load Rayfield: " .. tostring(rawScript))
    return
end
Rayfield = loadstring(rawScript)()

-- Create Window (Integrated with Hub)
local discordInvite = "https://discord.gg/mAFyAPnVA4"
local Window = Rayfield:CreateWindow({
    Name = "Fuckery Hub - Arsenal",
    LoadingTitle = "Fuckery Hub - Arsenal",
    LoadingSubtitle = "by d4mage1",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FuckeryHub",
        FileName = "ArsenalConfig"
    },
    Discord = {
        Enabled = true,
        Invite = discordInvite,
        RememberJoins = true
    },
    KeySystem = false
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat")

local aimbotEnabled = false
CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        aimbotEnabled = Value
        if not Value then
            locked = false
            target = nil
            local currentCFrame = camera.CFrame
            local flatLook = currentCFrame.Position + (currentCFrame.LookVector * Vector3.new(1, 0, 1)).Unit * 10
            camera.CFrame = CFrame.new(currentCFrame.Position, flatLook)
        end
    end
})

local aimAssistEnabled = false
CombatTab:CreateToggle({
    Name = "Enable Aim Assist",
    CurrentValue = false,
    Flag = "AimAssistToggle",
    Callback = function(Value)
        aimAssistEnabled = Value
    end
})

local fovSize = 150
CombatTab:CreateSlider({
    Name = "Aimbot/Assist FOV Size",
    Range = {50, 350},
    Increment = 1,
    Suffix = "Units",
    CurrentValue = 150,
    Flag = "FOVSlider",
    Callback = function(Value)
        fovSize = Value
    end
})

local hitboxExtenderEnabled = false
CombatTab:CreateToggle({
    Name = "Enable Hitbox Extender",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(Value)
        hitboxExtenderEnabled = Value
    end
})

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals")

local espEnabled = false
local espBoxes = {}
local espColor = Color3.fromRGB(255, 0, 0)
VisualsTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        espEnabled = Value
        if not espEnabled then
            clearESP()
        end
    end
})

VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Color = espColor,
    Flag = "ESPColorPicker",
    Callback = function(Value)
        espColor = Value
    end
})

local fovCircleEnabled = false
local fovCircleSize = 150
local fovCircleColor = Color3.fromRGB(255, 255, 255)
local fovCircle = nil

VisualsTab:CreateToggle({
    Name = "Enable FOV Circle",
    CurrentValue = false,
    Flag = "FOVCircleToggle",
    Callback = function(Value)
        fovCircleEnabled = Value
        if fovCircleEnabled then
            if not fovCircle then
                fovCircle = Drawing.new("Circle")
                fovCircle.Thickness = 2
                fovCircle.NumSides = 64
                fovCircle.Radius = fovCircleSize
                fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
                fovCircle.Color = fovCircleColor
                fovCircle.Visible = true
            end
        else
            if fovCircle then
                fovCircle.Visible = false
            end
        end
    end
})

VisualsTab:CreateSlider({
    Name = "FOV Circle Size",
    Range = {50, 350},
    Increment = 1,
    Suffix = "Units",
    CurrentValue = 150,
    Flag = "FOVCircleSizeSlider",
    Callback = function(Value)
        fovCircleSize = Value
        if fovCircle then
            fovCircle.Radius = fovCircleSize
        end
    end
})

VisualsTab:CreateColorPicker({
    Name = "FOV Circle Color",
    Color = fovCircleColor,
    Flag = "FOVCircleColorPicker",
    Callback = function(Value)
        fovCircleColor = Value
        if fovCircle then
            fovCircle.Color = fovCircleColor
        end
    end
})

-- Discord Fix Tab
local DiscordTab = Window:CreateTab("Discord Fix")
DiscordTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        local success, err = pcall(function()
            setclipboard(discordInvite)
        end)
        if success then
            print("Copied Discord invite to clipboard: " .. discordInvite)
        else
            print("Failed to copy Discord invite: " .. tostring(err))
            print("Join the Discord here: " .. discordInvite)
        end
    end
})

-- ESP Functions
local function addESP(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") or target == player.Character then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Adornee = target.HumanoidRootPart
    box.Color3 = espColor
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = target
    table.insert(espBoxes, box)
end

local function clearESP()
    for _, box in pairs(espBoxes) do
        if box then box:Destroy() end
    end
    espBoxes = {}
end

local function updateESP()
    if not espEnabled then
        clearESP()
        return
    end
    clearESP()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local isEnemy = (player.Team ~= v.Team) or not player.Team or not v.Team
            if isEnemy then
                addESP(v.Character)
            end
        end
    end
end

for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= player then
        v.CharacterAdded:Connect(function()
            if espEnabled then updateESP() end
        end)
    end
end

game.Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function()
        if espEnabled then updateESP() end
    end)
end)

-- Hitbox Extender Logic
local hooked = false
local originalFireServer
local function hookFireServer()
    if hooked then return end
    local remotes = game.ReplicatedStorage:FindFirstChild("Events") or game.ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local shootEvent = remotes:FindFirstChild("Shoot") or remotes:FindFirstChild("Fire") or remotes:FindFirstChild("Hit") or remotes:FindFirstChild("Bullet")
        if shootEvent then
            originalFireServer = shootEvent.FireServer
            shootEvent.FireServer = function(self, targetPos, ...)
                if hitboxExtenderEnabled then
                    local closestEnemy, shortestDist = nil, 10
                    for _, enemy in pairs(game.Players:GetPlayers()) do
                        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") and enemy.Character.Humanoid.Health > 0 then
                            local isEnemy = (player.Team ~= enemy.Team) or not player.Team or not enemy.Team
                            if isEnemy then
                                local dist = (enemy.Character.Head.Position - targetPos).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    closestEnemy = enemy.Character.Head
                                end
                            end
                        end
                    end
                    if closestEnemy then targetPos = closestEnemy.Position end
                end
                return originalFireServer(self, targetPos, ...)
            end
            hooked = true
        end
    end
end

-- Aimbot and Aim Assist Logic
local target = nil
local locked = false

local function findTarget(forAimAssist)
    local closest, shortestDist = nil, math.huge
    local cursorPos = Vector2.new(mouse.X, mouse.Y)
    for _, enemy in pairs(game.Players:GetPlayers()) do
        if enemy ~= player and enemy.Character then
            local head = enemy.Character:FindFirstChild("Head")
            local humanoid = enemy.Character:FindFirstChild("Humanoid")
            if head and humanoid and humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                local isEnemy = (player.Team ~= enemy.Team) or not player.Team or not enemy.Team
                if isEnemy then
                    local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - cursorPos).Magnitude
                        if dist < fovSize and dist < shortestDist then
                            shortestDist = dist
                            closest = head
                        end
                    end
                end
            end
        end
    end
    return closest
end

mouse.Button2Down:Connect(function()
    if not aimbotEnabled then return end
    target = findTarget(false)
    if target then
        locked = true
        print("Aimbot locked onto: " .. target.Parent.Name)
    else
        print("No aimbot target found")
    end
end)

mouse.Button2Up:Connect(function()
    locked = false
    target = nil
    print("Aimbot unlocked")
    local currentCFrame = camera.CFrame
    local flatLook = currentCFrame.Position + (currentCFrame.LookVector * Vector3.new(1, 0, 1)).Unit * 10
    camera.CFrame = CFrame.new(currentCFrame.Position, flatLook)
end)

runService.RenderStepped:Connect(function()
    -- Update FOV Circle
    if fovCircleEnabled and fovCircle then
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
        fovCircle.Radius = fovCircleSize
        fovCircle.Color = fovCircleColor
        fovCircle.Visible = true
    end

    -- ESP Update
    if espEnabled then updateESP() else clearESP() end

    -- Hitbox Extender
    if hitboxExtenderEnabled then hookFireServer() end

    -- Aimbot
    if aimbotEnabled and locked then
        if not target or not target.Parent or not target.Parent:FindFirstChild("Humanoid") or target.Parent.Humanoid.Health <= 0 or target.Parent.Humanoid:GetState() == Enum.HumanoidStateType.Dead then
            print("Aimbot target invalid: " .. (target and target.Parent.Name or "nil"))
            target = findTarget(false)
            if not target then
                locked = false
                print("No aimbot target, resetting camera")
                local currentCFrame = camera.CFrame
                local flatLook = currentCFrame.Position + (currentCFrame.LookVector * Vector3.new(1, 0, 1)).Unit * 10
                camera.CFrame = CFrame.new(currentCFrame.Position, flatLook)
                return
            end
            print("Aimbot new target: " .. target.Parent.Name)
        end
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
        camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.8)
    end

    -- Aim Assist
    if aimAssistEnabled and not locked then
        local assistTarget = findTarget(true)
        if assistTarget then
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, assistTarget.Position)
            camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.2)
        end
    end
end)

print("Fuckery Hub Arsenal script loaded - v1.2 by d4mage1")
