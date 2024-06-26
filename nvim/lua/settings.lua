-- Default settings
--

vim.cmd('syntax enable') -- Enable syntax highlighting

vim.cmd [[
set autoindent
set shiftwidth=2
set smartindent
set softtabstop=2
set tabstop=2
set smarttab
set smartcase
]]

vim.o.mouse = "a"
vim.o.hidden = true
vim.g.nowrap = true
vim.o.ruler = true
vim.o.cmdheight = 2
vim.o.number = true
vim.o.rnu = true -- Relative lines
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.background = "dark"
vim.o.cursorline = true
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
-- vim.o.guifont = "Hack Nerd Font"
vim.o.guifont = "Fira Code Nerd Font"
-- Set color theme
-- vim.cmd('colorscheme gruvbox')
-- vim.g.gruvbox_contrast_dark = true 
-- vim.cmd('colorscheme tokyonight')
vim.cmd('colorscheme catppuccin')
--- Dark theme by default, use <leader>cl to switch to light
vim.cmd('set background=light')
vim.cmd('set colorcolumn=110')
--- Define markdown inner languages
vim.g.markdown_fenced_languages = {
  "ts=typescript"
}
