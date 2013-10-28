" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

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

" set list                            " show invisible characters.
set listchars=tab:>-,trail:.,extends:#

set matchpairs+=<:>                 " match angle brackets

" I never use this, but I never use Ex mode, either.
map Q gq

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

  " highlights interpolated variable in sql strings and does sql syntax
  autocmd FileType php let php_sql_query=1

  " highlight html inside of php strings
  autocmd FileType php let php_htmlInStrings=1

  " discourages the use of short tags.
  autocmd FileType php let php_noShortTags=1

  autocmd FileType php nmap <leader>x :w<CR>:silent !php %:p<CR>
  autocmd FileType php nmap <leader>X :w<CR>:silent !php %:p
  autocmd FileType php nmap <leader>sx :w<CR>:silent !php %:p >> /tmp/$LOGNAME\screen-out<CR>:redraw<CR>

  " set PHP coding standard
  let Vimphpcs_Standard='/home/jorelli/development/Etsyweb/tests/standards/stable-ruleset.xml'
  " automatically codesniff all php code on file write.
  " autocmd BufWritePost *.php silent! :CodeSniff

  au BufRead,BufNewFile *.tpl set filetype=smarty

  " automagically folds functions & methods.
  " autocmd FileType php let php_folding=1

  " end PHP stuff

  autocmd FileType python nmap <leader>x :w<CR>:silent !python %:p<CR>
  autocmd FileType python nmap <leader>X :w<CR>:silent !python %:p
  autocmd FileType python nmap <leader>sx :w<CR>:!python %:p >> /tmp/$LOGNAME\screen-out 2>&1<CR><CR>

  " add proper coloring for my .localrc file
  au BufNewFile,BufRead .localrc call SetFileTypeSH("bash")

  " add Coloring for ChucK source
  au! BufNewFile,BufRead *.ck setf ck

else

endif " has("autocmd")


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    " set encoding=utf-8
    " setglobal fileencoding=utf-8 bomb
    " set fileencodings=ucs-bom,utf-8,latin1
endif

" Shortcut to show invisible characters
nmap <leader>l :set list!<CR>

" ctrl-shift-J appends the current line to the line below it
nmap <C-S-J> ddpkJ

map <C-k> :tabn<CR>
map <C-j> :tabp<CR>
map <C-n> :tabnew %<CR>

" swap current line with the line below
nmap <leader>s jddkP=j
" swap current line with the line above
nmap <leader>S kddp=kj

" jump to last non-blank line preceding a blank line
nmap <leader>f j/^[\s\t]*$/-1 <CR>

nmap <leader>i gg=G``

nmap <leader>n :set nu!<CR>

" Shows/Hides the Project Plugin
nmap <silent> <F2> <Plug>ToggleProject

" Shows/Hides the Taglist Plugin, which I never use.
nnoremap <silent> <F3> :TlistToggle<CR>

" Shows/Hides the NERDTree
nmap <F4> :NERDTreeToggle<CR>

map <F8> :vertical wincmd f<CR>

" closes the current buffer
nmap <F10> :bd<CR>
nmap <C-q> :bd<CR>

" press escape twice to clear highlight search
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Project.vim prefs
let g:proj_flags = "imstbc"
let g:proj_window_width = 30

" TagList prefs
let Tlist_Exit_OnlyWindow = 1               " Close Vim if the taglist is the
                                            " only window.
" let Tlist_Close_On_Select = 1               " Close the taglist window when a file or tag is selected.
let Tlist_GainFocus_On_ToggleOpen = 1       " Jump to taglist window on open.
let Tlist_Process_File_Always = 1           " Process files even when the taglist window is closed.
let Tlist_Compact_Format = 1                " Don't space out the tags.  Lets you fit more, but it's uglier.
let Tlist_WinWidth = 30

set tags=./tags;/
map <C-w><C-]> :vsp <CR><C-]>

map <Leader>x :!emacs %<CR>
vmap <Leader>s : ! skeam -prompt=""<CR>

set path+='/home/jorelli/development/Etsyweb/templates/'
set completeopt-=preview
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

set path+=~/development/Etsyweb/templates
set path+=~/development/Etsyweb/htdocs/assets/js
set path+=~/development/Etsyweb/htdocs/assets/css
