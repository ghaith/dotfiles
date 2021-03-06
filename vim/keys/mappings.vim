" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Insert mode
imap <C-h> <C-w>h
imap <C-j> <C-w>j
imap <C-k> <C-w>k
imap <C-l> <C-w>l

" Use alt + hjkl to resize windows
nnoremap <silent> <A-j>    :resize -2<CR>
nnoremap <silent> <A-k>    :resize +2<CR>
nnoremap <silent> <A-h>    :vertical resize -2<CR>
nnoremap <silent> <A-l>    :vertical resize +2<CR>

" Better indenting
vnoremap < <gv
vnoremap > >gv

let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

if !exists('g:vscode')
	" TAB in general mode will move to text buffer
	nnoremap <silent> <TAB> :bnext<CR>
	" SHIFT-TAB will go back
	nnoremap <silent> <S-TAB> :bprevious<CR>

	" <TAB>: completion.
	inoremap <silent> <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

	"Control + P will open the search menu
	nnoremap <silent> <C-p> :Files<CR>
	"<cmd>Telescope find_files<cr>
	nnoremap <silent> <A-o> :Vista finder<CR>

endif
