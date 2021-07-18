vimp.nnoremap('<C-p>', "<cmd>lua require('telescope.builtin').find_files()<cr>")
vimp.nnoremap('<leader>ff', "<cmd> lua require('telescope.builtin').find_files()<cr>")
vimp.nnoremap('<leader>fg', "<cmd> lua require('telescope.builtin').live_grep()<cr>")
vimp.nnoremap('<leader>fb', "<cmd> lua require('telescope.builtin').buffers()<cr>")
vimp.nnoremap('<leader>fc', "<cmd> lua require('telescope.builtin').commands()<cr>")
vimp.nnoremap('<leader>cc', "<cmd> lua require('telescope.builtin').colorscheme()<cr>")
vimp.nnoremap('<leader>f/', "<cmd> lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>")


-- Whick key config

local wk = require("which-key")

wk.register({
				c = {
								c = "Color scheme",
				},
				f = {
								name = "File",
								f =  "Find files" ,
								g =  "Find In files" ,
								b =  "Find Buffers" ,
								c =  "Find Commands" ,
								-- '/' =  "Search in Buffer" ,
				},
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
