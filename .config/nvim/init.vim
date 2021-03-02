runtime! plugins/plugins.vim

set number
set cursorline
set cursorcolumn

set cmdheight=2
set laststatus=2
set showcmd

" It makes vim slow.
" set clipboard=unnamed,unnamedplus

set fenc=utf-8
set nobackup
set noswapfile

set smartindent
set expandtab
set tabstop=2
set shiftwidth=2

set ignorecase
set smartcase
set incsearch

nnoremap j gj
nnoremap k gk

" Press escape to save file
nnoremap <silent> <expr> <esc> len(@%) ? "<Esc>:w<CR>" : "<Esc>"
nnoremap <silent> <space><space> :noh<CR>

" Run ':termdebug' to debug
augroup loadDebug
  autocmd!
  autocmd VimEnter * packadd termdebug
  autocmd FileType rust let termdebugger = "rust-gdb"
augroup end
