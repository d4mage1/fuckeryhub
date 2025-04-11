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
print("Version: 1.3.2 - Main Hub")
print(" ")

-- Load Rayfield UI Library
local Rayfield
local rayfieldUrl = "https://sirius.menu/rayfield" -- Updated URL, might work in April 2025
local rayfieldFallbackUrl = "https://raw.githubusercontent.com/Rayfield-UI/Rayfield/main/source" 
local rawScript

local success, err = pcall(function()
    rawScript = game:HttpGet(rayfieldUrl)
end)
if not success then
    warn("Failed to load Rayfield from primary URL: " .. tostring(err))
    success, err = pcall(function()
        rawScript = game:HttpGet(rayfieldFallbackUrl)
    end)
    if not success then
        warn("Failed to load Rayfield from fallback URL: " .. tostring(err))
        rawScript = nil
    end
end

if rawScript then
    success, err = pcall(function()
        Rayfield = loadstring(rawScript) -- Don’t call it yet, just get the function
        if Rayfield then
            Rayfield = Rayfield() -- Now call it if it’s not nil
        end
    end)
    if not success or not Rayfield then
        warn("Failed to initialize Rayfield: " .. tostring(err))
        Rayfield = nil
    end
else
    warn("No Rayfield script loaded. UI will not be available.")
end

-- Create Main Hub Window (if Rayfield loaded)
local Window
if Rayfield then
    success, err = pcall(function()
        Window = Rayfield:CreateWindow({
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
    end)
    if not success or not Window then
        warn("Failed to create Rayfield window: " .. tostring(err))
        Window = nil
    end
else
    warn("Rayfield UI failed to load. You can still load scripts manually.")
end

-- Select Game Tab
if Window then
    local SelectGameTab = Window:CreateTab("Games")

    SelectGameTab:CreateButton({
        Name = "Load Arsenal Script",
        Callback = function()
            print("Loading Arsenal script...")
            local success, result = pcall(function()
                local scriptContent = game:HttpGet("https://raw.githubusercontent.com/d4mage1/fuckeryhub/refs/heads/main/arsenal_fuckery.lua")
                local loadedFunc = loadstring(scriptContent)
                if loadedFunc then
                    return loadedFunc()
                else
                    error("Failed to loadstring Arsenal script: scriptContent is invalid")
                end
            end)
            if success then
                print("Arsenal script loaded successfully!")
            else
                warn("Failed to load Arsenal script: " .. tostring(result))
            end
        end
    })
end

print("Fuckery Hub Main Menu loaded - Select a game to start!")
