-- Leader is space
vim.g.mapleader = " "
-- Plugin Management 
require('plugins')


-- Package Management
require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = {"lua_ls", "rust_analyzer"}
}

-- Defaults
require('settings')
-- Mappings
require('mappings')

-- Language Configuration
--
-- Auto Completion
-- require('autocomplete')
require('cmp_config')
require('codecompanion')
--Git configuration
require('git')
-- LSP
require('lsp')
require('rust')
-- require('go')

-- Testing
require('test')
require('telescope_config')
require('trouble_config')

require('dbg')

require('status')

require('sidebar')
