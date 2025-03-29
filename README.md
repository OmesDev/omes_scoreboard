# OMES Scoreboard

A modern, feature-rich player scoreboard for FiveM servers. Compatible with both ESX and QBCore frameworks.

## Features

- Clean, modern UI with customizable position and size
- Support for ESX and QBCore frameworks
- Display of job counts for emergency services and other configured jobs
- Job icons next to player names
- Player ID display in 3D above characters
- Configurable refresh rate
- Scrollable player list
- Ping display with color-coding

## Installation

1. Extract the `omes_scoreboard` folder to your server's resources directory
2. Add `ensure omes_scoreboard` to your server.cfg
3. Edit the config.lua file to match your server's requirements

## Configuration

### Basic Setup
- Set your preferred framework in `config.lua`:
  ```lua
  Config.Framework = "esx"  -- Options: "esx", "qbcore", or "none"
  ```

### Job Customization
Configure which jobs appear in the scoreboard under `Config.DisplayedJobs`:

```lua
Config.DisplayedJobs = {
    {
        name = "police",      -- Job name in database
        label = "Police",     -- Display name 
        icon = "👮",          -- Emoji icon
        color = "#4d88ff"     -- Text color (hex)
    },
    -- Add more jobs as needed
}
```

### Additional Options
- `Config.LargeMode` - Toggle between compact side view and large centered view
- `Config.ShowJobs` - Toggle display of job information
- `Config.ShowPlayerIDs` - Toggle 3D player ID display
- `Config.Position` - Set position when not in large mode ("left", "center", or "right")

## Controls
- Use the HOME key to toggle the scoreboard (configurable in settings)
- Arrow keys to scroll through the player list
- HOME key to close the scoreboard

## License
This resource is licensed under MIT license.

## Support
For issues, feature requests, or support, please open an issue on the GitHub repository. 