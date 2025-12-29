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
        desc = "AI: Open chat",
        mode = { "n", "v" },
      },

      {
        "<leader>ax",
        function()
          require("codecompanion").chat({
            prompt = table.concat({
              "Explain the following code.",
              "Focus on intent, control flow, and edge cases.",
              "Assume I am an experienced backend developer.",
              "",
              "Code:",
              "```",
              vim.fn.getreg("v"),
              "```",
            }, "\n"),
          })
        end,
        desc = "AI: Explain selected code",
        mode = "v",
      },

      {
        "<leader>ai",
        function()
          require("codecompanion").inline({
            prompt = table.concat({
              "Improve the following code.",
              "Preserve behavior.",
              "Improve readability, naming, and structure.",
              "Do not add abstractions unless clearly beneficial.",
            }, "\n"),
          })
        end,
        desc = "AI: Improve selected code",
        mode = "v",
      },

      {
        "<leader>ar",
        function()
          require("codecompanion").chat({
            prompt = table.concat({
              "Review the following code.",
              "Call out potential bugs, edge cases, and design issues.",
              "Be concise and concrete.",
              "",
              "Code:",
              "```",
              vim.fn.getreg("v"),
              "```",
            }, "\n"),
          })
        end,
        desc = "AI: Review selected code",
        mode = "v",
      },

      {
        "<leader>at",
        function()
          require("codecompanion").chat({
            prompt = table.concat({
              "Write tests for the following code.",
              "Use the project's existing testing style if possible.",
              "Focus on behavior and edge cases.",
              "",
              "Code:",
              "```",
              vim.fn.getreg("v"),
              "```",
            }, "\n"),
          })
        end,
        desc = "AI: Generate tests for selection",
        mode = "v",
      },

      -- Generate Conventional Commit via git diff
      {
        "<leader>aG",
        function()
          local diff = vim.fn.system("git diff --cached; git diff")
          if diff == "" then
            vim.notify("No git diff found", vim.log.levels.WARN)
            return
          end

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
            adapter = "qwen_big", -- <-- ensure big model handles diff
          })
        end,
        desc = "CodeCompanion: Conventional Commit from git diff",
        mode = "n",
      },

      -- optional quick toggle hotkeys
      {
        "<leader>am3",
        function()
          vim.cmd("CodeCompanionSwitchAdapter qwen_small")
        end,
        desc = "AI: Switch → small model (3B)",
      },
      {
        "<leader>am1",
        function()
          vim.cmd("CodeCompanionSwitchAdapter qwen_big")
        end,
        desc = "AI: Switch → big model (14B)",
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

      -- define two model adapters
      adapters = {
        qwen_big = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen_big",
            schema = { model = { default = "qwen2.5-coder:14b" } },
          })
        end,
        qwen_small = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen_small",
            schema = { model = { default = "qwen2.5-coder:3b" } },
          })
        end,
      },

      -- choose model by strategy: use big where it matters
      strategies = {
        chat = {
          adapter = "qwen_big", -- full reasoning, reviews, questions
        },
        inline = {
          adapter = "qwen_small", -- fast edits / rename / formatting
        },
        task = {
          adapter = "qwen_big", -- long instructions, git diff tasks
        },
      },

      opts = {
        log_level = "WARN",
      },
    },
  },
}
