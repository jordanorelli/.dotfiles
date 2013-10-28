if exists("g:loaded_Etsy") || &cp
    finish
endif

" version number
let g:loaded_Etsy = 0

" here be magic ----------------------------------------
" http://vim.wikia.com/wiki/How_to_write_a_plugin
" if !hasmapto('<Plug>Etsy')
"     map <unique> <Leader>E <Plug>AppFunction
" endif
" 
" map <silent> <unique> <script> <Plug>Etsy :set lz<CR>:call <SID>Etsy<CR>:set nolz<CR>
" /magic -----------------------------------------------
