vim.cmd"command Layout lua require'commands'.layout()"

return {
  layout = function ()
    local win_id = vim.api.nvim_get_current_win()

    if #vim.lsp.get_active_clients() >= 1 then
      require'trouble'.open()
    end

    require'nvim-tree'.open()

    vim.api.nvim_set_current_win(win_id)
  end
}
