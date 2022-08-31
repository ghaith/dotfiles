local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
local telescope = require("telescope")

require('telescope').load_extension('fzf')

vimp.nnoremap('<C-p>', "<cmd>Telescope find_files<cr>")
vimp.nnoremap('<leader><leader>', "<cmd>Telescope find_files<cr>")
vimp.nnoremap('<leader>ff', "<cmd>Telescope find_files<cr>")
vimp.nnoremap('<leader>fg', "<cmd>Telescope live_grep<cr>")
vimp.nnoremap('<leader>fb', "<cmd>Telescope buffers<cr>")
vimp.nnoremap('<leader>fc', "<cmd>Telescope commands<cr>")
vimp.nnoremap('<leader>fh', "<cmd>Telescope help_tags<cr>")
vimp.nnoremap('<leader>cc', "<cmd>Telescope colorscheme<cr>")
vimp.nnoremap('<leader>fs', "<cmd>Telescope current_buffer_fuzzy_find<cr>")

-- This is your opts table
telescope.setup {
	defaults = {
		mappings = {
			i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble }
		}
	},
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension("ui-select")

-- Whick key config

local wk = require("which-key")

wk.register({
				c = {
								name = "Color",
								c = "Color scheme",
				},
				f = {
								name = "File",
								b =  "Find Buffers" ,
								c =  "Find Commands" ,
								f =  "Find files" ,
								g =  "Find In files" ,
								h =	 "Help Tags",
								s =  "Search in Buffer" ,
				},
				["<leader>"] = "Find files"
}, {prefix= "<leader>"}) 

require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- DevIcon will be appended to `name`
 -- override = {
 --  zsh = {
 --    icon = "",
 --    color = "#428850",
 --    name = "Zsh"
 --  }
 -- };
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
