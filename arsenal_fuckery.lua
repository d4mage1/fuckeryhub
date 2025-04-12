print(" ")
print("=====================================")
print("     FUCKERY HUB - ARSENAL LOADED    ")
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
print("Version: 2.7 - Arsenal Edition")
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
    local hitboxExtenderEnabled = false
    local autoFireEnabled = false
    local espEnabled = false
    local tracersEnabled = false
    local fovCircleEnabled = false
    local panicModeEnabled = false

    -- Feature Variables
    local espBoxes = {}
    local hitboxParts = {} -- Store expanded hitboxes
    local tracerBeams = {}
    local fovCircle = nil
    local hitboxSize = 6 -- Default hitbox size (6 studs)
    local fovCircleSize = 150
    local fovCircleColor = Color3.fromRGB(255, 255, 255)
    local espColor = Color3.fromRGB(255, 0, 0)
    local hitboxColor = Color3.fromRGB(255, 0, 0) -- Red for hitbox overlay
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
        print("F3 - Toggle Hitbox Extender")
        print("F4 - Toggle Auto Fire")
        print("F5 - Toggle ESP")
        print("F6 - Toggle Tracers")
        print("F7 - Toggle FOV Circle")
        print("F8 - Toggle Panic Mode")
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
                    hitboxExtenderEnabled = not hitboxExtenderEnabled
                    print("Hitbox Extender " .. (hitboxExtenderEnabled and "enabled" or "disabled"))
                    if not hitboxExtenderEnabled then clearHitboxes() end
                elseif input.KeyCode == Enum.KeyCode.F4 then
                    autoFireEnabled = not autoFireEnabled
                    print("Auto Fire " .. (autoFireEnabled and "enabled" or "disabled"))
                elseif input.KeyCode == Enum.KeyCode.F5 then
                    espEnabled = not espEnabled
                    print("ESP " .. (espEnabled and "enabled" or "disabled"))
                    if not espEnabled then clearESP() end
                elseif input.KeyCode == Enum.KeyCode.F6 then
                    tracersEnabled = not tracersEnabled
                    print("Tracers " .. (tracersEnabled and "enabled" or "disabled"))
                    if not tracersEnabled then clearTracers() end
                elseif input.KeyCode == Enum.KeyCode.F7 then
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
                elseif input.KeyCode == Enum.KeyCode.F8 then
                    panicModeEnabled = not panicModeEnabled
                    print("Panic Mode " .. (panicModeEnabled and "enabled" or "disabled"))
                    if panicModeEnabled then
                        aimbotEnabled = false
                        aimAssistEnabled = false
                        hitboxExtenderEnabled = false
                        autoFireEnabled = false
                        espEnabled = false
                        tracersEnabled = false
                        fovCircleEnabled = false
                        locked = false
                        target = nil
                        clearESP()
                        clearTracers()
                        clearHitboxes()
                        if fovCircle then fovCircle.Visible = false end
                        print("Panic Mode enabled - all features disabled")
                    end
                end
            end
        end)
    else
        -- Rayfield loaded successfully, create the GUI with tabs
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

        -- Combat Tab
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
            Name = "Aim Assist",
            CurrentValue = false,
            Callback = function(Value)
                aimAssistEnabled = Value
                print("Aim Assist " .. (aimAssistEnabled and "enabled" or "disabled"))
            end
        })

        CombatTab:CreateToggle({
            Name = "Hitbox Extender",
            CurrentValue = false,
            Callback = function(Value)
                hitboxExtenderEnabled = Value
                print("Hitbox Extender " .. (hitboxExtenderEnabled and "enabled" or "disabled"))
                if not hitboxExtenderEnabled then clearHitboxes() end
            end
        })

        CombatTab:CreateSlider({
            Name = "Hitbox Size",
            Range = {4, 12}, -- Range from 4 to 12 studs
            Increment = 1,
            Suffix = "Studs",
            CurrentValue = 6,
            Callback = function(Value)
                hitboxSize = Value
                print("Hitbox Size set to " .. hitboxSize .. " studs")
                if hitboxExtenderEnabled then
                    clearHitboxes()
                    updateHitboxes()
                end
            end
        })

        CombatTab:CreateToggle({
            Name = "Auto Fire",
            CurrentValue = false,
            Callback = function(Value)
                autoFireEnabled = Value
                print("Auto Fire " .. (autoFireEnabled and "enabled" or "disabled"))
            end
        })

        -- Visuals Tab
        local VisualsTab = Window:CreateTab("Visuals")
        local VisualsSection = VisualsTab:CreateSection("Visual Features")

        VisualsTab:CreateToggle({
            Name = "ESP",
            CurrentValue = false,
            Callback = function(Value)
                espEnabled = Value
                print("ESP " .. (espEnabled and "enabled" or "disabled"))
                if not espEnabled then clearESP() end
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
                    fovCircle.Transparency = 0.5
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

        VisualsTab:CreateToggle({
            Name = "Tracers",
            CurrentValue = false,
            Callback = function(Value)
                tracersEnabled = Value
                print("Tracers " .. (tracersEnabled and "enabled" or "disabled"))
                if not tracersEnabled then clearTracers() end
            end
        })

        -- Panic Tab
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
                    hitboxExtenderEnabled = false
                    autoFireEnabled = false
                    espEnabled = false
                    tracersEnabled = false
                    fovCircleEnabled = false
                    locked = false
                    target = nil
                    clearESP()
                    clearTracers()
                    clearHitboxes()
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

    -- Hitbox Extender Functions
    local function addHitbox(target)
        if not target or not target.Parent or not target:FindFirstChild("HumanoidRootPart") or target == player.Character then
            return
        end
        local hitbox = Instance.new("Part")
        hitbox.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        hitbox.Anchored = true
        hitbox.CanCollide = false
        hitbox.Transparency = 0.7
        hitbox.Color = hitboxColor
        hitbox.Position = target.HumanoidRootPart.Position
        hitbox.Parent = target

        -- Weld the hitbox to the target's HumanoidRootPart
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hitbox
        weld.Part1 = target.HumanoidRootPart
        weld.Parent = hitbox

        table.insert(hitboxParts, {part = hitbox, target = target})
    end

    local function clearHitboxes()
        for _, hitbox in pairs(hitboxParts) do
            if hitbox.part then hitbox.part:Destroy() end
        end
        hitboxParts = {}
    end

    local function updateHitboxes()
        if not hitboxExtenderEnabled then
            clearHitboxes()
            return
        end
        clearHitboxes()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                if isEnemyPlayer(v) then
                    addHitbox(v.Character)
                end
            end
        end
    end

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player then
            v.CharacterAdded:Connect(function()
                if hitboxExtenderEnabled then updateHitboxes() end
            end)
        end
    end

    game.Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.CharacterAdded:Connect(function()
            if hitboxExtenderEnabled then updateHitboxes() end
        end)
    end)

    -- Tracers Functions (Using Beams)
    local function addTracer(target)
        if not target or not target.Parent or not target:FindFirstChild("HumanoidRootPart") then
            return
        end
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        -- Create Beam
        local beam = Instance.new("Beam")
        beam.Color = ColorSequence.new((player.Team == target.Parent.Team and player.Team and target.Parent.Team) and tracerColorTeam or tracerColorEnemy)
        beam.Width0 = 0.1
        beam.Width1 = 0.1
        beam.Transparency = NumberSequence.new(0.3)
        beam.LightEmission = 0.5

        -- Create Attachments
        local attachment0 = Instance.new("Attachment")
        local attachment1 = Instance.new("Attachment")
        attachment0.Parent = player.Character.HumanoidRootPart
        attachment1.Parent = target.HumanoidRootPart

        -- Assign Attachments to Beam
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.Parent = game.Workspace

        table.insert(tracerBeams, {beam = beam, target = target, attachment0 = attachment0, attachment1 = attachment1})
    end

    local function clearTracers()
        for _, tracer in pairs(tracerBeams) do
            if tracer.beam then tracer.beam:Destroy() end
            if tracer.attachment0 then tracer.attachment0:Destroy() end
            if tracer.attachment1 then tracer.attachment1:Destroy() end
        end
        tracerBeams = {}
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

    -- Auto Fire: Check if cursor is over an enemy (including expanded hitbox)
    local function isCursorOnEnemy()
        local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {player.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
        if raycastResult then
            local hitPart = raycastResult.Instance
            local hitPlayer = game.Players:GetPlayerFromCharacter(hitPart.Parent)
            if hitPlayer and hitPlayer ~= player and hitPlayer.Character and hitPlayer.Character:FindFirstChild("Humanoid") and hitPlayer.Character.Humanoid.Health > 0 then
                if isEnemyPlayer(hitPlayer) then
                    return hitPlayer.Character:FindFirstChild("Head")
                end
            end
            -- Check if ray hits an expanded hitbox
            if hitboxExtenderEnabled then
                for _, hitbox in pairs(hitboxParts) do
                    if hitbox.part == hitPart then
                        local targetPlayer = game.Players:GetPlayerFromCharacter(hitbox.target)
                        if targetPlayer and targetPlayer ~= player and isEnemyPlayer(targetPlayer) then
                            return hitbox.target:FindFirstChild("Head")
                        end
                    end
                end
            end
        end
        return nil
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

    -- Hook FireServer for Auto Fire
    local function hookFireServer()
        if hooked then return end
        local comm = game.ReplicatedStorage:FindFirstChild("Comm")
        if not comm then
            print("Error: Could not find Comm in ReplicatedStorage")
            return
        end
        local hitPart = comm:FindFirstChild("HitPart")
        if not hitPart then
            print("Error: Could not find HitPart in Comm")
            return
        end
        print("Successfully hooked Arsenal HitPart event")
        originalFireServer = hitPart.FireServer
        hitPart.FireServer = function(self, hit, position, ...)
            return originalFireServer(self, hit, position, ...)
        end
        hooked = true
    end

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

        -- Update Hitboxes
        if hitboxExtenderEnabled then updateHitboxes() end

        -- Update Tracers
        if tracersEnabled then
            for _, tracer in pairs(tracerBeams) do
                if tracer.target and tracer.target.Parent and tracer.target:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    tracer.beam.Enabled = true
                else
                    tracer.beam.Enabled = false
                end
            end
            updateTracers()
        end

        -- Hook FireServer for Auto Fire
        if autoFireEnabled then
            local successHook, hookErr = pcall(hookFireServer)
            if not successHook then
                print("Failed to hook FireServer: " .. tostring(hookErr))
            end
        end

        -- Auto Fire: Fire when cursor is over an enemy (including expanded hitbox)
        if autoFireEnabled then
            local cursorTarget = isCursorOnEnemy()
            if cursorTarget then
                local currentTime = tick()
                if currentTime - lastFireTime >= fireRate then
                    local hitPart = game.ReplicatedStorage:FindFirstChild("Comm") and game.ReplicatedStorage.Comm:FindFirstChild("HitPart")
                    if hitPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local successFire, fireErr = pcall(function()
                            hitPart:FireServer(cursorTarget, cursorTarget.Position)
                        end)
                        if successFire then
                            lastFireTime = currentTime
                            print("Auto Fire: Shot fired at " .. cursorTarget.Parent.Name)
                        else
                            print("Auto Fire failed: " .. tostring(fireErr))
                        end
                    else
                        print("Auto Fire failed: HitPart or player character not found")
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

        -- Aim Assist (Less Sticky)
        if aimAssistEnabled and not locked then
            local assistTarget = findTarget(true)
            if assistTarget then
                local screenPos, onScreen = camera:WorldToScreenPoint(assistTarget.Position)
                if onScreen then
                    local cursorPos = Vector2.new(mouse.X, mouse.Y)
                    local distToTarget = (Vector2.new(screenPos.X, screenPos.Y) - cursorPos).Magnitude
                    local baseStrength = 0.05
                    local stickiness = math.clamp(1 - (distToTarget / (fovSize * 1.5)), 0, 1)
                    local speedFactor = math.clamp(mouseSpeed / 50, 0, 1)
                    local finalStrength = baseStrength * stickiness * (1 - speedFactor)
                    local currentCFrame = camera.CFrame
                    local targetCFrame = CFrame.new(currentCFrame.Position, assistTarget.Position)
                    camera.CFrame = currentCFrame:Lerp(targetCFrame, finalStrength)
                end
            end
        end
    end)

    print("Fuckery Hub Arsenal script loaded - v2.7 by d4mage1 - Fixed hitbox extender (expanded, transparent, slider)")
end)

if not success then
    print("Script failed to initialize: " .. tostring(err))
end
