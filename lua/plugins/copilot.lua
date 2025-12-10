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

      panel = {
        enabled = false, -- No Copilot chat UI, avoids conflicts with CodeCompanion
      },
    },

    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
}
