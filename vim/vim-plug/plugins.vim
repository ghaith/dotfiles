" auto-install vim-plug
if empty(glob('~/.config/vim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
   autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"vim-plug setup
call plug#begin('~/.config/vim/plugged')

"Repeat
Plug 'tpope/vim-repeat'
"Comments 
Plug 'tpope/vim-commentary'
"Increment dates with C-a C-x
Plug 'tpope/vim-speeddating'
"Show icons for different files
Plug 'lambdalisue/nerdfont.vim'

"Show buffers in the tab line 
source $HOME/.config/vim/vim-plug/buffet.vim

"Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

"Use gitgutter to show changes in VCS
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
"Commit Browser
Plug 'junegunn/gv.vim'

"Polyglog : better syntax support
Plug 'sheerun/vim-polyglot'

"Which Key : Press space to show shortcuts
Plug 'liuchengxu/vim-which-key'

"Tagbar
"Plug 'majutsushi/tagbar'
Plug 'liuchengxu/vista.vim'

"Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Colors
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

"Load auto completion plugin
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-buffer.vim'
"Plug 'prabirshrestha/asyncomplete-file.vim'

""Load language server
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'

"Plug 'mattn/vim-lsp-settings'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Plug 'kevinoid/vim-jsonc'

"Nvim only
"if has('nvim')
"  Plug 'neovim/nvim-lspconfig'
"  Plug 'nvim-lua/completion-nvim'
"else 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"endif

"Need for formatting
Plug 'kana/vim-operator-user'

"Format C files
Plug 'rhysd/vim-clang-format'

"Rust language support
Plug 'rust-lang/rust.vim'

"Debugger
Plug 'mfussenegger/nvim-dap'

"Toggle relative numbers automatically
Plug 'jeffkreeftmeijer/vim-numbertoggle'

"Quick Scope make navigating easier
"Plug 'unblevable/quick-scope'  

"Sneak to jump around in the buffer
Plug 'justinmk/vim-sneak'

"Surround plugin, use with ys cs, ds
" Plug 'tpope/vim-surround'

"Color themes Plugins
"Solarized Theme
" Plug 'altercation/vim-colors-solarized'

"Dracula color theme
" Plug 'dracula/vim', { 'as' : 'dracula' }

Plug 'sainnhe/gruvbox-material'
Plug 'gruvbox-community/gruvbox'

"Make vim use the root .git directory if available
Plug 'airblade/vim-rooter'

"Fern for file explorer
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'

" TODO : Remove 
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

"Treesitter for better syntax
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

"Tmux Support
Plug 'tmux-plugins/vim-tmux'

" Plug 'ThePrimeagen/vim-be-good', {'do': './install.sh'}

"Open Scad support
Plug 'sirtaj/vim-openscad'

call plug#end()
" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
     \|   PlugInstall --sync | q
  \| endif
