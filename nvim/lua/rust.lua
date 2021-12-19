require('rust-tools').setup()

-- Mappings
vimp.nnoremap('<leader>rh', function() 
				require'rust-tools.hover_actions'.hover_actions()
end)
vimp.nnoremap('<leader>rr', function() 
				require('rust-tools.runnables').runnables()
end)
vimp.nnoremap('<leader>rem', function() 
				require'rust-tools.expand_macro'.expand_macro()
end)
vimp.nnoremap('<leader>rmu', function()
				local up = true -- true = move up, false = move down
				require'rust-tools.move_item'.move_item(up)
end)
vimp.nnoremap('<leader>rmd', function()
				local up = false -- true = move up, false = move down
				require'rust-tools.move_item'.move_item(up)
end)
vimp.nnoremap('<leader>rc', function()
				require'rust-tools.open_cargo_toml'.open_cargo_toml()
end)

vimp.nnoremap('<leader>ru', function()
				require'rust-tools.parent_module'.parent_module()
end)
vimp.nnoremap('<leader>rj', function()
				require'rust-tools.join_lines'.join_lines()
end)
vimp.nnoremap('<leader>rd', function()
				require'rust-tools.debuggables'.debuggables()
end)



  local wk = require("which-key")

				wk.register({
								r = {
												name = "Rust Tools",
												c = "Cargo toml",
												d = "Debuggables",
												e = {
																m = "Expand Macro",
												},
												h = "Hover",
												j = "Join Lines",
												m = {
																name = "Move",
																d = "Down",
																u = "Up",
												},
												r = "Runnables",
												u = "Parent Module",
								},
				}, {prefix= "<leader>"}) 

