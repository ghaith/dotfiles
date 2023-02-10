-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp = require'lsp'
local rt = require("rust-tools")
local function on_attach(client, bufnr) 
	
	lsp.on_attach(client, bufnr)

	-- Mappings
	vimp.nnoremap('<leader>ra', function() 
					rt.code_action_group.code_action_group()
	end)
	vimp.nnoremap('<leader>rh', function() 
					rt.hover_actions.hover_actions()
	end)
	vimp.nnoremap('<leader>rr', function() 
					rt.runnables.runnables()
	end)
	vimp.nnoremap('<leader>rem', function() 
					rt.expand_macro.expand_macro()
	end)
	vimp.nnoremap('<leader>rmu', function()
					local up = true -- true = move up, false = move down
					rt.move_item.move_item(up)
	end)
	vimp.nnoremap('<leader>rmd', function()
					local up = false -- true = move up, false = move down
					rt.move_item.move_item(up)
	end)
	vimp.nnoremap('<leader>rc', function()
					rt.open_cargo_toml.open_cargo_toml()
	end)

	vimp.nnoremap('<leader>ru', function()
					rt.parent_module.parent_module()
	end)
	vimp.nnoremap('<leader>rj', function()
					rt.join_lines.join_lines()
	end)
	vimp.nnoremap('<leader>rd', function()
					rt.debuggables.debuggables()
	end)



  local wk = require("which-key")

				wk.register({
								r = {
												name = "Rust Tools",
												a = "Code Action",
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
local extension_path = vim.env.HOME .. '/usr/lib/codelldb/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'


local opts = {
	tools = {
		-- whether to show variable name before type hints with the inlay hints or not
		show_variable_name = true,
		hover_actions = {
			auto_focus = true,
		},
	},
	server = {
		-- Call the lsp generic configuration for rust
		on_attach = on_attach ,
		-- standalone = false,
		capabilities = lsp.capabilities,
		["rust-analyzer"] = {
			on_init = function(client)
				-- Override rust command if within the rust repo. hardcoded for now
				local path = client.workspace_folders[1].name
				if path:sub(-#"/rust") == "/rust" then
						client.config.settings["rust-analyzer"].checkOnSave.overrideCommand = { 
							"python3", 
							"x.py", 
							"check", 
							"--json-output" ,
							"--build-dir",
							"build-rust-analyzer"
						}
						client.config.settings["rust-analyzer"].procMacro.enable = true
						client.config.settings["rust-analyzer"].cargo.buildScripts.enable = true
						client.config.settings["rust-analyzer"].cargo.buildScripts.overrideCommand = {
										"python3",
										"x.py",
										"check",
										"--json-output",
										"--build-dir",
										"build-rust-analyzer"
						}
						client.config.settings["rust-analyzer"].rustc.source = "./Cargo.toml"
				end
			end,
			--enable clippy on save
			checkOnSave = {
				-- command = "clippy",
				overrideCommand = {"cargo", "clippy", "--message-format=json" }
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
