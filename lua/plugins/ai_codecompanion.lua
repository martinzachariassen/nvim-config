-- ====================================================================
-- AI: codecompanion.nvim
-- ====================================================================

local function visual_selection()
  local bufnr = 0
  local start = vim.fn.getpos("'<")
  local finish = vim.fn.getpos("'>")

  local srow, scol = start[2] - 1, start[3] - 1
  local erow, ecol = finish[2] - 1, finish[3]

  if srow < 0 or erow < 0 then
    return ""
  end

  local lines = vim.api.nvim_buf_get_text(bufnr, srow, scol, erow, ecol, {})
  return table.concat(lines, "\n")
end

local function fenced(lang, text)
  return table.concat({ "```" .. (lang or ""), text, "```" }, "\n")
end

local function chat_with_selection(system_lines, user_lines)
  local sel = visual_selection()
  if sel == "" then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  require("codecompanion").chat({
    prompt = table.concat(vim.list_extend(vim.deepcopy(user_lines), { "", "Code:", fenced("", sel) }), "\n"),
    system_prompt = table.concat(system_lines or {}, "\n"),
  })
end

local function git_diff_all()
  if vim.fn.executable("git") ~= 1 then
    return nil, "git not found in PATH"
  end
  local out = vim.fn.system("git diff --cached; git diff")
  if vim.v.shell_error ~= 0 then
    return nil, "Not a git repository (or git diff failed)"
  end
  out = (out or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if out == "" then
    return nil, "No git diff found"
  end
  return out, nil
end

return {
  {
    "olimorris/codecompanion.nvim",
    version = "v17.33.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },

    keys = {
      {
        "<leader>ac",
        function()
          require("codecompanion").chat()
        end,
        desc = "AI: Open chat",
        mode = { "n", "v" },
      },

      -- Explain selection
      {
        "<leader>ax",
        function()
          chat_with_selection(nil, {
            "Explain the following code.",
            "Focus on intent, control flow, and edge cases.",
          })
        end,
        desc = "AI: Explain selection",
        mode = "v",
      },

      -- Improve selection
      {
        "<leader>ai",
        function()
          local sel = visual_selection()
          if sel == "" then
            vim.notify("No visual selection found", vim.log.levels.WARN)
            return
          end

          require("codecompanion").inline({
            prompt = table.concat({
              "Improve the following code.",
              "- Preserve behavior.",
              "- Improve readability, naming, and structure.",
              "- Avoid unnecessary abstractions.",
              "",
              "Code:",
              fenced("", sel),
            }, "\n"),
          })
        end,
        desc = "AI: Improve selection",
        mode = "v",
      },

      -- Review selection
      {
        "<leader>ar",
        function()
          chat_with_selection(nil, {
            "Review the following code.",
            "Call out bugs, edge cases, and design issues.",
            "Be concise and concrete.",
          })
        end,
        desc = "AI: Review selection",
        mode = "v",
      },

      -- Tests for selection
      {
        "<leader>at",
        function()
          chat_with_selection(nil, {
            "Write tests for the following code.",
            "Use the project's existing testing style if possible.",
            "Focus on behavior and edge cases.",
          })
        end,
        desc = "AI: Generate tests for selection",
        mode = "v",
      },

      -- Conventional Commit from git diff
      {
        "<leader>aG",
        function()
          local diff, err = git_diff_all()
          if not diff then
            vim.notify(err, vim.log.levels.WARN)
            return
          end

          if #diff > 50000 then
            vim.notify("Git diff too large for LLM context", vim.log.levels.WARN)
            return
          end

          require("codecompanion").chat({
            prompt = table.concat({
              "Write ONE Conventional Commit message from this diff.",
              "",
              "Rules:",
              "- Format: <type>(<scope>): <summary>",
              "- Types: feat, fix, refactor, perf, test, docs, chore, build, ci",
              "- Scope: infer module/package/feature",
              "- Summary: imperative, <= 72 chars",
              "- Choose the dominant change if multiple exist",
              "- Optional body: bullet points only if they add real value",
              "",
              "Diff:",
              fenced("diff", diff),
            }, "\n"),
            adapter = "qwen_big",
          })
        end,
        desc = "AI: Conventional Commit from git diff",
        mode = "n",
      },

      { "<leader>am3", "<cmd>CodeCompanionSwitchAdapter qwen_small<cr>", desc = "AI: Switch → small model" },
      { "<leader>am1", "<cmd>CodeCompanionSwitchAdapter qwen_big<cr>", desc = "AI: Switch → big model" },
    },

    opts = {
      display = {
        chat = { window = { position = "float", border = "rounded", width = 0.50, height = 0.80 } },
        diff = { position = "vertical", border = "rounded" },
      },

      adapters = {
        qwen_big = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen_big",
            schema = { model = { default = "qwen3-coder:30b" } },
          })
        end,
        qwen_small = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "qwen_small",
            schema = { model = { default = "qwen2.5-coder:14b" } },
          })
        end,
      },

      strategies = {
        chat = { adapter = "qwen_big" },
        inline = { adapter = "qwen_small" },
        task = { adapter = "qwen_big" },
      },

      opts = { log_level = "WARN" },
    },
  },
}
