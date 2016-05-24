" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-rails'
    Plugin 'slim-template/vim-slim'
    Plugin 'kchmck/vim-coffee-script'
    Plugin 'fatih/vim-go'
    Plugin 'nanotech/jellybeans.vim'
    Plugin 'ervandew/supertab'
    Plugin 'scrooloose/nerdtree'

call vundle#end()            " required

filetype plugin indent on    " required


set backspace=indent,eol,start
set autoindent
set smartindent
set tabstop=4
set expandtab                       " holy war
set smarttab                        " I don't know what this does.
set shiftwidth=4

set history=50                      " keep 50 lines of command line history
set ruler                           " show the cursor position all the time
set showcmd                         " display incomplete commands
set incsearch                       " incremental searching
set ignorecase                      " case-insensitive searching
set smartcase

" set scrolloff=3                     " scroll when 3 lines from edge
" set sidescroll=5                    " scroll when 5 chars from the right
set wrap                            " wrap text
set linebreak                       " soft text wrapping

set nobackup                        " disable temporary files.
set nowritebackup
set noswapfile

set wildmenu                        " enabled the wild menu.
set wildmode=list:full              " list matches
set wildignore=.svn,CVS,.git        " ignore verson control files
set wildignore+=*.o,*.a,*.so        " ignore compiled binaries
set wildignore+=*.jpg,*.png,*.gif   " ignore images
set wildignore+=*.pdf               " ignore pdf documents
set wildignore+=*.pyc,*.pyo         " ignore compiled Python files

set mousehide                       " hides the mouse when typing

set listchars=tab:>-,trail:.,extends:#

set matchpairs+=<:>                 " match angle brackets

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

if &t_Co > 2 || has("gui_running")
  syntax on                         " turns on syntax highlighting
  set hlsearch                      " highlights the last searched pattern.
  set t_Co=256                      " enable 256 color mode
  colorscheme jellybeans
endif

if has("autocmd")
  filetype plugin indent on         " Enable file type detection.

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  augroup END

  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS

  " causes VIM to enter the directory of the file being edited to simplify
  " finding related files.
  autocmd BufEnter * cd %:p:h

  " add proper coloring for my .localrc file
  au BufNewFile,BufRead .localrc call SetFileTypeSH("bash")

  " add Coloring for ChucK source
  au! BufNewFile,BufRead *.ck setf ck
else

endif " has("autocmd")

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
endif

" Shortcut to show invisible characters
nmap <leader>l :set list!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tab navigation helpers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctrl-k to go to the next tab
map <C-k> :tabn<CR>
" ctrl-j to go to the previous tab
map <C-j> :tabp<CR>
" ctrl-n to open a new tab with the current file
map <C-n> :tabnew %<CR>

nmap <leader>n :set nu!<CR>

" press escape twice to clear highlight search
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" use omnicomplete by default
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" close doc window after finishing an autocomplete
let g:SuperTabClosePreviewOnPopupClose = 1

" supress go fmt errors on file write
let g:go_fmt_fail_silently = 1

" move by visual lines when mapping instead of physical lines
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$
