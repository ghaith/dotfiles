"Configure language server defaults
"nmap <F2> :LspDefinition<CR>
"nmap <C-LeftMouse> :LspDefinition<CR>
"nmap <F3> :LspHover<CR>
"nmap <F1> :LspCodeAction<CR>
"nmap <C-F2> :LspReferences<CR>

"Enable rust language server
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

"Rust auto format on save
let g:rustfmt_autosave = 1

"Enable Pytthon Language server
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

"Enable bash language server
if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
endif

"Enable dockerfile language server
if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'docker-langserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
        \ 'whitelist': ['dockerfile'],
        \ })
endif

let g:lsp_highlight_references_enabled = 1
