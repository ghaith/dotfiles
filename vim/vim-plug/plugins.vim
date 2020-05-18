" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
   autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"vim-plug setup
call plug#begin('~/.config/vim/plugged')

"Use vim signify to show changes in VCS
"if has('nvim') || has('patch-8.0.902')
"  Plug 'mhinz/vim-signify'
"else
"  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
"endif
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
"Start Screen
Plug 'mhinz/vim-startify'
"Polyglog : better syntax support
Plug 'sheerun/vim-polyglot'

"Which Key : Press space to show shortcuts
Plug 'liuchengxu/vim-which-key'

"Rust language support
Plug 'rust-lang/rust.vim'
"Syntax check plugin
Plug 'vim-syntastic/syntastic'
"Tagbar
Plug 'majutsushi/tagbar'

"Load auto completion plugin
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-buffer.vim'
"
""Load language server
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'


"Use COC for autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"

"Toggle relative numbers automatically
Plug 'jeffkreeftmeijer/vim-numbertoggle'

"CtrlP File finder
Plug 'ctrlpvim/ctrlp.vim'

"Quick Scope make navigating easier
Plug 'unblevable/quick-scope'  

"Surround plugin, use with ys cs, ds
Plug 'tpope/vim-surround'

"Sneak plugin - Enables two word searches with s
Plug 'justinmk/vim-sneak'

"Python LSP
Plug 'ryanolsonx/vim-lsp-python'

"Solarized Theme
Plug 'altercation/vim-colors-solarized'

"Dracula color theme
Plug 'dracula/vim', { 'as' : 'dracula' }

"Ranger support 
Plug 'francoiscabrol/ranger.vim'

"Plugin to not close the window when closing the buffer
Plug 'rbgrouleff/bclose.vim'

"Support for fzf in vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"Make vim use the root .git directory if available
Plug 'airblade/vim-rooter'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
     \|   PlugInstall --sync | q
  \| endif
