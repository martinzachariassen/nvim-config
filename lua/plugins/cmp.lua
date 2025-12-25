return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")

    -- =====================================================
    -- SOURCES (IntelliSense-like priority)
    -- =====================================================
    opts.sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 },
      { name = "path",     priority = 250 },
      { name = "buffer",   priority = 200 },
    })

    -- =====================================================
    -- SORTING (stable, IDE-like)
    -- =====================================================
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

    -- =====================================================
    -- FORMATTING (clean menu, keep LazyVim icons)
    -- =====================================================
    opts.formatting = vim.tbl_extend("force", opts.formatting or {}, {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, item)
        item.menu = ({
          nvim_lsp = "[LSP]",
          buffer   = "[BUF]",
          path     = "[PATH]",
        })[entry.source.name]
        return item
      end,
    })

    return opts
  end,
}
