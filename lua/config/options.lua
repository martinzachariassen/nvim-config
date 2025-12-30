-- ====================================================================
-- Options
-- ====================================================================
-- Global defaults only. Filetype-specific settings belong in:
--   ~/.config/nvim/after/ftplugin/<ft>.lua

-- Disable unused providers (silences :checkhealth vim.provider warnings)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local opt = vim.opt

-- --------------------------------------------------------------------
-- Indentation: global defaults
-- --------------------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.shiftround = true

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

-- Allows switching buffers without saving every time
opt.hidden = true

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

-- Subtle whitespace visibility
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}
