_G.dotfiles.sneak = {
  init = function ()
    vim.api.nvim_del_keymap('', 's')
    vim.api.nvim_del_keymap('', 'S')
    vim.api.nvim_del_keymap('', ',')
    vim.api.nvim_del_keymap('', ';')
    local vimp = require'vimp'
    vimp.nmap({ 'silent' }, ';', '<Plug>Sneak_s')
    vimp.nmap({ 'silent' }, '+', '<Plug>Sneak_S')
  end
}

return function()
  vim.g['sneak#s_next'] = 1
  vim.g['sneak#prompt'] = 'sneak =>>' 
  vim.cmd'autocmd VimEnter * ++once lua _G.dotfiles.sneak.init()'
end
