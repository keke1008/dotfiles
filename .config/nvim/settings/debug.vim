augroup debugProgram
  autocmd!
  autocmd VimEnter * packadd termdebug
  autocmd FileType rust let termdebugger = "rust-gdb"
augroup end
