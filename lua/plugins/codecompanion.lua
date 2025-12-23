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

          -- Guard against massive diffs
          if #diff > 50000 then
            vim.notify("Git diff too large for LLM context", vim.log.levels.WARN)
            return
          end

          require("codecompanion").chat({
            prompt = table.concat({
              "You are an expert software engineer.",
              "Your task is to write a SINGLE Conventional Commit message based on the git diff below.",
              "",
              "Rules:",
              "- Use the Conventional Commits format: <type>(<scope>): <summary>",
              "- Valid types: feat, fix, refactor, perf, test, docs, chore, build, ci",
              "- Infer scope from the code (module, package, or feature name)",
              "- Summary must be concise, imperative, and under 72 characters",
              "- Do NOT mention filenames unless necessary",
              "- Do NOT describe implementation details line-by-line",
              "- If multiple concerns exist, pick the dominant one",
              "",
              "Output format:",
              "- First line: commit message",
              "- Optional body: bullet points ONLY if they add real value",
              "",
              "Git diff:",
              "```diff",
              diff,
              "```",
            }, "\n"),
          })
        end,
        desc = "CodeCompanion: Conventional Commit from git diff",
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
                default = "qwen2.5-coder:7b",
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
