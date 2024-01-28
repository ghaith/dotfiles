local lsp_status = require('lsp-status')
local function lsp_prog()
	-- if vim.lsp.buf_get_clients() > 0 then
		return lsp_status.status()
	-- end
end
require('lualine').setup
{
	options = {theme = 'solarized'},
	sections = {
		lualine_x = {lsp_prog, 'encoding', 'fileformat', 'filepyte'},
	},
}

--Search lense
require('hlslens').setup()

local kopts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

require('gitsigns').setup()
-- Scrollbar
require("scrollbar").setup()
require("scrollbar.handlers.search").setup()
