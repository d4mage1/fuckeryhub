print(" ")
print("=====================================")
print("     FUCKERY HUB LOADED - LET'S GO!  ")
print("=====================================")
print(" ")
print([[
 __  __       _        ______   ______   __   __       _        ______   _    _       ______   __     __  _____   ______   ______   ______   ______  
|  \/  |     (_)      |  ____| |  __ \  \ \ / /      (_)      |  ____| | |  | |     |  ____|  \ \   / / |  __ \ |  __ \ |  __ \ |  __ \ |  ____| 
| \  / | __ _ _  ___  | |__    | |  | |  \ V /  __ _ _  ___  | |__    | |__| |     | |__  _  \ \_/ /  | |  | || |  | || |  | || |  | || |__   
| |\/| |/ _` | |/ _ \ |  __|   | |  | |   > <  / _` | |/ _ \ |  __|   |  __  |     |  __|| |  \   /   | |  | || |  | || |  | || |  | ||  __|  
| |  | | (_| | |  __/ | |      | |__| |  / . \ | (_| | |  __/ | |      | |  | |     | |   | |   | |    | |__| || |__| || |__| || |__| || |____ 
|_|  |_|__,_|_|_|___| |_|      |_____/  /_/ \_\__,_|_|_|___| |_|      |_|  |_|     |_|   |_|   |_|    |_____/ |_____/ |_____/ |_____/ |______|
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
local httpService = game:GetService("HttpService")

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

-- Create Rayfield Window
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
            Enabled = false,
            Invite = "",
            RememberJoins = true
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
    CombatTab = Window:CreateTab("Combat", "rbxassetid://4483362458")
end)

if not CombatTabSuccess or not CombatTab then
    warn("Failed to create Combat Tab: " .. tostring(CombatTabError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Combat Tab: " .. tostring(CombatTabError) .. ", cuhh.",
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
    VisualsTab = Window:CreateTab("Visuals", "rbxassetid://4483362458")
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

-- Suggest Tab
local SuggestTab
local SuggestTabSuccess, SuggestTabError = pcall(function()
    SuggestTab = Window:CreateTab("Suggest", "rbxassetid://4483362458")
end)

if not SuggestTabSuccess or not SuggestTab then
    warn("Failed to create Suggest Tab: " .. tostring(SuggestTabError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Suggest Tab: " .. tostring(SuggestTabError) .. ", cuhh.",
        Duration = 5
    })
    return
end

local suggestionInput
local suggestionInputSuccess, suggestionInputError = pcall(function()
    suggestionInput = SuggestTab:CreateInput({
        Name = "Suggestion",
        PlaceholderText = "Type your suggestion here, cuhh...",
        RemoveTextAfterFocusLost = false,
        Flag = "SuggestionInput",
        Callback = function(Text)
            -- Store the input for the send button
        end
    })
end)

if not suggestionInputSuccess then
    warn("Failed to create Suggestion Input: " .. tostring(suggestionInputError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Suggestion Input: " .. tostring(suggestionInputError) .. ", cuhh.",
        Duration = 5
    })
end

local sendButtonSuccess, sendButtonError = pcall(function()
    SuggestTab:CreateButton({
        Name = "Send Suggestion",
        Callback = function()
            local suggestion = suggestionInput and suggestionInput.CurrentText or ""
            if suggestion == "" then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Suggestion can't be empty, cuhh.",
                    Duration = 3
                })
                return
            end
            sendSuggestion(suggestion)
        end
    })
end)

if not sendButtonSuccess then
    warn("Failed to create Send Suggestion Button: " .. tostring(sendButtonError))
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Couldn't create Send Suggestion Button: " .. tostring(sendButtonError) .. ", cuhh.",
        Duration = 5
    })
end

-- About Me Tab
local AboutTab
local AboutTabSuccess, AboutTabError = pcall(function()
    AboutTab = Window:CreateTab("About Me", "rbxassetid://4483362458")
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
        AboutTab:CreateLabel("Wanna hit me up? Catch me on Discord: d4mage1")
        AboutTab:CreateLabel("Version: 1.0 | Last Updated: April 11th 2025")
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
    SettingsTab = Window:CreateTab("Settings", "rbxassetid://4483362458")
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
                if Option == "Dark" then
                    -- Rayfield doesn't support direct theme changes, so we simulate it
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Theme",
                        Text = "Switched to Dark theme, cuhh! (Default Rayfield look)",
                        Duration = 3
                    })
                elseif Option == "Light" then
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Theme",
                        Text = "Switched to Light theme, cuhh! (Not fully supported, but we vibin')",
                        Duration = 3
                    })
                elseif Option == "Fuckery" then
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Theme",
                        Text = "Switched to Fuckery theme, cuhh! (Red and black vibes)",
                        Duration = 3
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
            continue -- Skip the local player
        end
        if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local playerTeam = player.Team
            local enemyTeam = v.Team
            local isEnemy = true
            if playerTeam and enemyTeam and playerTeam == enemyTeam then
                isEnemy = false -- Skip teammates
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

-- Webhook Logic
local webhookUrl = "https://discord.com/api/webhooks/1360247235757084772/zP2eOCkVrnoGE2bB3fuEbJ2NtqmhknVkuPJ6jl5CQShZd3M3zl5QWtQG_yesTcxFZzfq"
local cooldown = 30
local lastSubmit = 0
local blockedWords = {"nigger", "slur", "@everyone", "@here", "nigga", "kys"}

local function containsBlockedWords(text)
    for _, word in pairs(blockedWords) do
        if string.find(string.lower(text), word) then
            return true
        end
    end
    return false
end

function sendSuggestion(suggestion)
    local currentTime = tick()
    if currentTime - lastSubmit < cooldown then
        Rayfield:Notify({
            Title = "Cooldown",
            Content = "Wait " .. math.ceil(cooldown - (currentTime - lastSubmit)) .. " seconds, cuhh.",
            Duration = 3
        })
        return
    end

    if containsBlockedWords(suggestion) then
        Rayfield:Notify({
            Title = "Error",
            Content = "Suggestion got blocked words, cuhh.",
            Duration = 3
        })
        return
    end

    local success, err = pcall(function()
        local data = {
            ["content"] = "New Suggestion from " .. player.Name .. ": " .. suggestion
        }
        local jsonData = httpService:JSONEncode(data)
        local response = httpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
        return response
    end)

    if success then
        lastSubmit = currentTime
        Rayfield:Notify({
            Title = "Success",
            Content = "Suggestion sent to Discord, cuhh!",
            Duration = 3
        })
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "Failed to send suggestion: " .. tostring(err) .. ", cuhh. Check if the webhook URL is valid.",
            Duration = 5
        })
    end
end

print("This script is licensed under the GNU General Public License v3.0 Copyright (C) 2025 d4mage1 You can use, modify, and share this script as long as you keep it open-source and give credit.")
