return {
  {
    "nvimdev/lspsaga.nvim",

    -- CRITICAL: ensure this plugin is loaded before LSP attaches
    lazy = false,

    opts = {
      ui = { border = "rounded", title = true },
      hover = { max_width = 0.8 },
    },

    config = function(_, opts)
      require("lspsaga").setup(opts)

      local group = vim.api.nvim_create_augroup("UserLspsagaK", { clear = true })

      local function set_k(buf)
        -- remove whatever is there buffer-locally
        pcall(vim.keymap.del, "n", "K", { buffer = buf })

        -- set lspsaga hover buffer-locally
        vim.keymap.set(
          "n",
          "K",
          "<cmd>Lspsaga hover_doc<CR>",
          { buffer = buf, silent = true, desc = "LSP Hover (Lspsaga)" }
        )
      end

      -- When an LSP attaches, replace K in that buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
          set_k(args.buf)
        end,
      })

      -- Also fix any buffers that already have an attached client (important on startup/reloads)
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and #vim.lsp.get_clients({ bufnr = buf }) > 0 then
          set_k(buf)
        end
      end
    end,
  },
}
