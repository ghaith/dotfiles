""Rust auto format on save
"let g:rustfmt_autosave = 1
let g:rust_fold = 1

" Auto-format *.rs files prior to saving them
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
