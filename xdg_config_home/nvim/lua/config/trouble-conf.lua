return function()
  require'trouble'.setup {
    action_keys = {
      open_folds = 'o',
      jump = 'o',
    },
  }

  local nnoremap = require'vimp'.nnoremap

  nnoremap({ 'silent' }, '<leader>t', '<CMD>Trouble<CR>')

  vim.cmd[[ autocmd User LspProgressUpdate ++once Trouble ]]
  vim.cmd[[ autocmd User LspProgressUpdate ++once execute "0 wincmd w" ]]
end
