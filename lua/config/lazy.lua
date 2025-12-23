-- ====================================================================
-- Bootstrap lazy.nvim
-- ====================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ====================================================================
-- Setup lazy.nvim + LazyVim
-- ====================================================================
require("lazy").setup({
  spec = {

    --------------------------------------------------------------------
    -- Core LazyVim + base plugins
    --------------------------------------------------------------------
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    --------------------------------------------------------------------
    -- Language Extras
    --------------------------------------------------------------------
    { import = "lazyvim.plugins.extras.lang.java" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.helm" },
    { import = "lazyvim.plugins.extras.lang.json" },

    --------------------------------------------------------------------
    -- Tooling / Workflow Extras
    --------------------------------------------------------------------
    { import = "lazyvim.plugins.extras.util.project" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.editor.inc-rename" },
    { import = "lazyvim.plugins.extras.editor.neo-tree" },
    { import = "lazyvim.plugins.extras.coding.yanky" },
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    { import = "lazyvim.plugins.extras.coding.nvim-cmp" },

    --------------------------------------------------------------------
    -- User plugins (everything in lua/plugins/)
    --------------------------------------------------------------------
    { import = "plugins" },
  },

  defaults = {
    lazy = false, -- user plugins load immediately
    -- version = "*", -- not recommended
    -- version = false, -- always use latest commit
  },

  install = {
    missing = true,
    colorscheme = { "tokyonight", "habamax" },
  },

  checker = {
    enabled = true,
    notify = false,
    frequency = 3600, -- check every hour
  },

  change_detection = {
    enabled = true,
    notify = false,
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        -- "netrwPlugin", -- enable if you want netrw disabled
      },
    },
  },
})
