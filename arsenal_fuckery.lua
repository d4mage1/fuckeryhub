-- Load Confirmation with ASCII Art
print(" ")
print("=====================================")
print("     FUCKERY HUB LOADED - LET'S GO!  ")
print("=====================================")
print(" ")
print([[
 _  _   __   ____  ____    ____  _  _    ____   ___  _  _   __    ___  ____ 
( \/ ) / _\ (    \(  __)  (  _ \( \/ )  (    \ / _ \( \/ ) / _\  / __)(  __)
/ \/ \/    \ ) D ( ) _)    ) _ ( )  /    ) D ((__  (/ \/ \/    \( (_ \ ) _) 
\_)(_/\_/\_/(____/(____)  (____/(__/    (____/  (__/\_)(_/\_/\_/ \___/(____)
]])
print(" ")
print("Loaded by: d4mage")
print("Version: 1.0 - Arsenal Edition")
print(" ")

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")
local teams = game:GetService("Teams")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

-- GUI Setup (ZYHPERION Style)
local gui = Instance.new("ScreenGui")
gui.Name = "FuckeryHub"
gui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Make GUI Draggable
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

-- Side Panel (Tabs)
local sidePanel = Instance.new("Frame")
sidePanel.Size = UDim2.new(0, 120, 1, 0)
sidePanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
sidePanel.BorderSizePixel = 0
sidePanel.BackgroundTransparency = 1
sidePanel.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 8)
sideCorner.Parent = sidePanel

local sidePanelList = Instance.new("UIListLayout")
sidePanelList.SortOrder = Enum.SortOrder.LayoutOrder
sidePanelList.Padding = UDim.new(0, 5)
sidePanelList.Parent = sidePanel

-- Tab Buttons
local combatTabButton = Instance.new("TextButton")
combatTabButton.Size = UDim2.new(1, -10, 0, 40)
combatTabButton.Position = UDim2.new(0, 5, 0, 5)
combatTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
combatTabButton.Text = "Combat"
combatTabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
combatTabButton.TextSize = 16
combatTabButton.Font = Enum.Font.SourceSansBold
combatTabButton.BackgroundTransparency = 1
combatTabButton.Parent = sidePanel

local combatCorner = Instance.new("UICorner")
combatCorner.CornerRadius = UDim.new(0, 6)
combatCorner.Parent = combatTabButton

local visualsTabButton = Instance.new("TextButton")
visualsTabButton.Size = UDim2.new(1, -10, 0, 40)
visualsTabButton.Position = UDim2.new(0, 5, 0, 50)
visualsTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
visualsTabButton.Text = "Visuals"
visualsTabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
visualsTabButton.TextSize = 16
visualsTabButton.Font = Enum.Font.SourceSansBold
visualsTabButton.BackgroundTransparency = 1
visualsTabButton.Parent = sidePanel

local visualsCorner = Instance.new("UICorner")
visualsCorner.CornerRadius = UDim.new(0, 6)
visualsCorner.Parent = visualsTabButton

local suggestTabButton = Instance.new("TextButton")
suggestTabButton.Size = UDim2.new(1, -10, 0, 40)
suggestTabButton.Position = UDim2.new(0, 5, 0, 95)
suggestTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
suggestTabButton.Text = "Suggest"
suggestTabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
suggestTabButton.TextSize = 16
suggestTabButton.Font = Enum.Font.SourceSansBold
suggestTabButton.BackgroundTransparency = 1
suggestTabButton.Parent = sidePanel

local suggestCorner = Instance.new("UICorner")
suggestCorner.CornerRadius = UDim.new(0, 6)
suggestCorner.Parent = suggestTabButton

-- Content Area
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 380, 1, 0)
contentFrame.Position = UDim2.new(0, 120, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
contentFrame.BorderSizePixel = 0
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

-- Combat Tab Content
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
combatPadding.PaddingLeft = UDim.new(0, 15)
combatPadding.PaddingTop = UDim.new(0, 15)
combatPadding.Parent = combatTab

-- Aimbot Toggle
local aimbotFrame = Instance.new("Frame")
aimbotFrame.Size = UDim2.new(1, 0, 0, 30)
aimbotFrame.BackgroundTransparency = 1
aimbotFrame.Parent = combatTab

local aimbotLabel = Instance.new("TextLabel")
aimbotLabel.Size = UDim2.new(0, 200, 1, 0)
aimbotLabel.BackgroundTransparency = 1
aimbotLabel.Text = "Enable Aimbot"
aimbotLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
aimbotLabel.TextSize = 16
aimbotLabel.Font = Enum.Font.SourceSans
aimbotLabel.TextXAlignment = Enum.TextXAlignment.Left
aimbotLabel.Parent = aimbotFrame

local aimbotToggle = Instance.new("TextButton")
aimbotToggle.Size = UDim2.new(0, 50, 0, 25)
aimbotToggle.Position = UDim2.new(1, -60, 0.5, -12.5)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
aimbotToggle.Text = "OFF"
aimbotToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
aimbotToggle.TextSize = 14
aimbotToggle.Font = Enum.Font.SourceSans
aimbotToggle.Parent = aimbotFrame

local aimbotCorner = Instance.new("UICorner")
aimbotCorner.CornerRadius = UDim.new(0, 6)
aimbotCorner.Parent = aimbotToggle

-- FOV Slider
local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(1, 0, 0, 30)
fovFrame.BackgroundTransparency = 1
fovFrame.Parent = combatTab

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 200, 1, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV Size"
fovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fovLabel.TextSize = 16
fovLabel.Font = Enum.Font.SourceSans
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = fovFrame

local fovSlider = Instance.new("TextButton")
fovSlider.Size = UDim2.new(0, 150, 0, 8)
fovSlider.Position = UDim2.new(1, -160, 0.5, -4)
fovSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
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
fovValue.TextColor3 = Color3.fromRGB(200, 200, 200)
fovValue.TextSize = 16
fovValue.Font = Enum.Font.SourceSans
fovValue.Parent = fovFrame

-- Visuals Tab Content
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
visualsPadding.PaddingLeft = UDim.new(0, 15)
visualsPadding.PaddingTop = UDim.new(0, 15)
visualsPadding.Parent = visualsTab

-- ESP Toggle
local espFrame = Instance.new("Frame")
espFrame.Size = UDim2.new(1, 0, 0, 30)
espFrame.BackgroundTransparency = 1
espFrame.Parent = visualsTab

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0, 200, 1, 0)
espLabel.BackgroundTransparency = 1
espLabel.Text = "Enable ESP"
espLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
espLabel.TextSize = 16
espLabel.Font = Enum.Font.SourceSans
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.Parent = espFrame

local espToggle = Instance.new("TextButton")
espToggle.Size = UDim2.new(0, 50, 0, 25)
espToggle.Position = UDim2.new(1, -60, 0.5, -12.5)
espToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
espToggle.Text = "OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
espToggle.TextSize = 14
espToggle.Font = Enum.Font.SourceSans
espToggle.Parent = espFrame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 6)
espCorner.Parent = espToggle

-- Suggest Tab Content
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
suggestPadding.PaddingLeft = UDim.new(0, 15)
suggestPadding.PaddingTop = UDim.new(0, 15)
suggestPadding.Parent = suggestTab

-- Textbox for suggestion
local suggestBox = Instance.new("TextBox")
suggestBox.Size = UDim2.new(1, -30, 0, 100)
suggestBox.Position = UDim2.new(0, 0, 0, 0)
suggestBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
suggestBox.TextColor3 = Color3.fromRGB(200, 200, 200)
suggestBox.TextSize = 16
suggestBox.Font = Enum.Font.SourceSans
suggestBox.PlaceholderText = "Type your suggestion here..."
suggestBox.TextWrapped = true
suggestBox.TextXAlignment = Enum.TextXAlignment.Left
suggestBox.TextYAlignment = Enum.TextYAlignment.Top
suggestBox.Parent = suggestTab

local suggestBoxCorner = Instance.new("UICorner")
suggestBoxCorner.CornerRadius = UDim.new(0, 6)
suggestBoxCorner.Parent = suggestBox

-- Submit Button
local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0, 100, 0, 30)
submitButton.Position = UDim2.new(0.5, -50, 0, 120)
submitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
submitButton.Text = "Submit"
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 16
submitButton.Font = Enum.Font.SourceSansBold
submitButton.Parent = suggestTab

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 6)
submitCorner.Parent = submitButton

-- Animations
local fadeInInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
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

-- Tab Switching
combatTabButton.MouseButton1Click:Connect(function()
    combatTab.Visible = true
    visualsTab.Visible = false
    suggestTab.Visible = false
    combatTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    combatTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualsTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    visualsTabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    suggestTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    suggestTabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

visualsTabButton.MouseButton1Click:Connect(function()
    combatTab.Visible = false
    visualsTab.Visible = true
    suggestTab.Visible = false
    combatTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    combatTabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    visualsTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    visualsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    suggestTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    suggestTabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

suggestTabButton.MouseButton1Click:Connect(function()
    combatTab.Visible = false
    visualsTab.Visible = false
    suggestTab.Visible = true
    combatTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    combatTabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    visualsTabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    visualsTabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    suggestTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    suggestTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- FOV Slider Logic
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
        fovSize = 50 + (relativeX * 300) -- Range: 50 to 350
        fovFill.Size = UDim2.new(relativeX, 0, 1, 0)
        fovValue.Text = math.floor(fovSize)
    end
end)

-- ESP with SelectionBox (Box around enemies)
local espEnabled = false
local espBoxes = {}

local function addESP(target)
    local box = Instance.new("SelectionBox")
    box.Adornee = target
    box.LineThickness = 0.01
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.SurfaceColor3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.9
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
                    if dist < fovSize then -- Use FOV size
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
    -- Reset camera to prevent aiming down
    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + camera.CFrame.LookVector * 10)
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
        -- Check if target is dead
        local humanoid = target.Parent:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            locked = false
            target = nil
            -- Reset camera to prevent aiming down
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + camera.CFrame.LookVector * 10)
        end
    end
end)

-- Toggle Logic
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

-- Discord Webhook Suggestion Logic
local webhookUrl = "https://discord.com/api/webhooks/1360247235757084772/zP2eOCkVrnoGE2bB3fuEbJ2NtqmhknVkuPJ6jl5CQShZd3M3zl5QWtQG_yesTcxFZzfq" -- Replace with your webhook URL
local cooldown = 30
local lastSubmit = 0
local blockedWords = {"nigger", "slur", "@everyone", "@here","nigga","kys"}

local function containsBlockedWords(text)
    for _, word in pairs(blockedWords) do
        if string.find(string.lower(text), word) then
            return true
        end
    end
    return false
end

submitButton.MouseButton1Click:Connect(function()
    local currentTime = tick()
    if currentTime - lastSubmit < cooldown then
        print("Cooldown active. Wait " .. math.ceil(cooldown - (currentTime - lastSubmit)) .. " seconds.")
        return
    end

    local suggestion = suggestBox.Text
    if suggestion == "" then
        print("Suggestion cannot be empty.")
        return
    end

    if containsBlockedWords(suggestion) then
        print("Suggestion contains blocked words.")
        return
    end

    -- Send to Discord Webhook
    local data = {
        ["content"] = "New Suggestion from " .. player.Name .. ": " .. suggestion
    }
    local jsonData = game:GetService("HttpService"):JSONEncode(data)
    game:GetService("HttpService"):PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)

    lastSubmit = currentTime
    print("Suggestion sent!")
end)
