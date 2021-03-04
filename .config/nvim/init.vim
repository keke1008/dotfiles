if exists('g:vscode')
  let $VIMRUNTIME="/usr/share/nvim/runtime"
  set runtimepath+=/usr/share/nvim/runtime
endif

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
if !exists('g:vscode')
  nnoremap <silent> <expr> <esc> len(@%) ? "<Esc>:w<CR>" : "<Esc>"
endif

" Run ':termdebug' to debug
augroup loadDebug
  autocmd!
  autocmd VimEnter * packadd termdebug
  autocmd FileType rust let termdebugger = "rust-gdb"
augroup end
