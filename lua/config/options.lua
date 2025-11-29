-- Global Neovim options for LazyVim
local opt = vim.opt
local api = vim.api

-----------------------------------------------------------
-- Encoding
-----------------------------------------------------------
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-----------------------------------------------------------
-- Indentation (defaults)
-- 4 spaces by default; overridden per filetype below
-----------------------------------------------------------
opt.expandtab = true   -- tabs → spaces
opt.shiftwidth = 4     -- spaces per indent level
opt.tabstop = 4        -- how many spaces a <Tab> displays as
opt.softtabstop = 4    -- how many spaces <Tab>/<BS> insert/remove
opt.smartindent = true -- basic auto-indent for new lines

-----------------------------------------------------------
-- Indentation overrides by filetype (common conventions)
-----------------------------------------------------------
api.nvim_create_autocmd("FileType", {
  pattern = {
    "json",
    "jsonc",
    "yaml",
    "yml",
    "toml",
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "html",
    "css",
    "scss",
    "lua",
    "helm",
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-----------------------------------------------------------
-- UI / layout
-----------------------------------------------------------
opt.number = true         -- absolute line numbers
opt.relativenumber = true -- relative numbers for motions
opt.cursorline = true     -- highlight current line
opt.signcolumn = "yes"    -- never hide git/diagnostic signs

opt.wrap = false          -- no soft wrap by default
opt.scrolloff = 4         -- keep context above/below cursor
opt.sidescrolloff = 8

opt.splitright = true    -- vertical splits open to the right
opt.splitbelow = true    -- horizontal splits open below

opt.termguicolors = true -- true color
opt.showmode = false     -- don't show -- INSERT -- (statusline handles it)

-----------------------------------------------------------
-- Searching
-----------------------------------------------------------
opt.ignorecase = true -- ignore case by default
opt.smartcase = true  -- but be case-sensitive if pattern has capitals
opt.hlsearch = true   -- highlight search results
opt.incsearch = true  -- show matches as you type

-----------------------------------------------------------
-- Files, backup, undo
-----------------------------------------------------------
opt.undofile = true  -- persistent undo across sessions
opt.swapfile = false -- don't use swapfiles (LazyVim friendly)
opt.backup = false
opt.writebackup = false

-----------------------------------------------------------
-- Timing / responsiveness
-----------------------------------------------------------
opt.updatetime = 200 -- faster CursorHold, diagnostics, etc.
opt.timeoutlen = 300 -- shorter mapped sequence timeout

-----------------------------------------------------------
-- Misc
-----------------------------------------------------------
opt.clipboard = "unnamedplus" -- use system clipboard
opt.mouse = "a"               -- enable mouse in all modes
opt.confirm = true            -- confirm instead of error on unsaved changes

-- Make whitespace slightly more visible (without being obnoxious)
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}
