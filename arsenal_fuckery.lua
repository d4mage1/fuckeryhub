print(" ")
print("=====================================")
print("     FUCKERY HUB LOADED - LET'S GO!  ")
print("=====================================")
print(" ")
print([[
     _____ ______   ________  ________  _______           ________      ___    ___      ________  ___   ___  _____ ______   ________  ________  _______      
|\   _ \  _   \|\   __  \|\   ___ \|\  ___ \         |\   __  \    |\  \  /  /|    |\   ___ \|\  \ |\  \|\   _ \  _   \|\   __  \|\   ____\|\  ___ \     
\ \  \\\__\ \  \ \  \|\  \ \  \_|\ \ \   __/|        \ \  \|\ /_   \ \  \/  / /    \ \  \_|\ \ \  \\_\  \ \  \\\__\ \  \ \  \|\  \ \  \___|\ \   __/|    
 \ \  \\|__| \  \ \   __  \ \  \ \\ \ \  \_|/__       \ \   __  \   \ \    / /      \ \  \ \\ \ \______  \ \  \\|__| \  \ \   __  \ \  \  __\ \  \_|/__  
  \ \  \    \ \  \ \  \ \  \ \  \_\\ \ \  \_|\ \       \ \  \|\  \   \/  /  /        \ \  \_\\ \|_____|\  \ \  \    \ \  \ \  \ \  \ \  \|\  \ \  \_|\ \ 
   \ \__\    \ \__\ \__\ \__\ \_______\ \_______\       \ \_______\__/  / /           \ \_______\     \ \__\ \__\    \ \__\ \__\ \__\ \_______\ \_______\
    \|__|     \|__|\|__|\|__|\|_______|\|_______|        \|_______|\___/ /             \|_______|      \|__|\|__|     \|__|\|__|\|__|\|_______|\|_______|
                                                                  \|___|/                                                                                                                                                                                                                                       
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

local gui = Instance.new("ScreenGui")
gui.Name = "FuckeryHub"
gui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = gui


local sidePanel = Instance.new("Frame")
sidePanel.Size = UDim2.new(0, 150, 1, 0)
sidePanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
sidePanel.BorderSizePixel = 0
sidePanel.BackgroundTransparency = 1
sidePanel.Parent = mainFrame

local sidePanelList = Instance.new("UIListLayout")
sidePanelList.SortOrder = Enum.SortOrder.LayoutOrder
sidePanelList.Padding = UDim.new(0, 5)
sidePanelList.Parent = sidePanel


local combatTabButton = Instance.new("TextButton")
combatTabButton.Size = UDim2.new(1, 0, 0, 40)
combatTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
combatTabButton.Text = "Combat"
combatTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
combatTabButton.TextSize = 16
combatTabButton.Font = Enum.Font.SourceSansBold
combatTabButton.BackgroundTransparency = 1
combatTabButton.Parent = sidePanel

local visualsTabButton = Instance.new("TextButton")
visualsTabButton.Size = UDim2.new(1, 0, 0, 40)
visualsTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
visualsTabButton.Text = "Visuals"
visualsTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
visualsTabButton.TextSize = 16
visualsTabButton.Font = Enum.Font.SourceSansBold
visualsTabButton.BackgroundTransparency = 1
visualsTabButton.Parent = sidePanel


local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 450, 1, 0)
contentFrame.Position = UDim2.new(0, 150, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
contentFrame.BorderSizePixel = 0
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame


local combatTab = Instance.new("Frame")
combatTab.Size = UDim2.new(1, 0, 1, 0)
combatTab.BackgroundTransparency = 1
combatTab.Visible = true
combatTab.Parent = contentFrame

local combatList = Instance.new("UIListLayout")
combatList.SortOrder = Enum.SortOrder.LayoutOrder
combatList.Padding = UDim.new(0, 10)
combatList.Parent = combatTab


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
aimbotToggle.Size = UDim2.new(0, 40, 0, 20)
aimbotToggle.Position = UDim2.new(1, -50, 0.5, -10)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
aimbotToggle.Text = "OFF"
aimbotToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
aimbotToggle.TextSize = 14
aimbotToggle.Font = Enum.Font.SourceSans
aimbotToggle.Parent = aimbotFrame


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
fovSlider.Size = UDim2.new(0, 150, 0, 10)
fovSlider.Position = UDim2.new(1, -160, 0.5, -5)
fovSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
fovSlider.Text = ""
fovSlider.Parent = fovFrame

local fovFill = Instance.new("Frame")
fovFill.Size = UDim2.new(0.5, 0, 1, 0)
fovFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fovFill.BorderSizePixel = 0
fovFill.Parent = fovSlider

local fovValue = Instance.new("TextLabel")
fovValue.Size = UDim2.new(0, 50, 1, 0)
fovValue.Position = UDim2.new(1, -50, 0, 0)
fovValue.BackgroundTransparency = 1
fovValue.Text = "150"
fovValue.TextColor3 = Color3.fromRGB(200, 200, 200)
fovValue.TextSize = 16
fovValue.Font = Enum.Font.SourceSans
fovValue.Parent = fovFrame


local visualsTab = Instance.new("Frame")
visualsTab.Size = UDim2.new(1, 0, 1, 0)
visualsTab.BackgroundTransparency = 1
visualsTab.Visible = false
visualsTab.Parent = contentFrame

local visualsList = Instance.new("UIListLayout")
visualsList.SortOrder = Enum.SortOrder.LayoutOrder
visualsList.Padding = UDim.new(0, 10)
visualsList.Parent = visualsTab


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
espToggle.Size = UDim2.new(0, 40, 0, 20)
espToggle.Position = UDim2.new(1, -50, 0.5, -10)
espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
espToggle.Text = "OFF"
espToggle.TextColor3 = Color3.fromRGB(255, 0, 0)
espToggle.TextSize = 14
espToggle.Font = Enum.Font.SourceSans
espToggle.Parent = espFrame


local fadeInInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local mainFadeIn = tweenService:Create(mainFrame, fadeInInfo, {BackgroundTransparency = 0})
local sideFadeIn = tweenService:Create(sidePanel, fadeInInfo, {BackgroundTransparency = 0})
local contentFadeIn = tweenService:Create(contentFrame, fadeInInfo, {BackgroundTransparency = 0})
local combatFadeIn = tweenService:Create(combatTab, fadeInInfo, {BackgroundTransparency = 0})
local visualsFadeIn = tweenService:Create(visualsTab, fadeInInfo, {BackgroundTransparency = 0})

mainFadeIn:Play()
sideFadeIn:Play()
contentFadeIn:Play()
combatFadeIn:Play()
visualsFadeIn:Play()


combatTabButton.MouseButton1Click:Connect(function()
    combatTab.Visible = true
    visualsTab.Visible = false
    combatTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    visualsTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
end)

visualsTabButton.MouseButton1Click:Connect(function()
    combatTab.Visible = false
    visualsTab.Visible = true
    combatTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    visualsTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
end)


local fovSize = 150
local dragging = false

fovSlider.MouseButton1Down:Connect(function()
    dragging = true
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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
local espLabels = {}

local function addESP(target)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = target:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = target

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = target.Parent.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = billboard

    table.insert(espLabels, billboard)
end

local function clearESP()
    for _, label in pairs(espLabels) do
        label:Destroy()
    end
    espLabels = {}
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
                    addESP(char)
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
                addESP(char)
            end
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
        local humanoid = target.Parent:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            locked = false
            target = nil
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + camera.CFrame.LookVector * 10)
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
