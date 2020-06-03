function! g:BuffetSetCustomColors()
  hi! clear BuffetBuffer
  hi! link BuffetCurrentBuffer DraculaSelection
  hi! link BuffetTab DraculaCommentBold
endfunction

Plug 'bagrat/vim-buffet'

let g:buffet_powerline_separators = 1
let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_right_trunc_icon = "\uf0a9"
