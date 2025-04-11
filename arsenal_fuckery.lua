print(" ")
print("=====================================")
print("     FUCKERY HUB LOADED - LET'S GO!  ")
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
]])
print(" ")
print("Loaded by: d4mage1")
print("Version: 1.1 - Arsenal Edition")
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

-- Create Window
local discordInvite = "https://discord.gg/mAFyAPnVA4"
local Window = Rayfield:CreateWindow({
    Name = "Fuckery Hub",
    LoadingTitle = "Fuckery Hub",
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
            -- Snap camera to neutral when toggled off
            local currentCFrame = camera.CFrame
            local flatLook = currentCFrame.Position + (currentCFrame.LookVector * Vector3.new(1, 0, 1)).Unit * 10
            camera.CFrame = CFrame.new(currentCFrame.Position, flatLook)
        end
    end
})

local fovSize = 150
CombatTab:CreateSlider({
    Name = "Aimbot FOV Size",
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

-- Discord Fix Tab
local DiscordTab = Window:CreateTab("Discord Fix")
DiscordTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard(discordInvite)
        Rayfield:Notify({
            Title = "Discord Invite Copied",
            Content = "Paste this in your browser to join: " .. discordInvite,
            Duration = 5,
            Image = "rbxassetid://4483345998"
        })
    end
})

-- ESP Functions
local function addESP(target, playerName)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    if target == player.Character then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Adornee = target:FindFirstChild("HumanoidRootPart")
    box.Color3 = Color3.fromRGB(255, 0, 0)
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
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local isEnemy = (player.Team ~= v.Team) or not player.Team or not v.Team
            if isEnemy then
                addESP(v.Character, v.Name)
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

-- Main Loop
runService.RenderStepped:Connect(function()
    if espEnabled then updateESP() else clearESP() end
    if hitboxExtenderEnabled then hookFireServer() end
end)

-- Aimbot Logic
local target = nil
local locked = false

local function findNewTarget()
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
    target = findNewTarget()
    if target then
        locked = true
        print("Locked onto: " .. target.Parent.Name)
    else
        print("No target found")
    end
end)

mouse.Button2Up:Connect(function()
    locked = false
    target = nil
    print("Aimbot unlocked")
    -- Snap camera to neutral on release
    local currentCFrame = camera.CFrame
    local flatLook = currentCFrame.Position + (currentCFrame.LookVector * Vector3.new(1, 0, 1)).Unit * 10
    camera.CFrame = CFrame.new(currentCFrame.Position, flatLook)
end)

runService.RenderStepped:Connect(function()
    if aimbotEnabled and locked then
        if not target or not target.Parent or not target.Parent:FindFirstChild("Humanoid") or target.Parent.Humanoid.Health <= 0 or target.Parent.Humanoid:GetState() == Enum.HumanoidStateType.Dead then
            print("Target invalid: " .. (target and target.Parent.Name or "nil"))
            target = findNewTarget()
            if not target then
                locked = false
                print("No target, snapping camera")
                local currentCFrame = camera.CFrame
                local flatLook = currentCFrame.Position + (currentCFrame.LookVector * Vector3.new(1, 0, 1)).Unit * 10
                camera.CFrame = CFrame.new(currentCFrame.Position, flatLook)
                return
            end
            print("New target: " .. target.Parent.Name)
        end
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
        camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.8)
    end
end)

print("Script updated to v1.1 by d4mage1 - Fixed aimbot looking down and added Discord button.")
