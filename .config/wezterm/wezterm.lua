local wezterm = require 'wezterm'
local act     = wezterm.action
local config  = wezterm.config_builder()

if wezterm.target_triple ~= 'x86_64-pc-windows-msvc' then
    config.default_prog = { '/usr/bin/bash' }
    config.font = wezterm.font { family = 'JetBrainsMono Nerd Font Mono', weight = 'Bold' }
else
    config.font = wezterm.font { family = 'JetBrainsMono NFM Medium', weight = 'Bold' }
end

config.font_size = 14.5

config.line_height = 1.0
config.cell_width = 1.1

config.window_decorations = 'RESIZE'
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = true

config.color_scheme = 'Gruvbox Material (Gogh)'
config.colors = {
    tab_bar = {
        background = '#32302f',
        active_tab = {
            bg_color = '#45403d',
            fg_color = '#d4be98',
            intensity = 'Normal',
            underline = 'None',
            italic = false,
            strikethrough = false,
        },
        inactive_tab = {
            bg_color = '#282828',
            fg_color = '#d4be98',
        },
    },
    selection_bg = "#5a524c",
    copy_mode_active_highlight_bg = { Color = '#5a524c' },
    copy_mode_active_highlight_fg = { Color = '#e6d0aa' },
    copy_mode_inactive_highlight_bg = { Color = '#3a3735' },
    copy_mode_inactive_highlight_fg = { Color = '#d4be98' },
    quick_select_label_bg = { Color = '#5a524c' },
    quick_select_label_fg = { Color = '#e6d0aa' },
    quick_select_match_bg = { Color = '#3a3735' },
    quick_select_match_fg = { Color = '#d4be98' },
}

config.inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 1.0,
}

config.leader = { key = 'h', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    { key = "d", mods = "LEADER", action = act.CloseCurrentTab { confirm = true } },
    { key = 'c', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
    { key = 'r', mods = 'LEADER', action = act.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(
            function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
    }},
    { key = 't', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 's', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    { key = 'o', mods = 'CTRL', action = wezterm.action.SendString('\x1b[200~cdi\x1b[201~\r') },
    { key = 'u', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'a', mods = 'CTRL', action = act.SendString('\x1b[B') },
    { key = 'e', mods = 'CTRL', action = act.SendString('\x1b[A') },
    { key = 'd', mods = 'CTRL', action = act.ActivatePaneDirection 'Next' },
    { key = 's', mods = 'CTRL', action = act.Search { Regex = '(?i)' } },
    { key = 'w', mods = 'CTRL', action = act.TogglePaneZoomState },

    { key = 'h', mods = 'ALT', action = act.SendString('\x02') },
    { key = "a", mods = "ALT", action = act.ActivateTabRelative(1) },
    { key = "e", mods = "ALT", action = act.ActivateTabRelative(-1) },
    { key = 'i', mods = 'ALT', action = act.SendString('\x06') },
    { key = 'f', mods = 'ALT', action = act.SendString('\x01') },
    { key = 'o', mods = 'ALT', action = act.SendString('\x05') },
    { key = 'd', mods = 'ALT', action = act.SendString('\x1bb') },
    { key = 'c', mods = 'ALT', action = act.SendString('\x1bf') },
    { key = 'r', mods = 'ALT', action = act.ActivateCopyMode },
    { key = 't', mods = 'ALT', action = act.SendString('\x1b\x7f') },
    { key = 's', mods = 'ALT', action = act.SendString('\x1bd') },
}
config.key_tables = {
    copy_mode = {
        { key = 'f', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
        { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },

        { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
        { key = 'a', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveUp' },
        { key = 'i', mods = 'NONE', action = act.CopyMode 'MoveRight' },
        { key = 'k', mods = 'NONE', action = act.Multiple {
            act.CopyMode { SetSelectionMode = "Line" },
            act.CopyMode 'MoveToEndOfLineContent',
        }},
        { key = '.', mods = 'NONE', action = act.CopyMode{ MoveByPage = (-0.5) } },
        { key = ',', mods = 'NONE', action = act.CopyMode{ MoveByPage = (0.5) } },
        { key = 'l', mods = 'NONE', action = act.Multiple {
            act.CopyTo 'ClipboardAndPrimarySelection',
            act.ClearSelection,
            act.CopyMode 'ClearPattern',
            act.CopyMode 'Close',
        }},
        { key = 'd', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
        { key = 'c', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
        { key = 'n', mods = 'NONE', action = act.CopyMode { SetSelectionMode = "Cell" } },
        { key = 'g', mods = 'NONE', action = act.CopyMode 'Close' },
        { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Block' } },
        { key = 'Escape', mods = 'NONE', action =  act.Multiple {
            act.ClearSelection,
            act.CopyMode 'ClearPattern',
            act.CopyMode 'Close'
        }}},
    search_mode = {
        { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
        { key = 'r', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
        { key = 's', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
        { key = 'Enter', mods = 'NONE', action = act.Multiple {
            act.ClearSelection,
            act.CopyMode 'ClearPattern',
            act.ActivateCopyMode,
        }},
        { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
    }
}

wezterm.on("gui-startup",
           function(cmd)
               local tab, pane, window = wezterm.mux.spawn_window({
                   cwd = "~/",
               })
               tab:set_title("dev")

               -- local second_tab = window:spawn_tab({
               --     cwd = "/",
               -- })
               -- second_tab:set_title("/")

               window:tabs()[1]:activate()
           end)

return config
