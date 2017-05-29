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
set laststatus=2                    " always show the status line

" set scrolloff=3                     " scroll when 3 lines from edge
" set sidescroll=5                    " scroll when 5 chars from the right
set wrap                            " wrap text
set linebreak                       " soft text wrapping

set nobackup                        " disable temporary files.
set nowritebackup
set noswapfile
set updatetime=750                  " wait 750ms after typing for updates
" set hidden                          " hide buffers instead of closing them

set visualbell                      " don't beep
set noerrorbells                    " don't beep

set wildmenu                        " enabled the wild menu.
set wildmode=list:full              " list matches
set wildignore=.svn,CVS,.git        " ignore verson control files
set wildignore+=*.o,*.a,*.so        " ignore compiled binaries
set wildignore+=*.jpg,*.png,*.gif   " ignore images
set wildignore+=*.pdf               " ignore pdf documents
set wildignore+=*.pyc,*.pyo         " ignore compiled Python files

set mousehide                       " hides the mouse when typing

set autochdir                       " set current working directory on file enter

set noshowmode                      " not necessary with the status line plugin

set listchars=tab:>-,trail:.,extends:#

set matchpairs+=<:>                 " match angle brackets

set encoding=utf8
set fillchars=vert:│

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
  try
    colorscheme jellybeans
  catch
    silent! colorscheme delek
  endtry
endif

if has("autocmd")
  filetype plugin indent on         " Enable file type detection.

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    " delete existing definitions for this group
    au!

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

" press escape twice to clear highlight search
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

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

" don't show the readonly marker in help files, it's pointless.
function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction

" status line configuration
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
