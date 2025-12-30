-- ====================================================================
-- Keymaps
-- ====================================================================
-- Global keymaps only. Plugin-specific mappings should live in the plugin spec.

local set = vim.keymap.set

local function map(modes, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  opts.noremap = opts.noremap ~= false
  opts.desc = desc
  set(modes, lhs, rhs, opts)
end

-- --------------------------------------------------------------------
-- Insert mode: quick escape
-- --------------------------------------------------------------------
-- Note: `jk` can introduce a small delay when typing `j` because of mapping timeout.
map("i", "jk", "<Esc>", "Exit insert mode")
