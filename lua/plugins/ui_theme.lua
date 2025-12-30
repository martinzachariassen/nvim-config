-- ====================================================================
-- UI: Colorscheme (tokyonight)
-- ====================================================================

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Options: "night", "storm", "moon", "day"
      style = "moon",

      transparent = false,
      terminal_colors = true,

      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },
}
