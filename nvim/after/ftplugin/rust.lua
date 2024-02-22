local bufnr = vim.api.nvim_get_current_buf()
-- Mappings
vim.keymap.set('n', '<leader>ra', function()
	vim.cmd.RusLsp('codeAction')
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>rh', function()
	vim.cmd.RustLsp{'hover', 'actions'}
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>rr', function()
	vim.cmd.RustLsp('runnables')
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>rt', function()
	vim.cmd.RustLsp('testables')
end, {noremap=true, silent = true, buffer = bufnr})
	vim.keymap.set('n', '<leader>rem', function()
vim.cmd.RustLsp('expandMacro')
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>rmu', function()
	vim.cmd.RustLsp { 'moveItem',  'up' }
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>rmd', function()
	vim.cmd.RustLsp { 'moveItem',  'down' }
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>rc', function()
	vim.cmd.RustLsp('openCargo')
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>ru', function()
	vim.cmd.RustLsp('parentModule')
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>rj', function()
	vim.cmd.RustLsp('joinLines')
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>rd', function()
	vim.cmd.RustLsp('debuggables')
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>red', function()
	vim.cmd.RustLsp('renderDiagnostic')
end, {noremap=true, silent = true, buffer = bufnr})
vim.keymap.set('n', '<leader>ree', function()
	vim.cmd.RustLsp('explainError')
end, {noremap=true, silent = true, buffer = bufnr})



local wk = require("which-key")

wk.register({
		r = {
			name = "Rust Tools",
			a = "Code Action",
			c = "Cargo toml",
			d = "Debuggables",
			e = {
				d = "Render Diagnostics",
				e = "Explain Error",
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
			t = "Testables",
			u = "Parent Module",
		},
	}, 
	{prefix= "<leader>"}
) 

