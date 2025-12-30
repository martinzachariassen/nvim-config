-- ====================================================================
-- Transparency / background clearing
-- ====================================================================
-- Highlights are often reset when:
--   - you change colorscheme
--   - plugins reconfigure their UI groups after startup
-- So we:
--   1) define a stable "apply()" function
--   2) re-apply on ColorScheme
--   3) run once on startup
--   4) expose a user command for manual re-apply

local M = {}

-- Use a set to avoid duplicates and to keep lookups cheap.
local groups = {
  -- Core UI
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "EndOfBuffer",
  "SignColumn",
  "FoldColumn",
  "Folded",
  "Pmenu",
  "Terminal",

  -- WhichKey
  "WhichKeyFloat",

  -- Telescope
  "TelescopeNormal",
  "TelescopeBorder",
  "TelescopePromptBorder",
  "TelescopePromptTitle",

  -- Neo-tree
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NeoTreeVertSplit",
  "NeoTreeWinSeparator",
  "NeoTreeEndOfBuffer",

  -- nvim-tree (if you ever use it)
  "NvimTreeNormal",
  "NvimTreeVertSplit",
  "NvimTreeEndOfBuffer",

  -- nvim-notify (common groups; some versions/themes vary)
  "NotifyINFOBody",
  "NotifyERRORBody",
  "NotifyWARNBody",
  "NotifyTRACEBody",
  "NotifyDEBUGBody",
  "NotifyINFOTitle",
  "NotifyERRORTitle",
  "NotifyWARNTitle",
  "NotifyTRACETitle",
  "NotifyDEBUGTitle",
  "NotifyINFOBorder",
  "NotifyERRORBorder",
  "NotifyWARNBorder",
  "NotifyTRACEBorder",
  "NotifyDEBUGBorder",
}

-- Optional: if you want borders to stay visible while backgrounds are cleared.
local function clear_bg(name)
  -- Only set if the highlight group exists; avoids noise for missing groups.
  if vim.fn.hlexists(name) == 1 then
    vim.api.nvim_set_hl(0, name, { bg = "none" })
  end
end

function M.apply()
  for _, name in ipairs(groups) do
    clear_bg(name)
  end
end

function M.setup()
  local grp = vim.api.nvim_create_augroup("UserTransparency", { clear = true })

  -- Re-apply whenever a colorscheme is set/changed.
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = grp,
    callback = function()
      -- Schedule so it runs after the colorscheme finishes setting its highlights.
      vim.schedule(M.apply)
    end,
    desc = "Reapply transparency highlights after colorscheme changes",
  })

  -- Apply once on startup as well.
  vim.schedule(M.apply)

  -- Manual command (useful when a plugin resets its highlights)
  vim.api.nvim_create_user_command("TransparencyApply", function()
    M.apply()
  end, { desc = "Reapply transparency highlight overrides" })
end

return M
