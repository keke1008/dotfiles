"dein Scripts-----------------------------
if has('unix')
  let s:workdir = expand('~/.config/nvim/')
elseif has('win32')
  let s:workdir = expand('~/AppData/Local/nvim/')
endif
let g:plugin_dir = s:workdir . 'plugins/'
let s:dein_dir = expand('~/.cache/dein/')
let s:dein_repo_dir = s:dein_dir . 'repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  echo "downloading dein.vim"
  call system('mkdir ' . shellescape(s:dein_repo_dir) . '-p')
  call system('git clone https://github.com/Shougo/dein.vim '. shellescape(s:dein_repo_dir))
endif

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
execute 'set runtimepath+=' . s:dein_repo_dir

" Required:
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " Add or remove your plugins here like this:

  execute 'source ' . g:plugin_dir . 'lazy.vim'
  execute 'source ' . g:plugin_dir . 'load.vim'

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

call dein#recache_runtimepath()

"End dein Scripts-------------------------

