nnoremap <silent> <S-Esc> :noh<CR>
nnoremap <silent> <expr> <Esc> len(@%) ? "<Esc>:w<CR>" : "<Esc>"

nnoremap j gj
nnoremap k gk

call textobj#user#plugin('braces', {
      \ 'rect': {
      \    'pattern': ['[', ']'],
      \    'select-a': 'ar',
      \    'select-i': 'ir'
      \  }
      \})

call textobj#user#plugin('braces', {
      \ 'angle': {
      \    'pattern': ['<', '>'],
      \    'select-a': 'aa',
      \    'select-i': 'ia'
      \  }
      \})
