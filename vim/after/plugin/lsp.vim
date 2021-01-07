"nnoremap <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap <leader>lh     <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <leader>lD    <cmd>lua vim.lsp.buf.implementation()<CR>
""nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"nnoremap <leader>lt   <cmd>lua vim.lsp.buf.type_definition()<CR>
"nnoremap <leader>lr    <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
"nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
"nnoremap <leader>lsd :lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
"
"
"lua require'lspconfig'.rust_analyzer.setup{ on_attach=require'completion'.on_attach }
"lua require'lspconfig'.vimls.setup{ on_attach=require'completion'.on_attach }
"lua require'lspconfig'.gopls.setup{ on_attach=require'completion'.on_attach }
"lua require'lspconfig'.clangd.setup{ on_attach=require'completion'.on_attach }
"lua require'lspconfig'.cmake.setup{ on_attach=require'completion'.on_attach }
