local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local teams = game:GetService("Teams")
local tweenService = game:GetService("TweenService")

-- GUI Setup (Next-Level Design)
local gui = Instance.new("ScreenGui")
gui.Name = "FuckeryHub"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 380)
frame.Position = UDim2.new(0.5, -160, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 1
frame.Parent = gui

-- Neon Border with Glow
local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 3
frameStroke.Color = Color3.fromRGB(255, 0, 0)
frameStroke.Transparency = 1
frameStroke.Parent = frame

-- Gradient with a Sharper Contrast
local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 0))
})
frameGradient.Rotation = 90
frameGradient.Parent = frame

-- Title with a Futuristic Font (Switched to SciFi)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "FUCKERY HUB"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextSize = 28
title.Font = Enum.Font.SciFi -- Valid font, looks futuristic
title.TextStrokeTransparency = 0.4
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1
title.Parent = frame

-- Close Button (Top-Right)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.SciFi -- Valid font
closeButton.BackgroundTransparency = 1
closeButton.Parent = frame

local closeStroke = Instance.new("UIStroke")
closeStroke.Thickness = 1
closeStroke.Color = Color3.fromRGB(255, 0, 0)
closeStroke.Transparency = 1
closeStroke.Parent = closeButton

-- ESP Toggle Button
local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 280, 0, 70)
espToggle.Position = UDim2.new(0.5, -140, 0, 80)
espToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
espToggle.Text = "ESP: OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
espToggle.TextSize = 22
espToggle.Font = Enum.Font.SciFi -- Valid font
espToggle.BackgroundTransparency = 1
espToggle.Parent = frame

local espStroke = Instance.new("UIStroke")
espStroke.Thickness = 2
espStroke.Color = Color3.fromRGB(255, 0, 0)
espStroke.Transparency = 1
espStroke.Parent = espToggle

local espGradient = Instance.new("UIGradient")
espGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 0, 0))
})
espGradient.Parent = espToggle

-- Aimbot Toggle Button
local aimToggle = Instance.new("TextButton")
aimToggle.Size = UDim2.new(0, 280, 0, 70)
aimToggle.Position = UDim2.new(0.5, -140, 0, 160)
aimToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
aimToggle.Text = "AIMBOT: OFF"
aimToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
aimToggle.TextSize = 22
aimToggle.Font = Enum.Font.SciFi -- Valid font
aimToggle.BackgroundTransparency = 1
aimToggle.Parent = frame

local aimStroke = Instance.new("UIStroke")
aimStroke.Thickness = 2
aimStroke.Color = Color3.fromRGB(255, 0, 0)
aimStroke.Transparency = 1
aimStroke.Parent = aimToggle

local aimGradient = Instance.new("UIGradient")
aimGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 0, 0))
})
aimGradient.Parent = aimToggle

-- Animations
-- Fade-In for GUI
local fadeInInfo = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local frameFadeIn = tweenService:Create(frame, fadeInInfo, {BackgroundTransparency = 0})
local frameStrokeFadeIn = tweenService:Create(frameStroke, fadeInInfo, {Transparency = 0})
local titleFadeIn = tweenService:Create(title, fadeInInfo, {TextTransparency = 0})
local espFadeIn = tweenService:Create(espToggle, fadeInInfo, {BackgroundTransparency = 0})
local espStrokeFadeIn = tweenService:Create(espStroke, fadeInInfo, {Transparency = 0})
local aimFadeIn = tweenService:Create(aimToggle, fadeInInfo, {BackgroundTransparency = 0})
local aimStrokeFadeIn = tweenService:Create(aimStroke, fadeInInfo, {Transparency = 0})
local closeFadeIn = tweenService:Create(closeButton, fadeInInfo, {BackgroundTransparency = 0})
local closeStrokeFadeIn = tweenService:Create(closeStroke, fadeInInfo, {Transparency = 0})

frameFadeIn:Play()
frameStrokeFadeIn:Play()
titleFadeIn:Play()
espFadeIn:Play()
espStrokeFadeIn:Play()
aimFadeIn:Play()
aimStrokeFadeIn:Play()
closeFadeIn:Play()
closeStrokeFadeIn:Play()

-- Hover Effect for Buttons
local hoverInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local espHoverOn = tweenService:Create(espToggle, hoverInfo, {Size = UDim2.new(0, 290, 0, 75), BackgroundColor3 = Color3.fromRGB(55, 55, 55)})
local espHoverOff = tweenService:Create(espToggle, hoverInfo, {Size = UDim2.new(0, 280, 0, 70), BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
local aimHoverOn = tweenService:Create(aimToggle, hoverInfo, {Size = UDim2.new(0, 290, 0, 75), BackgroundColor3 = Color3.fromRGB(55, 55, 55)})
local aimHoverOff = tweenService:Create(aimToggle, hoverInfo, {Size = UDim2.new(0, 280, 0, 70), BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
local closeHoverOn = tweenService:Create(closeButton, hoverInfo, {BackgroundColor3 = Color3.fromRGB(80, 0, 0)})
local closeHoverOff = tweenService:Create(closeButton, hoverInfo, {BackgroundColor3 = Color3.fromRGB(50, 0, 0)})

espToggle.MouseEnter:Connect(function()
    espHoverOn:Play()
end)
espToggle.MouseLeave:Connect(function()
    espHoverOff:Play()
end)

aimToggle.MouseEnter:Connect(function()
    aimHoverOn:Play()
end)
aimToggle.MouseLeave:Connect(function()
    aimHoverOff:Play()
end)

closeButton.MouseEnter:Connect(function()
    closeHoverOn:Play()
end)
closeButton.MouseLeave:Connect(function()
    closeHoverOff:Play()
end)

-- Close Button Spin Animation
local spinInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local closeSpin = tweenService:Create(closeButton, spinInfo, {Rotation = 180})

closeButton.MouseButton1Click:Connect(function()
    closeSpin:Play()
    wait(0.5)
    gui:Destroy()
end)

-- ESP with Boxes (Enemies Only, Arsenal Fix)
local espEnabled = false
local espBoxes = {}

local function addESPBox(target)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = target:GetExtentsSize() * 1.1
    box.Adornee = target
    box.AlwaysOnTop = true
    box.ZIndex = 0
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Parent = target
    table.insert(espBoxes, box)
end

local function clearESP()
    for _, box in pairs(espBoxes) do
        box:Destroy()
    end
    espBoxes = {}
end

local function updateESP()
    if espEnabled then
        clearESP()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character then
                -- Arsenal-specific team check using TeamColor and Status
                local playerTeam = player:FindFirstChild("TeamColor") and player.TeamColor
                local enemyTeam = v:FindFirstChild("TeamColor") and v.TeamColor
                local isEnemy = true
                if playerTeam and enemyTeam then
                    if playerTeam == enemyTeam then
                        isEnemy = false
                    end
                else
                    -- Fallback: Check Team and Status (Arsenal-specific)
                    local playerTeamObj = player.Team
                    local enemyTeamObj = v.Team
                    if playerTeamObj and enemyTeamObj and playerTeamObj == enemyTeamObj then
                        isEnemy = false
                    end
                    -- Arsenal-specific: Check "Status" for team assignment
                    local playerStatus = player:FindFirstChild("Status")
                    local enemyStatus = v:FindFirstChild("Status")
                    if playerStatus and enemyStatus then
                        local playerTeamValue = playerStatus:FindFirstChild("Team")
                        local enemyTeamValue = enemyStatus:FindFirstChild("Team")
                        if playerTeamValue and enemyTeamValue and playerTeamValue.Value == enemyTeamValue.Value then
                            isEnemy = false
                        end
                    end
                end
                if isEnemy then
                    addESPBox(v.Character)
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
                local playerTeam = player:FindFirstChild("TeamColor") and player.TeamColor
                local enemyTeam = v:FindFirstChild("TeamColor") and v.TeamColor
                local isEnemy = true
                if playerTeam and enemyTeam then
                    if playerTeam == enemyTeam then
                        isEnemy = false
                    end
                else
                    local playerTeamObj = player.Team
                    local enemyTeamObj = v.Team
                    if playerTeamObj and enemyTeamObj and playerTeamObj == enemyTeamObj then
                        isEnemy = false
                    end
                    local playerStatus = player:FindFirstChild("Status")
                    local enemyStatus = v:FindFirstChild("Status")
                    if playerStatus and enemyStatus then
                        local playerTeamValue = playerStatus:FindFirstChild("Team")
                        local enemyTeamValue = enemyStatus:FindFirstChild("Team")
                        if playerTeamValue and enemyTeamValue and playerTeamValue.Value == enemyTeamValue.Value then
                            isEnemy = false
                        end
                    end
                end
                if isEnemy then
                    addESPBox(char)
                end
            end
        end)
    end
end

game.Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if espEnabled then
            local playerTeam = player:FindFirstChild("TeamColor") and player.TeamColor
            local enemyTeam = newPlayer:FindFirstChild("TeamColor") and newPlayer.TeamColor
            local isEnemy = true
            if playerTeam and enemyTeam then
                if playerTeam == enemyTeam then
                    isEnemy = false
                end
            else
                local playerTeamObj = player.Team
                local enemyTeamObj = newPlayer.Team
                if playerTeamObj and enemyTeamObj and playerTeamObj == enemyTeamObj then
                    isEnemy = false
                end
                local playerStatus = player:FindFirstChild("Status")
                local enemyStatus = newPlayer:FindFirstChild("Status")
                if playerStatus and enemyStatus then
                    local playerTeamValue = playerStatus:FindFirstChild("Team")
                    local enemyTeamValue = enemyStatus:FindFirstChild("Team")
                    if playerTeamValue and enemyTeamValue and playerTeamValue.Value == enemyTeamValue.Value then
                        isEnemy = false
                    end
                end
            end
            if isEnemy then
                addESPBox(char)
            end
        end
    end)
end)

-- Aimbot: Hold Right-Click to Lock and Fire (Enemies Only)
local aimEnabled = false
local target = nil
local locked = false

mouse.Button2Down:Connect(function()
    if aimEnabled then
        local closest = nil
        local shortestDist = math.huge
        local mousePos = mouse.Hit.Position

        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") then
                local playerTeam = player:FindFirstChild("TeamColor") and player.TeamColor
                local enemyTeam = enemy:FindFirstChild("TeamColor") and enemy.TeamColor
                local isEnemy = true
                if playerTeam and enemyTeam then
                    if playerTeam == enemyTeam then
                        isEnemy = false
                    end
                else
                    local playerTeamObj = player.Team
                    local enemyTeamObj = enemy.Team
                    if playerTeamObj and enemyTeamObj and playerTeamObj == enemyTeamObj then
                        isEnemy = false
                    end
                    local playerStatus = player:FindFirstChild("Status")
                    local enemyStatus = enemy:FindFirstChild("Status")
                    if playerStatus and enemyStatus then
                        local playerTeamValue = playerStatus:FindFirstChild("Team")
                        local enemyTeamValue = enemyStatus:FindFirstChild("Team")
                        if playerTeamValue and enemyTeamValue and playerTeamValue.Value == enemyTeamValue.Value then
                            isEnemy = false
                        end
                    end
                end
                if isEnemy then
                    local head = enemy.Character.Head
                    local dist = (head.Position - mousePos).Magnitude
                    if dist < shortestDist then
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
    end
end)

mouse.Button2Up:Connect(function()
    locked = false
    target = nil
end)

runService.RenderStepped:Connect(function()
    if aimEnabled and locked and target and target.Parent then
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
    end
end)

-- Toggle Logic with Slide Animation
local toggleInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
local espSlideOn = tweenService:Create(espToggle, toggleInfo, {Position = UDim2.new(0.5, -130, 0, 80)})
local espSlideOff = tweenService:Create(espToggle, toggleInfo, {Position = UDim2.new(0.5, -140, 0, 80)})
local aimSlideOn = tweenService:Create(aimToggle, toggleInfo, {Position = UDim2.new(0.5, -130, 0, 160)})
local aimSlideOff = tweenService:Create(aimToggle, toggleInfo, {Position = UDim2.new(0.5, -140, 0, 160)})

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espToggle.TextColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    if espEnabled then
        espSlideOn:Play()
    else
        espSlideOff:Play()
    end
    updateESP()
end)

aimToggle.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimToggle.Text = "AIMBOT: " .. (aimEnabled and "ON" or "OFF")
    aimToggle.TextColor3 = aimEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    if aimEnabled then
        aimSlideOn:Play()
    else
        aimSlideOff:Play()
    end
end)
