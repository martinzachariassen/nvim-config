-- ====================================================================
-- Options
-- ====================================================================
-- These are global defaults. Filetype-specific settings belong in after/ftplugin/*.
-- LazyVim loads your lua/config/options.lua automatically. :contentReference[oaicite:3]{index=3}

local opt = vim.opt

-- --------------------------------------------------------------------
-- Indentation: global defaults
-- --------------------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.shiftround = true -- round indent to shiftwidth

-- --------------------------------------------------------------------
-- UI / layout
-- --------------------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"

opt.wrap = false
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true

opt.termguicolors = true
opt.showmode = false

-- --------------------------------------------------------------------
-- Searching
-- --------------------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- --------------------------------------------------------------------
-- Files, backup, undo
-- --------------------------------------------------------------------
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- --------------------------------------------------------------------
-- Timing / responsiveness
-- --------------------------------------------------------------------
opt.updatetime = 200
opt.timeoutlen = 300

-- --------------------------------------------------------------------
-- Clipboard (guard for SSH / remote)
-- --------------------------------------------------------------------
-- Over SSH, using the system clipboard can be slow/broken depending on setup.
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- --------------------------------------------------------------------
-- Misc
-- --------------------------------------------------------------------
opt.mouse = "a"
opt.confirm = true

opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}
