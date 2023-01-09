set nocompatible

" Plugins -------------------------------------------------------------------{{{
" set the runtime path to include Vundle and initialize
if !has('nvim')
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
      " let Vundle manage Vundle, required
      Plugin 'VundleVim/Vundle.vim'

      Plugin 'dense-analysis/ale'       " asynchronous linting engine
      Plugin 'tpope/vim-fugitive'       " integration with the git cli
      Plugin 'tpope/vim-surround'       " edits surrounding quotes and parens and the like
      Plugin 'tpope/vim-rails'          " rails project management stuff
      Plugin 'tpope/vim-repeat'         " fixes the . key for ...something
      " Plugin 'airblade/vim-gitgutter'   " in-file git integration
      Plugin 'mhinz/vim-signify'
      Plugin 'slim-template/vim-slim'   " what in the 2008 is this
      Plugin 'kchmck/vim-coffee-script' " lol coffee script
      Plugin 'fatih/vim-go'             " all-in-one Go tools
      Plugin 'fatih/vim-hclfmt'         " nicely formats hcl files
      Plugin 'nanotech/jellybeans.vim'  " the best colorscheme
      Plugin 'ervandew/supertab'        " makes tab better apparently
      Plugin 'scrooloose/nerdcommenter' " no idea if I'm even using this
      Plugin 'scrooloose/nerdtree'      " better file navigation
      Plugin 'Align'                    " aligns things on demand
      Plugin 'tomtom/tlib_vim'          " dependency of flashdevelop
      Plugin 'endel/flashdevelop.vim'   " this is probably old now
      Plugin 'ctrlpvim/ctrlp.vim'       " don't actually know how to use this honestly
      Plugin 'itchyny/lightline.vim'    " fancy status line
      Plugin 'heavenshell/vim-jsdoc'    " js docs?
      Plugin 'hashivim/vim-terraform'   " hclfmt but for terraform
      Plugin 'b4b4r07/vim-hcl'          " hcl syntax stuff?
      Plugin 'Glench/Vim-Jinja2-Syntax' " jinja2 syntax stuff
      Plugin 'rust-lang/rust.vim'       " bare minimum rust syntax stuff
      Plugin 'elubow/cql-vim'

      " Past plugins
      "
      " Seems to break NERDTree. I dunno why. Kinda problematic since it's
      " intended to improve NERDTree.
      " Plugin 'Xuyuanp/nerdtree-git-plugin'
      "
      " Still figuring this one out. I think I hate it?
      " Plugin 'neoclide/coc.nvim'
      "
      " this repo is gone
      " Plugin 'calviken/vim-gdscript3'
      "
      " I'm trying ALE instead
      " Plugin 'ycm-core/YouCompleteMe'
      " Plugin 'prabirshrestha/vim-lsp'
      " Plugin 'mattn/vim-lsp-settings'
  call vundle#end()            " required
endif

" enable the filetype plugin
filetype plugin indent on
" ---------------------------------------------------------------------------}}}

" Character Encoding --------------------------------------------------------{{{
" sets the character encoding used inside of vim itself. does not change how
" files are written to disk.
set encoding=utf-8

if has("multi_byte")
  " termencoding specifies what character encoding the keyboard produces and
  " the display will understand
  if &termencoding == ""
    let &termencoding = &encoding
  endif
endif
" ---------------------------------------------------------------------------}}}

" Whitespace ----------------------------------------------------------------{{{
" allow backspacing over line breaks
set backspace=indent,eol,start

" copy indent from current line when starting a new line
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
if has("multi_byte")
  set listchars=tab:▸\ ,trail:·,precedes:←,extends:→
  let &showbreak='↪ '
else
  set listchars=tab:>-,trail:.,precedes:#,extends:#
endif
" ---------------------------------------------------------------------------}}}

" Search --------------------------------------------------------------------{{{
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
" ---------------------------------------------------------------------------}}}

" Backup --------------------------------------------------------------------{{{
set nobackup
set nowritebackup
set noswapfile
" ---------------------------------------------------------------------------}}}

" Wild Menu -----------------------------------------------------------------{{{
" enable the wild menu.
set wildmenu

" list matches
set wildmode=list:full

set wildignore=.svn,CVS,.git        " ignore verson control files
set wildignore+=*.o,*.a,*.so        " ignore compiled binaries
set wildignore+=*.jpg,*.png,*.gif   " ignore images
set wildignore+=*.pdf               " ignore pdf documents
set wildignore+=*.pyc,*.pyo         " ignore compiled Python files
" ---------------------------------------------------------------------------}}}

" Mouse ---------------------------------------------------------------------{{{
" enable the mouse
if has('mouse')
  set mouse=a
endif

" hide the mouse when typing
set mousehide

" open up directories with a single click instead of needing to double-click
let g:NERDTreeMouseMode = 2

" mouse is always on in nvim anyway
if !has('nvim')
    " this fixes the WSL mouse not working beyond column 95 but I have no idea why
    set ttymouse=sgr
endif
" ---------------------------------------------------------------------------}}}

" Colorscheme ---------------------------------------------------------------{{{
if &t_Co > 2 || has("gui_running")
  " enable syntax highlighting
  syntax on

  " enable 256-color mode
  set t_Co=256

  " background-color erasing corrections to tell vim to fill the background
  " from our colorscheme instead of from the terminal default
  if (&term =~ '^xterm')
    set t_ut= | set ttyscroll=1
  endif

  " this should not do anything but it does.
  set termguicolors

  let g:jellybeans_use_term_italics = 1
  let g:jellybeans_overrides = {
  \    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
  \}
  
  if has('termguicolors') && &termguicolors
      let g:jellybeans_overrides['background']['guibg'] = 'none'
  endif

  try
    colorscheme jellybeans
  catch
    silent! colorscheme delek
  endtry


endif
" ---------------------------------------------------------------------------}}}

" Autocmd Hooks -------------------------------------------------------------{{{
if has("autocmd")
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    autocmd!

    autocmd BufNewFile,BufRead *.zig set filetype=zig
    autocmd BufNewFile,BufRead *.txt set filetype=text
    autocmd BufNewFile,BufRead *.gd set filetype=gdscript3

    " on some machines md files are thought to be modula2
    autocmd BufNewFile,BufRead *.md set filetype=markdown

    autocmd BufNewFile,BufRead *.tf set filetype=terraform

    " add Coloring for ChucK source
    autocmd BufNewFile,BufRead *.ck set filetype=ck

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
    if !has('nvim')
      autocmd FileType rust set omnifunc=ale#completion#OmniFunc
    endif

    " causes VIM to enter the directory of the file being edited to simplify
    " finding related files.
    " autocmd BufEnter * silent! lcd %:p:h

    autocmd FileType go :iabbrev iff if {<cr>}<up><right>
    autocmd FileType javascript :iabbrev iff if
    autocmd FileType javascript :iabbrev fun function
  augroup END
else

endif
" ---------------------------------------------------------------------------}}}

" Status Line ---------------------------------------------------------------{{{
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
\     'gitbranch': 'FugitiveHead',
\     'llreadonly': 'LightlineReadonly'
\   }
\ }

" }}}

" Normal|Visual|Operator-Pending Mode {{{
" ctrl-k to go to the next tab
noremap <C-k> :tabnext<CR>

" ctrl-j to go to the previous tab
noremap <C-j> :tabprevious<CR>

" ctrl-n to open a new tab with the current file
noremap <C-n><C-n> :tabnew %<CR>

noremap <C-n><o> :tab term<CR>
noremap <C-n><C-o> :tab term<CR>

" move by visual lines when moving instead of physical lines
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$

" ---------------------------------------------------------------------------}}}

" Normal Mode ---------------------------------------------------------------{{{
" toggle line numbering with <leader>n
nnoremap <leader>n :set number!<CR>
set number

" Shortcut to show invisible characters
nnoremap <leader>l :set list!<CR>

" leader pe (prefs edit) to edit your vimrc
nnoremap <leader>pe :vsplit $MYVIMRC<cr>

" leader ps (prefs source) to source your vimrc
nnoremap <leader>ps :source $MYVIMRC<cr>

" leader ci inverts comment states on a line by line basis
noremap <Leader>ci NERDComInvertComment

" ---------------------------------------------------------------------------}}}

" Git -----------------------------------------------------------------------{{{
let g:signify_disable_by_default = 1

" toggle the signify sign column on and off
nmap <leader>vs :SignifyToggle<CR>

" toggle line-level highlighting in signify
nmap <leader>vl :SignifyToggleHighlight<CR>

" diff the current file with signify
nmap <leader>vd :SignifyDiff<CR>

nmap <leader>vc :Git commit<CR>
nmap <leader>vp :Git push<CR>
nmap <leader>va :Git add %<CR>

nmap <leader>vj <plug>(signify-next-hunk)
nmap <leader>vk <plug>(signify-prev-hunk)

omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)
" ---------------------------------------------------------------------------}}}

" Insert Mode ---------------------------------------------------------------{{{
" Ctrl-U deletes from the current position to the start of the line.
inoremap <C-U> <C-G>u<C-U>

iabbrev @@ @jordanorelli
" ---------------------------------------------------------------------------}}}

" Command Mode --------------------------------------------------------------{{{
" new command mode command: w!!
" allows you to sudo write the file you're currently editing without closing
" (and thus losing) your changes.
cnoremap w!! w !sudo tee % >/dev/null

" command mode abbreviation :vhelp to open help text in a vertical split
" instead of a horizontal split.
cabbrev vhelp vertical help

" prevents editing a file named "~", which I literally never want.
cabbrev ~ $HOME
" ---------------------------------------------------------------------------}}}

" Terminal Mode -------------------------------------------------------------{{{

" ctrl-k to go to the next tab
tnoremap <C-k> <C-w>:tabnext<CR>

" ctrl-j to go to the previous tab
tnoremap <C-j> <C-w>:tabprevious<CR>

" ctrl-n-n to create a new tab with an empty buffer
tnoremap <C-n><n> <C-w>:tabnew<CR>
tnoremap <C-n><C-n> <C-w>:tabnew<CR>

" ctrl-shift-n creates a new tab with a terminal
tnoremap <C-n><o> <C-w>:tab term<CR>
tnoremap <C-n><C-o> <C-w>:tab term<CR>

let g:terminal_ansi_colors = [
  \ '#929292',
  \ '#e27373',
  \ '#94b979',
  \ '#ffba7b',
  \ '#97bedc',
  \ '#e1c0fa',
  \ '#00988e',
  \ '#dedede',
  \ '#bdbdbd',
  \ '#ffa1a1',
  \ '#bddeab',
  \ '#ffdca0',
  \ '#b1d8f6',
  \ '#fbdaff',
  \ '#1ab2a8',
  \ '#ffffff'
  \ ]

if !has('nvim')
  autocmd TerminalOpen * set nonu
endif

highlight Terminal guibg='#0c0c0c'
highlight Terminal guifg='#cccccc'

function! ExitNormalMode()
    unmap <buffer> <silent> <RightMouse>
    call feedkeys("a")
endfunction

function! EnterNormalMode()
    if &buftype == 'terminal' && mode('') == 't'
        call feedkeys("\<c-w>N")
        call feedkeys("\<c-y>")
        map <buffer> <silent> <RightMouse> :call ExitNormalMode()<CR>
    endif
endfunction

tmap <silent> <ScrollWheelUp> <c-w>:call EnterNormalMode()<CR>
" ---------------------------------------------------------------------------}}}

" Operator-Pending Mode -----------------------------------------------------{{{
" new text object: "next paren". means the next open paren on the current
" line.
onoremap in( :<c-u>normal! f(ci(<cr>

" new text object: "last paren". means the previous open paren on the current
" line. (using p would shadow the paragraph object)
onoremap il( :<c-u>normal! F)vi(<cr>
" ---------------------------------------------------------------------------}}}

" Supertab ------------------------------------------------------------------{{{
" use omnicomplete by default
" let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabClosePreviewOnPopupClose = 1

" close doc window after finishing an autocomplete
" let g:SuperTabClosePreviewOnPopupClose = 1
" ---------------------------------------------------------------------------}}}

" YouCompleteMe -------------------------------------------------------------{{{
"
" I've stopped using this because the install process was too crazy
"
" let g:ycm_keep_logfiles = 1
" let g:ycm_log_level = 'debug'
" let g:ycm_language_server =
"       \ [
"       \   {
"       \     'name': 'zig',
"       \     'cmdline': [ 'zls', '--debug-log' ],
"       \     'filetypes': [ 'zig' ],
"       \   }
"       \ ]
" ---------------------------------------------------------------------------}}}

" ALE -----------------------------------------------------------------------{{{
if !has('nvim')
  let g:ale_linters = {'rust': ['analyzer']}
  let g:ale_fixers = {'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines']}
  let g:rustfmt_autosave = 1
  let g:ale_rust_analyzer_executable = "/home/jorelli/analyzer-spy"
  let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
  let g:ale_completion_enabled = 1
  set completeopt=menu,menuone,preview,noselect,noinsert
endif
" ---------------------------------------------------------------------------}}}

" CtrlP ---------------------------------------------------------------------{{{
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = [
      \ '.git',
      \ 'cd %s && git ls-files -co --exclude-standard'
      \ ]
" ---------------------------------------------------------------------------}}}

" NERDTree ------------------------------------------------------------------{{{
if has("multi_byte")
  let g:NERDTreeDirArrowExpandable = '▸'
  let g:NERDTreeDirArrowCollapsible = '▾'
else
  let g:NERDTreeDirArrowExpandable = '+'
  let g:NERDTreeDirArrowCollapsible = '-'
endif

" enable dir tree arrows
let g:NERDTreeDirArrows = 1
" ---------------------------------------------------------------------------}}}

" terraform -----------------------------------------------------------------{{{
let g:terraform_align=1
let g:terraform_fmt_on_save=1
" ---------------------------------------------------------------------------}}}

" Commenting ----------------------------------------------------------------{{{
" left-align comment markers by default
let g:NERDDefaultAlign='left'
" insert a space after comment markers
let g:NERDSpaceDelims=1

vmap K <Plug>NERDCommenterToggle('n', 'Toggle')<Cr>
nmap KK <Plug>NERDCommenterToggle('n', 'Toggle')<Cr>
" ---------------------------------------------------------------------------}}}

" Misc ----------------------------------------------------------------------{{{
" keep 50 lines of command line history
set history=50

" show commands as you type them (mostly for leader-based stuff)
set showcmd

" wrap long lines
set wrap

" force line wrapping to only happen at word boundaries
set linebreak

" wait 200ms after typing for updates (default is 4000)
set updatetime=200

" set current working directory on file enter
set autochdir

" match angle brackets
set matchpairs+=<:>

" use visual bell instead of beeping
set visualbell

" you know what, just disable the error bells entirely
set noerrorbells

" highlight the cursor line only in the current window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" integrate the wsl clipboard for yanking to the system clipboard
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif
" ---------------------------------------------------------------------------}}}

