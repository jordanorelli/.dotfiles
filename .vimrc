set nocompatible

" Plugins {{{
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-rails'
    Plugin 'tpope/vim-repeat'
    Plugin 'slim-template/vim-slim'
    Plugin 'kchmck/vim-coffee-script'
    Plugin 'fatih/vim-go'
    Plugin 'nanotech/jellybeans.vim'
    Plugin 'ervandew/supertab'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'scrooloose/nerdtree'
    Plugin 'Align'
    Plugin 'tomtom/tlib_vim' " dependency of flashdevelop
    Plugin 'endel/flashdevelop.vim'
    Plugin 'airblade/vim-rooter'
    Plugin 'airblade/vim-gitgutter'
    Plugin 'ctrlpvim/ctrlp.vim'
    Plugin 'itchyny/lightline.vim'
    Plugin 'heavenshell/vim-jsdoc'

    " Past plugins
    "
    " Seems to break NERDTree. I dunno why. Kinda problematic since it's
    " intended to improve NERDTree.
    " Plugin 'Xuyuanp/nerdtree-git-plugin'
call vundle#end()            " required

" enable the filetype plugin
filetype plugin indent on

" }}}

" Whitespace {{{
" allow backspacing over line breaks
set backspace=indent,eol,start

" copy indent form current line when starting a new line
set autoindent

" automatically add an indent after block-opening symbols like {
set smartindent

" display tab as 4 characters wide instead of 8
set tabstop=4

" use 4 spaces when creating a new indentation level with autoindentation
set shiftwidth=4

" tab key inserts spaces
set expandtab

" no matter how many times I read the help text on this I still don't
" understand what it does, but I've had it in here for years so I'm just
" leaving it.
set smarttab

" set whitespace characters
set listchars=tab:>-,trail:.,extends:#
" }}}

" Search {{{
" perform searches incrementally
set incsearch

" perform case-insensitive searches
set ignorecase

" if a search term includes upper case letters, use a cast-sensitive search
set smartcase

" highlights the last searched pattern
set hlsearch

" press escape twice to clear highlight search
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>
" }}}

" Backup {{{
set nobackup
set nowritebackup
set noswapfile
" }}}

set history=50                      " keep 50 lines of command line history

" show commands as you type them
set showcmd

" wrap long lines
set wrap

" force line wrapping to only happen at word boundaries
set linebreak

set updatetime=750                  " wait 750ms after typing for updates

set autochdir                       " set current working directory on file enter

" no beeping {{{
" use visual bell instead of beeping
set visualbell

" you know what, just disable the error bells entirely
set noerrorbells
"}}}

" Wild Menu {{{

" enabled the wild menu.
set wildmenu

" list matches
set wildmode=list:full

set wildignore=.svn,CVS,.git        " ignore verson control files
set wildignore+=*.o,*.a,*.so        " ignore compiled binaries
set wildignore+=*.jpg,*.png,*.gif   " ignore images
set wildignore+=*.pdf               " ignore pdf documents
set wildignore+=*.pyc,*.pyo         " ignore compiled Python files
" }}}


set matchpairs+=<:>                 " match angle brackets

" sets the character encoding used inside of vim itself. does not change how
" files are written to disk.
set encoding=utf-8

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Mouse {{{
" enable the mouse
if has('mouse')
  set mouse=a
endif

" hide the mouse when typing
set mousehide
" }}}

" Set Colorscheme {{{
if &t_Co > 2 || has("gui_running")
  " enable syntax highlighting
  syntax on

  " enable 256-color mode
  set t_Co=256

  try
    colorscheme jellybeans
  catch
    silent! colorscheme delek
  endtry

endif
" }}}

if has("autocmd")
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    autocmd!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " on some machines md files are thought to be modula2
    autocmd BufNewFile,BufRead *.md set filetype=markdown

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS

    " causes VIM to enter the directory of the file being edited to simplify
    " finding related files.
    " autocmd BufEnter * silent! lcd %:p:h

    autocmd FileType go :iabbrev iff if {<cr>}<up><right>
    autocmd FileType javascript :iabbrev iff if
    autocmd FileType javascript :iabbrev fun function

    " add proper coloring for my .localrc file
    au BufNewFile,BufRead .localrc call SetFileTypeSH("bash")

    " add Coloring for ChucK source
    au! BufNewFile,BufRead *.ck setf ck
  augroup END
else

endif " has("autocmd")

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
endif

" Shortcut to show invisible characters
nnoremap <leader>l :set list!<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tab navigation helpers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctrl-k to go to the next tab
noremap <C-k> :tabn<CR>
" ctrl-j to go to the previous tab
noremap <C-j> :tabp<CR>
" ctrl-n to open a new tab with the current file
noremap <C-n> :tabnew %<CR>

nnoremap <leader>n :set nu!<CR>


" use omnicomplete by default
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" close doc window after finishing an autocomplete
let g:SuperTabClosePreviewOnPopupClose = 1

" supress go fmt errors on file write
let g:go_fmt_fail_silently = 1

" move by visual lines when mapping instead of physical lines
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = [
      \ '.git',
      \ 'cd %s && git ls-files -co --exclude-standard'
      \ ]

" open up directories with a single click instead of needing to double-click
let g:NERDTreeMouseMode = 2

" fix windows arrows. This gets rid of the pretty arrows on other systems,
" will have to restore that properly. The default switching behavior is broken
" inside of msys2.
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

" enable dir tree arrows
let g:NERDTreeDirArrows = 1

" By default all files and directories trigger vim-rooter. Setting the targets
" causes it to only trigger on directories.
let g:rooter_targets = '/'

" new command mode command: w!!
" allows you to sudo write the file you're currently editing without closing
" (and thus losing) your changes.
cnoremap w!! w !sudo tee % >/dev/null

" prevents editing a file named "~", which I literally never want.
cabbrev ~ $HOME

" leader ev to edit your vim rc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

nnoremap <leader>sv :source $MYVIMRC<cr>

iabbrev @@ @jordanorelli

noremap <Leader>ci NERDComInvertComment

let g:NERDDefaultAlign='left'
let g:NERDSpaceDelims=1

" new text object: "next paren". means the next open paren on the current
" line.
onoremap in( :<c-u>normal! f(ci(<cr>

" new text object: "last paren". means the previous open paren on the current
" line. (using p would shadow the paragraph object)
onoremap il( :<c-u>normal! F)vi(<cr>

" command mode abbreviation :vhelp to open help text in a vertical split
" instead of a horizontal split.
cabbrev vhelp vertical help


" Status Line settings {{{

" always show the status line
set laststatus=2

" don't display the current mode in the message line, we moved it to the
" status line.
set noshowmode

" don't show the readonly marker in help files, it's pointless.
function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction

let g:lightline = {
\   'colorscheme': 'jellybeans',
\   'active': {
\     'left': [
\       ['mode', 'paste'],
\       ['gitbranch'],
\       ['llreadonly', 'filename', 'modified']
\     ],
\     'right': [
\       ['lineinfo'],
\       ['filetype']
\     ]
\   },
\   'component_function': {
\     'gitbranch': 'fugitive#head',
\     'llreadonly': 'LightlineReadonly'
\   }
\ }

" }}}

" use explicit folds like this one when editing vimscript {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldlevelstart=0
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
