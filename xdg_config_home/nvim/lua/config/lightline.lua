return function()
  vim.g.lightline = {
    colorscheme = 'landscape',
    active = {
      left = {
        { 'mode', 'paste' },
        { 'readonly', 'filename', 'modified' },
        { 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings' },
        { 'coc_status' }
      }
    },
	}
  vim.fn['lightline#coc#register']()
end
