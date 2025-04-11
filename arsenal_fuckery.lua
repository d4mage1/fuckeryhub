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

-- Load Rayfield UI Library with Error Handling
local Rayfield
local success, errorMsg = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Failed to load Rayfield UI Library: " .. tostring(errorMsg))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't load Rayfield UI. Error: " .. tostring(errorMsg) .. ". Try a different executor, cuhh.",
        Duration = 5
    })
    return
end

if not Rayfield then
    warn("Rayfield UI Library is nil after loading.")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Rayfield UI didn't load properly. Try a different executor, cuhh.",
        Duration = 5
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
            Invite = discordInvite, -- Your Discord invite link
            RememberJoins = true -- Remember if the user has joined
        },
        KeySystem = false
    })
end)

if not WindowSuccess or not Window then
    warn("Failed to create Rayfield Window: " .. tostring(Window))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Rayfield Window. Try a different executor, cuhh.",
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
        Name = "FOV Size",
        Range = {50, 350},
        Increment = 1,
        Suffix = "Units",
        CurrentValue = 150,
        Flag = "FOVSlider",
        Callback = function(Value)
            fovSize = Value
            Rayfield:Notify({
                Title = "FOV Size",
                Content = "Set FOV to " .. Value .. " units, cuhh!",
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
                -- Find the Rayfield GUI elements to change colors
                local success, err = pcall(function()
                    local gui = game:GetService("CoreGui"):FindFirstChild("Rayfield")
                    if not gui then return end

                    local mainFrame = gui:FindFirstChild("Main", true)
                    if not mainFrame then return end

                    local tabs = mainFrame:FindFirstChild("Tabs", true)
                    local elements = mainFrame:FindFirstChild("Elements", true)

                    if Option == "Dark" then
                        if mainFrame then
                            mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark background
                        end
                        if tabs then
                            for _, tab in pairs(tabs:GetChildren()) do
                                if tab:IsA("Frame") then
                                    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                                end
                            end
                        end
                        if elements then
                            for _, element in pairs(elements:GetDescendants()) do
                                if element:IsA("TextLabel") or element:IsA("TextButton") then
                                    element.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    if element:IsA("TextButton") then
                                        element.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                                    end
                                end
                            end
                        end
                        Rayfield:Notify({
                            Title = "Theme",
                            Content = "Switched to Dark theme, cuhh!",
                            Duration = 3
                        })
                    elseif Option == "Light" then
                        if mainFrame then
                            mainFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220) -- Light background
                        end
                        if tabs then
                            for _, tab in pairs(tabs:GetChildren()) do
                                if tab:IsA("Frame") then
                                    tab.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                                end
                            end
                        end
                        if elements then
                            for _, element in pairs(elements:GetDescendants()) do
                                if element:IsA("TextLabel") or element:IsA("TextButton") then
                                    element.TextColor3 = Color3.fromRGB(0, 0, 0)
                                    if element:IsA("TextButton") then
                                        element.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
                                    end
                                end
                            end
                        end
                        Rayfield:Notify({
                            Title = "Theme",
                            Content = "Switched to Light theme, cuhh!",
                            Duration = 3
                        })
                    elseif Option == "Fuckery" then
                        if mainFrame then
                            mainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0) -- Dark red background
                        end
                        if tabs then
                            for _, tab in pairs(tabs:GetChildren()) do
                                if tab:IsA("Frame") then
                                    tab.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
                                end
                            end
                        end
                        if elements then
                            for _, element in pairs(elements:GetDescendants()) do
                                if element:IsA("TextLabel") or element:IsA("TextButton") then
                                    element.TextColor3 = Color3.fromRGB(255, 0, 0)
                                    if element:IsA("TextButton") then
                                        element.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                                    end
                                end
                            end
                        end
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
local function addESP(target)
    if target and target:FindFirstChild("HumanoidRootPart") then
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
            continue -- Explicitly skip the local player
        end
        if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local playerTeam = player.Team
            local enemyTeam = v.Team
            local isEnemy = true
            -- Handle Arsenal's team system (sometimes teams are nil in FFA modes)
            if playerTeam and enemyTeam and playerTeam == enemyTeam then
                isEnemy = false -- Skip teammates
            elseif not playerTeam or not enemyTeam then
                -- If teams are nil (FFA mode), treat everyone as an enemy except the local player
                isEnemy = true
            end
            if isEnemy then
                addESP(v.Character)
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

runService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    else
        clearESP()
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
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        local char = player.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("Part")
                if handle then
                    local remotes = game.ReplicatedStorage:FindFirstChild("Events") or game.ReplicatedStorage:FindFirstChild("Remotes")
                    if remotes then
                        local fireEvent = remotes:FindFirstChild("Fire") or remotes:FindFirstChild("Shoot")
                        if fireEvent then
                            fireEvent:FireServer(target.Position)
                        end
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
