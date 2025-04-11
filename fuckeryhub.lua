print(" ")
print("=====================================")
print("     FUCKERY HUB - MAIN MENU LOADED  ")
print("=====================================")
print(" ")
print([[
                      _         _                  _ _  _                             __ 
                     | |       | |                | | || |                           /_ |
  _ __ ___   __ _  __| | ___   | |__  _   _     __| | || |_ _ __ ___   __ _  __ _  ___| |
 | '_ ` _ \ / _` |/ _` |/ _ \  | '_ \| | | |   / _` |__   _| '_ ` _ \ / _` |/ _` |/ _ \ |
 | | | | | | (_| | (_| |  __/  | |_) | |_| |  | (_| |  | | | | | | | | (_| | (_| |  __/ |
 |_| |_| |_|\__,_|\__,_|\___|  |_.__/ \__, |   \__,_|  |_| |_| |_| |_|\__,_|\__, |\___|_|
                                       __/ |                                 __/ |       
                                      |___/                                 |___/        
]])
print(" ")
print("Loaded by: d4mage1")
print("Version: 1.2 - Main Hub")
print(" ")

-- Load Rayfield UI Library
local Rayfield
local rayfieldUrl = "https://sirius.menu/rayfield"
local success, rawScript = pcall(function()
    return game:HttpGet(rayfieldUrl)
end)
if not success then
    print("Failed to load Rayfield: " .. tostring(rawScript))
    return
end
Rayfield = loadstring(rawScript)()

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
    KeySystem = false
})

-- Select Game Tab
local SelectGameTab = Window:CreateTab("Select Game")

SelectGameTab:CreateButton({
    Name = "Load Arsenal Script",
    Callback = function()
        print("Loading Arsenal script...")
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/d4mage1/fuckeryhub/refs/heads/main/arsenal_fuckery.lua"))()
        end)
        if success then
            print("Arsenal script loaded successfully!")
        else
            print("Failed to load Arsenal script: " .. tostring(err))
        end
    end
})

print("Fuckery Hub Main Menu loaded - Select a game to start!")
