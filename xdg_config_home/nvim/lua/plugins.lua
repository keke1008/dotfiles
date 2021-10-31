-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

require'packer'.startup(function(use)

  -- Packer
  use { 'wbthomason/packer.nvim' }

  -- Surrounding
  use 'tpope/vim-surround'

  -- Commenting
  use 'tpope/vim-commentary'

  -- Repeat
  use 'tpope/vim-repeat'

  -- Git commands
  use 'tpope/vim-fugitive'

  -- Textobj
  use { 'sgur/vim-textobj-parameter', requires = { 'kana/vim-textobj-user' } }

  -- Format
  use { 'junegunn/vim-easy-align', config = require'config.easy-align' }

  -- Call lua function in keymap
  use { 'svermeulen/vimpeccable', config = require'config.vimp' }

  -- Motion
  use { 'justinmk/vim-sneak', config = require'config.sneak' }

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

  -- AutoPairs
  use_no_vscode { 'jiangmiao/auto-pairs', config = require'config.auto-pairs' }

  -- Change filetype
  use_no_vscode {
    'osyo-manga/vim-precious',
    opt = true,
    ft = { 'html', 'markdown' },
    requires = 'Shougo/context_filetype.vim',
    config = require'config.precious',
  }

  -- Colorscheme
  use_no_vscode { 'tomasiser/vim-code-dark', config = require'config.code-dark' }

  -- Statusline
  use_no_vscode { 'itchyny/lightline.vim', requires = 'josa42/vim-lightline-coc', config = require'config.lightline' }

  -- Highlight
  use_no_vscode { 'nvim-treesitter/nvim-treesitter', config = require'config.treesitter', disable = true }

  -- LSP
  use_no_vscode { 'neoclide/coc.nvim', branch = 'release', config = require'config.coc' }

  -- Filer
  use_no_vscode { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons', config = require'config.nvim-tree' }
end)
