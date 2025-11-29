return {
  "CopilotC-Nvim/CopilotChat.nvim",

  -- Extend LazyVim's default CopilotChat options
  opts = function(_, opts)
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)

    -- Ensure we always have a model, and expose it globally for the intro header
    opts.model = opts.model or "gpt-4.1"
    vim.g.copilotchat_model = opts.model

    -- Fancy headers
    opts.headers = {
      user = "  " .. user .. " ",
      assistant = "  Copilot ",
      tool = "󰊳  Tool ",
    }

    -- Right-hand sidebar layout
    opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
      layout = "vertical", -- solid sidebar (not float)
      width = 0.40,     -- 40% of editor width
      border = "rounded",
      title = "  Copilot Chat",
    })

    -- Cleaner separator and help
    opts.separator =
    "────────────────────────────────────"
    opts.show_help = false -- we render our own intro instead
  end,

  -- Extra keymaps on top of LazyVim's defaults
  keys = {
    -- Explain (uses selection if in visual mode)
    {
      "<leader>ae",
      ":CopilotChatExplain<CR>",
      desc = "Explain (CopilotChat)",
      mode = { "n", "x" },
    },
    -- Fix / refactor (uses selection if in visual mode)
    {
      "<leader>af",
      ":CopilotChatFix<CR>",
      desc = "Fix (CopilotChat)",
      mode = { "n", "x" },
    },
  },

  -- Intro header + highlight styling
  init = function()
    -- Tie CopilotChat highlight groups into your colorscheme
    vim.api.nvim_set_hl(0, "CopilotChatHeader", { link = "Title" })
    vim.api.nvim_set_hl(0, "CopilotChatSeparator", { link = "Comment" })
    vim.api.nvim_set_hl(0, "CopilotChatHelp", { link = "DiagnosticHint" })

    local ns = vim.api.nvim_create_namespace("copilotchat_intro")

    -- Add a welcome / usage block when the chat buffer is first created
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "copilot-chat",
      callback = function(ev)
        local buf = ev.buf

        -- Only once per buffer
        if vim.b[buf].copilot_intro_done then
          return
        end

        -- Only if buffer is still empty
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local empty = (#lines == 1 and lines[1] == "")
        if not empty then
          return
        end

        vim.b[buf].copilot_intro_done = true

        local model = vim.g.copilotchat_model or "unknown"

        local intro = {
          ("  Copilot Chat (model: %s)"):format(model),
          "───────────────────────────────────────────────",
          "",
          "Quick usage:",
          "  • <leader>aa           Toggle chat on/off",
          "  • Visual + <leader>ae  Explain selected code",
          "  • Visual + <leader>af  Fix / refactor selection",
          "  • #buffer / #selection  Send current file/selection",
          "  • #file:path/to/File    Add extra file to context",
          "  • /Explain /Review /Fix /Tests for common tasks",
          "  • gh inside chat        Show full keymap/help",
          "",
          "Start typing below to ask a question.",
          "",
        }

        -- Insert intro text
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, intro)

        -- Highlight header + help using extmarks (no deprecated APIs)
        for i, text in ipairs(intro) do
          local hl_group

          if i == 1 then
            hl_group = "CopilotChatHeader"
          elseif i == 2 then
            hl_group = "CopilotChatSeparator"
          elseif i >= 4 and i <= #intro - 1 then
            hl_group = "CopilotChatHelp"
          end

          if hl_group then
            vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
              end_col = #text,
              hl_group = hl_group,
            })
          end
        end
      end,
    })
  end,
}
