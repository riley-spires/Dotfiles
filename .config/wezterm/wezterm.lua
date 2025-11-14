local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on('spawn-pane', function(window, pane)
    window:perform_action(
        act.SpawnTab('CurrentPaneDomain'),
        pane
    )
end)

local config = wezterm.config_builder()

-- Set font
config.font = wezterm.font("JetBrains Mono")
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
        action = act.EmitEvent('spawn-pane')
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
