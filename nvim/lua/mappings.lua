-- Keep the cursor in place while joining lines
vim.keymap.set("n", "J", "mzJ`z", {noremap = true, silent = true})

-- Better indenting
vim.keymap.set('v', '<', '<gv', {noremap = true, silent = true})
vim.keymap.set('v', '>', '>gv', {noremap = true, silent = true})

-- Buffer navigation
vim.keymap.set('n', '<leader>n', ':bnext<CR>', {noremap = true, silent = true, desc = "Next Buffer"})
vim.keymap.set('n', '<leader>p', ':bprev<CR>', {noremap = true, silent = true, desc = "Previous Buffer"})
vim.keymap.set('n', '<leader>cl', ':set background=light<CR>', {noremap = true, silent = true, desc = "Light Theme"})
vim.keymap.set('n', '<leader>cd', ':set background=dark<CR>', {noremap = true, silent = true, desc = "Dark Theme"})

-- Center the page on Ctrl+D and Ctrl+U
vim.keymap.set('n', '<ctrl>d', '<ctrl>Dzz', {noremap = true, silent = true})
vim.keymap.set('n', '<ctrl>U', '<ctrl>Uzz', {noremap = true, silent = true})
vim.keymap.set('n', 'n', 'nzz', {noremap = true, silent = true})
vim.keymap.set('n', 'N', 'Nzz', {noremap = true, silent = true})

-- Activate leap keymaps
require('leap').set_default_keymaps()
