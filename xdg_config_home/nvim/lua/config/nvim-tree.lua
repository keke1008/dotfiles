return function ()
  local vimp = require'vimp'
  vimp.nnoremap('<leader>ep', '<CMD>NvimTreeFindFile<CR>')
  vimp.nnoremap('<leader>er', '<CMD>NvimTreeRefreash<CR>')

  local tree = require'nvim-tree.view'
  tree.View.width = 35
  vim.g.nvim_tree_auto_open = 1
  vim.g.nvim_tree_tab_open = 1
end
