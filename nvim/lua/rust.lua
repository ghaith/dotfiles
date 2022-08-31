-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp = require'lsp'
local function on_attach(client, bufnr) 
	
	lsp.on_attach(client, bufnr)

	-- Mappings
	vimp.nnoremap('<leader>ra', function() 
					require'rust-tools.code_action'.code_action()
	end)
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


end
-- DAP uses codelldb
local extension_path = vim.env.HOME .. '/.local/codelldb/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

local opts = {
	tools = {
		-- whether to show variable name before type hints with the inlay hints or not
		show_variable_name = true,
	},
	server = {
		-- Call the lsp generic configuration for rust
		on_attach = on_attach ,
		capabilities = lsp.capabilities,
		["rust-analyzer"] = {
			--enable clippy on save
			checkOnSave = {
				command = "clippy",
			},
		},
	},
	dap = {
		adapter = require('rust-tools.dap').get_codelldb_adapter(
			codelldb_path, liblldb_path
		)
	},
}
require('rust-tools').setup(opts)
