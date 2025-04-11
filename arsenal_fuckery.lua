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
print("Version: 1.0 - Arsenal Edition")
print(" ")

-- Services
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local teams = game:GetService("Teams")
local uis = game:GetService("UserInputService")

-- Load Rayfield UI Library with Better Error Handling
local Rayfield
local rayfieldUrl = "https://sirius.menu/rayfield"
local rayfieldFallbackUrl = "https://raw.githubusercontent.com/UI-Interface/Rayfield/main/source"
local rawScript

local success, errorMsg = pcall(function()
    rawScript = game:HttpGet(rayfieldUrl)
end)

if not success then
    print("Failed to fetch Rayfield from primary URL: " .. tostring(errorMsg))
    success, errorMsg = pcall(function()
        rawScript = game:HttpGet(rayfieldFallbackUrl)
    end)
    if not success then
        print("Failed to fetch Rayfield from fallback URL: " .. tostring(errorMsg))
        return
    end
end

success, errorMsg = pcall(function()
    Rayfield = loadstring(rawScript)()
end)

if not success or not Rayfield then
    print("Failed to load Rayfield UI Library: " .. tostring(errorMsg))
    return
end

-- Create Rayfield Window with Discord Join Requirement
local discordInvite = "https://discord.gg/tqSz4aVBg9" -- Replace with your Discord server invite link
local WindowSuccess, Window = pcall(function()
    return Rayfield:CreateWindow({
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
end)

if not WindowSuccess or not Window then
    print("Failed to create Rayfield Window: " .. tostring(Window))
    return
end

-- Combat Tab
local CombatTab
local CombatTabSuccess, CombatTabError = pcall(function()
    CombatTab = Window:CreateTab("Combat")
end)

if not CombatTabSuccess or not CombatTab then
    print("Failed to create Combat Tab: " .. tostring(CombatTabError))
    return
end

local aimbotEnabled = false
local aimbotToggleSuccess, aimbotToggleError = pcall(function()
    CombatTab:CreateToggle({
        Name = "Enable Aimbot",
        CurrentValue = false,
        Flag = "AimbotToggle",
        Callback = function(Value)
            aimbotEnabled = Value
        end
    })
end)

if not aimbotToggleSuccess then
    print("Failed to create Aimbot Toggle: " .. tostring(aimbotToggleError))
end

local fovSize = 150
local fovSliderSuccess, fovSliderError = pcall(function()
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
end)

if not fovSliderSuccess then
    print("Failed to create FOV Slider: " .. tostring(fovSliderError))
end

local hitboxExtenderEnabled = false
local hitboxSize = 10 -- Big hitbox as requested
local hitboxParts = {} -- Store custom hitbox parts
local hitboxToggleSuccess, hitboxToggleError = pcall(function()
    CombatTab:CreateToggle({
        Name = "Enable Hitbox Extender",
        CurrentValue = false,
        Flag = "HitboxToggle",
        Callback = function(Value)
            hitboxExtenderEnabled = Value
            if not hitboxExtenderEnabled then
                -- Clean up custom hitbox parts
                for _, part in pairs(hitboxParts) do
                    if part then
                        part:Destroy()
                    end
                end
                hitboxParts = {}
            end
        end
    })
end)

if not hitboxToggleSuccess then
    print("Failed to create Hitbox Extender Toggle: " .. tostring(hitboxToggleError))
end

-- Visuals Tab
local VisualsTab
local VisualsTabSuccess, VisualsTabError = pcall(function()
    VisualsTab = Window:CreateTab("Visuals")
end)

if not VisualsTabSuccess or not VisualsTab then
    print("Failed to create Visuals Tab: " .. tostring(VisualsTabError))
    return
end

local espEnabled = false
local espBoxes = {}
local espToggleSuccess, espToggleError = pcall(function()
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
end)

if not espToggleSuccess then
    print("Failed to create ESP Toggle: " .. tostring(espToggleError))
end

-- About Me Tab
local AboutTab
local AboutTabSuccess, AboutTabError = pcall(function()
    AboutTab = Window:CreateTab("About Me")
end)

if not AboutTabSuccess or not AboutTab then
    print("Failed to create About Me Tab: " .. tostring(AboutTabError))
else
    local aboutLabelSuccess, aboutLabelError = pcall(function()
        AboutTab:CreateLabel("Yo, I'm d4mage1, the mastermind behind Fuckery Hub, yk!")
        AboutTab:CreateLabel("I made this script to fuck shit up in Arsenal and have a good time.")
        AboutTab:CreateLabel("Shoutout to my homies for testing this out—y'all the real MVPs.")
        AboutTab:CreateLabel("Wanna hit me up? Catch me on Discord: d4mage1#1337")
        AboutTab:CreateLabel("Version: 1.0 | Last Updated: April 2025")
    end)
    if not aboutLabelSuccess then
        print("Failed to create About Me Labels: " .. tostring(aboutLabelError))
    end
end

-- ESP Functions (Fixed BoxHandleAdornment Method)
local function addESP(target, playerName)
    if not target or not target:FindFirstChild("HumanoidRootPart") then
        print("No HumanoidRootPart for " .. playerName .. ", skipping ESP")
        return
    end
    if target == player.Character then
        print("Attempted to add ESP to local player, skipping: " .. playerName)
        return
    end
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4) -- Fixed size to avoid scaling issues
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
        if box then
            box:Destroy()
        end
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
        if v == player then
            print("Skipping local player in ESP loop: " .. v.Name)
            continue
        end
        if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local playerTeam = player.Team
            local enemyTeam = v.Team
            local isEnemy = true
            if playerTeam and enemyTeam and playerTeam == enemyTeam then
                print("Skipping teammate in ESP: " .. v.Name .. " (Team: " .. tostring(enemyTeam) .. ")")
                isEnemy = false
            elseif not playerTeam or not enemyTeam then
                print("No teams detected, treating as enemy in ESP: " .. v.Name)
                isEnemy = true
            end
            if isEnemy then
                print("Adding ESP for enemy: " .. v.Name)
                addESP(v.Character, v.Name)
            end
        end
    end
end

for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= player then
        v.CharacterAdded:Connect(function(char)
            if espEnabled then
                updateESP()
            end
        end)
    end
end

game.Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if espEnabled then
            updateESP()
        end
    end)
end)

-- Hitbox Extender Logic (Using Custom Parts, Big and Slightly Transparent)
local function createHitboxPart(character)
    if not character or not character:FindFirstChild("Head") then return end
    local head = character.Head
    local hitboxPart = Instance.new("Part")
    hitboxPart.Name = "ExtendedHitbox"
    hitboxPart.Size = Vector3.new(10, 10, 10) -- Big hitbox (10x10x10 studs)
    hitboxPart.Transparency = 0.8 -- Slightly transparent
    hitboxPart.CanCollide = false
    hitboxPart.Anchored = false
    hitboxPart.Position = head.Position
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = hitboxPart
    weld.Parent = hitboxPart
    hitboxPart.Parent = character
    table.insert(hitboxParts, hitboxPart)
    return hitboxPart
end

-- Main Loop
runService.RenderStepped:Connect(function()
    -- ESP Update
    if espEnabled then
        updateESP()
    else
        clearESP()
    end

    -- Hitbox Extender Update
    if hitboxExtenderEnabled then
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") then
                local existingHitbox = enemy.Character:FindFirstChild("ExtendedHitbox")
                if not existingHitbox then
                    createHitboxPart(enemy.Character)
                end
            end
        end
    end
end)

-- Aimbot Logic (Sharper Turn, Lock On Until Kill, Then Find New Target)
local target = nil
local locked = false

local function findNewTarget()
    local closest = nil
    local shortestDist = math.huge
    local cursorPos = Vector2.new(mouse.X, mouse.Y)

    for _, enemy in pairs(game.Players:GetPlayers()) do
        if enemy == player then continue end
        if enemy.Character and enemy.Character:FindFirstChild("Head") and enemy.Character:FindFirstChild("Humanoid") and enemy.Character.Humanoid.Health > 0 then
            local playerTeam = player.Team
            local enemyTeam = enemy.Team
            local isEnemy = true
            if playerTeam and enemyTeam and playerTeam == enemyTeam then
                isEnemy = false
            elseif not playerTeam or not enemyTeam then
                isEnemy = true
            end
            if isEnemy then
                local head = enemy.Character.Head
                local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (screenPos2D - cursorPos).Magnitude
                    if dist < fovSize and dist < shortestDist then
                        shortestDist = dist
                        closest = head
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
    end
end)

mouse.Button2Up:Connect(function()
    locked = false
    target = nil
end)

runService.RenderStepped:Connect(function()
    if aimbotEnabled and locked then
        if not target or not target.Parent then
            target = findNewTarget()
            if not target then
                locked = false
                return
            end
        end

        local humanoid = target.Parent:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            target = findNewTarget()
            if not target then
                locked = false
                return
            end
        end

        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
        camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.8) -- Sharper turn (was 0.2)
    end
end)

print("This script is licensed under the GNU General Public License v3.0 Copyright (C) 2025 d4mage1 You can use, modify, and share this script as long as you keep it open-source and give credit.")
