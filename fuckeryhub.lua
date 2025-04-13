print("=====================================")
print("     FUCKERY HUB - MAIN MENU LOADED  ")
print("=====================================")
print([[ 
                  _         _                  _ _  _                             __ 
                 | |       | |                | | || |                           /_ |
  _ __ ___   __ _  __| | ___   | |__  _   _     __| | || |_ _ __ ___   __ _  __ _  ___| |
 | '_ ` _ \ / _` |/ _` |/ _ \  | '_ \| | | |   / _` |__   _| '_ ` _ \ / _` |/ _` |/ _ \ |
 | | | | | | (_| | (_| |  __/  | |_) | |_| |  | (_| |  | | | | | | | | (_| | (_| |  __/ |
 |_| |_| |_|__,_|__,_|_|___|  |_.__/ |__, |   |__,_|  |_| |_| |_| |_|__,_|__,_|_|___|_|
                                      __/ |                                 __/ |       
                                     |___/                                 |___/        
]])
print("Loaded by: d4mage1")
print("Version: 1.3.3 - Main Hub")
print(" ")

-- Load Rayfield UI Library (once for all scripts)
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusMenu/Rayfield/main/source"))()
end)
if not success or not Rayfield then
    warn("Failed to load Rayfield: " .. tostring(err))
    return
end
print("Rayfield loaded successfully!")

-- Create Main Hub Window
local Window = Rayfield:CreateWindow({
    Name = "Fuckery Hub - Main Menu",
    LoadingTitle = "Fuckery Hub",
    LoadingSubtitle = "by d4mage1",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FuckeryHub",
        FileName = "MainConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "mAFyAPnVA4",
        RememberJoins = true
    },
    KeySystem = false
})

-- Select Game Tab
local SelectGameTab = Window:CreateTab("Games")
SelectGameTab:CreateSection("Load Game Scripts")

SelectGameTab:CreateButton({
    Name = "Load Arsenal Script",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/d4mage1/fuckeryhub/refs/heads/main/arsenal_fuckery.lua"))()
        end)
        if success then
            print("Arsenal script loaded successfully!")
        else
            warn("Failed to load Arsenal script: " .. tostring(result))
        end
    end
})

SelectGameTab:CreateButton({
    Name = "Load Rivals Script",
    Callback = function()
        local success, result = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/d4mage1/fuckeryhub/refs/heads/main/rivals_fuckery.lua"))()
        end)
        if success then
            print("Rivals script loaded successfully!")
        else
            warn("Failed to load Rivals script: " .. tostring(result))
        end
    end
})

print("Fuckery Hub Main Menu loaded - Select a game to start")
