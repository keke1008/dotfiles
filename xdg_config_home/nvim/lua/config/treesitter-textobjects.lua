return function() 
  require'nvim-treesitter.configs'.setup {
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["ip"] = "@call.inner",
          ["ap"] = "@call.outer",
          ["if"] = "@function.inner",
          ["af"] = "@function.outer",
        },
      },
    },
  }
end
