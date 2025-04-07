Config = {}

-- Framework Settings
Config.Framework = "esx"    -- Options: "esx", "qbcore", "qbx", or "none"

-- Key Bindings
Config.OpenKey = 212       -- HOME key

-- Scoreboard Settings
Config.RefreshInterval = 5000  -- Update interval in ms
Config.ScoreboardTitle = "Player List"  -- Title displayed at the top of the scoreboard
Config.Position = "right"  -- Position of the scoreboard: "left", "center", or "right"
Config.LargeMode = false   -- Set to true for a larger, centered scoreboard (overrides Position setting)
Config.ShowJobs = true    -- Set to true to show job icons/counts, false to hide them

-- Jobs to display in large mode
Config.DisplayedJobs = {
    {
        name = "police",       -- Job name in database
        label = "Police",      -- Display name 
        icon = "👮",           -- Emoji icon
        color = "#4d88ff"      -- Text color (hex)
    },
    {
        name = "ambulance",
        label = "EMS",
        icon = "🚑",
        color = "#ff3366"
    },
    {
        name = "mechanic",
        label = "Mechanic",
        icon = "🔧",
        color = "#ffaa33"
    },
    {
        name = "cardealer",
        label = "Car Dealer",
        icon = "🚗",
        color = "#ffaa33"
    },

    -- Add more jobs as needed:

}

-- 3D ID Display Settings
Config.ShowPlayerIDs = true
Config.MaxDisplayDistance = 15.0
Config.MinTextSize = 0.4
Config.MaxTextSize = 0.7
Config.HeightOffsetBase = 1.0
Config.HeightOffsetFactor = 0.06  -- Extra height added per meter over 5m distance

-- Text Appearance
Config.TextFont = 4
Config.TextColor = {255, 255, 255, 255}  -- RGBA
Config.TextDropShadow = {0, 0, 0, 0, 255}
Config.TextEdge = {2, 0, 0, 0, 150} 
