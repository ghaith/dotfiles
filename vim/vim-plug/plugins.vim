" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
   autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"vim-plug setup
call plug#begin('~/.config/vim/plugged')

"Show icons for different files
Plug 'ryanoasis/vim-devicons'

"Show buffers in the tab line 
source $HOME/.config/vim/vim-plug/buffet.vim

"Use gitgutter to show changes in VCS
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

"Polyglog : better syntax support
Plug 'sheerun/vim-polyglot'

"Which Key : Press space to show shortcuts
Plug 'liuchengxu/vim-which-key'

"Tagbar
Plug 'majutsushi/tagbar'

"Colors
Plug 'chrisbra/Colorizer'
"Load auto completion plugin
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'

""Load language server
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

"Plug 'mattn/vim-lsp-settings' "TODO look into this
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'piec/vim-lsp-clangd'
"Python LSP
Plug 'ryanolsonx/vim-lsp-python'

"Rust language support
Plug 'rust-lang/rust.vim'

"Toggle relative numbers automatically
Plug 'jeffkreeftmeijer/vim-numbertoggle'

"Quick Scope make navigating easier
Plug 'unblevable/quick-scope'  

"Surround plugin, use with ys cs, ds
Plug 'tpope/vim-surround'

"Solarized Theme
Plug 'altercation/vim-colors-solarized'

"Dracula color theme
Plug 'dracula/vim', { 'as' : 'dracula' }

"Make vim use the root .git directory if available
Plug 'airblade/vim-rooter'

"Fern for file explorer
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-devicons.vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"Tmux Support
Plug 'tmux-plugins/vim-tmux'

call plug#end()
" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
     \|   PlugInstall --sync | q
  \| endif
