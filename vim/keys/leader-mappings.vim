" Map leader to which_key
" g Leader key
let g:mapleader="\<Space>"

nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
" set timeoutlen=100

"Open markdown
noremap <silent> <leader>om :call OpenMarkdownPreview()<cr>
" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler


" Single mappings
nnoremap <silent> <leader>;     :Commands<CR>
let g:which_key_map[';'] = [ ':Commands'                  , 'commands' ]

nnoremap <silent> <leader>=     <C-w>=<CR>
let g:which_key_map['='] = [ '<C-W>='                     , 'balance windows' ]

nnoremap <silent> <leader>d     :bd<CR>
let g:which_key_map['d'] = [ ':bd'                        , 'delete buffer']

nnoremap <silent> <leader>h     <C-w>s
let g:which_key_map['h'] = [ '<C-W>s'                     , 'split below']

nnoremap <silent> <leader>v     <C-w>v
let g:which_key_map['v'] = [ '<C-W>v'                     , 'split right']

nnoremap <silent> <leader>r     :Ranger<CR>
let g:which_key_map['r'] = [ ':Ranger'                    , 'ranger' ]

nnoremap <silent> <leader>S     :SSave<CR>
let g:which_key_map['S'] = [ ':SSave'                     , 'save session' ]

nnoremap <silent> <leader>T     :RustTest<CR>
let g:which_key_map['T'] = [ ':RustTest'                     , 'Run a rust test' ]

nnoremap <silent> <leader>.     :e $MYVIMRC<CR>
let g:which_key_map['.'] = [ ':e $MYVIMRC'                , 'open init' ]

"let g:which_key_map.f = [ ':Files'                     , 'search files' ]
nnoremap <silent> <leader>e     :Fern . -reveal=% -drawer -stay -toggle <CR>
" Group mappings

" a is for actions
let g:which_key_map.a = {
      \ 'name' : '+actions' ,
      \ 'n' : [':set nonumber!'          , 'line-numbers'],
      \ 'r' : [':set norelativenumber!'  , 'relative line nums'],
      \ 's' : [':let @/ = ""'            , 'remove search highlight'],
      \ 'v' : [':Vista!!'                , 'tag viewer'],
      \ }

" b is for buffer
let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ 'd' : ['bd'        , 'delete-buffer']   ,
      \ 'f' : ['bfirst'    , 'first-buffer']    ,
      \ 'l' : ['blast'     , 'last-buffer']     ,
      \ 'n' : ['bnext'     , 'next-buffer']     ,
      \ 'p' : ['bprevious' , 'previous-buffer'] ,
      \ '?' : ['Buffers'   , 'fzf-buffer']      ,
      \ }

" s is for search
let g:which_key_map.s = {
      \ 'name' : '+search' ,
      \ '/' : [':History/'     , 'history'],
      \ ';' : [':Commands'     , 'commands'],
      \ 'b' : [':BLines'       , 'current buffer'],
      \ 'B' : [':Buffers'      , 'open buffers'],
      \ 'c' : [':Commits'      , 'commits'],
      \ 'C' : [':BCommits'     , 'buffer commits'],
      \ 'f' : [':Files'        , 'files'],
      \ 'g' : [':GFiles'       , 'git files'],
      \ 'G' : [':GFiles?'      , 'modified git files'],
      \ 'l' : [':Lines'        , 'lines'] ,
      \ 'm' : [':Marks'        , 'marks'] ,
      \ 'M' : [':Maps'         , 'normal maps'] ,
      \ 'p' : [':Helptags'     , 'help tags'] ,
      \ 'P' : [':Tags'         , 'project tags'],
      \ 's' : [':Snippets'     , 'snippets'],
      \ 'S' : [':Colors'       , 'color schemes'],
      \ 't' : [':Rg'           , 'text Rg'],
      \ 'T' : [':BTags'        , 'buffer tags'],
      \ 'w' : [':Windows'      , 'search windows'],
      \ 'y' : [':Filetypes'    , 'file types'],
      \ 'z' : [':FZF'          , 'FZF'],
      \ }

" g is for git
let g:which_key_map.g = {
      \ 'name' : '+git' ,
      \ 'a' : [':Git add .'                        , 'add all'],
      \ 'A' : [':Git add %'                        , 'add current'],
      \ 'b' : [':Git blame'                        , 'blame'],
      \ 'c' : [':Git commit'                       , 'commit'],
      \ 'd' : [':Git diff'                         , 'diff'],
      \ 'D' : [':Gdiffsplit'                       , 'diff split'],
      \ 'g' : [':GGrep'                            , 'git grep'],
      \ 'G' : [':Gstatus'                          , 'status'],
      \ 'h' : [':GitGutterLineHighlightsToggle'    , 'highlight hunks'],
      \ 'H' : ['<Plug>(GitGutterPreviewHunk)'      , 'preview hunk'],
      \ 'j' : ['<Plug>(GitGutterNextHunk)'         , 'next hunk'],
      \ 'k' : ['<Plug>(GitGutterPrevHunk)'         , 'prev hunk'],
      \ 'l' : [':Git log'                          , 'log'],
      \ 'p' : [':Git push'                         , 'push'],
      \ 'P' : [':Git pull'                         , 'pull'],
      \ 'r' : [':GRemove'                          , 'remove'],
      \ 's' : ['<Plug>(GitGutterStageHunk)'        , 'stage hunk'],
      \ 't' : [':GitGutterSignsToggle'             , 'toggle signs'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)'         , 'undo hunk'],
      \ 'v' : [':GV'                               , 'view commits'],
      \ 'V' : [':GV!'                              , 'view buffer commits'],
      \ }

" l is for language server protocol
"nnoremap <silent> <leader>la    :LspCodeAction<CR>
"nnoremap <silent> <leader>ld    :LspDefinition<CR>
"nnoremap <silent> <leader>lf    :LspReferences<CR>
"nnoremap <silent> <leader>lh    :LspHover<CR>
"nnoremap <silent> <leader>lH    :LspPeekDefinition<CR>
"nnoremap <silent> <leader>lI    :LspDiagnostics<CR>
"nnoremap <silent> <leader>ln    :LspNextDiagnostic<CR>
"nnoremap <silent> <leader>lp    :LspPreviousDiagnostic<CR>
"nnoremap <silent> <leader>lr    :LspRename<CR>
let g:which_key_map.l = {
      \ 'name' : 'Language Server Protocol' ,
      \ }

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
