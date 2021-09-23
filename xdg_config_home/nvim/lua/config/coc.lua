return function()
  local utils = require'utils'
  local vimp = require'vimp'

  vimp.nmap('[g', '<Plug>(coc-diagnostic-prev)')
  vimp.nmap(']g', '<Plug>(coc-diagnostic-next)')
  vimp.nmap('gd', '<Plug>(coc-definition)')
  vimp.nmap('<leader>vgd', '<C-w>vgd')
  vimp.nmap('<leader>sgd', '<C-w>sgd')
  vimp.nmap('gy', '<Plug>(coc-type-definition)')
  vimp.nmap('<leader>vgy', '<C-w>vgy')
  vimp.nmap('<leader>sgy', '<C-w>sgy')
  vimp.nmap('gi', '<Plug>(coc-implementation)')
  vimp.nmap('<leader>vgi', '<C-w>vgi')
  vimp.nmap('<leader>sgi', '<C-w>sgi')
  vimp.nmap('gr', '<Plug>(coc-references)')
  vimp.nmap('<leader>vgr', '<C-w>vgr')
  vimp.nmap('<leader>sgr', '<C-w>sgr')

  vimp.nmap('<leader>rn', '<Plug>(coc-rename)')
  vimp.nmap('<leader>ac', '<Plug>(coc-codeaction)')
  vimp.nmap('<leader>qf',  '<Plug>(coc-fix-current)')
  vimp.omap('if', '<Plug>(coc-funcobj-a)')
  vimp.xmap('if', '<Plug>(coc-funcobj-a)')
  vimp.omap('af', '<Plug>(coc-funcobj-a)')
  vimp.xmap('af', '<Plug>(coc-funcobj-a)')
  vimp.omap('ic', '<Plug>(coc-classobj-i)')
  vimp.xmap('ic', '<Plug>(coc-classobj-i)')
  vimp.omap('ac', '<Plug>(coc-classobj-a)')
  vimp.xmap('ac', '<Plug>(coc-classobj-a)')

  vimp.nnoremap('K', function()
    if vim.bo.filetype == 'vim' or vim.bo.filetype == 'help' then
      vim.cmd('h ' .. vim.fn.expand('<cword>'))
    elseif vim.fn['coc#rpc#ready']() == 1 then
      vim.cmd 'call CocActionAsync("doHover")'
    else
      vim.cmd('!' .. vim.o.keywordprg .. ' ' .. vim.fn.expand('<cword>'))
    end
  end)

  vimp.inoremap({ 'expr' }, '<Tab>', function()
    if utils.pumvisible() then
      return utils.esc'<C-n>'
    else
      local char_before_cursor = utils.get_cursor_char(-1)
      if char_before_cursor:find('%s') or char_before_cursor == '' then
        return utils.esc'<Tab>'
      else
        return vim.fn['coc#refresh']()
      end
    end
  end)

  vimp.inoremap({ 'expr' }, '<S-Tab>', function()
    return utils.esc(utils.pumvisible() and '<C-p>' or '<C-h>')
  end)

  vimp.inoremap({ 'expr', 'silent' }, '<CR>', function ()
    if utils.pumvisible() then
      if vim.fn.complete_info().selected == -1 then
        return utils.esc'<CR>'
      else
        return vim.fn['coc#_select_confirm']()
      end
    else
      return utils.esc'<CR><C-r>=AutoPairsReturn()<CR>'
    end
  end)

  vimp.imap('<C-h>', '<BS>')
  vimp.inoremap({ 'expr' }, '<BS>', function()
    local command = utils.esc'<C-r>=AutoPairsDelete()<CR>'
    if utils.get_cursor_char(-2):find('%w') then
      command = command .. utils.esc'<C-r>=coc#refresh()<CR>'
    end
    return command
  end)

end
