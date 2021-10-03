return function ()
  local vimp = require'vimp'
  vimp.nnoremap('<leader>ep', '<CMD>NvimTreeFindFile<CR>')

  require'nvim-tree'.setup {
    view = {
      width = 35
    },
    open_on_tab = true,
    open_on_setup = true
  }
end
