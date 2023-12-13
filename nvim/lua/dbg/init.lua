require('telescope').load_extension('dap')

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = '/usr/lib/codelldb/adapter/codelldb',
    args = {"--port", "${port}"},

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "codelldb",
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
-- dap.configurations.rust = dap.configurations.cpp


-- Configuration

require'nvim-dap-virtual-text'.setup()

vim.keymap.set('n', '<F5>', '<cmd>lua require"dap".continue()<CR>', {noremap = true, force})
vim.keymap.set('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>', {noremap = true, force})
vim.keymap.set('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>', {noremap = true, force})
vim.keymap.set('n', '<Shift><F11>', '<cmd>lua require"dap".step_out()<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', {noremap = true, force})

vim.keymap.set('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>', {noremap = true, force})
vim.keymap.set('v', '<leader>dhv',
          '<cmd>lua require"dap.ui.variables".visual_hover()<CR>', {noremap = true, force})

vim.keymap.set('n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>duf', 
          "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>", {noremap = true, force})

vim.keymap.set('n', '<leader>dB',
          '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>dL',
          '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>', {noremap = true, force})


-- telescope-dap
vim.keymap.set('n', '<leader>dcc',
          '<cmd>lua require"telescope".extensions.dap.commands{}<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>dco',
          '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>dlb',
          '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>dv',
          '<cmd>lua require"telescope".extensions.dap.variables{}<CR>', {noremap = true, force})
vim.keymap.set('n', '<leader>df',
          '<cmd>lua require"telescope".extensions.dap.frames{}<CR>', {noremap = true, force})

-- UI
require("dapui").setup()
vim.keymap.set('n', '<leader>dui', '<cmd>lua require"dapui".toggle()<CR>', {noremap = true, force})

-- Whichkey bindings 
local wk = require("which-key")

wk.register({
				d = {
								name = "Debug",
								b = "Breakpoint",
								B = "Conditional Breakpoint",
								c = {
												c = "Commands",
												o = "Configurations",
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
								L = "Log point",
								r = {
												name = "Repl",
												l = "Run Last",
												o = "open",
								},
								s = {
												c = "Scopes",
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
