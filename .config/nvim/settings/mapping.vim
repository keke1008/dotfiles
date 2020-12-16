nnoremap <silent> <Esc><Esc> :noh<CR>
inoremap <silent> <expr> <Esc> len(@%) ? "<Esc>:w<CR>" : "<Esc>"
