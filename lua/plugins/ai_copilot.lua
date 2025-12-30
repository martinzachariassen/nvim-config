-- ====================================================================
-- AI: GitHub Copilot (suggestions)
-- ====================================================================

return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-e>",
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-x>",
        },
      },
      panel = { enabled = false },
    },
  },
}
