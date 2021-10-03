return function()
  local vimp = require'vimp'

  vimp.always_override = true
  
  vimp.nnoremap('j', 'gj')
  vimp.nnoremap('k', 'gk')
  vimp.nnoremap('+', ',')
  vimp.nmap({ 'silent' }, '<leader><Space>', '<CMD>noh<CR>')
  vimp.nmap({ 'expr' }, '<Esc>', 'len(@%) ? "<CMD>w<CR>" : "<Esc>"')
  
  
  if os.getenv('TMUX') then
    local change_active_pain = function(key_direction, tmux_option)
      return function()
        local id = vim.fn.win_getid()
        vim.cmd('normal!' .. utils.esc'<C-w>' .. key_direction)
        if id == vim.fn.win_getid() then
          os.execute('tmux select-pane ' .. tmux_option)
        end
      end
    end
    vimp.nnoremap('<C-w>h', change_active_pain("h", "-L"))
    vimp.nnoremap('<C-w>j', change_active_pain("j", "-D"))
    vimp.nnoremap('<C-w>k', change_active_pain("k", "-U"))
    vimp.nnoremap('<C-w>l', change_active_pain("l", "-R"))
  end
end
