local bufnr = vim.api.nvim_get_current_buf()
-- Mappings
vim.keymap.set('n', '<leader>ra', function()
  vim.cmd.RustLsp 'codeAction'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Code Action' })
vim.keymap.set('n', '<leader>rh', function()
  vim.cmd.RustLsp { 'hover', 'actions' }
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Hover' })
vim.keymap.set('n', '<leader>rr', function()
  vim.cmd.RustLsp 'runnables'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Runnables' })
vim.keymap.set('n', '<leader>rt', function()
  vim.cmd.RustLsp 'testables'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Testables' })
vim.keymap.set('n', '<leader>rem', function()
  vim.cmd.RustLsp 'expandMacro'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Expand Macro' })
vim.keymap.set('n', '<leader>rmu', function()
  vim.cmd.RustLsp { 'moveItem', 'up' }
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Move Item Up' })
vim.keymap.set('n', '<leader>rmd', function()
  vim.cmd.RustLsp { 'moveItem', 'down' }
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Move Item Down' })
vim.keymap.set('n', '<leader>rc', function()
  vim.cmd.RustLsp 'openCargo'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Open Cargo' })
vim.keymap.set('n', '<leader>ru', function()
  vim.cmd.RustLsp 'parentModule'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Parent Module' })
vim.keymap.set('n', '<leader>rj', function()
  vim.cmd.RustLsp 'joinLines'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Join Lines' })
vim.keymap.set('n', '<leader>rd', function()
  vim.cmd.RustLsp 'debuggables'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Debuggables' })
vim.keymap.set('n', '<leader>red', function()
  vim.cmd.RustLsp 'renderDiagnostic'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Render Diagnostics' })
vim.keymap.set('n', '<leader>ree', function()
  vim.cmd.RustLsp 'explainError'
end, { noremap = true, silent = true, buffer = bufnr, desc = 'Explain Error' })

local wk = require 'which-key'

wk.add {
  { '<leader>r', group = 'Rust Tools' },
  { '<leader>rm', group = 'Move' },
}
