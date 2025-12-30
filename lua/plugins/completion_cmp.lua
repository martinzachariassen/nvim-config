-- ====================================================================
-- Completion: nvim-cmp
-- ====================================================================
-- Keep this file focused: source priority, sorting, and menu labels.

return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      -- Sources: IDE-like priority
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "path", priority = 250 },
        { name = "buffer", priority = 200 },
      })

      -- Sorting: stable, predictable
      opts.sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      }

      -- Menu labels (keep LazyVim icons; just add a short source label)
      opts.formatting = vim.tbl_extend("force", opts.formatting or {}, {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, item)
          local labels = {
            nvim_lsp = "[LSP]",
            buffer = "[BUF]",
            path = "[PATH]",
          }
          item.menu = labels[entry.source.name] or ("[" .. entry.source.name .. "]")
          return item
        end,
      })

      return opts
    end,
  },
}
