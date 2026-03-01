-- ====================================================================
-- Autocmds
-- ====================================================================

local api = vim.api

local function augroup(name)
  return api.nvim_create_augroup(name, { clear = true })
end

-- --------------------------------------------------------------------
-- Transparency / highlight overrides
-- --------------------------------------------------------------------
pcall(function()
  require("config.transparency").setup()
end)

-- --------------------------------------------------------------------
-- Highlight on yank
-- --------------------------------------------------------------------
api.nvim_create_autocmd("TextYankPost", {
  group = augroup("UserYankHighlight"),
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
  desc = "Briefly highlight yanked text",
})

-- --------------------------------------------------------------------
-- Resize splits on terminal resize
-- --------------------------------------------------------------------
api.nvim_create_autocmd("VimResized", {
  group = augroup("UserResizeSplits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
  desc = "Keep splits sized after terminal resize",
})

-- --------------------------------------------------------------------
-- Close certain utility buffers with q
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
-- JSON readability: disable conceal
-- --------------------------------------------------------------------
api.nvim_create_autocmd("FileType", {
  group = augroup("UserJsonConceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
  end,
  desc = "Disable conceal for JSON buffers",
})

-- --------------------------------------------------------------------
-- Trim trailing whitespace on save (safe)
-- --------------------------------------------------------------------
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("UserTrimWhitespace"),
  callback = function(event)
    -- Skip special/unmodifiable buffers
    if vim.bo[event.buf].buftype ~= "" then
      return
    end
    if not vim.bo[event.buf].modifiable then
      return
    end

    -- Skip diff buffers (whitespace is meaningful there)
    if vim.wo.diff then
      return
    end

    local view = vim.fn.winsaveview()
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
  desc = "Trim trailing whitespace on save",
})

-- --------------------------------------------------------------------
-- Java: skip autoformat-on-save when buffer has ERROR diagnostics
-- --------------------------------------------------------------------
api.nvim_create_autocmd("BufWritePre", {
  group = augroup("UserJavaSkipAutoformatOnError"),
  callback = function(event)
    if vim.bo[event.buf].filetype ~= "java" then
      return
    end

    -- Respect explicit disable (<leader>uf or manual vim.b.autoformat=false)
    if vim.b[event.buf].autoformat == false then
      return
    end

    local errs = vim.diagnostic.get(event.buf, { severity = vim.diagnostic.severity.ERROR })
    if #errs > 0 then
      -- temporarily disable autoformat for this save
      vim.b[event.buf]._autoformat_restore = vim.b[event.buf].autoformat
      vim.b[event.buf].autoformat = false
    end
  end,
  desc = "Disable autoformat on save for Java when diagnostics contain ERROR",
})

api.nvim_create_autocmd("BufWritePost", {
  group = augroup("UserJavaRestoreAutoformatAfterSave"),
  callback = function(event)
    if vim.bo[event.buf].filetype ~= "java" then
      return
    end

    if vim.b[event.buf]._autoformat_restore ~= nil then
      vim.b[event.buf].autoformat = vim.b[event.buf]._autoformat_restore
      vim.b[event.buf]._autoformat_restore = nil
    end
  end,
  desc = "Restore autoformat setting after save (Java)",
})
