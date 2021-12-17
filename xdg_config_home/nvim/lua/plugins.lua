-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

require'packer'.startup(function(use)

  -- Packer
  use 'wbthomason/packer.nvim'

  -- Surrounding
  use 'tpope/vim-surround'

  -- Repeat
  use 'tpope/vim-repeat'

  -- Git commands
  use 'tpope/vim-fugitive'

  -- Textobj
  use { 'sgur/vim-textobj-parameter', requires = 'kana/vim-textobj-user' }

  -- Format
  use 'junegunn/vim-easy-align'

  -- Call lua function in keymap
  use 'svermeulen/vimpeccable'

  -- Motion
  use { 'justinmk/vim-sneak', setup = function () vim.g['sneak#s_next'] = 1 end }

  -- Comment and AutoPairs
  use { 'echasnovski/mini.nvim', config = require'config.mini' }

  --*-*-*- If not running in VSCode -*-*-*--
  local use_no_vscode = function(conf)
    if type(conf) == 'string' then
      conf = { conf }
    end
    conf.cond = function()
      return vim.fn.exists'g:vscode' == 0
    end
    use(conf)
  end

  -- Shows a git diff in the sign column.
  use_no_vscode 'airblade/vim-gitgutter'

  -- Change filetype
  use_no_vscode {
    'osyo-manga/vim-precious',
    opt = true,
    ft = { 'html', 'markdown' },
    requires = 'Shougo/context_filetype.vim',
    config = require'config.precious',
  }

  -- Colorscheme
  use_no_vscode { 'EdenEast/nightfox.nvim', opt = true }

  --Fuzzy finder
  use_no_vscode { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }

  -- Statusline
  use_no_vscode {
    'nvim-lualine/lualine.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = require'config.lualine-conf',
  }

  -- Highlight
  use_no_vscode { 'nvim-treesitter/nvim-treesitter', event = 'BufRead', config = require'config.treesitter' }

  -- LSP
  use_no_vscode {
    {
      'williamboman/nvim-lsp-installer',
      config = require'config.lsp',
      requires = {
        'nvim-telescope/telescope.nvim',
        'neovim/nvim-lspconfig',
        { 'simrat39/rust-tools.nvim', config = require'config.rust-tools-conf' },
      },
    }, {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/vim-vsnip',
      }
    }
  }

  -- Diagnostics
  use_no_vscode {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = require'config.trouble-conf',
    event = 'User LspProgressUpdate'
  }

  -- Filer
  use_no_vscode {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = require'config.nvim-tree'
  }

  -- Resize Window
  use_no_vscode 'simeji/winresizer'
end)
