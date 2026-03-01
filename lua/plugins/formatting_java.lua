-- lua/plugins/formatting_java.lua
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.default_format_opts = opts.default_format_opts or {}

      opts.notify_on_error = false
      opts.notify_no_formatters = false

      opts.default_format_opts = vim.tbl_deep_extend("force", opts.default_format_opts, {
        timeout_ms = 3000,
        quiet = true,
        lsp_format = "fallback",
      })

      opts.formatters_by_ft.java = { "google-java-format" }
    end,
  },
}
