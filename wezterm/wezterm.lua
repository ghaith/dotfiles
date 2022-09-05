local wezterm = require'wezterm'
local act = wezterm.action

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

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

	tab_bar_style = {
    active_tab_left = wezterm.format {
      { Background = { Color = '#0b0022' } },
      { Foreground = { Color = '#2b2042' } },
      { Text = SOLID_LEFT_ARROW },
    },
    active_tab_right = wezterm.format {
      { Background = { Color = '#0b0022' } },
      { Foreground = { Color = '#2b2042' } },
      { Text = SOLID_RIGHT_ARROW },
    },
    inactive_tab_left = wezterm.format {
      { Background = { Color = '#0b0022' } },
      { Foreground = { Color = '#1b1032' } },
      { Text = SOLID_LEFT_ARROW },
    },
    inactive_tab_right = wezterm.format {
      { Background = { Color = '#0b0022' } },
      { Foreground = { Color = '#1b1032' } },
      { Text = SOLID_RIGHT_ARROW },
    },
  },

	

}
