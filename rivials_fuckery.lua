print(" ")
print("=====================================")
print("     FUCKERY HUB - RIVALS LOADED     ")
print("=====================================")
print(" ")
print([[
                  _        _                 _   ___                            __  
                    | |      | |               | | /   |                          /  | 
 _ __ ___   __ _  __| | ___  | |__  _   _    __| |/ /| |_ __ ___   __ _  __ _  ___`| | 
| '_ ` _ \ / _` |/ _` |/ _ \ | '_ \| | | |  / _` / /_| | '_ ` _ \ / _` |/ _` |/ _ \| | 
| | | | | | (_| | (_| |  __/ | |_) | |_| | | (_| \___  | | | | | | (_| | (_| |  __/| |_
|_| |_| |_|\__,_|\__,_|\___| |_.__/ \__, |  \__,_|   |_/_| |_| |_|\__,_|\__, |\___\___/
                                     __/ |                               __/ |         
                                    |___/                               |___/              
]])
print(" ")
print("Loaded by: d4mage1")
print("Version: 1.0 - Rivals Edition (Xeno)")
print(" ")

-- Services
local success, err = pcall(function()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    local camera = game.Workspace.CurrentCamera
    local runService = game:GetService("RunService")
    local teams = game:GetService("Teams")
    local uis = game:GetService("UserInputService")
    local physicsService = game:GetService("PhysicsService")

    -- Wait for player character
    if not player.Character then
        player.CharacterAdded:Wait()
    end

    -- Feature Toggles
    local aimbotEnabled = false
    local aimAssistEnabled = false
    local espEnabled = false
    local speedHackEnabled = false
    local noClipEnabled = false
    local fovCircleEnabled = false
    local panicModeEnabled = false

    -- Feature Variables
    local espBoxes = {}
    local fovCircle = nil
    local fovCircleSize = 200
    local fovCircleColor = Color3.fromRGB(255, 255, 255)
    local espColorEnemy = Color3.fromRGB(255, 0, 0)
    local target = nil
    local locked = false
    local maxAimbotRange = 500 -- Max distance for aimbot/aim assist (studs)
    local speedMultiplier = 2 -- Default speed boost
    local defaultWalkSpeed = 16 -- Roblox default

    -- Game Mode Detection
    local function isFFA()
        local teamCount = #teams:GetChildren()
        if teamCount == 0 then return true end
        local playersWithTeam = 0
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Team ~= nil then playersWithTeam = playersWithTeam + 1 end
        end
        return playersWithTeam == 0
    end

    local function isEnemyPlayer(enemy)
        if not enemy or enemy == player then return false end
        local ffa = isFFA()
        if ffa then return true end
        local enemyPlayer = game.Players:GetPlayerFromCharacter(enemy.Character)
        if not enemyPlayer or not player.Team or not enemyPlayer.Team then return false end
        return player.Team ~= enemyPlayer.Team
    end

    -- Try to load Rayfield
    local Rayfield = nil
    local rayfieldSuccess, rayfieldErr = pcall(function()
        wait(1.5)
        Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    end)

    if not rayfieldSuccess then
        print("Failed to load Rayfield: " .. tostring(rayfieldErr))
        print("Falling back to keybinds...")
        print("Keybinds:")
        print("F1 - Toggle Aimbot")
        print("F2 - Toggle Aim Assist (Always On)")
        print("F3 - Toggle ESP")
        print("F4 - Toggle Speed Hack")
        print("F5 - Toggle No Clip")
        print("F6 - Toggle FOV Circle")
        print("F7 - Toggle Panic Mode")
        print(" ")

        uis.InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.F1 then
                    aimbotEnabled = not aimbotEnabled
                    print("Aimbot " .. (aimbotEnabled and "enabled" or "disabled"))
                elseif input.KeyCode == Enum.KeyCode.F2 then
                    aimAssistEnabled = not aimAssistEnabled
                    print("Aim Assist " .. (aimAssistEnabled and "enabled" or "disabled"))
                elseif input.KeyCode == Enum.KeyCode.F3 then
                    espEnabled = not espEnabled
                    print("ESP " .. (espEnabled and "enabled" or "disabled"))
                    pcall(clearESP)
                    if espEnabled then pcall(updateESP) end
                elseif input.KeyCode == Enum.KeyCode.F4 then
                    speedHackEnabled = not speedHackEnabled
                    print("Speed Hack " .. (speedHackEnabled and "enabled" or "disabled"))
                    if not speedHackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.WalkSpeed = defaultWalkSpeed
                    end
                elseif input.KeyCode == Enum.KeyCode.F5 then
                    noClipEnabled = not noClipEnabled
                    print("No Clip " .. (noClipEnabled and "enabled" or "disabled"))
                elseif input.KeyCode == Enum.KeyCode.F6 then
                    fovCircleEnabled = not fovCircleEnabled
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
                elseif input.KeyCode == Enum.KeyCode.F7 then
                    panicModeEnabled = not panicModeEnabled
                    print("Panic Mode " .. (panicModeEnabled and "enabled" or "disabled"))
                    if panicModeEnabled then
                        aimbotEnabled = false
                        aimAssistEnabled = false
                        espEnabled = false
                        speedHackEnabled = false
                        noClipEnabled = false
                        fovCircleEnabled = false
                        locked = false
                        target = nil
                        pcall(clearESP)
                        if fovCircle then fovCircle.Visible = false end
                        if player.Character and player.Character:FindFirstChild("Humanoid") then
                            player.Character.Humanoid.WalkSpeed = defaultWalkSpeed
                        end
                        print("Panic Mode enabled - all features disabled")
                    end
                end
            end
        end)
    else
        print("Rayfield loaded successfully!")
        local Window = Rayfield:CreateWindow({
            Name = "Fuckery Hub - Rivals",
            LoadingTitle = "Fuckery Hub Loading",
            LoadingSubtitle = "by d4mage1",
            ConfigurationSaving = {
                Enabled = true,
                FolderName = "FuckeryHub",
                FileName = "RivalsConfig"
            }
        })

        local CombatTab = Window:CreateTab("Combat")
        local CombatSection = CombatTab:CreateSection("Combat Features")

        CombatTab:CreateToggle({
            Name = "Aimbot",
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

        local MovementTab = Window:CreateTab("Movement")
        local MovementSection = MovementTab:CreateSection("Movement Features")

        MovementTab:CreateToggle({
            Name = "Speed Hack",
            CurrentValue = false,
            Callback = function(Value)
                speedHackEnabled = Value
                print("Speed Hack " .. (speedHackEnabled and "enabled" or "disabled"))
                if not speedHackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = defaultWalkSpeed
                end
            end
        })

        MovementTab:CreateSlider({
            Name = "Speed Multiplier",
            Range = {1, 5},
            Increment = 0.5,
            Suffix = "x",
            CurrentValue = 2,
            Callback = function(Value)
                speedMultiplier = Value
                print("Speed Multiplier set to " .. speedMultiplier .. "x")
            end
        })

        MovementTab:CreateToggle({
            Name = "No Clip",
            CurrentValue = false,
            Callback = function(Value)
                noClipEnabled = Value
                print("No Clip " .. (noClipEnabled and "enabled" or "disabled"))
            end
        })

        local VisualsTab = Window:CreateTab("Visuals")
        local VisualsSection = VisualsTab:CreateSection("Visual Features")

        VisualsTab:CreateToggle({
            Name = "ESP",
            CurrentValue = false,
            Callback = function(Value)
                espEnabled = Value
                print("ESP " .. (espEnabled and "enabled" or "disabled"))
                pcall(clearESP)
                if espEnabled then pcall(updateESP) end
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
                pcall(function()
                    fovCircleSize = Value
                    print("FOV Circle Size set to " .. fovCircleSize .. " pixels")
                    if fovCircle then
                        fovCircle.Radius = fovCircleSize
                    end
                end)
            end
        })

        VisualsTab:CreateDropdown({
            Name = "FOV Circle Color",
            Options = {"White", "Red", "Green", "Blue", "Yellow"},
            CurrentOption = "White",
            Callback = function(Value)
                pcall(function()
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
                end)
            end
        })

        VisualsTab:CreateInput({
            Name = "Custom FOV RGB (R,G,B)",
            PlaceholderText = "e.g., 255,128,0",
            Callback = function(Value)
                pcall(function()
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
                end)
            end
        })

        local PanicTab = Window:CreateTab("Panic")
        local PanicSection = PanicTab:CreateSection("Panic Features")

        PanicTab:CreateToggle({
            Name = "Panic Mode",
            CurrentValue = false,
            Callback = function(Value)
                panicModeEnabled = Value
                print("Panic Mode " .. (panicModeEnabled and "enabled" or "disabled"))
                if panicModeEnabled then
                    aimbotEnabled = false
                    aimAssistEnabled = false
                    espEnabled = false
                    speedHackEnabled = false
                    noClipEnabled = false
                    fovCircleEnabled = false
                    locked = false
                    target = nil
                    pcall(clearESP)
                    if fovCircle then fovCircle.Visible = false end
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.WalkSpeed = defaultWalkSpeed
                    end
                    print("Panic Mode enabled - all features disabled")
                end
            end
        })
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
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                if isEnemyPlayer(v) then
                    if not espBoxes[v.Character] then
                        pcall(function() addESP(v.Character) end)
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

    -- Aimbot/Aim Assist Logic
    local function getClosestPlayerToCursor()
        local closestPlayer, closestDistance = nil, math.huge
        for _, enemy in pairs(game.Players:GetPlayers()) do
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
                                print("Scanning: Found " .. enemy.Name .. " at " .. math.floor(distance) .. " pixels, " .. math.floor(worldDistance) .. " studs")
                            end
                        end
                    end
                end
            end
        end
        if not closestPlayer then
            print("No valid target in FOV or range")
        end
        return closestPlayer
    end

    -- Aimbot (God-Tier, Right-Click)
    mouse.Button2Down:Connect(function()
        if not aimbotEnabled or panicModeEnabled then
            locked = false
            target = nil
            print("Aimbot: Disabled or panicked")
            return
        end
        local closest = getClosestPlayerToCursor()
        if closest then
            target = closest.Character
            locked = true
            print("Aimbot: Locked onto " .. closest.Name)
        else
            print("Aimbot: No target found")
        end
    end)

    mouse.Button2Up:Connect(function()
        locked = false
        target = nil
        print("Aimbot: Unlocked")
    end)

    -- Player Cleanup
    game.Players.PlayerRemoving:Connect(function(p)
        if espBoxes[p.Character] then
            pcall(function()
                espBoxes[p.Character]:Destroy()
                espBoxes[p.Character] = nil
            end)
        end
    end)

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            v.CharacterAdded:Connect(function()
                if espEnabled then pcall(updateESP) end
            end)
        end
    end

    game.Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.CharacterAdded:Connect(function()
            if espEnabled then pcall(updateESP) end
        end)
    end)

    -- No Clip Setup
    local function setNoClip(state)
        if not player.Character then return end
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end

    runService.Stepped:Connect(function()
        if noClipEnabled and player.Character then
            setNoClip(true)
        elseif player.Character then
            setNoClip(false)
        end
    end)

    runService.RenderStepped:Connect(function(deltaTime)
        local success, err = pcall(function()
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

            -- Speed Hack
            if speedHackEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = defaultWalkSpeed * speedMultiplier
            end

            -- Aimbot (God-Tier)
            if aimbotEnabled and locked and target and target.Parent then
                local humanoid = target:FindFirstChild("Humanoid")
                if not humanoid or humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then
                    target = nil
                    locked = false
                    print("Aimbot: Target dead, unlocking")
                    return
                end

                local targetPart = target:FindFirstChild("Head")
                if not targetPart then
                    targetPart = target:FindFirstChild("HumanoidRootPart")
                    if not targetPart then
                        target = nil
                        locked = false
                        print("Aimbot: Target missing parts, unlocking")
                        return
                    end
                end

                local distance = (targetPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance > maxAimbotRange then
                    target = nil
                    locked = false
                    print("Aimbot: Target out of range (" .. math.floor(distance) .. " studs), unlocking")
                    return
                end

                local velocity = targetPart.Velocity
                local predictionFactor = 0.1
                local predictedPos = targetPart.Position + velocity * predictionFactor

                local headPos, onScreen = camera:WorldToScreenPoint(predictedPos)
                if onScreen then
                    local screenPos = Vector2.new(headPos.X, headPos.Y)
                    local mousePos = Vector2.new(mouse.X, mouse.Y)
                    local delta = screenPos - mousePos
                    delta = Vector2.new(
                        math.clamp(delta.X, -15, 15),
                        math.clamp(delta.Y, -15, 15)
                    )
                    mousemoverel(delta.X, delta.Y)
                    print("Aimbot: Moved to (" .. math.floor(delta.X) .. ", " .. math.floor(delta.Y) .. ") for " .. target.Name)
                else
                    print("Aimbot: Target off-screen")
                    target = nil
                    locked = false
                end
            end

            -- Aim Assist (Always On)
            if aimAssistEnabled then
                local closest = getClosestPlayerToCursor()
                if closest and closest.Character then
                    local targetPart = closest.Character:FindFirstChild("Head")
                    if not targetPart then
                        targetPart = closest.Character:FindFirstChild("HumanoidRootPart")
                        if not targetPart then return end
                    end

                    local humanoid = closest.Character:FindFirstChild("Humanoid")
                    if not humanoid or humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end

                    local distance = (targetPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance > maxAimbotRange then return end

                    local velocity = targetPart.Velocity
                    local predictionFactor = 0.1
                    local predictedPos = targetPart.Position + velocity * predictionFactor

                    local headPos, onScreen = camera:WorldToScreenPoint(predictedPos)
                    if onScreen then
                        local screenPos = Vector2.new(headPos.X, headPos.Y)
                        local mousePos = Vector2.new(mouse.X, mouse.Y)
                        local distToTarget = (screenPos - mousePos).Magnitude
                        local stickiness = math.clamp(1 - (distToTarget / fovCircleSize), 0, 0.3)
                        local delta = (screenPos - mousePos) * stickiness
                        delta = Vector2.new(
                            math.clamp(delta.X, -10, 10),
                            math.clamp(delta.Y, -10, 10)
                        )
                        mousemoverel(delta.X, delta.Y)
                        print("Aim Assist: Adjusted by (" .. math.floor(delta.X) .. ", " .. math.floor(delta.Y) .. ") for " .. closest.Name)
                    end
                end
            end
        end)
        if not success then
            print("RenderStepped error: " .. tostring(err))
        end
    end)

    print("Fuckery Hub Rivals script loaded - v1.0 by d4mage1 - God-tier aimbot, always-on aim assist, enemies-only ESP, speed hack, no clip, custom FOV, Xeno-optimized")
end)

if not success then
    print("Script failed to initialize: " .. tostring(err))
end
