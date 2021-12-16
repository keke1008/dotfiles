return function()
  local cmp = require'cmp'

  local feedkey = function(key, mode)
    mode = mode or ''
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn['vsnip#anonymous'](args.body)
      end
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }),
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if   has_words_before() then cmp.complete()
        else fallback()
        end
      end, { 'i', 's' }),
      ['<C-j>'] = cmp.mapping(function(fallback)
        if     cmp.visible()               then cmp.select_next_item()
        elseif vim.fn['vsnip#jumpable'](1) then feedkey('<Plug>(vsnip-jump-next)')
        else   fallback()
        end
      end, { 'i', 's' }),
      ['<C-k>'] = cmp.mapping(function(fallback)
        if     cmp.visible()                then cmp.select_prev_item()
        elseif vim.fn['vsnip#jumpable'](-1) then feedkey('<Plug>(vsnip-jump-prev)')
        else   fallback()
        end
      end, { 'i', 's' }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
    }
  })

  local vimp = require'vimp'
  local nnoremap = vimp.nnoremap

  nnoremap({ 'silent' }, 'gD', vim.lsp.buf.declaration)
  nnoremap({ 'silent' }, 'gd', vim.lsp.buf.definition)
  nnoremap({ 'silent' }, 'gi', vim.lsp.buf.implementation)
  nnoremap({ 'silent' }, 'K', vim.lsp.buf.hover)
  nnoremap({ 'silent' }, '<C-K>', vim.lsp.sigunature_help)
  nnoremap({ 'silent' }, '[g', vim.lsp.diagnostic.goto_prev)
  nnoremap({ 'silent' }, ']g', vim.lsp.diagnostic.goto_next)
  nnoremap({ 'silent' }, '<leader>rn', vim.lsp.buf.rename)
  nnoremap({ 'silent' }, '<leader>ac', vim.lsp.buf.code_action)
  nnoremap({ 'silent' }, '<leader>qf', function() vim.lsp.buf.code_action({ only = 'quickfix' }) end)

  local lsp_installer = require'nvim-lsp-installer'
  local cmp_nvim_lsp = require'cmp_nvim_lsp'

  lsp_installer.on_server_ready(function(server)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local opt = {
      capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    }
    server:setup(opt)
  end)
end
