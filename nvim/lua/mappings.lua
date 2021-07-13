-- Keep the cursor in place while joining lines
vimp.nnoremap('J', 'mzJ`z')

-- Better window navigation
vimp.nnoremap('<C-h>', '<C-w>h')
vimp.nnoremap('<C-j>', '<C-w>j')
vimp.nnoremap('<C-k>', '<C-w>k')
vimp.nnoremap('<C-l>', '<C-w>l')

--Insert mode
vimp.imap('<C-h>', '<C-w>h')
vimp.imap('<C-j>', '<C-w>j')
vimp.imap('<C-k>', '<C-w>k')
vimp.imap('<C-l>', '<C-w>l')

-- Use alt + hjkl to resize windows
vimp.nnoremap({'<A-j>', 'silent'}, ':resize -2<CR>')
vimp.nnoremap({'<A-k>', 'silent'}, ':resize +2<CR>')
vimp.nnoremap({'<A-h>', 'silent'}, ':vertical resize -2<CR>')
vimp.nnoremap({'<A-l>', 'silent'}, ':vertical resize +2<CR>')

-- Better indenting
vimp.vnoremap('<', '<gv')
vimp.vnoremap('>', '>gv')
