-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp = require'lsp'
-- DAP uses codelldb
local extension_path = vim.env.HOME .. '/usr/lib/codelldb/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'


vim.g.rustaceanvim = {
	tools = {
		-- whether to show variable name before type hints with the inlay hints or not
		show_variable_name = true,
		hover_actions = {
			auto_focus = true,
		},
		-- test_executor = 'background',
	},
	server = {
		-- Call the lsp generic configuration for rust
		on_attach = lsp.on_attach,
		-- capabilities = lsp.capabilities,
		-- ["rust-analyzer"] = {
		-- 	on_init = function(client)
		-- 		-- Override rust command if within the rust repo. hardcoded for now
		-- 		local path = client.workspace_folders[1].name
		-- 		if path:sub(-#"/rust") == "/rust" then
		-- 				client.config.settings["rust-analyzer"].checkOnSave.overrideCommand = { 
		-- 					"python3", 
		-- 					"x.py", 
		-- 					"check", 
		-- 					"--json-output" ,
		-- 					"--build-dir",
		-- 					"build-rust-analyzer"
		-- 				}
		-- 				client.config.settings["rust-analyzer"].procMacro.enable = true
		-- 				client.config.settings["rust-analyzer"].cargo.buildScripts.enable = true
		-- 				client.config.settings["rust-analyzer"].cargo.buildScripts.overrideCommand = {
		-- 								"python3",
		-- 								"x.py",
		-- 								"check",
		-- 								"--json-output",
		-- 								"--build-dir",
		-- 								"build-rust-analyzer"
		-- 				}
		-- 				client.config.settings["rust-analyzer"].rustc.source = "./Cargo.toml"
		-- 		end
		-- 	end,
			----enable clippy on save
			--checkOnSave = {
			--	-- command = "clippy",
			--	overrideCommand = {"cargo", "clippy", "--message-format=json" }
			--},
		-- },
	},
	-- dap = {
	-- 	adapter = require('rust-tools.dap').get_codelldb_adapter(
	-- 		codelldb_path, liblldb_path
	-- 	)
	-- },
}
