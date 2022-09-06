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
		{ key = 'X', mods = 'CTRL', action = wezterm.action.ActivateCopyMode },
		--- Increase / Decrease fonts sizes
		{ key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
		{ key = '-', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
		{ key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },

	},
	--- Appearence
	color_scheme = 'TokyoNightLight (Gogh)',
	font = wezterm.font 'Fira Code',
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	unix_domains = {
		{
			name = 'unix',
		},
	}

	

}
