-- ====================================================================
-- Bootstrap lazy.nvim and load LazyVim + your plugins
-- ====================================================================

-- IMPORTANT: leader must be set before plugins/keymaps load.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out .. "\n", "WarningMsg" },
      { "Press any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- ====================================================================
-- lazy.nvim setup
-- ====================================================================
require("lazy").setup({
  spec = {
    -- Core LazyVim + defaults
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Your plugin specs in ~/.config/nvim/lua/plugins/*.lua
    { import = "plugins" },
  },

  defaults = {
    -- Best practice with LazyVim: lazy-load by default; opt-out per plugin.
    lazy = true,
    version = false,
  },

  install = {
    colorscheme = { "tokyonight", "habamax" },
  },

  checker = {
    enabled = true,
    notify = false,
    frequency = 3600,
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
      },
    },
  },
})
