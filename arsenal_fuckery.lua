print(" ")
print("=====================================")
print("     FUCKERY HUB - ARSENAL LOADED    ")
print("=====================================")
print(" ")
print([[
                      _        _                 _ _  _                             __ 
                     | |      | |               | | || |                           /_ |
  _ __ ___   __ _  __| | ___  | |__  _   _    __| | || |_ _ __ ___   __ _  __ _  ___| |
 | '_ ` _ \ / _` |/ _` |/ _ \ | '_ \| | | |  / _` |__   _| '_ ` _ \ / _` |/ _` |/ _ \ |
 | | | | | | (_| | (_| |  __/ | |_) | |_| | | (_| |  | | | | | | | | (_| | (_| |  __/ |
 |_| |_| |_|\__,_|\__,_|\___| |_.__/ \__, |  \__,_|  |_| |_| |_| |_|\__,_|\__, |\___|_|
                                      __/ |                                __/ |       
                                     |___/                                |___/         
]])
print(" ")
print("Loaded by: d4mage1")
print("Version: 1.4.2 - Arsenal Edition")
print(" ")

-- Services
local success, err = pcall(function()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    local camera = game.Workspace.CurrentCamera
    local runService = game:GetService("RunService")
    local teams = game:GetService("Teams")
    local uis = game:GetService("UserInputService")

    -- Load Rayfield UI Library
    local Rayfield
    local rayfieldUrl = "https://sirius.menu/rayfield"
    local rayfieldFallbackUrl = "https://raw.githubusercontent.com/UI-Interface/Rayfield/main/source"
    local rawScript

    success, err = pcall(function()
        rawScript = game:HttpGet(rayfieldUrl)
    end)
    if not success then
        print("Failed to load Rayfield from primary URL: " .. tostring(err))
        success, err = pcall(function()
            rawScript = game:HttpGet(rayfieldFallbackUrl)
        end)
        if not success then
            print("Failed to load Rayfield from fallback URL: " .. tostring(err))
            return
        end
    end

    success, err = pcall(function()
        Rayfield = loadstring(rawScript)()
    end)
    if not success or not Rayfield then
        print("Failed to initialize Rayfield: " .. tostring(err))
        return
    end

    -- Create Window
    local discordInvite = "https://discord.gg/mAFyAPnVA4"
    local Window = Rayfield:CreateWindow({
        Name = "Fuckery Hub - Arsenal",
        LoadingTitle = "Fuckery Hub - Arsenal",
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

    -- Main Tab (for Panic Mode)
    local MainTab = Window:CreateTab("Main")

    local panicModeEnabled = false
    MainTab:CreateToggle({
        Name = "Panic Mode (Disables All Features)",
        CurrentValue = false,
        Flag = "PanicModeToggle",
        Callback = function(Value)
            panicModeEnabled = Value
            if panicModeEnabled then
                print("Panic Mode enabled - disabling all features")
                aimbotEnabled = false
                aimAssistEnabled = false
                silentAimEnabled = false
                hitboxExtenderEnabled = false
                espEnabled = false
                fovCircleEnabled = false
                autoFireEnabled = false
                tracersEnabled = false
                locked = false
                target = nil
                clearESP()
                if fovCircle then fovCircle.Visible = false end
                clearTracers()
                Window:Notify({
                    Title = "Panic Mode",
                    Content = "All features disabled.",
                    Duration = 3
                })
            else
                print("Panic Mode disabled - features can be re-enabled")
                Window:Notify({
                    Title = "Panic Mode",
                    Content = "Features can now be re-enabled.",
                    Duration = 3
                })
            end
        end
    })

    -- Combat Tab
    local CombatTab = Window:CreateTab("Combat")

    local aimbotEnabled = false
    CombatTab:CreateToggle({
        Name = "Enable Aimbot",
        CurrentValue = false,
        Flag = "AimbotToggle",
        Callback = function(Value)
            if panicModeEnabled then
                print("Cannot enable aimbot - Panic Mode is active")
                Window:Notify({
                    Title = "Aimbot Error",
                    Content = "Cannot enable aimbot - Panic Mode is active.",
                    Duration = 3
                })
                return
            end
            aimbotEnabled = Value
            if not Value then
                locked = false
                target = nil
                local currentCFrame = camera.CFrame
                local lookVector = currentCFrame.LookVector
                local flatLook = lookVector * Vector3.new(1, 0, 1)
                local newLook = currentCFrame.Position + flatLook.Unit * 10
                local currentPitch = math.asin(lookVector.Y)
                local newCFrame = CFrame.new(currentCFrame.Position, newLook) * CFrame.Angles(currentPitch, 0, 0)
                camera.CFrame = newCFrame
                print("Aimbot disabled, camera reset")
            end
        end
    })

    local aimAssistEnabled = false
    CombatTab:CreateToggle({
        Name = "Enable Aim Assist",
        CurrentValue = false,
        Flag = "AimAssistToggle",
        Callback = function(Value)
            if panicModeEnabled then
                print("Cannot enable aim assist - Panic Mode is active")
                Window:Notify({
                    Title = "Aim Assist Error",
                    Content = "Cannot enable aim assist - Panic Mode is active.",
                    Duration = 3
                })
                return
            end
            aimAssistEnabled = Value
        end
    })

    local silentAimEnabled = false
    CombatTab:CreateToggle({
        Name = "Enable Silent Aim",
        CurrentValue = false,
        Flag = "SilentAimToggle",
        Callback = function(Value)
            if panicModeEnabled then
                print("Cannot enable silent aim - Panic Mode is active")
                Window:Notify({
                    Title = "Silent Aim Error",
                    Content = "Cannot enable silent aim - Panic Mode is active.",
                    Duration = 3
                })
                return
            end
            silentAimEnabled = Value
        end
    })

    local autoFireEnabled = false
    CombatTab:CreateToggle({
        Name = "Enable Auto Fire",
        CurrentValue = false,
        Flag = "AutoFireToggle",
        Callback = function(Value)
            if panicModeEnabled then
                print("Cannot enable auto fire - Panic Mode is active")
                Window:Notify({
                    Title = "Auto Fire Error",
                    Content = "Cannot enable auto fire - Panic Mode is active.",
                    Duration = 3
                })
                return
            end
            autoFireEnabled = Value
        end
    })

    local fovSize = 150
    CombatTab:CreateSlider({
        Name = "Aimbot/Assist FOV Size",
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
            if panicModeEnabled then
                print("Cannot enable hitbox extender - Panic Mode is active")
                Window:Notify({
                    Title = "Hitbox Extender Error",
                    Content = "Cannot enable hitbox extender - Panic Mode is active.",
                    Duration = 3
                })
                return
            end
            hitboxExtenderEnabled = Value
        end
    })

    -- Visuals Tab
    local VisualsTab = Window:CreateTab("Visuals")

    local espEnabled = false
    local espBoxes = {}
    local espColor = Color3.fromRGB(255, 0, 0)
    VisualsTab:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = false,
        Flag = "ESPToggle",
        Callback = function(Value)
            if panicModeEnabled then
                print("Cannot enable ESP - Panic Mode is active")
                Window:Notify({
                    Title = "ESP Error",
                    Content = "Cannot enable ESP - Panic Mode is active.",
                    Duration = 3
                })
                return
            end
            espEnabled = Value
            if not espEnabled then
                clearESP()
            end
        end
    })

    VisualsTab:CreateColorPicker({
        Name = "ESP Color",
        Color = espColor,
        Flag = "ESPColorPicker",
        Callback = function(Value)
            espColor = Value
        end
    })

    local tracersEnabled = false
    local tracers = {}
    local tracerColorEnemy = Color3.fromRGB(255, 0, 0)
    local tracerColorTeam = Color3.fromRGB(0, 255, 0)
    VisualsTab:CreateToggle({
        Name = "Enable Tracers",
        CurrentValue = false,
        Flag = "TracersToggle",
        Callback = function(Value)
            if panicModeEnabled then
                print("Cannot enable tracers - Panic Mode is active")
                Window:Notify({
                    Title = "Tracers Error",
                    Content = "Cannot enable tracers - Panic Mode is active.",
                    Duration = 3
                })
                return
            end
            tracersEnabled = Value
            if not tracersEnabled then
                clearTracers()
            end
        end
    })

    local fovCircleEnabled = false
    local fovCircleSize = 150
    local fovCircleColor = Color3.fromRGB(255, 255, 255)
    local fovCircle = nil

    VisualsTab:CreateToggle({
        Name = "Enable FOV Circle",
        CurrentValue = false,
        Flag = "FOVCircleToggle",
        Callback = function(Value)
            if panicModeEnabled then
                print("Cannot enable FOV circle - Panic Mode is active")
                Window:Notify({
                    Title = "FOV Circle Error",
                    Content = "Cannot enable FOV circle - Panic Mode is active.",
                    Duration = 3
                })
                return
            end
            fovCircleEnabled = Value
            if fovCircleEnabled then
                if not fovCircle then
                    fovCircle = Drawing.new("Circle")
                    fovCircle.Thickness = 2
                    fovCircle.NumSides = 64
                    fovCircle.Radius = fovCircleSize
                    local screenSize = camera.ViewportSize
                    fovCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
                    fovCircle.Color = fovCircleColor
                    fovCircle.Visible = true
                end
            else
                if fovCircle then
                    fovCircle.Visible = false
                end
            end
        end
    })

    VisualsTab:CreateSlider({
        Name = "FOV Circle Size",
        Range = {50, 350},
        Increment = 1,
        Suffix = "Units",
        CurrentValue = 150,
        Flag = "FOVCircleSizeSlider",
        Callback = function(Value)
            fovCircleSize = Value
            if fovCircle then
                fovCircle.Radius = fovCircleSize
            end
        end
    })

    VisualsTab:CreateColorPicker({
        Name = "FOV Circle Color",
        Color = fovCircleColor,
        Flag = "FOVCircleColorPicker",
        Callback = function(Value)
            fovCircleColor = Value
            if fovCircle then
                fovCircle.Color = fovCircleColor
            end
        end
    })

    -- Discord Fix Tab
    local DiscordTab = Window:CreateTab("Discord Fix")
    DiscordTab:CreateButton({
        Name = "Copy Discord Invite",
        Callback = function()
            local success, err = pcall(function()
                setclipboard(discordInvite)
            end)
            if success then
                print("Copied Discord invite to clipboard: " .. discordInvite)
            else
                print("Failed to copy Discord invite: " .. tostring(err))
                print("Join the Discord here: " .. discordInvite)
            end
        end
    })

    -- Game Mode Detection and Enemy Check
    local function isFFA()
        local teamCount = #teams:GetChildren()
        print("Team count: " .. teamCount)
        if teamCount == 0 then
            print("Detected FFA mode (no teams)")
            return true
        end
        local playersWithTeam = 0
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Team ~= nil then
                playersWithTeam = playersWithTeam + 1
            end
        end
        print("Players with teams: " .. playersWithTeam .. "/" .. #game.Players:GetPlayers())
        if playersWithTeam == 0 then
            print("Detected FFA mode (no players have teams)")
            return true
        end
        print("Detected Team mode")
        return false
    end

    local function isEnemyPlayer(enemy)
        if enemy == player then return false end
        local ffa = isFFA()
        if ffa then
            print("Enemy check (FFA): " .. enemy.Name .. " is an enemy")
            return true
        else
            local isEnemy = (player.Team ~= enemy.Team) or not player.Team or not enemy.Team
            print("Enemy check (Team mode): " .. enemy.Name .. " is " .. (isEnemy and "an enemy" or "not an enemy"))
            return isEnemy
        end
    end

    -- ESP Functions
    local function addESP(target)
        if not target or not target:FindFirstChild("HumanoidRootPart") or target == player.Character then return end
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
        if not target or not target:FindFirstChild("HumanoidRootPart") or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            print("Failed to add tracer for " .. (target and target.Name or "nil") .. ": Missing HumanoidRootPart")
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
            if tracer.line then tracer.line:Remove() end
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
            print("Cannot update tracers: Player character or HumanoidRootPart missing")
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
    local hooked = false
    local originalFireServer
    local lastFireTime = 0
    local fireRate = 0.1

    local function findClosestEnemy()
        local closest, shortestDist = nil, math.huge
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character then
                local head = enemy.Character:FindFirstChild("Head")
                local humanoid = enemy.Character:FindFirstChild("Humanoid")
                if head and humanoid and humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                    if isEnemyPlayer(enemy) then
                        local dist = (head.Position - (player.Character and player.Character:FindFirstChild("Head") and player.Character.Head.Position or camera.CFrame.Position)).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closest = head
                        end
                    end
                end
            end
        end
        if closest then
            print("Closest enemy found: " .. closest.Parent.Name .. " (Distance: " .. shortestDist .. ")")
        else
            print("No closest enemy found")
        end
        return closest
    end

    local function hookFireServer()
        if hooked then return end
        local comm = game.ReplicatedStorage:WaitForChild("Comm", 5)
        if not comm then
            print("Error: Could not find Comm in ReplicatedStorage")
            Window:Notify({
                Title = "Hook Error",
                Content = "Could not find Comm in ReplicatedStorage. Some features may not work.",
                Duration = 5
            })
            return
        end
        local hitPart = comm:WaitForChild("HitPart", 5)
        if not hitPart then
            print("Error: Could not find HitPart in Comm")
            Window:Notify({
                Title = "Hook Error",
                Content = "Could not find HitPart in Comm. Silent Aim, Hitbox Extender, and Auto Fire may not work.",
                Duration = 5
            })
            return
        end
        print("Successfully hooked Arsenal HitPart event")
        originalFireServer = hitPart.FireServer
        hitPart.FireServer = function(self, hit, position, ...)
            if silentAimEnabled then
                local closestEnemy = findClosestEnemy()
                if closestEnemy then
                    print("Silent Aim: Redirecting shot to " .. closestEnemy.Parent.Name)
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
                    print("Hitbox Extender: Redirecting shot to " .. closestEnemy.Parent.Name)
                    hit = closestEnemy
                    position = closestEnemy.Position
                end
            end
            return originalFireServer(self, hit, position, ...)
        end
        hooked = true
    end

    -- Aimbot and Aim Assist Logic
    local target = nil
    local locked = false
    local lastMousePos = Vector2.new(mouse.X, mouse.Y)
    local mouseSpeed = 0

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
                            if forAimAssist or dist < fovSize then -- Aim assist doesn't need FOV check
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
        if closest then
            print("Found target: " .. closest.Parent.Name .. " (Distance: " .. shortestDist .. ")")
        else
            print("No target found within " .. (forAimAssist and "screen" or "FOV"))
        end
        return closest
    end

    mouse.Button2Down:Connect(function()
        if not aimbotEnabled or panicModeEnabled then
            print("Cannot lock aimbot: " .. (not aimbotEnabled and "Aimbot disabled" or "Panic Mode active"))
            return
        end
        print("Right-click detected, attempting to lock aimbot")
        target = findTarget(false)
        if target then
            locked = true
            print("Aimbot locked onto: " .. target.Parent.Name)
            Window:Notify({
                Title = "Aimbot",
                Content = "Locked onto " .. target.Parent.Name,
                Duration = 2
            })
        else
            print("No aimbot target found")
            Window:Notify({
                Title = "Aimbot",
                Content = "No target found within FOV.",
                Duration = 2
            })
        end
    end)

    mouse.Button2Up:Connect(function()
        if locked then
            locked = false
            target = nil
            print("Aimbot unlocked")
            Window:Notify({
                Title = "Aimbot",
                Content = "Aimbot unlocked.",
                Duration = 2
            })
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
    local isFiring = false
    mouse.Button1Down:Connect(function()
        if autoFireEnabled and not panicModeEnabled then
            isFiring = true
            print("Left-click down: Auto fire started")
        end
    end)

    mouse.Button1Up:Connect(function()
        isFiring = false
        print("Left-click up: Auto fire stopped")
    end)

    runService.RenderStepped:Connect(function()
        if panicModeEnabled then return end

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
        if espEnabled then updateESP() else clearESP() end

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
        else
            clearTracers()
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
                        print("Auto Fire: Shot fired at " .. targetPart.Parent.Name)
                    else
                        print("Auto Fire failed: " .. tostring(fireErr))
                    end
                else
                    print("Auto Fire failed: HitPart or player character not found")
                end
            end
        end

        -- Aimbot
        if aimbotEnabled and locked then
            if not target or not target.Parent or not target.Parent:FindFirstChild("Humanoid") or target.Parent.Humanoid.Health <= 0 or target.Parent.Humanoid:GetState() == Enum.HumanoidStateType.Dead then
                print("Aimbot target invalid: " .. (target and target.Parent.Name or "nil"))
                target = findTarget(false)
                if not target then
                    locked = false
                    print("No aimbot target, resetting camera")
                    Window:Notify({
                        Title = "Aimbot",
                        Content = "Target lost. Aimbot unlocked.",
                        Duration = 2
                    })
                    local currentCFrame = camera.CFrame
                    local lookVector = currentCFrame.LookVector
                    local flatLook = lookVector * Vector3.new(1, 0, 1)
                    local newLook = currentCFrame.Position + flatLook.Unit * 10
                    local currentPitch = math.asin(lookVector.Y)
                    local newCFrame = CFrame.new(currentCFrame.Position, newLook) * CFrame.Angles(currentPitch, 0, 0)
                    camera.CFrame = newCFrame
                    return
                end
                print("Aimbot new target: " .. target.Parent.Name)
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
                    print("Aim Assist Strength: " .. finalStrength .. " (Distance: " .. distToTarget .. ", Speed: " .. mouseSpeed .. ")")
                end
            end
        end
    end)

    print("Fuckery Hub Arsenal script loaded - v2.1 by d4mage1 - Fixed aimbot lock, fixed all features, added notifications")
end)

if not success then
    print("Script failed to initialize: " .. tostring(err))
end
