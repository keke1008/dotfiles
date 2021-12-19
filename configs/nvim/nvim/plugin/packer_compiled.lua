-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/keke1008/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/keke1008/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/keke1008/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/keke1008/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/keke1008/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["context_filetype.vim"] = {
    load_after = {
      ["vim-precious"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/context_filetype.vim",
    url = "https://github.com/Shougo/context_filetype.vim"
  },
  ["lualine.nvim"] = {
    cond = { "\27LJ\2\2K\0\0\2\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\1\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\rg:vscode\vexists\afn\bvim\0\0" },
    config = { "\27LJ\2\2Ò\a\0\0\6\0(\0F'\0\0\0006\1\1\0009\1\2\1'\2\3\0\18\3\0\0&\2\3\2B\1\2\0016\1\1\0009\1\2\1'\2\4\0\18\3\0\0&\2\3\2B\1\2\0016\1\1\0009\1\2\1'\2\5\0\18\3\0\0&\2\3\2B\1\2\0015\1\6\0005\2\a\0=\2\b\0016\2\t\0'\3\n\0B\2\2\0029\2\v\0025\3\18\0005\4\f\0005\5\r\0=\5\14\0045\5\15\0=\5\16\0044\5\0\0=\5\17\4=\4\19\0035\4\21\0005\5\20\0=\5\22\0045\5\23\0>\1\2\5=\5\24\0045\5\25\0=\5\26\0045\5\27\0=\5\28\0045\5\29\0=\5\30\0045\5\31\0=\5 \4=\4!\0035\4\"\0004\5\0\0=\5\22\0044\5\0\0=\5\24\0045\5#\0=\5\26\0045\5$\0=\5\28\0044\5\0\0=\5\30\0044\5\0\0=\5 \4=\4%\0034\4\0\0=\4&\0034\4\0\0=\4'\3B\2\2\1K\0\1\0\15extensions\ftabline\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_c\1\2\0\0\rfilename\14lualine_b\1\4\0\0\vbranch\0\16diagnostics\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\1\0\0\23disabled_filetypes\23section_separators\1\0\2\tleft\bî‚°\nright\bî‚²\25component_separators\1\0\2\tleft\bî‚±\nright\bî‚³\1\0\3\25always_divide_middle\2\ntheme\tauto\18icons_enabled\2\nsetup\flualine\frequire\15diff_color\1\0\3\nadded\19LualineDiffAdd\rmodified\24LualineDiffModified\fremoved\22LualineDiffDelete\1\2\0\0\tdiff5highlight LualineDiffDelete guifg=#b2555b guibg=7highlight LualineDiffModified guifg=#7861e9 guibg=2highlight LualineDiffAdd guifg=#209894 guibg=\bcmd\bvim\f#3b4261\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mini.nvim"] = {
    config = { "\27LJ\2\2•\1\0\0\2\0\b\1\0206\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\0016\0\3\0009\0\4\0009\0\5\0'\1\6\0B\0\2\2\t\0\0\0X\0\6€6\0\0\0'\1\a\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\15mini.pairs\rg:vscode\vexists\afn\bvim\nsetup\17mini.comment\frequire\0\0" },
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/mini.nvim",
    url = "https://github.com/echasnovski/mini.nvim"
  },
  ["nightfox.nvim"] = {
    cond = { "\27LJ\2\2K\0\0\2\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\1\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\rg:vscode\vexists\afn\bvim\0\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lsp-installer"] = {
    config = { "\27LJ\2\2}\0\2\b\0\5\0\18\14\0\1\0X\2\1€'\1\0\0006\2\1\0009\2\2\0029\2\3\0026\3\1\0009\3\2\0039\3\4\3\18\4\0\0+\5\2\0+\6\2\0+\a\2\0B\3\5\2\18\4\1\0+\5\2\0B\2\4\1K\0\1\0\27nvim_replace_termcodes\18nvim_feedkeys\bapi\bvim\5Ð\1\0\0\a\0\b\2!6\0\0\0006\1\1\0009\1\2\0019\1\3\1)\2\0\0B\1\2\0A\0\0\3\b\1\0\0X\2\20€6\2\1\0009\2\2\0029\2\4\2)\3\0\0\23\4\1\0\18\5\0\0+\6\2\0B\2\5\2:\2\1\2\18\3\2\0009\2\5\2\18\4\1\0\18\5\1\0B\2\4\2\18\3\2\0009\2\6\2'\4\a\0B\2\3\2\n\2\0\0X\2\2€+\2\1\0X\3\1€+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\vunpack\0\2;\0\1\3\0\4\0\0066\1\0\0009\1\1\0019\1\2\0019\2\3\0B\1\2\1K\0\1\0\tbody\20vsnip#anonymous\afn\bvimX\0\1\3\1\3\0\r-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\5€-\1\0\0009\1\1\0015\2\2\0B\1\2\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\0À\1\0\1\vselect\2\fconfirm\fvisible@\0\1\2\2\1\0\v-\1\0\0B\1\1\2\15\0\1\0X\2\4€-\1\1\0009\1\0\1B\1\1\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\2À\0À\rcompletep\0\1\3\1\4\1\0146\1\0\0009\1\1\0019\1\2\1)\2\1\0B\1\2\2\t\1\0\0X\1\4€-\1\0\0'\2\3\0B\1\2\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\1À\28<Plug>(vsnip-jump-next)\19vsnip#jumpable\afn\bvim\2p\0\1\3\1\4\1\0146\1\0\0009\1\1\0019\1\2\1)\2ÿÿB\1\2\2\t\1\0\0X\1\4€-\1\0\0'\2\3\0B\1\2\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\1À\28<Plug>(vsnip-jump-prev)\19vsnip#jumpable\afn\bvim\2u\0\0\3\2\4\0\n6\0\0\0'\1\1\0B\0\2\2-\1\0\0008\0\1\0005\1\2\0-\2\1\0=\2\3\1B\0\2\1K\0\1\0\0À\1À\18layout_config\1\0\1\20layout_strategy\vcursor\22telescope.builtin\frequire\20\1\2\3\0\1\0\0033\2\0\0002\0\0€L\2\2\0\0²\1\0\0\4\0\f\0\0276\0\0\0009\0\1\0009\0\2\0\6\0\0\0X\0\5€6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\v€6\0\0\0009\0\4\0'\1\5\0006\2\0\0009\2\6\0029\2\a\2'\3\b\0B\2\2\2&\1\2\1B\0\2\1X\0\5€6\0\0\0009\0\t\0009\0\n\0009\0\v\0B\0\1\1K\0\1\0\nhover\bbuf\blsp\f<cword>\vexpand\afn\nhelp \bcmd\thelp\rfiletype\abo\bvimL\0\0\2\0\5\0\a6\0\0\0009\0\1\0009\0\2\0009\0\3\0005\1\4\0B\0\2\1K\0\1\0\1\0\1\tonly\rquickfix\16code_action\bbuf\blsp\bvimÞ\2\0\1\t\1\18\0&6\1\0\0009\1\1\0019\1\2\0019\1\3\1B\1\1\0025\2\5\0-\3\0\0009\3\4\3\18\4\1\0B\3\2\2=\3\6\0029\3\a\0\a\3\b\0X\3\19€6\3\t\0'\4\n\0B\3\2\0029\3\v\0035\4\15\0006\5\0\0009\5\f\5'\6\r\0\18\b\0\0009\a\14\0B\a\2\2\18\b\2\0B\5\4\2=\5\16\4B\3\2\1\18\4\0\0009\3\17\0B\3\2\1X\3\4€\18\4\0\0009\3\v\0\18\5\2\0B\3\3\1K\0\1\0\aÀ\19attach_buffers\vserver\1\0\0\24get_default_options\nforce\20tbl_deep_extend\nsetup\15rust-tools\frequire\18rust_analyzer\tname\17capabilities\1\0\0\24update_capabilities\29make_client_capabilities\rprotocol\blsp\bvim¿\n\1\0\f\0O\0—\0016\0\0\0'\1\1\0B\0\2\0023\1\2\0003\2\3\0009\3\4\0005\4\b\0005\5\6\0003\6\5\0=\6\a\5=\5\t\0049\5\n\0009\5\v\0054\6\3\0005\a\f\0>\a\1\6B\5\2\2=\5\v\0045\5\15\0009\6\r\0003\a\14\0B\6\2\2=\6\16\0059\6\r\0003\a\17\0005\b\18\0B\6\3\2=\6\19\0059\6\r\0003\a\20\0005\b\21\0B\6\3\2=\6\22\0059\6\r\0003\a\23\0005\b\24\0B\6\3\2=\6\25\0059\6\r\0009\6\26\6)\aüÿB\6\2\2=\6\27\0059\6\r\0009\6\26\6)\a\4\0B\6\2\2=\6\28\5=\5\r\4B\3\2\0016\3\0\0'\4\29\0B\3\2\0029\4\30\0033\5\31\0\18\6\4\0005\a \0'\b!\0006\t\"\0009\t#\t9\t$\t9\t%\tB\6\4\1\18\6\4\0005\a&\0'\b'\0\18\t\5\0'\n(\0005\v)\0B\t\3\0A\6\2\1\18\6\4\0005\a*\0'\b+\0\18\t\5\0'\n,\0005\v-\0B\t\3\0A\6\2\1\18\6\4\0005\a.\0'\b/\0\18\t\5\0'\n0\0005\v1\0B\t\3\0A\6\2\1\18\6\4\0005\a2\0'\b3\0003\t4\0B\6\4\1\18\6\4\0005\a5\0'\b6\0006\t\"\0009\t#\t9\t7\tB\6\4\1\18\6\4\0005\a8\0'\b9\0006\t\"\0009\t#\t9\t:\t9\t;\tB\6\4\1\18\6\4\0005\a<\0'\b=\0006\t\"\0009\t#\t9\t:\t9\t>\tB\6\4\1\18\6\4\0005\a?\0'\b@\0006\t\"\0009\t#\t9\t$\t9\tA\tB\6\4\1\18\6\4\0005\aB\0'\bC\0\18\t\5\0'\nD\0005\vE\0B\t\3\0A\6\2\1\18\6\4\0005\aF\0'\bG\0003\tH\0B\6\4\0016\6\"\0009\6I\6'\aJ\0B\6\2\0016\6\0\0'\aK\0B\6\2\0026\a\0\0'\bL\0B\a\2\0029\bM\0063\tN\0B\b\2\0012\0\0€K\0\1\0\0\20on_server_ready\17cmp_nvim_lsp\23nvim-lsp-installer7autocmd BufWritePre * lua vim.lsp.buf.formatting()\bcmd\0\15<leader>qf\1\2\0\0\vsilent\1\0\2\nwidth\4š³æÌ\t™³æþ\3\vheight\4š³æÌ\t™³¦þ\3\21lsp_code_actions\15<leader>ac\1\2\0\0\vsilent\vrename\15<leader>rn\1\2\0\0\vsilent\14goto_next\a]g\1\2\0\0\vsilent\14goto_prev\15diagnostic\a[g\1\2\0\0\vsilent\20sigunature_help\n<C-K>\1\2\0\0\vsilent\0\6K\1\2\0\0\vsilent\1\0\2\nwidth\4\0€€€ÿ\3\vheight\4\0€€€ÿ\3\19lsp_references\agr\1\2\0\0\vsilent\1\0\2\nwidth\4\0€€€ÿ\3\vheight\4\0€€€ÿ\3\20implementations\agi\1\2\0\0\vsilent\1\0\2\nwidth\4\0€€€ÿ\3\vheight\4\0€€€ÿ\3\20lsp_definitions\agd\1\2\0\0\vsilent\16declaration\bbuf\blsp\bvim\agD\1\2\0\0\vsilent\0\rnnoremap\tvimp\n<C-f>\n<C-b>\16scroll_docs\n<C-k>\1\3\0\0\6i\6s\0\n<C-j>\1\3\0\0\6i\6s\0\n<Tab>\1\3\0\0\6i\6s\0\t<CR>\1\0\0\0\fmapping\1\0\1\tname\rnvim_lsp\fsources\vconfig\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\0\0\bcmp\frequire\0" },
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    cond = { "\27LJ\2\2K\0\0\2\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\1\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\rg:vscode\vexists\afn\bvim\0\0" },
    config = { "\27LJ\2\2Á\1\0\0\4\0\n\0\0166\0\0\0'\1\1\0B\0\2\0029\1\2\0'\2\3\0'\3\4\0B\1\3\0016\1\0\0'\2\5\0B\1\2\0029\1\6\0015\2\b\0005\3\a\0=\3\t\2B\1\2\1K\0\1\0\tview\1\0\2\16open_on_tab\2\18open_on_setup\2\1\0\1\nwidth\3#\nsetup\14nvim-tree\30<CMD>NvimTreeFindFile<CR>\15<leader>ep\rnnoremap\tvimp\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    cond = { "\27LJ\2\2K\0\0\2\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\1\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\rg:vscode\vexists\afn\bvim\0\0" },
    config = { "\27LJ\2\2ƒ\1\0\0\3\0\b\0\v6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\4\0005\2\3\0=\2\5\0015\2\6\0=\2\a\1B\0\2\1K\0\1\0\vindent\1\0\1\venable\2\14highlight\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rust-tools.nvim"] = {
    config = { "\27LJ\2\2Ù\1\0\0\2\0\r\0\0196\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\0016\0\0\0'\1\3\0B\0\2\0029\0\4\0009\0\5\0009\0\6\0'\1\b\0=\1\a\0'\1\n\0=\1\t\0'\1\f\0=\1\v\0K\0\1\0\b =>\23other_hints_prefix\b <-\27parameter_hints_prefix\tType\14highlight\16inlay_hints\ntools\foptions\22rust-tools.config\nsetup\15rust-tools\frequire\0" },
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["telescope.nvim"] = {
    cond = { "\27LJ\2\2K\0\0\2\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\1\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\rg:vscode\vexists\afn\bvim\0\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["trouble.nvim"] = {
    cond = { "\27LJ\2\2K\0\0\2\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\1\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\rg:vscode\vexists\afn\bvim\0\0" },
    config = { "\27LJ\2\2À\1\0\0\5\0\v\0\0186\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\4\0005\2\3\0=\2\5\1B\0\2\0016\0\0\0'\1\6\0B\0\2\0029\0\a\0\18\1\0\0005\2\b\0'\3\t\0'\4\n\0B\1\4\1K\0\1\0\21<CMD>Trouble<CR>\15<leader>tr\1\2\0\0\vsilent\rnnoremap\tvimp\16action_keys\1\0\0\1\0\2\15open_folds\6o\tjump\6o\nsetup\ftrouble\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-gitgutter"] = {
    cond = { "\27LJ\2\2K\0\0\2\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\1\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\rg:vscode\vexists\afn\bvim\0\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/vim-gitgutter",
    url = "https://github.com/airblade/vim-gitgutter"
  },
  ["vim-precious"] = {
    after = { "context_filetype.vim" },
    cond = { "\27LJ\2\2K\0\0\2\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\1\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\rg:vscode\vexists\afn\bvim\0\0" },
    config = { "\27LJ\2\2ª\2\0\0\2\0\b\0\r6\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0006\0\0\0009\0\6\0'\1\a\0B\0\2\1K\0\1\0’\1    augroup filetype\n      autocmd!\n      autocmd InsertEnter * :PreciousSwitch\n      autocmd InsertLeave * :PreciousReset\n    augroup END\n  \bcmd\1\0\1\6*\3\0)precious_enable_switch_CursorMoved_i\1\0\1\6*\3\0'precious_enable_switch_CursorMoved\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/vim-precious",
    url = "https://github.com/osyo-manga/vim-precious"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-sneak"] = {
    loaded = true,
    needs_bufread = false,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/vim-sneak",
    url = "https://github.com/justinmk/vim-sneak"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-textobj-parameter"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/vim-textobj-parameter",
    url = "https://github.com/sgur/vim-textobj-parameter"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/vim-textobj-user",
    url = "https://github.com/kana/vim-textobj-user"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  vimpeccable = {
    loaded = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/start/vimpeccable",
    url = "https://github.com/svermeulen/vimpeccable"
  },
  winresizer = {
    cond = { "\27LJ\2\2K\0\0\2\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\1\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\rg:vscode\vexists\afn\bvim\0\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = true,
    path = "/home/keke1008/.local/share/nvim/site/pack/packer/opt/winresizer",
    url = "https://github.com/simeji/winresizer"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: vim-sneak
time([[Setup for vim-sneak]], true)
try_loadstring("\27LJ\2\2.\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\17sneak#s_next\6g\bvim\0", "setup", "vim-sneak")
time([[Setup for vim-sneak]], false)
time([[packadd for vim-sneak]], true)
vim.cmd [[packadd vim-sneak]]
time([[packadd for vim-sneak]], false)
-- Config for: rust-tools.nvim
time([[Config for rust-tools.nvim]], true)
try_loadstring("\27LJ\2\2Ù\1\0\0\2\0\r\0\0196\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\0016\0\0\0'\1\3\0B\0\2\0029\0\4\0009\0\5\0009\0\6\0'\1\b\0=\1\a\0'\1\n\0=\1\t\0'\1\f\0=\1\v\0K\0\1\0\b =>\23other_hints_prefix\b <-\27parameter_hints_prefix\tType\14highlight\16inlay_hints\ntools\foptions\22rust-tools.config\nsetup\15rust-tools\frequire\0", "config", "rust-tools.nvim")
time([[Config for rust-tools.nvim]], false)
-- Config for: mini.nvim
time([[Config for mini.nvim]], true)
try_loadstring("\27LJ\2\2•\1\0\0\2\0\b\1\0206\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\0016\0\3\0009\0\4\0009\0\5\0'\1\6\0B\0\2\2\t\0\0\0X\0\6€6\0\0\0'\1\a\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\15mini.pairs\rg:vscode\vexists\afn\bvim\nsetup\17mini.comment\frequire\0\0", "config", "mini.nvim")
time([[Config for mini.nvim]], false)
-- Config for: nvim-lsp-installer
time([[Config for nvim-lsp-installer]], true)
try_loadstring("\27LJ\2\2}\0\2\b\0\5\0\18\14\0\1\0X\2\1€'\1\0\0006\2\1\0009\2\2\0029\2\3\0026\3\1\0009\3\2\0039\3\4\3\18\4\0\0+\5\2\0+\6\2\0+\a\2\0B\3\5\2\18\4\1\0+\5\2\0B\2\4\1K\0\1\0\27nvim_replace_termcodes\18nvim_feedkeys\bapi\bvim\5Ð\1\0\0\a\0\b\2!6\0\0\0006\1\1\0009\1\2\0019\1\3\1)\2\0\0B\1\2\0A\0\0\3\b\1\0\0X\2\20€6\2\1\0009\2\2\0029\2\4\2)\3\0\0\23\4\1\0\18\5\0\0+\6\2\0B\2\5\2:\2\1\2\18\3\2\0009\2\5\2\18\4\1\0\18\5\1\0B\2\4\2\18\3\2\0009\2\6\2'\4\a\0B\2\3\2\n\2\0\0X\2\2€+\2\1\0X\3\1€+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\vunpack\0\2;\0\1\3\0\4\0\0066\1\0\0009\1\1\0019\1\2\0019\2\3\0B\1\2\1K\0\1\0\tbody\20vsnip#anonymous\afn\bvimX\0\1\3\1\3\0\r-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\5€-\1\0\0009\1\1\0015\2\2\0B\1\2\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\0À\1\0\1\vselect\2\fconfirm\fvisible@\0\1\2\2\1\0\v-\1\0\0B\1\1\2\15\0\1\0X\2\4€-\1\1\0009\1\0\1B\1\1\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\2À\0À\rcompletep\0\1\3\1\4\1\0146\1\0\0009\1\1\0019\1\2\1)\2\1\0B\1\2\2\t\1\0\0X\1\4€-\1\0\0'\2\3\0B\1\2\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\1À\28<Plug>(vsnip-jump-next)\19vsnip#jumpable\afn\bvim\2p\0\1\3\1\4\1\0146\1\0\0009\1\1\0019\1\2\1)\2ÿÿB\1\2\2\t\1\0\0X\1\4€-\1\0\0'\2\3\0B\1\2\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\1À\28<Plug>(vsnip-jump-prev)\19vsnip#jumpable\afn\bvim\2u\0\0\3\2\4\0\n6\0\0\0'\1\1\0B\0\2\2-\1\0\0008\0\1\0005\1\2\0-\2\1\0=\2\3\1B\0\2\1K\0\1\0\0À\1À\18layout_config\1\0\1\20layout_strategy\vcursor\22telescope.builtin\frequire\20\1\2\3\0\1\0\0033\2\0\0002\0\0€L\2\2\0\0²\1\0\0\4\0\f\0\0276\0\0\0009\0\1\0009\0\2\0\6\0\0\0X\0\5€6\0\0\0009\0\1\0009\0\2\0\a\0\3\0X\0\v€6\0\0\0009\0\4\0'\1\5\0006\2\0\0009\2\6\0029\2\a\2'\3\b\0B\2\2\2&\1\2\1B\0\2\1X\0\5€6\0\0\0009\0\t\0009\0\n\0009\0\v\0B\0\1\1K\0\1\0\nhover\bbuf\blsp\f<cword>\vexpand\afn\nhelp \bcmd\thelp\rfiletype\abo\bvimL\0\0\2\0\5\0\a6\0\0\0009\0\1\0009\0\2\0009\0\3\0005\1\4\0B\0\2\1K\0\1\0\1\0\1\tonly\rquickfix\16code_action\bbuf\blsp\bvimÞ\2\0\1\t\1\18\0&6\1\0\0009\1\1\0019\1\2\0019\1\3\1B\1\1\0025\2\5\0-\3\0\0009\3\4\3\18\4\1\0B\3\2\2=\3\6\0029\3\a\0\a\3\b\0X\3\19€6\3\t\0'\4\n\0B\3\2\0029\3\v\0035\4\15\0006\5\0\0009\5\f\5'\6\r\0\18\b\0\0009\a\14\0B\a\2\2\18\b\2\0B\5\4\2=\5\16\4B\3\2\1\18\4\0\0009\3\17\0B\3\2\1X\3\4€\18\4\0\0009\3\v\0\18\5\2\0B\3\3\1K\0\1\0\aÀ\19attach_buffers\vserver\1\0\0\24get_default_options\nforce\20tbl_deep_extend\nsetup\15rust-tools\frequire\18rust_analyzer\tname\17capabilities\1\0\0\24update_capabilities\29make_client_capabilities\rprotocol\blsp\bvim¿\n\1\0\f\0O\0—\0016\0\0\0'\1\1\0B\0\2\0023\1\2\0003\2\3\0009\3\4\0005\4\b\0005\5\6\0003\6\5\0=\6\a\5=\5\t\0049\5\n\0009\5\v\0054\6\3\0005\a\f\0>\a\1\6B\5\2\2=\5\v\0045\5\15\0009\6\r\0003\a\14\0B\6\2\2=\6\16\0059\6\r\0003\a\17\0005\b\18\0B\6\3\2=\6\19\0059\6\r\0003\a\20\0005\b\21\0B\6\3\2=\6\22\0059\6\r\0003\a\23\0005\b\24\0B\6\3\2=\6\25\0059\6\r\0009\6\26\6)\aüÿB\6\2\2=\6\27\0059\6\r\0009\6\26\6)\a\4\0B\6\2\2=\6\28\5=\5\r\4B\3\2\0016\3\0\0'\4\29\0B\3\2\0029\4\30\0033\5\31\0\18\6\4\0005\a \0'\b!\0006\t\"\0009\t#\t9\t$\t9\t%\tB\6\4\1\18\6\4\0005\a&\0'\b'\0\18\t\5\0'\n(\0005\v)\0B\t\3\0A\6\2\1\18\6\4\0005\a*\0'\b+\0\18\t\5\0'\n,\0005\v-\0B\t\3\0A\6\2\1\18\6\4\0005\a.\0'\b/\0\18\t\5\0'\n0\0005\v1\0B\t\3\0A\6\2\1\18\6\4\0005\a2\0'\b3\0003\t4\0B\6\4\1\18\6\4\0005\a5\0'\b6\0006\t\"\0009\t#\t9\t7\tB\6\4\1\18\6\4\0005\a8\0'\b9\0006\t\"\0009\t#\t9\t:\t9\t;\tB\6\4\1\18\6\4\0005\a<\0'\b=\0006\t\"\0009\t#\t9\t:\t9\t>\tB\6\4\1\18\6\4\0005\a?\0'\b@\0006\t\"\0009\t#\t9\t$\t9\tA\tB\6\4\1\18\6\4\0005\aB\0'\bC\0\18\t\5\0'\nD\0005\vE\0B\t\3\0A\6\2\1\18\6\4\0005\aF\0'\bG\0003\tH\0B\6\4\0016\6\"\0009\6I\6'\aJ\0B\6\2\0016\6\0\0'\aK\0B\6\2\0026\a\0\0'\bL\0B\a\2\0029\bM\0063\tN\0B\b\2\0012\0\0€K\0\1\0\0\20on_server_ready\17cmp_nvim_lsp\23nvim-lsp-installer7autocmd BufWritePre * lua vim.lsp.buf.formatting()\bcmd\0\15<leader>qf\1\2\0\0\vsilent\1\0\2\nwidth\4š³æÌ\t™³æþ\3\vheight\4š³æÌ\t™³¦þ\3\21lsp_code_actions\15<leader>ac\1\2\0\0\vsilent\vrename\15<leader>rn\1\2\0\0\vsilent\14goto_next\a]g\1\2\0\0\vsilent\14goto_prev\15diagnostic\a[g\1\2\0\0\vsilent\20sigunature_help\n<C-K>\1\2\0\0\vsilent\0\6K\1\2\0\0\vsilent\1\0\2\nwidth\4\0€€€ÿ\3\vheight\4\0€€€ÿ\3\19lsp_references\agr\1\2\0\0\vsilent\1\0\2\nwidth\4\0€€€ÿ\3\vheight\4\0€€€ÿ\3\20implementations\agi\1\2\0\0\vsilent\1\0\2\nwidth\4\0€€€ÿ\3\vheight\4\0€€€ÿ\3\20lsp_definitions\agd\1\2\0\0\vsilent\16declaration\bbuf\blsp\bvim\agD\1\2\0\0\vsilent\0\rnnoremap\tvimp\n<C-f>\n<C-b>\16scroll_docs\n<C-k>\1\3\0\0\6i\6s\0\n<C-j>\1\3\0\0\6i\6s\0\n<Tab>\1\3\0\0\6i\6s\0\t<CR>\1\0\0\0\fmapping\1\0\1\tname\rnvim_lsp\fsources\vconfig\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\0\0\bcmp\frequire\0", "config", "nvim-lsp-installer")
time([[Config for nvim-lsp-installer]], false)
-- Conditional loads
time([[Conditional loading of vim-gitgutter]], true)
  require("packer.load")({"vim-gitgutter"}, {}, _G.packer_plugins)
time([[Conditional loading of vim-gitgutter]], false)
time([[Conditional loading of winresizer]], true)
  require("packer.load")({"winresizer"}, {}, _G.packer_plugins)
time([[Conditional loading of winresizer]], false)
time([[Conditional loading of telescope.nvim]], true)
  require("packer.load")({"telescope.nvim"}, {}, _G.packer_plugins)
time([[Conditional loading of telescope.nvim]], false)
time([[Conditional loading of nvim-tree.lua]], true)
  require("packer.load")({"nvim-tree.lua"}, {}, _G.packer_plugins)
time([[Conditional loading of nvim-tree.lua]], false)
time([[Conditional loading of lualine.nvim]], true)
  require("packer.load")({"lualine.nvim"}, {}, _G.packer_plugins)
time([[Conditional loading of lualine.nvim]], false)
time([[Conditional loading of nightfox.nvim]], true)
  require("packer.load")({"nightfox.nvim"}, {}, _G.packer_plugins)
time([[Conditional loading of nightfox.nvim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'vim-precious'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'vim-precious'}, { ft = "html" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au User LspProgressUpdate ++once lua require("packer.load")({'trouble.nvim'}, { event = "User LspProgressUpdate" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'nvim-treesitter'}, { event = "BufRead *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
