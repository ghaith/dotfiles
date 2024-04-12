-- Make sure packer is installed

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Enable better commenting
	'tpope/vim-commentary',

	-- Show icons for different file types
	'lambdalisue/nerdfont.vim',
	'kyazdani42/nvim-web-devicons',
	-- Git
	'f-person/git-blame.nvim',
  -- Make vim use the root .git directory if available
	'airblade/vim-rooter',

  -- Sneak to jump around in the buffer
	-- use 'justinmk/vim-sneak'
	-- Leap to jump around (like sneak but with labels)
	'ggandor/leap.nvim',

  -- Color themes Plugins
  -- use 'sainnhe/gruvbox-material'
  'gruvbox-community/gruvbox',
	'overcache/NeoSolarized',
	'folke/tokyonight.nvim',
	{ "catppuccin/nvim", as = "catppuccin"},

	-- Allow local configurations
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	-- Helpers for nvim config
  "folke/neodev.nvim",

	-- Better syntax
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
	-- Sidebar explorer
	{
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
	},

	-- LSP
	'neovim/nvim-lspconfig',
	'folke/lsp-colors.nvim',
	'nvim-lua/lsp-status.nvim',
	'onsails/lspkind.nvim',

	-- Programming languages
	{
		'mrcjkb/rustaceanvim',
		version = '^4', -- Recommended
		ft = { 'rust' },
	},
	'cespare/vim-toml',

	-- Tests
	{ 
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/nvim-nio"
		},
	},

	-- Grammar check
	-- use 'rhysd/vim-grammarous'

	--Diagnostics
	{
		"folke/trouble.nvim",
		dependencies = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	},

	-- Completion
	-- use 'hrsh7th/nvim-compe'
	'hrsh7th/nvim-cmp', --Engine
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-nvim-lsp-signature-help' ,
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/cmp-nvim-lua',
	'saadparwaiz1/cmp_luasnip',

	{
		"windwp/nvim-autopairs",
			config = function() require("nvim-autopairs").setup {} end
	},

	-- Snippets
	'L3MON4D3/LuaSnip',
	-- use 'hrsh7th/vim-vsnip'

	-- Status line
	{
				'hoob3rt/lualine.nvim',
				dependencies = {'kyazdani42/nvim-web-devicons', opt = true}
	},


  -- Telescope fuzzy finding
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	},

	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	},

	-- Use telescope for ui select
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

	{'nvim-telescope/telescope-ui-select.nvim' },
	-- Debug support
	"mfussenegger/nvim-dap",
  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap"} },
  {'nvim-telescope/telescope-dap.nvim'},
	"theHamsta/nvim-dap-virtual-text",

	-- Todo plugin
	{
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	},

	--Dev containers
	-- use 'jamestthompson3/nvim-remote-containers'

	"petertriho/nvim-scrollbar",
  'kevinhwang91/nvim-hlslens',
	"lewis6991/gitsigns.nvim",

})
