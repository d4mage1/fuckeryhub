local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local teams = game:GetService("Teams")
local tweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "FuckeryHub"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0.5, -150, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 1 
frame.Parent = gui

local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(255, 0, 0)
frameStroke.Transparency = 1
frameStroke.Parent = frame

local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
})
frameGradient.Rotation = 45
frameGradient.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "FUCKERY HUB"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextSize = 24
title.Font = Enum.Font.Antique
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1
title.Parent = frame

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 250, 0, 60)
espToggle.Position = UDim2.new(0.5, -125, 0, 70)
espToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
espToggle.Text = "ESP: OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
espToggle.TextSize = 20
espToggle.Font = Enum.Font.Antique
espToggle.BackgroundTransparency = 1
espToggle.Parent = frame

local espStroke = Instance.new("UIStroke")
espStroke.Thickness = 1
espStroke.Color = Color3.fromRGB(255, 0, 0)
espStroke.Transparency = 1
espStroke.Parent = espToggle

local espGradient = Instance.new("UIGradient")
espGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 0))
})
espGradient.Parent = espToggle

local aimToggle = Instance.new("TextButton")
aimToggle.Size = UDim2.new(0, 250, 0, 60)
aimToggle.Position = UDim2.new(0.5, -125, 0, 140)
aimToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
aimToggle.Text = "AIMBOT: OFF"
aimToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
aimToggle.TextSize = 20
aimToggle.Font = Enum.Font.Antique
aimToggle.BackgroundTransparency = 1
aimToggle.Parent = frame

local aimStroke = Instance.new("UIStroke")
aimStroke.Thickness = 1
aimStroke.Color = Color3.fromRGB(255, 0, 0)
aimStroke.Transparency = 1 
aimStroke.Parent = aimToggle

local aimGradient = Instance.new("UIGradient")
aimGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 0))
})
aimGradient.Parent = aimToggle

local fadeInInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local frameFadeIn = tweenService:Create(frame, fadeInInfo, {BackgroundTransparency = 0})
local frameStrokeFadeIn = tweenService:Create(frameStroke, fadeInInfo, {Transparency = 0})
local titleFadeIn = tweenService:Create(title, fadeInInfo, {TextTransparency = 0})
local espFadeIn = tweenService:Create(espToggle, fadeInInfo, {BackgroundTransparency = 0})
local espStrokeFadeIn = tweenService:Create(espStroke, fadeInInfo, {Transparency = 0})
local aimFadeIn = tweenService:Create(aimToggle, fadeInInfo, {BackgroundTransparency = 0})
local aimStrokeFadeIn = tweenService:Create(aimStroke, fadeInInfo, {Transparency = 0})

frameFadeIn:Play()
frameStrokeFadeIn:Play()
titleFadeIn:Play()
espFadeIn:Play()
espStrokeFadeIn:Play()
aimFadeIn:Play()
aimStrokeFadeIn:Play()

local hoverInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local espHoverOn = tweenService:Create(espToggle, hoverInfo, {Size = UDim2.new(0, 260, 0, 65), BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
local espHoverOff = tweenService:Create(espToggle, hoverInfo, {Size = UDim2.new(0, 250, 0, 60), BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
local aimHoverOn = tweenService:Create(aimToggle, hoverInfo, {Size = UDim2.new(0, 260, 0, 65), BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
local aimHoverOff = tweenService:Create(aimToggle, hoverInfo, {Size = UDim2.new(0, 250, 0, 60), BackgroundColor3 = Color3.fromRGB(30, 30, 30)})

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

-- ESP with Boxes (Enemies Only)
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
            if v ~= player and v.Character and v.Team ~= player.Team and v.Team ~= nil then
                addESPBox(v.Character)
            end
        end
    else
        clearESP()
    end
end

for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= player then
        v.CharacterAdded:Connect(function(char)
            if espEnabled and v.Team ~= player.Team and v.Team ~= nil then
                addESPBox(char)
            end
        end)
    end
end

game.Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if espEnabled and newPlayer.Team ~= player.Team and newPlayer.Team ~= nil then
            addESPBox(char)
        end
    end)
end)

local aimEnabled = false
local target = nil
local locked = false

mouse.Button2Down:Connect(function()
    if aimEnabled then
        local closest = nil
        local shortestDist = math.huge
        local mousePos = mouse.Hit.Position

        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") and enemy.Team ~= player.Team and enemy.Team ~= nil then
                local head = enemy.Character.Head
                local dist = (head.Position - mousePos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = head
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

local toggleInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
local espSlideOn = tweenService:Create(espToggle, toggleInfo, {Position = UDim2.new(0.5, -115, 0, 70)})
local espSlideOff = tweenService:Create(espToggle, toggleInfo, {Position = UDim2.new(0.5, -125, 0, 70)})
local aimSlideOn = tweenService:Create(aimToggle, toggleInfo, {Position = UDim2.new(0.5, -115, 0, 140)})
local aimSlideOff = tweenService:Create(aimToggle, toggleInfo, {Position = UDim2.new(0.5, -125, 0, 140)})

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
