-- ====================================================================
-- Keymaps
-- ====================================================================
-- Put *global* keymaps here. Plugin-specific keymaps belong in the plugin spec.
-- LazyVim docs: you can remove default keymaps with `vim.keymap.del(...)`. :contentReference[oaicite:0]{index=0}

local set = vim.keymap.set

-- Small wrapper to keep mappings consistent.
-- - silent=true avoids command-line noise
-- - noremap=true avoids recursive mapping surprises
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
-- Note: any `jk`-style mapping can introduce a small “pause” if you type `j`
-- and wait, because Neovim must decide whether you're starting the mapping.
-- If that annoys you, switch to something like `jj`, or reduce `timeoutlen`.
map("i", "jk", "<Esc>", "Exit insert mode")

-- Example: removing a LazyVim default mapping (if you hit a conflict)
-- vim.keymap.del("n", "<leader>/")
