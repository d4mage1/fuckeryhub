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
 |_| |_| |_|__,_|__,_|_|___|  |_.__/ \__, |   \__,_|  |_| |_| |_| |_|__,_|__,_|_|___|_|
                                       __/ |                                 __/ |       
                                      |___/                                 |___/        
]])
print(" ")
print("Loaded by: d4mage1")
print("Version: 1.3.3 - Main Hub")
print(" ")

-- Load Rayfield UI Library
local Rayfield
local rayfieldUrl = "https://raw.githubusercontent.com/UI-Libraries/Rayfield/main/source" -- Updated primary URL for 2025
local rayfieldFallbackUrl = "https://raw.githubusercontent.com/shlexware/Rayfield/main/source" -- Updated fallback URL
local rawScript

-- Try primary URL
local success, err = pcall(function()
    print("Attempting to fetch Rayfield from primary URL: " .. rayfieldUrl)
    rawScript = game:HttpGet(rayfieldUrl)
    print("Primary URL fetch successful, rawScript length: " .. (rawScript and #rawScript or "nil"))
end)
if not success then
    warn("Failed to load Rayfield from primary URL: " .. tostring(err))
    -- Try fallback URL
    success, err = pcall(function()
        print("Attempting to fetch Rayfield from fallback URL: " .. rayfieldFallbackUrl)
        rawScript = game:HttpGet(rayfieldFallbackUrl)
        print("Fallback URL fetch successful, rawScript length: " .. (rawScript and #rawScript or "nil"))
    end)
    if not success then
        warn("Failed to load Rayfield from fallback URL: " .. tostring(err))
        rawScript = nil
    end
end

-- Load Rayfield if rawScript exists
if rawScript then
    success, err = pcall(function()
        print("Attempting to loadstring Rayfield script...")
        Rayfield = loadstring(rawScript) -- Get the function
        if Rayfield then
            print("Rayfield loadstring successful, initializing Rayfield...")
            Rayfield = Rayfield() -- Call it to initialize
            print("Rayfield initialized successfully!")
        else
            error("loadstring returned nil, Rayfield script is invalid")
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
        print("Creating Rayfield window...")
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
        print("Rayfield window created successfully!")
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

    SelectGameTab:CreateButton({
        Name = "Load Rivals Script",
        Callback = function()
            print("Loading Rivals script...")
            local success, result = pcall(function()
                local scriptContent = game:HttpGet("https://raw.githubusercontent.com/d4mage1/fuckeryhub/refs/heads/main/rivials_fuckery.lua")
                local loadedFunc = loadstring(scriptContent)
                if loadedFunc then
                    return loadedFunc()
                else
                    error("Failed to loadstring Rivals script: scriptContent is invalid")
                end
            end)
            if success then
                print("Rivals script loaded successfully!")
            else
                warn("Failed to load Rivals script: " .. tostring(result))
            end
        end
    })
end

print("Fuckery Hub Main Menu loaded - Select a game to start!")
