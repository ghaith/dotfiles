require('vimp')
-- Keep the cursor in place while joining lines
vimp.nnoremap('J', 'mzJ`z')

-- Better window navigation
--vimp.nnoremap('<C-h>', '<C-w>h')
--vimp.nnoremap('<C-j>', '<C-w>j')
--vimp.nnoremap('<C-k>', '<C-w>k')
--vimp.nnoremap('<C-l>', '<C-w>l')

----Insert mode
--vimp.imap('<C-h>', '<C-w>h')
--vimp.imap('<C-j>', '<C-w>j')
--vimp.imap('<C-k>', '<C-w>k')
--vimp.imap('<C-l>', '<C-w>l')

-- Better indenting
vimp.vnoremap('<', '<gv')
vimp.vnoremap('>', '>gv')

-- Buffer navigation
vimp.nnoremap('<leader>n', ':bnext<CR>')
vimp.nnoremap('<leader>p', ':bprev<CR>')
vimp.nnoremap('<leader>cl', ':set background=light<CR>')
vimp.nnoremap('<leader>cd', ':set background=dark<CR>')

-- Which key configuration
--
local wk = require("which-key")

wk.register({
				n = "Next Buffer",
				p = "Previous Buffer"
}, {prefix = "<leader>"})
