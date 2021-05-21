if getenv("TMUX") != v:null
  function! s:ChangeFocusWindow(key, tmux_option) abort
    let id = win_getid()
    execute "normal! \<C-w>" . a:key
    if id == win_getid()
      call system("tmux select-pane " . a:tmux_option)
    endif
  endfunction

  nnoremap <C-w>h <CMD>call <SID>ChangeFocusWindow("h", "-L")<CR>
  nnoremap <C-w>j <CMD>call <SID>ChangeFocusWindow("j", "-D")<CR>
  nnoremap <C-w>k <CMD>call <SID>ChangeFocusWindow("k", "-U")<CR>
  nnoremap <C-w>l <CMD>call <SID>ChangeFocusWindow("l", "-R")<CR>
endif

if !exists("g:vscode")
  nnoremap <silent> <expr> <esc> len(@%) ? "<Esc>:w<CR>" : "<Esc>"
endif

