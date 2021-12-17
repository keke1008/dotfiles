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
      ['<CR>'] = cmp.mapping(function(fallback)
        if   cmp.visible() then cmp.confirm({ select = true })
        else fallback()
        end
      end),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if   has_words_before() then cmp.complete()
        else fallback()
        end
      end, { 'i', 's' }),
      ['<C-j>'] = cmp.mapping(function(fallback)
        if vim.fn['vsnip#jumpable'](1) == 1 then feedkey('<Plug>(vsnip-jump-next)')
        else   fallback()
        end
      end, { 'i', 's' }),
      ['<C-k>'] = cmp.mapping(function(fallback)
        if vim.fn['vsnip#jumpable'](-1) == 1 then feedkey('<Plug>(vsnip-jump-prev)')
        else   fallback()
        end
      end, { 'i', 's' }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
    }
  })

  local vimp = require'vimp'
  local nnoremap = vimp.nnoremap

  local telescope_open = function(cmd, layout_config)
    return function()
      require'telescope.builtin'[cmd]({
        layout_strategy = 'cursor',
        layout_config = layout_config }
      )
    end
  end

  nnoremap({ 'silent' }, 'gD', vim.lsp.buf.declaration)
  nnoremap({ 'silent' }, 'gd', telescope_open('lsp_definitions', { width = 0.5, height = 0.5 }))
  nnoremap({ 'silent' }, 'gi', telescope_open('implementations', { width = 0.5, height = 0.5 }))
  nnoremap({ 'silent' }, 'gr', telescope_open('lsp_references', { width = 0.5, height = 0.5 }))
  nnoremap({ 'silent' }, 'K', function()
    if vim.bo.filetype == 'vim' or vim.bo.filetype == 'help' then
      vim.cmd("help " .. vim.fn.expand('<cword>'))
    else
      vim.lsp.buf.hover()
    end
  end)
  nnoremap({ 'silent' }, '<C-K>', vim.lsp.sigunature_help)
  nnoremap({ 'silent' }, '[g', vim.lsp.diagnostic.goto_prev)
  nnoremap({ 'silent' }, ']g', vim.lsp.diagnostic.goto_next)
  nnoremap({ 'silent' }, '<leader>rn', vim.lsp.buf.rename)
  nnoremap({ 'silent' }, '<leader>ac', telescope_open('lsp_code_actions', { width = 0.4, height = 0.2 }))
  nnoremap({ 'silent' }, '<leader>qf', function() vim.lsp.buf.code_action({ only = 'quickfix' }) end)

  vim.cmd'autocmd BufWritePre * lua vim.lsp.buf.formatting()'

  local lsp_installer = require'nvim-lsp-installer'
  local cmp_nvim_lsp = require'cmp_nvim_lsp'

  lsp_installer.on_server_ready(function(server)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local opt = {
      capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    }

    if server.name == 'rust_analyzer' then
      require'rust-tools'.setup {
        server = vim.tbl_deep_extend('force', server:get_default_options(), opt)
      }
      server:attach_buffers()
    else
      server:setup(opt)
    end
  end)
end
