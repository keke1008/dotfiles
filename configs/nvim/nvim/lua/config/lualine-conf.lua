return function()
  local guibg = '#3b4261' -- require'lualine.themes.auto'.normal.b.bg

  vim.cmd('highlight LualineDiffAdd guifg=#209894 guibg=' .. guibg)
  vim.cmd('highlight LualineDiffModified guifg=#7861e9 guibg=' .. guibg)
  vim.cmd('highlight LualineDiffDelete guifg=#b2555b guibg=' .. guibg)

  local diff = {
    'diff',
    diff_color = {
      added = 'LualineDiffAdd',
      modified = 'LualineDiffModified',
      removed = 'LualineDiffDelete'
    }
  }

  require'lualine'.setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', diff, 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }
end
