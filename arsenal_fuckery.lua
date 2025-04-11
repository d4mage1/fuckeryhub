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

-- Load Rayfield UI Library
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Failed to load Rayfield UI Library. Roblox might be blocking the request, or the URL is down.")
    game.StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Failed to load Rayfield UI. Check your executor or try again later.",
        Duration = 5
    })
    return
end

-- Create Rayfield Window
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
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", "rbxassetid://4483362458")

local aimbotEnabled = false
local aimbotToggle = CombatTab:CreateToggle({
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

local fovSize = 150
local fovSlider = CombatTab:CreateSlider({
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

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", "rbxassetid://4483362458")

local espEnabled = false
local espBoxes = {}
local espToggle = VisualsTab:CreateToggle({
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

-- Suggest Tab
local SuggestTab = Window:CreateTab("Suggest", "rbxassetid://4483362458")

local suggestionInput
suggestionInput = SuggestTab:CreateInput({
    Name = "Suggestion",
    PlaceholderText = "Type your suggestion here, cuhh...",
    RemoveTextAfterFocusLost = false,
    Flag = "SuggestionInput",
    Callback = function(Text)
        -- Store the input for the send button
    end
})

local sendButton = SuggestTab:CreateButton({
    Name = "Send Suggestion",
    Callback = function()
        local suggestion = suggestionInput.CurrentText or ""
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
    if espEnabled then
        clearESP()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                local playerTeam = player.Team
                local enemyTeam = v.Team
                local isEnemy = true
                if playerTeam and enemyTeam and playerTeam == enemyTeam then
                    isEnemy = false
                end
                if isEnemy then
                    addESP(v.Character)
                end
            end
        end
    else
        clearESP()
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
    end
end)

-- Aimbot Logic
local target = nil
local locked = false
local lastLookVector = camera.CFrame.LookVector

mouse.Button2Down:Connect(function()
    if aimbotEnabled then
        local closest = nil
        local shortestDist = math.huge
        local mousePos = mouse.Hit.Position

        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") and enemy.Character:FindFirstChild("Humanoid") and enemy.Character.Humanoid.Health > 0 then
                local playerTeam = player.Team
                local enemyTeam = enemy.Team
                local isEnemy = true
                if playerTeam and enemyTeam and playerTeam == enemyTeam then
                    isEnemy = false
                end
                if isEnemy then
                    local head = enemy.Character.Head
                    local dist = (head.Position - mousePos).Magnitude
                    if dist < fovSize then
                        if dist < shortestDist then
                            shortestDist = dist
                            closest = head
                        end
                    end
                end
            end
        end

        if closest then
            target = closest
            locked = true
        end
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
        httpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        lastSubmit = currentTime
        Rayfield:Notify({
            Title = "Success",
            Content = "Suggestion sent, cuhh!",
            Duration = 3
        })
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "Failed to send suggestion: " .. tostring(err) .. ", cuhh.",
            Duration = 5
        })
    end
end

print("This script is licensed under the GNU General Public License v3.0 Copyright (C) 2025 d4mage1 You can use, modify, and share this script as long as you keep it open-source and give credit.")
