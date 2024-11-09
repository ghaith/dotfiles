local actions = require("telescope.actions")
local trouble = require("trouble.sources.telescope")
local telescope = require("telescope")

require('telescope').load_extension('fzf')

vim.keymap.set('n', '<leader>f', "<cmd>Telescope find_files<cr>", {noremap=true, silent=true,  desc="Files"})
vim.keymap.set('n', '<leader>/', "<cmd>Telescope live_grep<cr>", {noremap=true, silent=true, desc="Live Grep"})
vim.keymap.set('n', '<leader>b', "<cmd>Telescope buffers<cr>", {noremap=true, silent=true, desc="Open Buffers"})
vim.keymap.set('n', '<leader>?', "<cmd>Telescope commands<cr>", {noremap=true, silent=true, desc="Open Commands"})
vim.keymap.set('n', '<leader>h', "<cmd>Telescope help_tags<cr>", {noremap=true, silent=true, desc="Help Tags"})
vim.keymap.set('n', '<leader>cc', "<cmd>Telescope colorscheme<cr>", {noremap=true, silent=true, desc="Color Scheme"})
vim.keymap.set('n', '<leader>g', "<cmd>Telescope current_buffer_fuzzy_find<cr>", {noremap=true, silent=true, desc="Find in Buffer"})

-- This is your opts table
telescope.setup {
	defaults = {
		mappings = {
			i = { ["<c-t>"] = trouble.open },
      n = { ["<c-t>"] = trouble.open }
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

wk.add({
	{"<leader>c", group = "Color"},
})

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
