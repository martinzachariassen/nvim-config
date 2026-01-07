return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.filesystem = opts.filesystem or {}

    --  Never show DS_Store, even when "show hidden files" is on
    opts.filesystem.filtered_items = vim.tbl_deep_extend("force", opts.filesystem.filtered_items or {}, {
      never_show = { ".DS_Store" },
    })
  end,
}
