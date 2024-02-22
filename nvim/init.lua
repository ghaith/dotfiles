-- Leader is space
vim.g.mapleader = " "
-- Plugin Management 
require('plugins')

-- Defaults
require('settings')
-- Mappings
require('mappings')

-- Language Configuration
--
-- Auto Completion
-- require('autocomplete')
require('cmp_config')
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
