return function()
  local utils = require'utils'
  local vimp = require'vimp'

  vimp.nmap('[g', '<Plug>(coc-diagnostic-prev)')
  vimp.nmap(']g', '<Plug>(coc-diagnostic-next)')
  vimp.nmap('gd', '<Plug>(coc-definition)')
  vimp.nmap('gy', '<Plug>(coc-type-definition)')
  vimp.nmap('gi', '<Plug>(coc-implementation)')
  vimp.nmap('gr', '<Plug>(coc-references)')

  show_documentation = function()
    if vim.bo.filetype == 'vim' or vim.bo.filetype == 'help' then
      vim.cmd('h ' .. vim.fn.expand('<cword>'))
    elseif vim.fn['coc#rpc#ready']() == 1 then
      vim.cmd 'call CocActionAsync("doHover")'
    else 
      vim.cmd('!' .. vim.o.keywordprg .. ' ' .. expand('<cword>'))
    end
  end
  vimp.nnoremap('K', show_documentation)


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

  local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):find('%s') ~= nil
  end
    
  local handle_tab = function() 
    if vim.fn.pumvisible() == 1 then
      return utils.esc'<C-n>'
    elseif check_back_space() then
      return utils.esc'<Tab>'
    else
      return vim.fn['coc#refresh']()
    end
  end

  vimp.inoremap({ 'expr' }, '<Tab>', handle_tab)
end
