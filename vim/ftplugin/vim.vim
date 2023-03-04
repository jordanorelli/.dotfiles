" open .vim files with all folds closed
set foldlevelstart=0

" vim folds include explicit markers
set foldmethod=marker

" automatically open folds when entering them
set foldopen=all

" automatically close folds when leaving them
set foldclose=all

set shiftwidth=2

set tabstop=2

" in normal mode, leader x will source the whole file
nnoremap <leader>x :source %<cr>

" in visual mode, leader x will source the selected lines
vnoremap <leader>x :<C-w>exe join(getline("'<","'>"),'<Bar>')<CR>
