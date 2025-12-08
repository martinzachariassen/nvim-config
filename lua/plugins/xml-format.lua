return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "xmlformatter",
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      opts.formatters.xmlformatter = {
        command = "xmlformat",
        args = {
          "--indent",
          "4", -- 4 spaces
          "--indent-char",
          " ", -- use spaces
          "-", -- read from stdin
        },
        stdin = true,
      }

      opts.formatters_by_ft.xml = { "xmlformatter" }
      opts.formatters_by_ft.mxml = { "xmlformatter" }

      return opts
    end,
  },
}
