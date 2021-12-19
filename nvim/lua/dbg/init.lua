require('telescope').load_extension('dap')

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}


-- If you want to use this for rust and c, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp


-- Configuration

require'nvim-dap-virtual-text'.setup()

local utils = require('utils')

utils.map('n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>')
utils.map('n', '<leader>dss', '<cmd>lua require"dap".step_over()<CR>')
utils.map('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>')
utils.map('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>')
utils.map('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>')

utils.map('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>')
utils.map('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>')
utils.map('v', '<leader>dhv',
          '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')

utils.map('n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>')
utils.map('n', '<leader>duf',
          "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")

utils.map('n', '<leader>dsbr',
          '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
utils.map('n', '<leader>dsbm',
          '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
utils.map('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>')
utils.map('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>')


-- telescope-dap
utils.map('n', '<leader>dcc',
          '<cmd>lua require"telescope".extensions.dap.commands{}<CR>')
utils.map('n', '<leader>dco',
          '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>')
utils.map('n', '<leader>dlb',
          '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>')
utils.map('n', '<leader>dv',
          '<cmd>lua require"telescope".extensions.dap.variables{}<CR>')
utils.map('n', '<leader>df',
          '<cmd>lua require"telescope".extensions.dap.frames{}<CR>')

-- UI
require("dapui").setup()
utils.map('n', '<leader>dui', '<cmd>lua require"dapui".toggle()<CR>')

-- Whichkey bindings 
local wk = require("which-key")

wk.register({
				d = {
								name = "Debug",
								c = {
												c = "Commands",
												o = "Configurations",
												t = "Continue",
								},
								f = "Frames",
								h = {
												name = "Hover",
												h = "Hover",
												v = "Visual",
								},
								l = {
												name = "List",
												b = "Breakpoints",
								},
								r = {
												name = "Repl",
												l = "Run Last",
												o = "open",
								},
								s = {
												b = {
																name = "Breakpoints",
																r = "Set Conditional",
																m = "Set log point",
												},
												c = "Scopes",
												i = "Into",
												o = "Out",
												s = "Over",
								},
								t = {
												name = "Toggle",
												b = "Breakpoint",
								},
								u = {
												name  = "UI", 
												i = "Start UI",
												h = "Hover",
												f = "Scopes",
								},
								v = "Variables",

				}
}, {prefix = "<leader>"})
