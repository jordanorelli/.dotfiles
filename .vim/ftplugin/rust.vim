if !has('nvim')
  nnoremap <buffer> <C-]> :ALEGoToDefinition<CR>
endif

nnoremap <F5> :Cargo run<CR>

let g:rustfmt_autosave = 1
