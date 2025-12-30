-- ====================================================================
-- Autocmds
-- ====================================================================
-- This file is loaded automatically by LazyVim.
-- Put editor automation here (not plugin specs).
--
-- Tips:
--   - Use augroups with { clear = true } so re-sourcing doesn't duplicate autocmds.
--   - Prefer buffer-local changes in ftplugin files for filetype-specific behavior.
-- ====================================================================

local api = vim.api

-- --------------------------------------------------------------------
-- Helper: create/reuse augroups cleanly
-- --------------------------------------------------------------------
local function augroup(name)
  return api.nvim_create_augroup(name, { clear = true })
end

-- --------------------------------------------------------------------
-- Re-apply custom highlight tweaks (transparency)
-- --------------------------------------------------------------------
-- Your transparency/highlight overrides should live in:
--   lua/config/transparency.lua
-- and expose a `setup()` that registers ColorScheme re-apply logic.
-- If the module doesn't exist yet, this will just no-op safely.
pcall(function()
  require("config.transparency").setup()
end)

-- --------------------------------------------------------------------
-- Highlight on yank (nice UX feedback)
-- --------------------------------------------------------------------
api.nvim_create_autocmd("TextYankPost", {
  group = augroup("UserYankHighlight"),
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
  desc = "Briefly highlight yanked text",
})

-- --------------------------------------------------------------------
-- Resize splits when the terminal window is resized
-- --------------------------------------------------------------------
api.nvim_create_autocmd("VimResized", {
  group = augroup("UserResizeSplits"),
  callback = function()
    -- keep splits proportional
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Keep splits sized after terminal resize",
})

-- --------------------------------------------------------------------
-- Close certain "utility" buffers with q
-- --------------------------------------------------------------------
api.nvim_create_autocmd("FileType", {
  group = augroup("UserCloseWithQ"),
  pattern = {
    "help",
    "man",
    "qf",
    "lspinfo",
    "checkhealth",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Close this window",
    })
  end,
  desc = "Make utility windows easy to close",
})

-- --------------------------------------------------------------------
-- Fix conceallevel for JSON-like files
-- --------------------------------------------------------------------
-- Some setups/plugins set conceal which can make JSON harder to read.
api.nvim_create_autocmd("FileType", {
  group = augroup("UserJsonConceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function(event)
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
  end,
  desc = "Disable conceal for JSON buffers",
})

-- --------------------------------------------------------------------
-- Remove trailing whitespace on save (safe version)
-- --------------------------------------------------------------------
-- This preserves your cursor position and won't touch binary buffers.
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("UserTrimWhitespace"),
  callback = function(event)
    -- skip special buffers
    if vim.bo[event.buf].buftype ~= "" then
      return
    end

    local view = vim.fn.winsaveview()
    -- only trailing whitespace, not full formatting
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
  desc = "Trim trailing whitespace on save",
})
