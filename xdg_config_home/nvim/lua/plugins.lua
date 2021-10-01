-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end


require'packer'.startup(function(use)

  -- Packer
  use { 'wbthomason/packer.nvim', opt = true}

  -- Surrounding
  use 'tpope/vim-surround'

  -- AutoPairs
  use { 'jiangmiao/auto-pairs', config = require'config.auto-pairs' }

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
  use { 'svermeulen/vimpeccable', config = function() require'vimp'.always_override = true end }

  -- Motion
  use { 'phaazon/hop.nvim', config = require'config.hop' }

  -- If not running in VSCode
  if vim.fn.exists('g:vscode') == 0 then

    -- Shows a git diff in the sign column.
    use 'airblade/vim-gitgutter'

    -- -- Insert/Delete brackets,
    -- use 'jiangmiao/auto-pairs'

    -- Change filetype
    use {
      'osyo-manga/vim-precious',
      opt = true,
      ft = { 'html', 'markdown' },
      requires = 'Shougo/context_filetype.vim',
      config = require'config.precious',
    }

    -- Colorscheme
    use { 'tomasiser/vim-code-dark', config = require'config.code-dark' }

    -- Statusline
    use { 'itchyny/lightline.vim', requires = 'josa42/vim-lightline-coc', config = require'config.lightline' }

    -- Highlight
    use { 'nvim-treesitter/nvim-treesitter', config = require'config.treesitter', disable = true }

    -- LSP
    use { 'neoclide/coc.nvim', branch = 'release', config = require'config.coc' }

    -- Filer
    use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons', config = require'config.nvim-tree' }
  end
end)
