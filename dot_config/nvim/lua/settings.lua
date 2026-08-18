-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Clipboard is configured in lua/ghaith/clipboard.lua (smart: native locally, OSC 52 over SSH)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.syntax = 'on'
vim.opt.ruler = true
vim.opt.title = true
vim.opt.hidden = true
-- Truecolor: safe inside tmux (tmux downconverts for weaker clients) and on
-- terminals declaring 24-bit via COLORTERM. Anywhere else, leave the option
-- unset so nvim's own terminal detection decides — on an exotic terminal
-- without RGB support, forcing it would render broken colors. The colorscheme
-- config also keys off this flag (catppuccin force-enables termguicolors).
local colorterm = vim.env.COLORTERM or ''
vim.g.has_truecolor = (vim.env.TMUX or '') ~= '' or colorterm == 'truecolor' or colorterm == '24bit'
if vim.g.has_truecolor then
  vim.opt.termguicolors = true
end

-- Tabs: use 2 spaces, expand tabs to spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- vim: ts=2 sts=2 sw=2 et
