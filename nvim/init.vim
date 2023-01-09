set nocompatible

filetype off

if has('win32')
  set rtp+=~/AppData/Local/nvim/bundle/Vundle.vim
else
  " set the runtime path to include Vundle and initialize
  set rtp+=~/.vim/bundle/Vundle.vim
endif

call vundle#begin()
  " let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'tpope/vim-fugitive'       " integration with the git cli
  Plugin 'tpope/vim-surround'       " edits surrounding quotes and parens and the like
  Plugin 'mhinz/vim-signify'
  Plugin 'fatih/vim-go'             " all-in-one Go tools
  Plugin 'fatih/vim-hclfmt'         " nicely formats hcl files
  Plugin 'nanotech/jellybeans.vim'  " the best colorscheme
  Plugin 'ervandew/supertab'        " makes tab better apparently
  Plugin 'scrooloose/nerdcommenter' " no idea if I'm even using this
  Plugin 'scrooloose/nerdtree'      " better file navigation
  Plugin 'Align'                    " aligns things on demand
  Plugin 'itchyny/lightline.vim'    " fancy status line
  Plugin 'hashivim/vim-terraform'   " hclfmt but for terraform
  Plugin 'Glench/Vim-Jinja2-Syntax' " jinja2 syntax stuff
  Plugin 'rust-lang/rust.vim'       " bare minimum rust syntax stuff
call vundle#end()

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
filetype plugin indent on
source ~/.vimrc
