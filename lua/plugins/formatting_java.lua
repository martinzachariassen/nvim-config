-- ====================================================================
-- Formatting: Java (LazyVim + conform.nvim) — best-effort, quiet on invalid code
-- ====================================================================

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.default_format_opts = opts.default_format_opts or {}

      opts.notify_on_error = false
      opts.notify_no_formatters = false

      opts.default_format_opts = vim.tbl_deep_extend("force", opts.default_format_opts, {
        lsp_format = "fallback",
        quiet = true,
      })

      opts.formatters_by_ft.java = { "google-java-format" }
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.format = opts.format or {}

      opts.format.on_save = function(bufnr)
        -- only apply for java
        if vim.bo[bufnr].filetype ~= "java" then
          return true
        end

        local has_errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }) > 0

        if has_errors then
          return false
        end

        return {
          timeout_ms = 800,
          quiet = true,
          lsp_format = "fallback",
        }
      end
    end,
  },
}
