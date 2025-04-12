print(" ")
print("=====================================")
print("     FUCKERY HUB - ARSENAL LOADED    ")
print("=====================================")
print(" ")
print([[
                     szerokie  szerokie  szerokie  szerokie  szerokie  szerokie  
                    | |       | |               | | || |                         / _|
 _ __ ___   __ _  __| | ___   | |__  _   _    __| | || |_| '_ ` _ \  __ _  __ _  |__|
| '_ ` _ \ / _` |/ _` |/ _ \  | '_ \| | | |  / _` |__   _| | | | | |/ _` |/ _` |/ _ \
| | | | | | (_| | (_| |  __/  | |_) | |_| | | (_| |  | | | | | | | | (_| | (_| |  __/ |
|_| |_| |_|__,_|__,_|_|___|  |_.__/ \__, |  \__,_|  |_| |_| |_| |_|__,_|__,_|_|___|_|
                                     __/ |                               __/ |       
                                    |___/                               |___/        
]])
print(" ")
print("Loaded by: d4mage1")
print("Version: 2.4 - Arsenal Edition")
print(" ")

-- Services
local success, err = pcall(function()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    local camera = game.Workspace.CurrentCamera
    local runService = game:GetService("RunService")
    local teams = game:GetService("Teams")
    local uis = game:GetService("UserInputService")

    -- Wait for player character to load
    if not player.Character then
        player.CharacterAdded:Wait()
    end

    -- Feature Toggles
    local aimbotEnabled = false
    local aimAssistEnabled = false
    local silentAimEnabled = false
    local hitboxExtenderEnabled = false
    local autoFireEnabled = false
    local espEnabled = false
    local tracersEnabled = false
    local fovCircleEnabled = false
    local panicModeEnabled = false

    -- Feature Variables
    local espBoxes = {}
    local tracers = {}
    local fovCircle = nil
    local fovCircleSize = 150
    local fovCircleColor = Color3.fromRGB(255, 255, 255)
    local espColor = Color3.fromRGB(255, 0, 0)
    local tracerColorEnemy = Color3.fromRGB(255, 0, 0)
    local tracerColorTeam = Color3.fromRGB(0, 255, 0)
    local fovSize = 150
    local target = nil
    local locked = false
    local lastMousePos = Vector2.new(mouse.X, mouse.Y)
    local mouseSpeed = 0
    local hooked = false
    local originalFireServer
    local lastFireTime = 0
    local fireRate = 0.1
    local isFiring = false

    -- Try to load Rayfield
    local Rayfield = nil
    local rayfieldSuccess, rayfieldErr = pcall(function()
        Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    end)

    if not rayfieldSuccess then
        print("Failed to load Rayfield: " .. tostring(rayfieldErr))
        print("Falling back to keybinds...")
        print("Keybinds:")
        print("F1 - Toggle Aimbot")
        print("F2 - Toggle Aim Assist")
        print("F3 - Toggle Silent Aim")
        print("F4 - Toggle Hitbox Extender")
        print("F5 - Toggle Auto Fire")
        print("F6 - Toggle ESP")
        print("F7 - Toggle Tracers")
        print("F8 - Toggle FOV Circle")
        print("F9 - Toggle Panic Mode")
        print(" ")

        -- Fallback to keybinds if Rayfield fails
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
                    silentAimEnabled = not silentAimEnabled
                    print("Silent Aim " .. (silentAimEnabled and "enabled" or "disabled"))
                elseif input.KeyCode == Enum.KeyCode.F4 then
                    hitboxExtenderEnabled = not hitboxExtenderEnabled
                    print("Hitbox Extender " .. (hitboxExtenderEnabled and "enabled" or "disabled"))
                elseif input.KeyCode == Enum.KeyCode.F5 then
                    autoFireEnabled = not autoFireEnabled
                    print("Auto Fire " .. (autoFireEnabled and "enabled" or "disabled"))
                elseif input.KeyCode == Enum.KeyCode.F6 then
                    espEnabled = not espEnabled
                    print("ESP " .. (espEnabled and "enabled" or "disabled"))
                    if not espEnabled then clearESP() end
                elseif input.KeyCode == Enum.KeyCode.F7 then
                    tracersEnabled = not tracersEnabled
                    print("Tracers " .. (tracersEnabled and "enabled" or "disabled"))
                    if not tracersEnabled then clearTracers() end
                elseif input.KeyCode == Enum.KeyCode.F8 then
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
                elseif input.KeyCode == Enum.KeyCode.F9 then
                    panicModeEnabled = not panicModeEnabled
                    print("Panic Mode " .. (panicModeEnabled and "enabled" or "disabled"))
                    if panicModeEnabled then
                        aimbotEnabled = false
                        aimAssistEnabled = false
                        silentAimEnabled = false
                        hitboxExtenderEnabled = false
                        autoFireEnabled = false
                        espEnabled = false
                        tracersEnabled = false
                        fovCircleEnabled = false
                        locked = false
                        target = nil
                        clearESP()
                        clearTracers()
                        if fovCircle then fovCircle.Visible = false end
                        print("Panic Mode enabled - all features disabled")
                    end
                end
            end
        end)
    else
        -- Rayfield loaded successfully, create the GUI
        print("Rayfield loaded successfully!")
        local Window = Rayfield:CreateWindow({
            Name = "Fuckery Hub - Arsenal",
            LoadingTitle = "Fuckery Hub Loading",
            LoadingSubtitle = "by d4mage1",
            ConfigurationSaving = {
                Enabled = true,
                FolderName = "FuckeryHub",
                FileName = "ArsenalConfig"
            }
        })

        local MainTab = Window:CreateTab("Main Features")
        local MainSection = MainTab:CreateSection("Toggles")

        MainTab:CreateToggle({
            Name = "Aimbot",
            CurrentValue = false,
            Callback = function(Value)
                aimbotEnabled = Value
                print("Aimbot " .. (aimbotEnabled and "enabled" or "disabled"))
            end
        })

        MainTab:CreateToggle({
            Name = "Aim Assist",
            CurrentValue = false,
            Callback = function(Value)
                aimAssistEnabled = Value
                print("Aim Assist " .. (aimAssistEnabled and "enabled" or "disabled"))
            end
        })

        MainTab:CreateToggle({
            Name = "Silent Aim",
            CurrentValue = false,
            Callback = function(Value)
                silentAimEnabled = Value
                print("Silent Aim " .. (silentAimEnabled and "enabled" or "disabled"))
            end
        })

        MainTab:CreateToggle({
            Name = "Hitbox Extender",
            CurrentValue = false,
            Callback = function(Value)
                hitboxExtenderEnabled = Value
                print("Hitbox Extender " .. (hitboxExtenderEnabled and "enabled" or "disabled"))
            end
        })

        MainTab:CreateToggle({
            Name = "Auto Fire",
            CurrentValue = false,
            Callback = function(Value)
                autoFireEnabled = Value
                print("Auto Fire " .. (autoFireEnabled and "enabled" or "disabled"))
            end
        })

        MainTab:CreateToggle({
            Name = "ESP",
            CurrentValue = false,
            Callback = function(Value)
                espEnabled = Value
                print("ESP " .. (espEnabled and "enabled" or "disabled"))
                if not espEnabled then clearESP() end
            end
        })

        MainTab:CreateToggle({
            Name = "Tracers",
            CurrentValue = false,
            Callback = function(Value)
                tracersEnabled = Value
                print("Tracers " .. (tracersEnabled and "enabled" or "disabled"))
                if not tracersEnabled then clearTracers() end
            end
        })

        MainTab:CreateToggle({
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

        MainTab:CreateToggle({
            Name = "Panic Mode",
            CurrentValue = false,
            Callback = function(Value)
                panicModeEnabled = Value
                print("Panic Mode " .. (panicModeEnabled and "enabled" or "disabled"))
                if panicModeEnabled then
                    aimbotEnabled = false
                    aimAssistEnabled = false
                    silentAimEnabled = false
                    hitboxExtenderEnabled = false
                    autoFireEnabled = false
                    espEnabled = false
                    tracersEnabled = false
                    fovCircleEnabled = false
                    locked = false
                    target = nil
                    clearESP()
                    clearTracers()
                    if fovCircle then fovCircle.Visible = false end
                    print("Panic Mode enabled - all features disabled")
                end
            end
        })
    end

    -- Game Mode Detection and Enemy Check
    local function isFFA()
        local teamCount = #teams:GetChildren()
        if teamCount == 0 then
            return true
        end
        local playersWithTeam = 0
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Team ~= nil then
                playersWithTeam = playersWithTeam + 1
            end
        end
        if playersWithTeam == 0 then
            return true
        end
        return false
    end

    local function isEnemyPlayer(enemy)
        if enemy == player then return false end
        local ffa = isFFA()
        if ffa then
            return true
        else
            return (player.Team ~= enemy.Team) or not player.Team or not enemy.Team
        end
    end

    -- ESP Functions
    local function addESP(target)
        if not target or not target.Parent or not target:FindFirstChild("HumanoidRootPart") or target == player.Character then
            return
        end
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
                if isEnemyPlayer(v) then
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

    -- Tracers Functions
    local function addTracer(target)
        if not target or not target.Parent or not target:FindFirstChild("HumanoidRootPart") then
            return
        end
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        local line = Drawing.new("Line")
        line.Transparency = 0.7
        line.Thickness = 1
        line.Color = (player.Team == target.Parent.Team and player.Team and target.Parent.Team) and tracerColorTeam or tracerColorEnemy
        line.Visible = true
        table.insert(tracers, {line = line, target = target})
    end

    local function clearTracers()
        for _, tracer in pairs(tracers) do
            if tracer.line then
                tracer.line:Remove()
            end
        end
        tracers = {}
    end

    local function updateTracers()
        if not tracersEnabled then
            clearTracers()
            return
        end
        clearTracers()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                addTracer(v.Character)
            end
        end
    end

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            v.CharacterAdded:Connect(function()
                if tracersEnabled then updateTracers() end
            end)
        end
    end

    game.Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.CharacterAdded:Connect(function()
            if tracersEnabled then updateTracers() end
        end)
    end)

    -- Silent Aim, Hitbox Extender, and Auto Fire Logic
    local function findClosestEnemy()
        local closest, shortestDist = nil, math.huge
        if not player.Character or not player.Character:FindFirstChild("Head") then
            return nil
        end
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character then
                local head = enemy.Character:FindFirstChild("Head")
                local humanoid = enemy.Character:FindFirstChild("Humanoid")
                if head and humanoid and humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                    if isEnemyPlayer(enemy) then
                        local dist = (head.Position - player.Character.Head.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closest = head
                        end
                    end
                end
            end
        end
        return closest
    end

    local function hookFireServer()
        if hooked then return end
        local comm = game.ReplicatedStorage:WaitForChild("Comm", 5)
        if not comm then
            print("Error: Could not find Comm in ReplicatedStorage")
            return
        end
        local hitPart = comm:WaitForChild("HitPart", 5)
        if not hitPart then
            print("Error: Could not find HitPart in Comm")
            return
        end
        print("Successfully hooked Arsenal HitPart event")
        originalFireServer = hitPart.FireServer
        hitPart.FireServer = function(self, hit, position, ...)
            if silentAimEnabled then
                local closestEnemy = findClosestEnemy()
                if closestEnemy then
                    hit = closestEnemy
                    position = closestEnemy.Position
                end
            elseif hitboxExtenderEnabled then
                local closestEnemy, shortestDist = nil, 10
                for _, enemy in pairs(game.Players:GetPlayers()) do
                    if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") and enemy.Character.Humanoid.Health > 0 then
                        if isEnemyPlayer(enemy) then
                            local dist = (enemy.Character.Head.Position - position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                closestEnemy = enemy.Character.Head
                            end
                        end
                    end
                end
                if closestEnemy then
                    hit = closestEnemy
                    position = closestEnemy.Position
                end
            end
            return originalFireServer(self, hit, position, ...)
        end
        hooked = true
    end

    -- Aimbot and Aim Assist Logic
    local function findTarget(forAimAssist)
        local closest, shortestDist = nil, math.huge
        local cursorPos = Vector2.new(mouse.X, mouse.Y)
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character then
                local head = enemy.Character:FindFirstChild("Head")
                local humanoid = enemy.Character:FindFirstChild("Humanoid")
                if head and humanoid and humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                    if isEnemyPlayer(enemy) then
                        local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - cursorPos).Magnitude
                            if forAimAssist or dist < fovSize then
                                if dist < shortestDist then
                                    shortestDist = dist
                                    closest = head
                                end
                            end
                        end
                    end
                end
            end
        end
        return closest
    end

    mouse.Button2Down:Connect(function()
        if not aimbotEnabled or panicModeEnabled then
            return
        end
        target = findTarget(false)
        if target then
            locked = true
            print("Aimbot locked onto: " .. target.Parent.Name)
        end
    end)

    mouse.Button2Up:Connect(function()
        if locked then
            locked = false
            target = nil
            print("Aimbot unlocked")
            local currentCFrame = camera.CFrame
            local lookVector = currentCFrame.LookVector
            local flatLook = lookVector * Vector3.new(1, 0, 1)
            local newLook = currentCFrame.Position + flatLook.Unit * 10
            local currentPitch = math.asin(lookVector.Y)
            local newCFrame = CFrame.new(currentCFrame.Position, newLook) * CFrame.Angles(currentPitch, 0, 0)
            camera.CFrame = newCFrame
        end
    end)

    -- Auto Fire Logic
    mouse.Button1Down:Connect(function()
        if autoFireEnabled and not panicModeEnabled then
            isFiring = true
        end
    end)

    mouse.Button1Up:Connect(function()
        isFiring = false
    end)

    runService.RenderStepped:Connect(function()
        if panicModeEnabled then return end

        -- Ensure player character is loaded
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        -- Calculate mouse movement speed for aim assist
        local currentMousePos = Vector2.new(mouse.X, mouse.Y)
        mouseSpeed = (currentMousePos - lastMousePos).Magnitude
        lastMousePos = currentMousePos

        -- Update FOV Circle
        if fovCircleEnabled and fovCircle then
            local screenSize = camera.ViewportSize
            local centerPos = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
            fovCircle.Position = centerPos
            fovCircle.Radius = fovCircleSize
            fovCircle.Color = fovCircleColor
            fovCircle.Visible = true
        end

        -- Update ESP
        if espEnabled then updateESP() end

        -- Update Tracers
        if tracersEnabled then
            for _, tracer in pairs(tracers) do
                if tracer.target and tracer.target:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local startPos = camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
                    local endPos, onScreen = camera:WorldToScreenPoint(tracer.target.HumanoidRootPart.Position)
                    if onScreen then
                        tracer.line.From = Vector2.new(startPos.X, startPos.Y)
                        tracer.line.To = Vector2.new(endPos.X, endPos.Y)
                        tracer.line.Visible = true
                    else
                        tracer.line.Visible = false
                    end
                else
                    tracer.line.Visible = false
                end
            end
            updateTracers()
        end

        -- Hook FireServer for Silent Aim, Hitbox Extender, and Auto Fire
        if silentAimEnabled or hitboxExtenderEnabled or autoFireEnabled then
            local successHook, hookErr = pcall(hookFireServer)
            if not successHook then
                print("Failed to hook FireServer: " .. tostring(hookErr))
            end
        end

        -- Auto Fire
        if autoFireEnabled and (isFiring or (aimbotEnabled and locked and target)) then
            local currentTime = tick()
            if currentTime - lastFireTime >= fireRate then
                local hitPart = game.ReplicatedStorage:FindFirstChild("Comm") and game.ReplicatedStorage.Comm:FindFirstChild("HitPart")
                if hitPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPart = target or mouse.Target
                    if not targetPart or not targetPart.Parent:FindFirstChild("Humanoid") then
                        targetPart = player.Character.HumanoidRootPart
                    end
                    local successFire, fireErr = pcall(function()
                        hitPart:FireServer(targetPart, targetPart.Position)
                    end)
                    if successFire then
                        lastFireTime = currentTime
                    else
                        print("Auto Fire failed: " .. tostring(fireErr))
                    end
                end
            end
        end

        -- Aimbot
        if aimbotEnabled and locked then
            if not target or not target.Parent or not target.Parent:FindFirstChild("Humanoid") or target.Parent.Humanoid.Health <= 0 or target.Parent.Humanoid:GetState() == Enum.HumanoidStateType.Dead then
                target = findTarget(false)
                if not target then
                    locked = false
                    local currentCFrame = camera.CFrame
                    local lookVector = currentCFrame.LookVector
                    local flatLook = lookVector * Vector3.new(1, 0, 1)
                    local newLook = currentCFrame.Position + flatLook.Unit * 10
                    local currentPitch = math.asin(lookVector.Y)
                    local newCFrame = CFrame.new(currentCFrame.Position, newLook) * CFrame.Angles(currentPitch, 0, 0)
                    camera.CFrame = newCFrame
                    return
                end
            end
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
            camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.8)
        end

        -- Aim Assist
        if aimAssistEnabled and not locked then
            local assistTarget = findTarget(true)
            if assistTarget then
                local screenPos, onScreen = camera:WorldToScreenPoint(assistTarget.Position)
                if onScreen then
                    local cursorPos = Vector2.new(mouse.X, mouse.Y)
                    local distToTarget = (Vector2.new(screenPos.X, screenPos.Y) - cursorPos).Magnitude
                    local baseStrength = 0.15
                    local stickiness = math.clamp(1 - (distToTarget / fovSize), 0, 1)
                    local speedFactor = math.clamp(mouseSpeed / 30, 0, 1)
                    local finalStrength = baseStrength * stickiness * (1 - speedFactor)
                    local currentCFrame = camera.CFrame
                    local targetCFrame = CFrame.new(currentCFrame.Position, assistTarget.Position)
                    camera.CFrame = currentCFrame:Lerp(targetCFrame, finalStrength)
                end
            end
        end
    end)

    print("Fuckery Hub Arsenal script loaded - v2.4 by d4mage1 - Added Rayfield with keybind fallback")
end)

if not success then
    print("Script failed to initialize: " .. tostring(err))
end
