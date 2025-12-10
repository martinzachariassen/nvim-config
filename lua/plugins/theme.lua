return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = true,
        snacks = true,
        mini = true,
        noice = true,
        mason = true,
        which_key = true,
        indent_blankline = { enabled = true },
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
