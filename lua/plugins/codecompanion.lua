return {
  {
    "olimorris/codecompanion.nvim",
    version = "v17.33.0",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },

    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },

    keys = {
      {
        "<leader>ac",
        function()
          require("codecompanion").chat()
        end,
        desc = "AI Chat (CodeCompanion v17)",
        mode = { "n", "v" },
      },

      {
        "<leader>ae",
        function()
          require("codecompanion").actions({})
        end,
        desc = "AI Inline Actions (CodeCompanion v17)",
        mode = { "n", "v" },
      },

      {
        "<leader>ar",
        function()
          require("codecompanion").inline({})
        end,
        desc = "AI Inline Rewrite (CodeCompanion v17)",
        mode = "v",
      },

      {
        "<leader>aG",
        function()
          local diff = vim.fn.system("git diff --cached; git diff")

          if diff == "" then
            vim.notify("No git diff found", vim.log.levels.WARN)
            return
          end

          require("codecompanion").chat({
            context = {
              git_diff = diff,
            },
            system_prompt = "You are an expert at writing high-quality Conventional Commit messages based on git diffs.",
          })
        end,
        desc = "Chat with FULL Git Diff",
        mode = "n",
      },
    },

    opts = {
      display = {
        chat = {
          window = {
            position = "float",
            border = "rounded",
            width = 0.50,
            height = 0.80,
          },
        },
        diff = {
          position = "vertical",
          border = "rounded",
        },
      },

      adapters = {
        qwen = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen",
            schema = {
              model = {
                default = "qwen2.5-coder:14b",
              },
            },
          })
        end,
      },

      strategies = {
        chat = {
          adapter = "qwen",
        },
        inline = {
          adapter = "qwen",
        },
      },

      opts = {
        log_level = "WARN",
      },
    },
  },
}
