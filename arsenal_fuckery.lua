print(" ")
print("=====================================")
print("     FUCKERY HUB LOADED - LET'S GO!  ")
print("=====================================")
print(" ")
print([[
  __  __            _____   ______     ____ __     __    _____   _  _    __  __            _____  ______  __ 
 |  \/  |    /\    |  __ \ |  ____|   |  _ \\ \   / /   |  __ \ | || |  |  \/  |    /\    / ____||  ____|/_ |
 | \  / |   /  \   | |  | || |__      | |_) |\ \_/ /    | |  | || || |_ | \  / |   /  \  | |  __ | |__    | |
 | |\/| |  / /\ \  | |  | ||  __|     |  _ <  \   /     | |  | ||__   _|| |\/| |  / /\ \ | | |_ ||  __|   | |
 | |  | | / ____ \ | |__| || |____    | |_) |  | |      | |__| |   | |  | |  | | / ____ \| |__| || |____  | |
 |_|  |_|/_/    \_\|_____/ |______|   |____/   |_|      |_____/    |_|  |_|  |_|/_/    \_\\_____||______| |_|
                                                                                                             
                                                                                                             
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
        warn("Failed to fetch Rayfield from fallback URL: " .. tostring(errorMsg))
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Couldn't fetch Rayfield UI library. Error: " .. tostring(errorMsg) .. ". Try a different executor or check your internet, cuhh.",
            Duration = 10
        })
        return
    end
end

success, errorMsg = pcall(function()
    Rayfield = loadstring(rawScript)()
end)

if not success or not Rayfield then
    warn("Failed to load Rayfield UI Library: " .. tostring(errorMsg))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't load Rayfield UI. Error: " .. tostring(errorMsg) .. ". The Rayfield library might be down or broken, cuhh. Try a different executor or wait a bit.",
        Duration = 10
    })
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
    warn("Failed to create Rayfield Window: " .. tostring(Window))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Rayfield Window. Error: " .. tostring(Window) .. ". Try a different executor, cuhh.",
        Duration = 5
    })
    return
end

-- Notify that the GUI loaded successfully
game.StarterGui:SetCore("SendNotification", {
    Title = "Success",
    Text = "Fuckery Hub window loaded, cuhh! Press Right Shift to toggle the GUI.",
    Duration = 5
})

-- Combat Tab
local CombatTab
local CombatTabSuccess, CombatTabError = pcall(function()
    CombatTab = Window:CreateTab("Combat")
end)

if not CombatTabSuccess or not CombatTab then
    warn("Failed to create Combat Tab: " .. tostring(CombatTabError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Combat Tab: " .. tostring(CombatTabError) .. ", cuhh. Try a different executor, cuhh.",
        Duration = 5
    })
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
            Rayfield:Notify({
                Title = "Aimbot",
                Content = aimbotEnabled and "Aimbot enabled, cuhh!" or "Aimbot disabled, cuhh!",
                Duration = 3
            })
        end
    })
end)

if not aimbotToggleSuccess then
    warn("Failed to create Aimbot Toggle: " .. tostring(aimbotToggleError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Aimbot Toggle: " .. tostring(aimbotToggleError) .. ", cuhh.",
        Duration = 5
    })
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
            Rayfield:Notify({
                Title = "Aimbot FOV Size",
                Content = "Set aimbot FOV to " .. Value .. " units, cuhh!",
                Duration = 3
            })
        end
    })
end)

if not fovSliderSuccess then
    warn("Failed to create FOV Slider: " .. tostring(fovSliderError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create FOV Slider: " .. tostring(fovSliderError) .. ", cuhh.",
        Duration = 5
    })
end

local hitboxExtenderEnabled = false
local hitboxSize = 5
local hitboxParts = {} -- Store custom hitbox parts
local hitboxToggleSuccess, hitboxToggleError = pcall(function()
    CombatTab:CreateToggle({
        Name = "Enable Hitbox Extender",
        CurrentValue = false,
        Flag = "HitboxToggle",
        Callback = function(Value)
            hitboxExtenderEnabled = Value
            Rayfield:Notify({
                Title = "Hitbox Extender",
                Content = hitboxExtenderEnabled and "Hitbox extender enabled, cuhh!" or "Hitbox extender disabled, cuhh!",
                Duration = 3
            })
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
    warn("Failed to create Hitbox Extender Toggle: " .. tostring(hitboxToggleError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Hitbox Extender Toggle: " .. tostring(hitboxToggleError) .. ", cuhh.",
        Duration = 5
    })
end

local hitboxSliderSuccess, hitboxSliderError = pcall(function()
    CombatTab:CreateSlider({
        Name = "Hitbox Size",
        Range = {2, 10}, -- Reduced max size to prevent freezing
        Increment = 1,
        Suffix = "Studs",
        CurrentValue = 5,
        Flag = "HitboxSlider",
        Callback = function(Value)
            hitboxSize = Value
            Rayfield:Notify({
                Title = "Hitbox Size",
                Content = "Set hitbox size to " .. Value .. " studs, cuhh!",
                Duration = 3
            })
        end
    })
end)

if not hitboxSliderSuccess then
    warn("Failed to create Hitbox Size Slider: " .. tostring(hitboxSliderError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Hitbox Size Slider: " .. tostring(hitboxSliderError) .. ", cuhh.",
        Duration = 5
    })
end

-- Visuals Tab
local VisualsTab
local VisualsTabSuccess, VisualsTabError = pcall(function()
    VisualsTab = Window:CreateTab("Visuals")
end)

if not VisualsTabSuccess or not VisualsTab then
    warn("Failed to create Visuals Tab: " .. tostring(VisualsTabError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Visuals Tab: " .. tostring(VisualsTabError) .. ", cuhh.",
        Duration = 5
    })
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
            Rayfield:Notify({
                Title = "ESP",
                Content = espEnabled and "ESP enabled, cuhh!" or "ESP disabled, cuhh!",
                Duration = 3
            })
            if not espEnabled then
                clearESP()
            end
        end
    })
end)

if not espToggleSuccess then
    warn("Failed to create ESP Toggle: " .. tostring(espToggleError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create ESP Toggle: " .. tostring(espToggleError) .. ", cuhh.",
        Duration = 5
    })
end

-- About Me Tab
local AboutTab
local AboutTabSuccess, AboutTabError = pcall(function()
    AboutTab = Window:CreateTab("About Me")
end)

if not AboutTabSuccess or not AboutTab then
    warn("Failed to create About Me Tab: " .. tostring(AboutTabError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create About Me Tab: " .. tostring(AboutTabError) .. ", cuhh.",
        Duration = 5
    })
else
    local aboutLabelSuccess, aboutLabelError = pcall(function()
        AboutTab:CreateLabel("Yo, I'm d4mage1, the mastermind behind Fuckery Hub, yk!")
        AboutTab:CreateLabel("I made this script to fuck shit up in Arsenal and have a good time.")
        AboutTab:CreateLabel("Shoutout to my homies for testing this out—y'all the real MVPs.")
        AboutTab:CreateLabel("Wanna hit me up? Catch me on Discord: d4mage1#1337")
        AboutTab:CreateLabel("Version: 1.0 | Last Updated: April 2025")
    end)
    if not aboutLabelSuccess then
        warn("Failed to create About Me Labels: " .. tostring(aboutLabelError))
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Couldn't create About Me Labels: " .. tostring(aboutLabelError) .. ", cuhh.",
            Duration = 5
        })
    end
end

-- Settings Tab
local SettingsTab
local SettingsTabSuccess, SettingsTabError = pcall(function()
    SettingsTab = Window:CreateTab("Settings")
end)

if not SettingsTabSuccess or not SettingsTab then
    warn("Failed to create Settings Tab: " .. tostring(SettingsTabError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Settings Tab: " .. tostring(SettingsTabError) .. ", cuhh.",
        Duration = 5
    })
else
    local themeDropdownSuccess, themeDropdownError = pcall(function()
        SettingsTab:CreateDropdown({
            Name = "Theme",
            Options = {"Dark", "Light", "Fuckery"},
            CurrentOption = "Dark",
            Flag = "ThemeDropdown",
            Callback = function(Option)
                local success, err = pcall(function()
                    local gui = game:GetService("CoreGui"):FindFirstChild("Rayfield")
                    if not gui then
                        warn("Rayfield GUI not found in CoreGui")
                        return
                    end

                    local interface = gui:FindFirstChild("Interface")
                    if not interface then
                        warn("Interface not found in Rayfield GUI")
                        return
                    end

                    local window = interface:FindFirstChild("Window")
                    if not window then
                        warn("Window not found in Interface")
                        return
                    end

                    local tabList = window:FindFirstChild("TabList")
                    local content = window:FindFirstChild("Content")
                    if not tabList or not content then
                        warn("TabList or Content not found in Window")
                        return
                    end

                    -- Function to recursively change colors
                    local function updateColors(obj, bgColor, textColor, buttonColor)
                        if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                            obj.BackgroundColor3 = bgColor
                        end
                        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                            obj.TextColor3 = textColor
                            if obj:IsA("TextButton") then
                                obj.BackgroundColor3 = buttonColor
                            end
                        end
                        for _, child in pairs(obj:GetChildren()) do
                            updateColors(child, bgColor, textColor, buttonColor)
                        end
                    end

                    if Option == "Dark" then
                        updateColors(window, Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255), Color3.fromRGB(50, 50, 50))
                        Rayfield:Notify({
                            Title = "Theme",
                            Content = "Switched to Dark theme, cuhh!",
                            Duration = 3
                        })
                    elseif Option == "Light" then
                        updateColors(window, Color3.fromRGB(220, 220, 220), Color3.fromRGB(0, 0, 0), Color3.fromRGB(180, 180, 180))
                        Rayfield:Notify({
                            Title = "Theme",
                            Content = "Switched to Light theme, cuhh!",
                            Duration = 3
                        })
                    elseif Option == "Fuckery" then
                        updateColors(window, Color3.fromRGB(20, 0, 0), Color3.fromRGB(255, 0, 0), Color3.fromRGB(50, 0, 0))
                        Rayfield:Notify({
                            Title = "Theme",
                            Content = "Switched to Fuckery theme, cuhh! Red and black vibes!",
                            Duration = 3
                        })
                    end
                end)
                if not success then
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Failed to change theme: " .. tostring(err) .. ", cuhh.",
                        Duration = 5
                    })
                end
            end
        })
    end)
    if not themeDropdownSuccess then
        warn("Failed to create Theme Dropdown: " .. tostring(themeDropdownError))
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Couldn't create Theme Dropdown: " .. tostring(themeDropdownError) .. ", cuhh.",
            Duration = 5
        })
    end
end

-- ESP Functions
local function addESP(target, playerName)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    if target == player.Character then
        print("Attempted to add ESP to local player, skipping: " .. playerName)
        return
    end
    local box = Instance.new("BoxHandleAdornment")
    box.Size = target:GetExtentsSize() + Vector3.new(0.5, 0.5, 0.5)
    box.Adornee = target
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

-- Hitbox Extender Logic (Using Custom Parts)
local function createHitboxPart(character)
    if not character or not character:FindFirstChild("Head") then return end
    local head = character.Head
    local hitboxPart = Instance.new("Part")
    hitboxPart.Name = "ExtendedHitbox"
    hitboxPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
    hitboxPart.Transparency = 0.7
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
                else
                    existingHitbox.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                end
            end
        end
    end
end)

-- Aimbot Logic
local target = nil
local locked = false
local lastLookVector = camera.CFrame.LookVector

mouse.Button2Down:Connect(function()
    if not aimbotEnabled then return end

    local closest = nil
    local shortestDist = math.huge
    local mousePos = mouse.Hit.Position

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
                local dist = (head.Position - mousePos).Magnitude
                if dist < fovSize and dist < shortestDist then
                    shortestDist = dist
                    closest = head
                end
            end
        end
    end

    if closest then
        target = closest
        locked = true
        Rayfield:Notify({
            Title = "Aimbot",
            Content = "Locked onto " .. closest.Parent.Name .. ", cuhh!",
            Duration = 3
        })
    end
end)

mouse.Button2Up:Connect(function()
    locked = false
    target = nil
    local camPos = camera.CFrame.Position
    local newLookAt = camPos + (lastLookVector * 100)
    camera.CFrame = CFrame.new(camPos, newLookAt)
end)

runService.RenderStepped:Connect(function()
    if not locked then
        lastLookVector = camera.CFrame.LookVector
    end
    if aimbotEnabled and locked and target and target.Parent then
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
        camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.2)

        local char = player.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                -- Arsenal-specific firing logic
                local remotes = game.ReplicatedStorage:FindFirstChild("Events") or game.ReplicatedStorage:FindFirstChild("Remotes")
                if remotes then
                    local shootEvent = remotes:FindFirstChild("Shoot") or remotes:FindFirstChild("Fire")
                    if shootEvent then
                        shootEvent:FireServer(target.Position)
                    end
                end
            end
        end
        local humanoid = target.Parent:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            locked = false
            target = nil
            local camPos = camera.CFrame.Position
            local newLookAt = camPos + (lastLookVector * 100)
            camera.CFrame = CFrame.new(camPos, newLookAt)
        end
    end
end)

print("This script is licensed under the GNU General Public License v3.0 Copyright (C) 2025 d4mage1 You can use, modify, and share this script as long as you keep it open-source and give credit.")
