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

-- Scrollbar
require("scrollbar").setup()
require("scrollbar.handlers.search").setup()
