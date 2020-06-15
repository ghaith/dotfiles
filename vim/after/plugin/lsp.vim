"Configure language server defaults
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

"set foldmethod=expr
"	\ foldexpr=lsp#ui#vim#folding#foldexpr()
"	\ foldtext=lsp#ui#vim#folding#foldtext()

let g:lsp_highlight_references_enabled = 1
""Rust auto format on save
"let g:rustfmt_autosave = 1
let g:rust_fold = 1
