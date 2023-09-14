-- Make sure packer is installed

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

	-- Enable better commenting
	use 'tpope/vim-commentary'

	-- Show icons for different file types
	use 'lambdalisue/nerdfont.vim'
	use 'kyazdani42/nvim-web-devicons'
	-- Git
	use 'airblade/vim-gitgutter'
	use 'tpope/vim-fugitive'
  use 'junegunn/gv.vim'
  -- Make vim use the root .git directory if available
	use 'airblade/vim-rooter'
	use 'f-person/git-blame.nvim'
	use({"petertriho/cmp-git", requires = "nvim-lua/plenary.nvim"})

	-- Tagbar
  use 'liuchengxu/vista.vim'


  -- Sneak to jump around in the buffer
	-- use 'justinmk/vim-sneak'
	-- Leap to jump around (like sneak but with labels)
	use 'ggandor/leap.nvim'

  -- Color themes Plugins
  -- use 'sainnhe/gruvbox-material'
  use 'gruvbox-community/gruvbox'
	use 'overcache/NeoSolarized'
	use 'folke/tokyonight.nvim'

	-- Colors
	use {'rrethy/vim-hexokinase', run = 'make hexokinase'}


	-- Better syntax
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	
	-- Sidebar explorer
	use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
	}

	-- LSP
	use 'neovim/nvim-lspconfig'
	use 'folke/lsp-colors.nvim'
	use 'nvim-lua/lsp-status.nvim'
	use 'onsails/lspkind.nvim'

	-- Programming languages
	use	'simrat39/rust-tools.nvim'
	use 'cespare/vim-toml'

	-- Grammar check
	use 'rhysd/vim-grammarous'

	--Diagnostics
	use {
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	}

	-- Completion
	-- use 'hrsh7th/nvim-compe'
	use 'hrsh7th/nvim-cmp' --Engine
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-nvim-lsp-signature-help' 
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-nvim-lua'
	use 'saadparwaiz1/cmp_luasnip'

	use {
		"windwp/nvim-autopairs",
			config = function() require("nvim-autopairs").setup {} end
	}

	-- Snippets
	use 'L3MON4D3/LuaSnip'
	-- use 'hrsh7th/vim-vsnip'

	-- Status line
	use {
				'hoob3rt/lualine.nvim',
				requires = {'kyazdani42/nvim-web-devicons', opt = true}
	}


  -- Telescope fuzzy finding
	use {
  'nvim-telescope/telescope.nvim',
  requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
			}

				use {
					"folke/which-key.nvim",
					config = function()
						require("which-key").setup {
							-- your configuration comes here
							-- or leave it empty to use the default settings
							-- refer to the configuration section below
						}
					end
				}

  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	-- Use telescope for ui select
	use {'nvim-telescope/telescope-ui-select.nvim' }
				
	-- Debug support
	use "mfussenegger/nvim-dap"
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use {'nvim-telescope/telescope-dap.nvim'}
	use "theHamsta/nvim-dap-virtual-text"

	-- Todo plugin
	use {
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	}

	--Dev containers
	-- use 'jamestthompson3/nvim-remote-containers'

	use("petertriho/nvim-scrollbar")
  use {'kevinhwang91/nvim-hlslens'}

end)
