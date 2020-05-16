" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"vim-plug setup
call plug#begin(g:vim_home.'/plugged')

"Use vim signify to show changes in VCS
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

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
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'

"Load language server
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

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

call plug#end()
