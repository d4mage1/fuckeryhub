print("=====================================")
print("     FUCKERY HUB - ARSENAL LOADED    ")
print("=====================================")
print([[
                     _        _                 _   ___                            __  
                    | |      | |               | | /   |                          /  | 
 _ __ ___   __ _  __| | ___  | |__  _   _    __| |/ /| |_ __ ___   __ _  __ _  ___`| | 
| '_ ` _ \ / _` |/ _` |/ _ \ | '_ \| | | |  / _` / /_| | '_ ` _ \ / _` |/ _` |/ _ \| | 
| | | | | | (_| | (_| |  __/ | |_) | |_| | | (_| \___  | | | | | | (_| | (_| |  __/| |_
|_| |_| |_|__,_|__,_|_|___| |_.__/ |__, |  |__,_|   |_|_| |_| |_|__,_|__,_|_|___|___/
                                    __/ |                               __/ |         
                                   |___/                               |___/                
]])
print("Loaded by: d4mage1")
print("Version: 4.10 - Arsenal Edition (Xeno)")
print(" ")

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local teams = game:GetService("Teams")

-- Wait for player character
if not player.Character then
    player.CharacterAdded:Wait()
end

-- Feature Toggles
local aimbotEnabled = false
local aimAssistEnabled = false
local hitboxExtenderEnabled = false
local espEnabled = false
local tracersEnabled = false
local fovCircleEnabled = false
local panicModeEnabled = false

-- Feature Variables
local espBoxes = {}
local hitboxAdornments = {}
local tracerBeams = {}
local fovCircle = nil
local hitboxSize = 6
local fovCircleSize = 200
local fovCircleColor = Color3.fromRGB(255, 255, 255)
local espColorEnemy = Color3.fromRGB(255, 0, 0)
local hitboxColor = Color3.fromRGB(255, 0, 0)
local tracerColorEnemy = Color3.fromRGB(255, 0, 0)
local target = nil
local locked = false
local tracerUpdateCounter = 0
local maxTracers = 10
local maxAimbotRange = 500

-- Game Mode Detection
local function isFFA()
    local teamCount = #teams:GetChildren()
    if teamCount == 0 then return true end
    local playersWithTeam = 0
    for _, v in pairs(Players:GetPlayers()) do
        if v.Team ~= nil then playersWithTeam = playersWithTeam + 1 end
    end
    return playersWithTeam == 0
end

local function isEnemyPlayer(enemy)
    if not enemy or enemy == player then return false end
    local ffa = isFFA()
    if ffa then return true end
    local enemyPlayer = Players:GetPlayerFromCharacter(enemy.Character)
    if not enemyPlayer or not player.Team or not enemyPlayer.Team then return false end
    return player.Team ~= enemyPlayer.Team
end

-- Create Rayfield Window (Rayfield already loaded from Main Menu)
local Window = Rayfield:CreateWindow({
    Name = "Fuckery Hub - Arsenal",
    LoadingTitle = "Fuckery Hub Loading",
    LoadingSubtitle = "by d4mage1",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FuckeryHub",
        FileName = "ArsenalConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "mAFyAPnVA4",
        RememberJoins = true
    }
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat")
CombatTab:CreateSection("Combat Features")

CombatTab:CreateToggle({
    Name = "Aimbot (Right-Click to Lock)",
    CurrentValue = false,
    Callback = function(Value)
        aimbotEnabled = Value
        print("Aimbot " .. (aimbotEnabled and "enabled" or "disabled"))
    end
})

CombatTab:CreateToggle({
    Name = "Aim Assist (Always On)",
    CurrentValue = false,
    Callback = function(Value)
        aimAssistEnabled = Value
        print("Aim Assist " .. (aimAssistEnabled and "enabled" or "disabled"))
    end
})

CombatTab:CreateSlider({
    Name = "Aimbot/Assist Range",
    Range = {100, 1000},
    Increment = 50,
    Suffix = "Studs",
    CurrentValue = 500,
    Callback = function(Value)
        maxAimbotRange = Value
        print("Aimbot Range set to " .. maxAimbotRange .. " studs")
    end
})

CombatTab:CreateToggle({
    Name = "Hitbox Extender",
    CurrentValue = false,
    Callback = function(Value)
        hitboxExtenderEnabled = Value
        print("Hitbox Extender " .. (hitboxExtenderEnabled and "enabled" or "disabled"))
        clearHitboxAdornments()
        if hitboxExtenderEnabled then updateHitboxAdornments() end
    end
})

CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {4, 12},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 6,
    Callback = function(Value)
        hitboxSize = Value
        print("Hitbox Size set to " .. hitboxSize .. " studs")
        if hitboxExtenderEnabled then
            clearHitboxAdornments()
            updateHitboxAdornments()
        end
    end
})

CombatTab:CreateDropdown({
    Name = "Hitbox Color",
    Options = {"Red", "Green", "Blue", "Yellow", "White"},
    CurrentOption = "Red",
    Callback = function(Value)
        local colors = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            White = Color3.fromRGB(255, 255, 255)
        }
        hitboxColor = colors[Value] or hitboxColor
        print("Hitbox Color set to " .. Value)
        if hitboxExtenderEnabled then
            clearHitboxAdornments()
            updateHitboxAdornments()
        end
    end
})

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals")
VisualsTab:CreateSection("Visual Features")

VisualsTab:CreateToggle({
    Name = "ESP (Enemies Only)",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
        print("ESP " .. (espEnabled and "enabled" or "disabled"))
        clearESP()
        if espEnabled then updateESP() end
    end
})

VisualsTab:CreateDropdown({
    Name = "ESP Color",
    Options = {"Red", "Green", "Blue", "Yellow", "White"},
    CurrentOption = "Red",
    Callback = function(Value)
        local colors = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            White = Color3.fromRGB(255, 255, 255)
        }
        espColorEnemy = colors[Value] or espColorEnemy
        print("ESP Color set to " .. Value)
        if espEnabled then
            clearESP()
            updateESP()
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Tracers (Enemies Only)",
    CurrentValue = false,
    Callback = function(Value)
        tracersEnabled = Value
        print("Tracers " .. (tracersEnabled and "enabled" or "disabled"))
        clearTracers()
        if tracersEnabled then updateTracers() end
    end
})

VisualsTab:CreateSlider({
    Name = "Max Tracers",
    Range = {5, 20},
    Increment = 1,
    Suffix = "Tracers",
    CurrentValue = 10,
    Callback = function(Value)
        maxTracers = Value
        print("Max Tracers set to " .. maxTracers)
        if tracersEnabled then
            clearTracers()
            updateTracers()
        end
    end
})

VisualsTab:CreateDropdown({
    Name = "Tracer Color",
    Options = {"Red", "Green", "Blue", "Yellow", "White"},
    CurrentOption = "Red",
    Callback = function(Value)
        local colors = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            White = Color3.fromRGB(255, 255, 255)
        }
        tracerColorEnemy = colors[Value] or tracerColorEnemy
        print("Tracer Color set to " .. Value)
        if tracersEnabled then
            clearTracers()
            updateTracers()
        end
    end
})

VisualsTab:CreateToggle({
    Name = "FOV Circle",
    CurrentValue = false,
    Callback = function(Value)
        fovCircleEnabled = Value
        print("FOV Circle " .. (fovCircleEnabled and "enabled" or "disabled"))
        if fovCircleEnabled and not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Thickness = 2
            fovCircle.NumSides = 64
            fovCircle.Radius = fovCircleSize
            local screenSize = camera.ViewportSize
            fovCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
            fovCircle.Color = fovCircleColor
            fovCircle.Visible = true
        elseif fovCircle then
            fovCircle.Visible = fovCircleEnabled
        end
    end
})

VisualsTab:CreateSlider({
    Name = "FOV Circle Size",
    Range = {50, 500},
    Increment = 10,
    Suffix = "Pixels",
    CurrentValue = 200,
    Callback = function(Value)
        fovCircleSize = Value
        print("FOV Circle Size set to " .. fovCircleSize .. " pixels")
        if fovCircle then
            fovCircle.Radius = fovCircleSize
        end
    end
})

VisualsTab:CreateDropdown({
    Name = "FOV Circle Color",
    Options = {"White", "Red", "Green", "Blue", "Yellow"},
    CurrentOption = "White",
    Callback = function(Value)
        local colors = {
            White = Color3.fromRGB(255, 255, 255),
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Yellow = Color3.fromRGB(255, 255, 0)
        }
        fovCircleColor = colors[Value] or fovCircleColor
        print("FOV Circle Color set to " .. Value)
        if fovCircle then
            fovCircle.Color = fovCircleColor
        end
    end
})

VisualsTab:CreateInput({
    Name = "Custom FOV RGB (R,G,B)",
    PlaceholderText = "e.g., 255,128,0",
    Callback = function(Value)
        local r, g, b = Value:match("(%d+),(%d+),(%d+)")
        r, g, b = tonumber(r), tonumber(g), tonumber(b)
        if r and g and b and r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
            fovCircleColor = Color3.fromRGB(r, g, b)
            print("FOV Circle Color set to RGB(" .. r .. "," .. g .. "," .. b .. ")")
            if fovCircle then
                fovCircle.Color = fovCircleColor
            end
        else
            print("Invalid RGB format. Use: R,G,B (0-255 each)")
        end
    end
})

-- Panic Tab
local PanicTab = Window:CreateTab("Panic")
PanicTab:CreateSection("Panic Features")

PanicTab:CreateToggle({
    Name = "Panic Mode",
    CurrentValue = false,
    Callback = function(Value)
        panicModeEnabled = Value
        print("Panic Mode " .. (panicModeEnabled and "enabled" or "disabled"))
        if panicModeEnabled then
            aimbotEnabled = false
            aimAssistEnabled = false
            hitboxExtenderEnabled = false
            espEnabled = false
            tracersEnabled = false
            fovCircleEnabled = false
            locked = false
            target = nil
            clearESP()
            clearTracers()
            clearHitboxAdornments()
            if fovCircle then fovCircle.Visible = false end
            print("Panic Mode enabled - all features disabled")
        end
    end
})

-- Hitbox Extender Functions
local function addHitboxAdornment(target)
    if not target or not target.Parent or not target:FindFirstChild("Head") or target == player.Character then return end
    local hitbox = Instance.new("BoxHandleAdornment")
    hitbox.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
    hitbox.Adornee = target.Head
    hitbox.Color3 = hitboxColor
    hitbox.Transparency = 0.7
    hitbox.AlwaysOnTop = true
    hitbox.ZIndex = 5
    hitbox.Parent = target
    hitboxAdornments[target] = hitbox
end

local function clearHitboxAdornments()
    for _, hitbox in pairs(hitboxAdornments) do
        pcall(function() hitbox:Destroy() end)
    end
    hitboxAdornments = {}
end

local function updateHitboxAdornments()
    if not hitboxExtenderEnabled then
        clearHitboxAdornments()
        return
    end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            if isEnemyPlayer(v) and not hitboxAdornments[v.Character] then
                pcall(addHitboxAdornment, v.Character)
            end
        end
    end
end

-- ESP Functions (Enemies only)
local function addESP(target)
    if not target or not target.Parent or not target:FindFirstChild("HumanoidRootPart") or target == player.Character then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Adornee = target.HumanoidRootPart
    box.Color3 = espColorEnemy
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = target
    espBoxes[target] = box
end

local function clearESP()
    for target, box in pairs(espBoxes) do
        pcall(function()
            if box then box:Destroy() end
            espBoxes[target] = nil
        end)
    end
    espBoxes = {}
end

local function updateESP()
    if not espEnabled then
        clearESP()
        return
    end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            if isEnemyPlayer(v) then
                if not espBoxes[v.Character] then
                    pcall(addESP, v.Character)
                end
            else
                if espBoxes[v.Character] then
                    pcall(function()
                        espBoxes[v.Character]:Destroy()
                        espBoxes[v.Character] = nil
                    end)
                end
            end
        end
    end
end

-- Tracer Functions (Enemies only, Optimized 3D Beams)
local function updateTracer(targetPlayer)
    if not targetPlayer or targetPlayer == player or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") or not targetPlayer.Character:FindFirstChild("Humanoid") or targetPlayer.Character.Humanoid.Health <= 0 then
        return
    end
    if not isEnemyPlayer(targetPlayer) then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local tracerData = tracerBeams[targetPlayer]
    local startPart = player.Character.HumanoidRootPart
    local endPart = targetPlayer.Character.Head

    if not tracerData then
        if #tracerBeams >= maxTracers then return end

        local startAttachment = Instance.new("Attachment")
        startAttachment.Parent = startPart

        local endAttachment = Instance.new("Attachment")
        endAttachment.Parent = endPart

        local beam = Instance.new("Beam")
        beam.Attachment0 = startAttachment
        beam.Attachment1 = endAttachment
        beam.Color = ColorSequence.new(tracerColorEnemy)
        beam.Width0 = 0.1
        beam.Width1 = 0.1
        beam.Transparency = NumberSequence.new(0.3)
        beam.Enabled = tracersEnabled
        beam.Parent = game.Workspace

        tracerData = {
            beam = beam,
            startAttachment = startAttachment,
            endAttachment = endAttachment,
            targetPlayer = targetPlayer
        }
        tracerBeams[targetPlayer] = tracerData
    else
        tracerData.beam.Enabled = tracersEnabled
        tracerData.beam.Color = ColorSequence.new(tracerColorEnemy)
    end
end

local function clearTracers()
    for _, tracer in pairs(tracerBeams) do
        pcall(function()
            if tracer.beam then tracer.beam:Destroy() end
            if tracer.startAttachment then tracer.startAttachment:Destroy() end
            if tracer.endAttachment then tracer.endAttachment:Destroy() end
        end)
    end
    tracerBeams = {}
end

local function updateTracers()
    if not tracersEnabled then
        clearTracers()
        return
    end

    local enemies = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            if isEnemyPlayer(v) then
                table.insert(enemies, v)
            end
        end
    end

    table.sort(enemies, function(a, b)
        local aDist = (a.Character.Head.Position - (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position)).Magnitude
        local bDist = (b.Character.Head.Position - (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position)).Magnitude
        return aDist < bDist
    end)

    local usedPlayers = {}
    for i = 1, math.min(#enemies, maxTracers) do
        pcall(updateTracer, enemies[i])
        usedPlayers[enemies[i]] = true
    end

    for player, tracer in pairs(tracerBeams) do
        if not usedPlayers[player] or not player.Character or not player.Character:FindFirstChild("Head") or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
            pcall(function()
                if tracer.beam then tracer.beam:Destroy() end
                if tracer.startAttachment then tracer.startAttachment:Destroy() end
                if tracer.endAttachment then tracer.endAttachment:Destroy() end
            end)
            tracerBeams[player] = nil
        end
    end
end

-- Aimbot/Aim Assist Logic
local function getClosestPlayerToCursor()
    local closestPlayer, closestDistance = nil, math.huge
    for _, enemy in pairs(Players:GetPlayers()) do
        if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") and enemy.Character:FindFirstChild("Humanoid") then
            local humanoid = enemy.Character.Humanoid
            if humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                if isEnemyPlayer(enemy) then
                    local headPos, onScreen = camera:WorldToScreenPoint(enemy.Character.Head.Position)
                    if onScreen then
                        local mousePos = Vector2.new(mouse.X, mouse.Y)
                        local distance = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude
                        local worldDistance = (enemy.Character.Head.Position - (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position)).Magnitude
                        if distance < closestDistance and distance < fovCircleSize and worldDistance <= maxAimbotRange then
                            closestDistance = distance
                            closestPlayer = enemy
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Aimbot (Right-Click to Lock)
mouse.Button2Down:Connect(function()
    if not aimbotEnabled or panicModeEnabled then
        locked = false
        target = nil
        return
    end
    local closest = getClosestPlayerToCursor()
    if closest then
        target = closest.Character
        locked = true
        print("Aimbot: Locked onto " .. closest.Name)
    end
end)

mouse.Button2Up:Connect(function()
    locked = false
    target = nil
    print("Aimbot: Unlocked")
end)

-- Player Cleanup
Players.PlayerRemoving:Connect(function(p)
    if espBoxes[p.Character] then
        pcall(function()
            espBoxes[p.Character]:Destroy()
            espBoxes[p.Character] = nil
        end)
    end
    if hitboxAdornments[p.Character] then
        pcall(function() hitboxAdornments[p.Character]:Destroy() end)
        hitboxAdornments[p.Character] = nil
    end
    if tracerBeams[p] then
        pcall(function()
            if tracerBeams[p].beam then tracerBeams[p].beam:Destroy() end
            if tracerBeams[p].startAttachment then tracerBeams[p].startAttachment:Destroy() end
            if tracerBeams[p].endAttachment then tracerBeams[p].endAttachment:Destroy() end
        end)
        tracerBeams[p] = nil
    end
end)

for _, v in pairs(Players:GetPlayers()) do
    if v ~= player then
        v.CharacterAdded:Connect(function()
            if espEnabled then updateESP() end
            if hitboxExtenderEnabled then updateHitboxAdornments() end
            if tracersEnabled then updateTracers() end
        end)
    end
end

Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function()
        if espEnabled then updateESP() end
        if hitboxExtenderEnabled then updateHitboxAdornments() end
        if tracersEnabled then updateTracers() end
    end)
end)

-- Main Loop
runService.RenderStepped:Connect(function()
    if panicModeEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    -- Update FOV Circle
    if fovCircleEnabled and fovCircle then
        local screenSize = camera.ViewportSize
        fovCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
        fovCircle.Radius = fovCircleSize
        fovCircle.Color = fovCircleColor
    end

    -- Update ESP
    if espEnabled then updateESP() end

    -- Update Hitbox Adornments
    if hitboxExtenderEnabled then updateHitboxAdornments() end

    -- Update Tracers (every 6 frames for optimization)
    if tracersEnabled and tracerUpdateCounter % 6 == 0 then
        updateTracers()
    end
    tracerUpdateCounter = tracerUpdateCounter + 1

    -- Aimbot (God-Tier)
    if aimbotEnabled and locked and target and target.Parent then
        local humanoid = target:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
            target = nil
            locked = false
            print("Aimbot: Target dead, unlocking")
            return
        end

        local targetPart = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
        if not targetPart then
            target = nil
            locked = false
            print("Aimbot: Target missing parts, unlocking")
            return
        end

        local distance = (targetPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
        if distance > maxAimbotRange then
            target = nil
            locked = false
            print("Aimbot: Target out of range (" .. math.floor(distance) .. " studs), unlocking")
            return
        end

        local velocity = targetPart.Velocity
        local predictedPos = targetPart.Position + velocity * 0.1
        local headPos, onScreen = camera:WorldToScreenPoint(predictedPos)
        if onScreen then
            local screenPos = Vector2.new(headPos.X, headPos.Y)
            local mousePos = Vector2.new(mouse.X, mouse.Y)
            local delta = screenPos - mousePos
            delta = Vector2.new(math.clamp(delta.X, -15, 15), math.clamp(delta.Y, -15, 15))
            mousemoverel(delta.X, delta.Y)
        else
            target = nil
            locked = false
        end
    end

    -- Aim Assist (Always On)
    if aimAssistEnabled then
        local closest = getClosestPlayerToCursor()
        if closest and closest.Character then
            local targetPart = closest.Character:FindFirstChild("Head") or closest.Character:FindFirstChild("HumanoidRootPart")
            if not targetPart then return end

            local humanoid = closest.Character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end

            local distance = (targetPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance > maxAimbotRange then return end

            local velocity = targetPart.Velocity
            local predictedPos = targetPart.Position + velocity * 0.1
            local headPos, onScreen = camera:WorldToScreenPoint(predictedPos)
            if onScreen then
                local screenPos = Vector2.new(headPos.X, headPos.Y)
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                local distToTarget = (screenPos - mousePos).Magnitude
                local stickiness = math.clamp(1 - (distToTarget / fovCircleSize), 0, 0.3)
                local delta = (screenPos - mousePos) * stickiness
                delta = Vector2.new(math.clamp(delta.X, -10, 10), math.clamp(delta.Y, -10, 10))
                mousemoverel(delta.X, delta.Y)
            end
        end
    end
end)

print("Fuckery Hub Arsenal script loaded - v4.10 by d4mage1")
