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

  -- Install vimpeccable to allow easier lua vim config
  use 'svermeulen/vimpeccable'

	-- Enable repetition on complex actions
	use 'tpope/vim-repeat'

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


	-- Tagbar
  use 'liuchengxu/vista.vim'


  use 'kana/vim-operator-user' -- Needed for formatting
	use 'rhysd/vim-clang-format'

	-- Toggle relative numbers automatically 
	-- use 'jeffkreeftmeijer/vim-numbertoggle'

  -- Sneak to jump around in the buffer
	use 'justinmk/vim-sneak'

  -- Color themes Plugins
  -- use 'sainnhe/gruvbox-material'
  use 'gruvbox-community/gruvbox'

	-- Colors
	use {'rrethy/vim-hexokinase', run = 'make hexokinase'}


	-- Better syntax
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	-- Firenvim 
	--  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }
	
	-- Tmux support
	use 'tmux-plugins/vim-tmux'

	-- Programming languages
	use 'rust-lang/rust.vim'
	use	'simrat39/rust-tools.nvim'
	use 'cespare/vim-toml'
	use 'sirtaj/vim-openscad'
	use 'habamax/vim-godot'

	-- LSP
	use 'neovim/nvim-lspconfig'
	use 'folke/lsp-colors.nvim'
	use 'nvim-lua/lsp-status.nvim'
	use {
		"ray-x/lsp_signature.nvim",
	}
	-- use {
	-- 	"RishabhRD/nvim-lsputils",
	-- 	requires = "RishabhRD/popfix"
	-- }

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
	use 'hrsh7th/nvim-compe'


	-- Folding support
	use 'pierreglaser/folding-nvim'

	-- Snippets
	use 'hrsh7th/vim-vsnip'

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
  
end)
