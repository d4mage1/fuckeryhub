local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "FuckeryHub"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
title.Text = "Fuckery Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.Code
title.Parent = frame

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 200, 0, 50)
espToggle.Position = UDim2.new(0.5, -100, 0, 60)
espToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espToggle.Text = "ESP: OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
espToggle.TextSize = 18
espToggle.Font = Enum.Font.Code
espToggle.Parent = frame

local aimToggle = Instance.new("TextButton")
aimToggle.Size = UDim2.new(0, 200, 0, 50)
aimToggle.Position = UDim2.new(0.5, -100, 0, 120)
aimToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
aimToggle.Text = "AIMBOT: OFF"
aimToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
aimToggle.TextSize = 18
aimToggle.Font = Enum.Font.Code
aimToggle.Parent = frame

local espEnabled = false
local highlights = {}

local function addESP(target)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.Adornee = target
    highlight.Parent = target
    table.insert(highlights, highlight)
end

local function clearESP()
    for _, highlight in pairs(highlights) do
        highlight:Destroy()
    end
    highlights = {}
end

local function updateESP()
    if espEnabled then
        clearESP()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character then
                addESP(v.Character)
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
                addESP(char)
            end
        end)
    end
end

game.Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if espEnabled then
            addESP(char)
        end
    end)
end)

local aimEnabled = false
local target = nil
local locked = false

mouse.Button2Down:Connect(function()
    if aimEnabled and not locked then
        local closest = nil
        local shortestDist = math.huge
        local mousePos = mouse.Hit.Position

        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") then
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
    else
        locked = false
        target = nil
    end
end)

runService.RenderStepped:Connect(function()
    if aimEnabled and locked and target and target.Parent then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
    end
end)

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espToggle.TextColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    updateESP()
end)

aimToggle.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimToggle.Text = "AIMBOT: " .. (aimEnabled and "ON" or "OFF")
    aimToggle.TextColor3 = aimEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
