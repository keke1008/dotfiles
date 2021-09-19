-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

require'packer'.startup(function()

  -- Packer
  use 'wbthomason/packer.nvim'

  -- Surrounding
  use 'tpope/vim-surround'

  -- Commenting
  use 'tpope/vim-commentary'

  -- Repeat
  use 'tpope/vim-repeat'

  -- Git commands
  use 'tpope/vim-fugitive'

  -- Textobj
  use { 'sgur/vim-textobj-parameter', requires = {{ 'kana/vim-textobj-user' }} }

  -- Format
  use { 'junegunn/vim-easy-align', config = require'config.easy-align' }

  -- Call lua function in keymap
  -- use 'tjdevries/astronauta.nvim'
  use { 'svermeulen/vimpeccable', config = function() require'vimp'.always_override = true end }

  -- If not running in VSCode
  if vim.fn.exists('g:vscode') == 0 then 

    -- Shows a git diff in the sign column.
    use 'airblade/vim-gitgutter'

    -- Insert/Delete brackets,
    use 'jiangmiao/auto-pairs'

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
    use { 'itchyny/lightline.vim', config = function() vim.g.lightline = { colorscheme = 'landscape' } end }

    -- Highlight
    use { 'nvim-treesitter/nvim-treesitter', config = require'config.treesitter' }

    -- LSP
    use { 'neoclide/coc.nvim', branch = 'release', config = require'config.coc' }
  end
end)
