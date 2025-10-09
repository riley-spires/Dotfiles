local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

-- Set shell to powershell 7
config.default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe" }

-- Set font
config.font = wezterm.font("Monocraft Nerd Font")
config.font_size = 14

-- Hide tabs
config.enable_tab_bar = false

-- Show scroll bar
config.enable_scroll_bar = true

-- Set Framerate
config.max_fps = 240

-- Set keybinds
config.keys = {
    {
        key = 't',
        mods = 'CTRL',
        action = act.SpawnTab('CurrentPaneDomain')
    },
    {
        key = 'w',
        mods = 'CTRL',
        action = act.CloseCurrentTab{ confirm = false }
    }
}
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'CTRL',
        action = act.ActivateTab(i-1)
    })
end


return config
