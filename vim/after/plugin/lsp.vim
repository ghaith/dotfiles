"Configure language server defaults
"nmap <F2> :LspDefinition<CR>
"nmap <C-LeftMouse> :LspDefinition<CR>
"nmap <F3> :LspHover<CR>
"nmap <F1> :LspCodeAction<CR>
"nmap <C-F2> :LspReferences<CR>

"Enable rust language server
"if executable('rls')
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'rls',
"        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
"        \ 'whitelist': ['rust'],
"        \ })
"endif
"
"
""Enable bash language server
"if executable('bash-language-server')
"  au User lsp_setup call lsp#register_server({
"        \ 'name': 'bash-language-server',
"        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
"        \ 'whitelist': ['sh'],
"        \ })
"endif
"
""Enable dockerfile language server
"if executable('docker-langserver')
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'docker-langserver',
"        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
"        \ 'whitelist': ['dockerfile'],
"        \ })
"endif
"
""Language server for VIM 
"if executable('vim-language-server')
"  augroup LspVim
"    autocmd!
"    autocmd User lsp_setup call lsp#register_server({
"        \ 'name': 'vim-language-server',
"        \ 'cmd': {server_info->['vim-language-server', '--stdio']},
"        \ 'whitelist': ['vim'],
"        \ 'initialization_options': {
"        \   'vimruntime': $VIMRUNTIME,
"        \   'runtimepath': &rtp,
"        \ }})
"  augroup END
"endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> gd <plug>(lsp-definition)
    nnoremap <buffer> <M-R> <plug>(lsp-rename)
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_highlight_references_enabled = 1
""Rust auto format on save
"let g:rustfmt_autosave = 1
