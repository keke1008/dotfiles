vim.cmd"command Layout lua require'commands'.layout()"

return {
  layout = function ()
    local trouble = require'trouble'
    local nvim_tree = require'nvim-tree'

    trouble.close()
    nvim_tree.close()
    local win_id = vim.api.nvim_get_current_win()

    if #vim.lsp.get_active_clients() >= 1 then
      trouble.open()
    end

    nvim_tree.open()

    vim.api.nvim_set_current_win(win_id)
  end
}
