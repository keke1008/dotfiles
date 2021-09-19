return function() 
  local map = vim.api.nvim_set_keymap
  map('n', 'ga', '<Plug>(EasyAlign)', {})
  map('x', 'ga', '<Plug>(EasyAlign)', {})
end

