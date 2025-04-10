local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local teams = game:GetService("Teams")

-- GUI Setup
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
            if v ~= player and v.Character and v.Team ~= player.Team then
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
            if espEnabled and v.Team ~= player.Team then
                addESPBox(char)
            end
        end)
    end
end

game.Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if espEnabled and newPlayer.Team ~= player.Team then
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
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Head") and enemy.Team ~= player.Team then -- Enemies only
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

-- Toggle Logic
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
