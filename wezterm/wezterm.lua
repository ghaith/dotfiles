local wezterm = require'wezterm'
local act = wezterm.action

-- -- The filled in variant of the < symbol
-- local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

-- -- The filled in variant of the > symbol
-- local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

-- wezterm.on(
-- 	'format-tab-title',
-- 	function(tab, tabs, panes, config, hover, max_width)
-- 		local edge_background = '#0b0022'
--     local background = '#1b1032'
--     local foreground = '#808080'

--     if tab.is_active then
--       background = '#2b2042'
--       foreground = '#c0c0c0'
--     elseif hover then
--       background = '#3b3052'
--       foreground = '#909090'
--     end

--     local edge_foreground = background

--     -- ensure that the titles fit in the available space,
--     -- and that we have room for the edges.
--     local title = wezterm.truncate_right(tab.active_pane.title, max_width - 2)

--     return {
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_LEFT_ARROW },
--       { Background = { Color = background } },
--       { Foreground = { Color = foreground } },
--       { Text = title },
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_RIGHT_ARROW },
--     }
-- 	end
-- )

return {
	unix_domains = {
		{
			--Default unix domain to connect to on new instances
			name = "unix"
		},
	},
	-- default_gui_startup_args = { 'connect', 'unix' },
	--  Disable keybindings
	disable_default_key_bindings = true,
  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
	--- Keyboard shortcuts
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
      key = 'a',
      mods = 'LEADER|CTRL',
      action = wezterm.action.SendString '\x01',
    },
		--- Window splits and navigation
		{
			--- Create a new tab, equivalant to tmux window
			key = 'c', 
			mods = 'LEADER',
			action = act.SpawnTab 'CurrentPaneDomain',
		},
		{
			key = '_', 
			mods = 'LEADER|SHIFT',
			action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
		},
		{
      key = '-',
      mods = 'LEADER',
      action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
		{
      key = 'n',
      mods = 'LEADER',
      action = act.ActivateTabRelative(1),
		},
		{
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateTabRelative(-1),
		},
		--- Trigger search
		{
			key = '/',
			mods = 'LEADER',
			action = act.Search("CurrentSelectionOrEmptyString"),
		},
		--- Pane rotation
		{
      key = 'b',
      mods = 'LEADER|CTRL',
      action = act.RotatePanes 'CounterClockwise',
    },
    { key = 'n', mods = 'LEADER|CTRL', action = act.RotatePanes 'Clockwise' },
		{ key = 's', mods = 'LEADER|CTRL', action = act.PaneSelect },

		--- Copy and paste actions
		{ key = 'x', mods = 'LEADER|CTRL', action = act.ActivateCopyMode },
		--- Increase / Decrease fonts sizes
		{ key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
		{ key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
		{ key = '0', mods = 'CTRL', action = act.ResetFontSize },

		--- Switch to light or dark theme on demand
		{ key = '=', mods = 'LEADER', 
		action = wezterm.action_callback(function(window) 
			wezterm.log_info 'Test'
			local overrides = window:get_config_overrides() or {}
			overrides.color_scheme = 'TokyoNightLight (Gogh)'
			window:set_config_overrides(overrides)
		end)},
		{ key = '=', mods = 'LEADER|CTRL', 
		action = wezterm.action_callback(function(window) 
			local overrides = window:get_config_overrides() or {}
			overrides.color_scheme = 'TokyoNight (Gogh)'
			window:set_config_overrides(overrides)
		end)},

		--- Copy and Paste
    { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },

		---Scrollback shortcuts
		{ key = 'K', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
		{ key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
		{ key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },

		--- Quickselect mode
		{ key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.QuickSelect },

	},
	--- Appearence
	color_scheme = 'TokyoNight (Gogh)',
	font = wezterm.font 'Fira Code Nerd Font',
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	adjust_window_size_when_changing_font_size = false,
	unix_domains = {
		{
			name = 'unix',
		},
	}
}
