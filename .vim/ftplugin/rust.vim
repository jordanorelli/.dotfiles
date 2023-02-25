" f5 runs the current project
nmap <F5> :!clear<CR>:!cargo run -q<CR>
nmap <S-F5> :!clear<CR>:!cargo run<CR>

" ctrl-f5 lets you run the current program but prompts you for the cli args
nmap <C-F5> :!clear<CR>:!cargo run -- 

nmap <F6> :!clear<CR>:!cargo run<CR>
nmap <F7> :!clear<CR>:!cargo check<CR>
nmap <F8> :!clear<CR>:!cargo test<CR>
