print(" ")
print("=====================================")
print("     FUCKERY HUB LOADED - LET'S GO!  ")
print("=====================================")
print(" ")
print([[
yes
 ong
]])
print(" ")
print("Loaded by: d4mage1")
print("Version: 1.0 - Arsenal Edition")
print(" ")

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local teams = game:GetService("Teams")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local httpService = game:GetService("HttpService")

local gui = Instance.new("ScreenGui")
gui.Name = "FuckeryHub"
gui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 0, 0)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.5
mainStroke.Parent = mainFrame

local dragging
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

uis.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

local sidePanel = Instance.new("Frame")
sidePanel.Size = UDim2.new(0, 120, 1, 0)
sidePanel.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
sidePanel.BorderSizePixel = 0
sidePanel.BackgroundTransparency = 1
sidePanel.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 12)
sideCorner.Parent = sidePanel

local sideStroke = Instance.new("UIStroke")
sideStroke.Color = Color3.fromRGB(255, 0, 0)
sideStroke.Thickness = 2
sideStroke.Transparency = 0.5
sideStroke.Parent = sidePanel

local sidePanelList = Instance.new("UIListLayout")
sidePanelList.SortOrder = Enum.SortOrder.LayoutOrder
sidePanelList.Padding = UDim.new(0, 8)
sidePanelList.Parent = sidePanel

local combatTabButton = Instance.new("TextButton")
combatTabButton.Size = UDim2.new(1, -10, 0, 40)
combatTabButton.Position = UDim2.new(0, 5, 0, 5)
combatTabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
combatTabButton.Text = "Combat"
combatTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
combatTabButton.TextSize = 18
combatTabButton.Font = Enum.Font.GothamBold
combatTabButton.BackgroundTransparency = 1
combatTabButton.Parent = sidePanel

local combatCorner = Instance.new("UICorner")
combatCorner.CornerRadius = UDim.new(0, 8)
combatCorner.Parent = combatTabButton

local combatStroke = Instance.new("UIStroke")
combatStroke.Color = Color3.fromRGB(255, 0, 0)
combatStroke.Thickness = 1
combatStroke.Transparency = 0.7
combatStroke.Parent = combatTabButton

local visualsTabButton = Instance.new("TextButton")
visualsTabButton.Size = UDim2.new(1, -10, 0, 40)
visualsTabButton.Position = UDim2.new(0, 5, 0, 53)
visualsTabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
visualsTabButton.Text = "Visuals"
visualsTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
visualsTabButton.TextSize = 18
visualsTabButton.Font = Enum.Font.GothamBold
visualsTabButton.BackgroundTransparency = 1
visualsTabButton.Parent = sidePanel

local visualsCorner = Instance.new("UICorner")
visualsCorner.CornerRadius = UDim.new(0, 8)
visualsCorner.Parent = visualsTabButton

local visualsStroke = Instance.new("UIStroke")
visualsStroke.Color = Color3.fromRGB(255, 0, 0)
visualsStroke.Thickness = 1
visualsStroke.Transparency = 0.7
visualsStroke.Parent = visualsTabButton

local suggestTabButton = Instance.new("TextButton")
suggestTabButton.Size = UDim2.new(1, -10, 0, 40)
suggestTabButton.Position = UDim2.new(0, 5, 0, 101)
suggestTabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
suggestTabButton.Text = "Suggest"
suggestTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
suggestTabButton.TextSize = 18
suggestTabButton.Font = Enum.Font.GothamBold
suggestTabButton.BackgroundTransparency = 1
suggestTabButton.Parent = sidePanel

local suggestCorner = Instance.new("UICorner")
suggestCorner.CornerRadius = UDim.new(0, 8)
suggestCorner.Parent = suggestTabButton

local suggestStroke = Instance.new("UIStroke")
suggestStroke.Color = Color3.fromRGB(255, 0, 0)
suggestStroke.Thickness = 1
suggestStroke.Transparency = 0.7
suggestStroke.Parent = suggestTabButton

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 380, 1, 0)
contentFrame.Position = UDim2.new(0, 120, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
contentFrame.BorderSizePixel = 0
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentFrame

local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(255, 0, 0)
contentStroke.Thickness = 2
contentStroke.Transparency = 0.5
contentStroke.Parent = contentFrame

local combatTab = Instance.new("Frame")
combatTab.Size = UDim2.new(1, 0, 1, 0)
combatTab.BackgroundTransparency = 1
combatTab.Visible = true
combatTab.Parent = contentFrame

local combatList = Instance.new("UIListLayout")
combatList.SortOrder = Enum.SortOrder.LayoutOrder
combatList.Padding = UDim.new(0, 15)
combatList.Parent = combatTab

local combatPadding = Instance.new("UIPadding")
combatPadding.PaddingLeft = UDim.new(0, 20)
combatPadding.PaddingTop = UDim.new(0, 20)
combatPadding.Parent = combatTab

local aimbotFrame = Instance.new("Frame")
aimbotFrame.Size = UDim2.new(1, 0, 0, 30)
aimbotFrame.BackgroundTransparency = 1
aimbotFrame.Parent = combatTab

local aimbotLabel = Instance.new("TextLabel")
aimbotLabel.Size = UDim2.new(0, 200, 1, 0)
aimbotLabel.BackgroundTransparency = 1
aimbotLabel.Text = "Enable Aimbot"
aimbotLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
aimbotLabel.TextSize = 16
aimbotLabel.Font = Enum.Font.Gotham
aimbotLabel.TextXAlignment = Enum.TextXAlignment.Left
aimbotLabel.Parent = aimbotFrame

local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Size = UDim2.new(0, 50, 0, 25)
aimbotToggle.Position = UDim2.new(1, -70, 0.5, -12.5)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
aimbotToggle.Text = "OFF"
aimbotToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
aimbotToggle.TextSize = 14
aimbotToggle.Font = Enum.Font.Gotham
aimbotToggle.Parent = aimbotFrame

local aimbotCorner = Instance.new("UICorner")
aimbotCorner.CornerRadius = UDim.new(0, 8)
aimbotCorner.Parent = aimbotToggle

local aimbotStroke = Instance.new("UIStroke")
aimbotStroke.Color = Color3.fromRGB(255, 0, 0)
aimbotStroke.Thickness = 1
aimbotStroke.Transparency = 0.7
aimbotStroke.Parent = aimbotToggle

local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(1, 0, 0, 30)
fovFrame.BackgroundTransparency = 1
fovFrame.Parent = combatTab

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 200, 1, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV Size"
fovLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
fovLabel.TextSize = 16
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = fovFrame

local fovSlider = Instance.new("TextButton")
fovSlider.Size = UDim2.new(0, 150, 0, 8)
fovSlider.Position = UDim2.new(1, -160, 0.5, -4)
fovSlider.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
fovSlider.Text = ""
fovSlider.Parent = fovFrame

local fovSliderCorner = Instance.new("UICorner")
fovSliderCorner.CornerRadius = UDim.new(0, 4)
fovSliderCorner.Parent = fovSlider

local fovFill = Instance.new("Frame")
fovFill.Size = UDim2.new(0.5, 0, 1, 0)
fovFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fovFill.BorderSizePixel = 0
fovFill.Parent = fovSlider

local fovFillCorner = Instance.new("UICorner")
fovFillCorner.CornerRadius = UDim.new(0, 4)
fovFillCorner.Parent = fovFill

local fovValue = Instance.new("TextLabel")
fovValue.Size = UDim2.new(0, 50, 1, 0)
fovValue.Position = UDim2.new(1, -50, 0, 0)
fovValue.BackgroundTransparency = 1
fovValue.Text = "150"
fovValue.TextColor3 = Color3.fromRGB(220, 220, 220)
fovValue.TextSize = 16
fovValue.Font = Enum.Font.Gotham
fovValue.Parent = fovFrame

local visualsTab = Instance.new("Frame")
visualsTab.Size = UDim2.new(1, 0, 1, 0)
visualsTab.BackgroundTransparency = 1
visualsTab.Visible = false
visualsTab.Parent = contentFrame

local visualsList = Instance.new("UIListLayout")
visualsList.SortOrder = Enum.SortOrder.LayoutOrder
visualsList.Padding = UDim.new(0, 15)
visualsList.Parent = visualsTab

local visualsPadding = Instance.new("UIPadding")
visualsPadding.PaddingLeft = UDim.new(0, 20)
visualsPadding.PaddingTop = UDim.new(0, 20)
visualsPadding.Parent = visualsTab

local espFrame = Instance.new("Frame")
espFrame.Size = UDim2.new(1, 0, 0, 30)
espFrame.BackgroundTransparency = 1
espFrame.Parent = visualsTab

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0, 200, 1, 0)
espLabel.BackgroundTransparency = 1
espLabel.Text = "Enable ESP"
espLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
espLabel.TextSize = 16
espLabel.Font = Enum.Font.Gotham
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.Parent = espFrame

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 50, 0, 25)
espToggle.Position = UDim2.new(1, -70, 0.5, -12.5)
espToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
espToggle.Text = "OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
espToggle.TextSize = 14
espToggle.Font = Enum.Font.Gotham
espToggle.Parent = espFrame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 8)
espCorner.Parent = espToggle

local espStroke = Instance.new("UIStroke")
espStroke.Color = Color3.fromRGB(255, 0, 0)
espStroke.Thickness = 1
espStroke.Transparency = 0.7
espStroke.Parent = espToggle

local suggestTab = Instance.new("Frame")
suggestTab.Size = UDim2.new(1, 0, 1, 0)
suggestTab.BackgroundTransparency = 1
suggestTab.Visible = false
suggestTab.Parent = contentFrame

local suggestList = Instance.new("UIListLayout")
suggestList.SortOrder = Enum.SortOrder.LayoutOrder
suggestList.Padding = UDim.new(0, 15)
suggestList.Parent = suggestTab

local suggestPadding = Instance.new("UIPadding")
suggestPadding.PaddingLeft = UDim.new(0, 20)
suggestPadding.PaddingTop = UDim.new(0, 20)
suggestPadding.Parent = suggestTab

local suggestBox = Instance.new("TextBox")
suggestBox.Size = UDim2.new(1, -40, 0, 100)
suggestBox.Position = UDim2.new(0, 0, 0, 0)
suggestBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
suggestBox.TextColor3 = Color3.fromRGB(220, 220, 220)
suggestBox.TextSize = 16
suggestBox.Font = Enum.Font.Gotham
suggestBox.PlaceholderText = "Type your suggestion here..."
suggestBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
suggestBox.TextWrapped = true
suggestBox.TextXAlignment = Enum.TextXAlignment.Left
suggestBox.TextYAlignment = Enum.TextYAlignment.Top
suggestBox.Parent = suggestTab

local suggestBoxCorner = Instance.new("UICorner")
suggestBoxCorner.CornerRadius = UDim.new(0, 8)
suggestBoxCorner.Parent = suggestBox

local suggestBoxStroke = Instance.new("UIStroke")
suggestBoxStroke.Color = Color3.fromRGB(255, 0, 0)
suggestBoxStroke.Thickness = 1
suggestBoxStroke.Transparency = 0.7
suggestBoxStroke.Parent = suggestBox

local usernameLabel = Instance.new("TextLabel")
usernameLabel.Size = UDim2.new(0, 200, 0, 20)
usernameLabel.Position = UDim2.new(1, -220, 0, 5)
usernameLabel.BackgroundTransparency = 1
usernameLabel.Text = "User: " .. player.Name
usernameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
usernameLabel.TextSize = 14
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextXAlignment = Enum.TextXAlignment.Right
usernameLabel.Parent = suggestTab

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 80, 0, 30)
sendButton.Position = UDim2.new(0.5, -40, 0, 120)
sendButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
sendButton.Text = "Send!"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextSize = 16
sendButton.Font = Enum.Font.GothamBold
sendButton.Parent = suggestTab

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 8)
sendCorner.Parent = sendButton

local sendStroke = Instance.new("UIStroke")
sendStroke.Color = Color3.fromRGB(255, 255, 255)
sendStroke.Thickness = 1
sendStroke.Transparency = 0.5
sendStroke.Parent = sendButton

local fadeInInfo = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local mainFadeIn = tweenService:Create(mainFrame, fadeInInfo, {BackgroundTransparency = 0})
local sideFadeIn = tweenService:Create(sidePanel, fadeInInfo, {BackgroundTransparency = 0})
local contentFadeIn = tweenService:Create(contentFrame, fadeInInfo, {BackgroundTransparency = 0})
local combatFadeIn = tweenService:Create(combatTab, fadeInInfo, {BackgroundTransparency = 0})
local visualsFadeIn = tweenService:Create(visualsTab, fadeInInfo, {BackgroundTransparency = 0})
local suggestFadeIn = tweenService:Create(suggestTab, fadeInInfo, {BackgroundTransparency = 0})

mainFadeIn:Play()
sideFadeIn:Play()
contentFadeIn:Play()
combatFadeIn:Play()
visualsFadeIn:Play()
suggestFadeIn:Play()

combatTabButton.MouseButton1Click:Connect(function()
    combatTab.Visible = true
    visualsTab.Visible = false
    suggestTab.Visible = false
    combatTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    combatTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    combatStroke.Transparency = 0
    visualsTabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    visualsTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    visualsStroke.Transparency = 0.7
    suggestTabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    suggestTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    suggestStroke.Transparency = 0.7
end)

visualsTabButton.MouseButton1Click:Connect(function()
    combatTab.Visible = false
    visualsTab.Visible = true
    suggestTab.Visible = false
    combatTabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    combatTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    combatStroke.Transparency = 0.7
    visualsTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    visualsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualsStroke.Transparency = 0
    suggestTabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    suggestTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    suggestStroke.Transparency = 0.7
end)

suggestTabButton.MouseButton1Click:Connect(function()
    combatTab.Visible = false
    visualsTab.Visible = false
    suggestTab.Visible = true
    combatTabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    combatTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    combatStroke.Transparency = 0.7
    visualsTabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    visualsTabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    visualsStroke.Transparency = 0.7
    suggestTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    suggestTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    suggestStroke.Transparency = 0
end)

local fovSize = 150
local draggingSlider = false

fovSlider.MouseButton1Down:Connect(function()
    draggingSlider = true
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

uis.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = uis:GetMouseLocation()
        local sliderPos = fovSlider.AbsolutePosition
        local sliderSize = fovSlider.AbsoluteSize
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        fovSize = 50 + (relativeX * 300)
        fovFill.Size = UDim2.new(relativeX, 0, 1, 0)
        fovValue.Text = math.floor(fovSize)
    end
end)

local espEnabled = false
local espBoxes = {}

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

local aimEnabled = false
local target = nil
local locked = false
local lastLookVector = camera.CFrame.LookVector

mouse.Button2Down:Connect(function()
    if aimEnabled then
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

espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggle.Text = espEnabled and "ON" or "OFF"
    espToggle.TextColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    updateESP()
end)

aimbotToggle.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimbotToggle.Text = aimEnabled and "ON" or "OFF"
    aimbotToggle.TextColor3 = aimEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

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

sendButton.MouseButton1Click:Connect(function()
    local currentTime = tick()
    if currentTime - lastSubmit < cooldown then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Cooldown",
            Text = "Wait " .. math.ceil(cooldown - (currentTime - lastSubmit)) .. " seconds.",
            Duration = 3
        })
        return
    end

    local suggestion = suggestBox.Text
    if suggestion == "" then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Suggestion cannot be empty.",
            Duration = 3
        })
        return
    end

    if containsBlockedWords(suggestion) then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Suggestion contains blocked words.",
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
        game.StarterGui:SetCore("SendNotification", {
            Title = "Success",
            Text = "Suggestion sent successfully!",
            Duration = 3
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "Failed to send suggestion: " .. tostring(err),
            Duration = 5
        })
    end
end)

print("This script is licensed under the GNU General Public License v3.0 Copyright (C) 2025 d4mage1 You can use, modify, and share this script as long as you keep it open-source and give credit.")
