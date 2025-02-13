-- Set <space> as the leader
-- Do this before plugins are loaded otherwise it might be set incorrectly
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set nerdfont to true
vim.g.have_nerd_font = true

-- [[ Global settings ]]
require 'settings'
require 'keymaps'

-- Install lazy
require 'lazy-bootstrap'
require 'lazy-plugins'
