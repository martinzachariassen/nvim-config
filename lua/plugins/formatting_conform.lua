-- ====================================================================
-- Formatting: Java (conform.nvim) — best-effort, quiet on invalid code
-- ====================================================================
-- Goals:
--   - Format Java with google-java-format when the file is parseable.
--   - Skip formatting on save if the buffer has ERROR diagnostics
--     (common while typing / mid-refactor).
--   - No popups/noise when formatting is skipped or fails.

return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    -- Ensure tables exist (merge-safe with LazyVim defaults)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.default_format_opts = opts.default_format_opts or {}

    -- Disable notifications; keep failures quiet (still logged in conform.log)
    opts.notify_on_error = false
    opts.notify_no_formatters = false

    -- Default formatting behavior
    opts.default_format_opts = vim.tbl_deep_extend("force", opts.default_format_opts, {
      lsp_format = "fallback",
      quiet = true,
    })

    -- Java formatter selection
    opts.formatters_by_ft.java = { "google-java-format" }

    -- Best-effort format-on-save:
    -- If the buffer currently has ERROR diagnostics, skip formatting.
    -- This prevents google-java-format parse errors while you're mid-edit.
    opts.format_on_save = function(bufnr)
      local has_errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }) > 0
      if has_errors then
        return nil
      end

      return {
        timeout_ms = 800,
        lsp_format = "fallback",
        quiet = true,
      }
    end
  end,
}
