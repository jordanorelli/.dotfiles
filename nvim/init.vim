set nocompatible

map <F12> :source $MYVIMRC<CR>

" Plugins -------------------------------------------------------------------{{{
" set the runtime path to include Vundle and initialize
if has('win32')
  set rtp+=~/AppData/Local/nvim/bundle/Vundle.vim
else
  set rtp+=~/.vim/bundle/Vundle.vim
endif

filetype off
call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'nanotech/jellybeans.vim'
  Plugin 'itchyny/lightline.vim'    " fancy status line
call vundle#end()

" enable the filetype plugin
filetype plugin indent on
" ---------------------------------------------------------------------------}}}
