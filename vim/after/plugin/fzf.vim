" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
\ 'bg':      ['bg', 'Normal'],
\ 'hl':      ['fg', 'Comment'],
\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
\ 'hl+':     ['fg', 'Statement'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Ignore'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment'] }

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_buffers_jump = 1


"Tells us if the current directry is the home config directory
"Requres the FindRootDirectory method from vim-rooter
function IsConfig()
        return FindRootDirectory() == $XDG_CONFIG_HOME
endfunction

"Sets default FZF Command to be rg which ignores the git excludes by default
"In our case, we want to re include any manual excludes we did on git if we are in the .config directory
function SetDefaultFZFCommands()
        let extraarguments = ""
        if IsConfig()
                let extraarguments = "--no-ignore-exclude"
        endif
        let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' " . extraarguments
endfunction

augroup fzfcommands
        autocmd!
        "Don't ignore the git excludes if we are in the .config directory
        autocmd VimEnter,BufEnter,BufWritePost * nested if empty(&buftype) | call SetDefaultFZFCommands() | endif
augroup END

