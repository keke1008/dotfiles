return function()
  require'trouble'.setup {
    action_keys = {
      open_folds = 'o',
      jump = 'o',
    },
  }

  local nnoremap = require'vimp'.nnoremap

  nnoremap({ 'silent' }, '<leader>tr', '<CMD>Trouble<CR>')
end
