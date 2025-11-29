-- Ensure lazy.nvim is installed and added to runtime path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazy_repo_url = "https://github.com/folke/lazy.nvim.git"
  local git_args = {
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazy_repo_url,
    lazypath,
  }
  local out = vim.fn.system(git_args)
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    vim.cmd("cquit 1")
  end
end
-- Prepend lazy.nvim to runtime path for plugin loading
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim (this is where LazyVim is pulled in)
require("lazy").setup({
  spec = {
    -- Core LazyVim
    { "LazyVim/LazyVim",                                    import = "lazyvim.plugins" },

    -- Extras
    -- languages
    { import = "lazyvim.plugins.extras.lang.java" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.helm" },
    { import = "lazyvim.plugins.extras.lang.json" },

    -- tooling / workflow
    { import = "lazyvim.plugins.extras.util.project" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },

    -- Copilot
    { import = "lazyvim.plugins.extras.ai.copilot" },
    { import = "lazyvim.plugins.extras.ai.copilot-chat" },

    -- Your own plugins under lua/plugins/
    { import = "plugins" },
  },

  defaults = {
    -- Don't lazy-load your own plugins by default
    lazy = false,
    -- Use latest git commit for plugins
    version = false,
    -- version = "*", -- (not recommended)
  },

  install = {
    -- Install missing plugins automatically
    missing = true,
    colorscheme = { "tokyonight", "habamax" },
  },

  checker = {
    enabled = true,
    notify = false,
    -- Optional: check every hour
    frequency = 3600,
  },

  -- Auto-reload when plugin files change (optional, but handy)
  change_detection = {
    enabled = true,
    notify = false,
  },

  performance = {
    rtp = {
      -- Disable some built-in runtime plugins
      disabled_plugins = {
        "gzip",
        -- "netrwPlugin", -- enable/disable as you like
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
