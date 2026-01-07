-- Force K to use lspsaga hover (wins even if LazyVim rebinds on LspAttach)

local group = vim.api.nvim_create_augroup("ForceKToLspsaga", { clear = true })

local function enforce(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  -- only if an LSP client is attached
  if #vim.lsp.get_clients({ bufnr = buf }) == 0 then
    return
  end

  -- delete existing buffer-local K (LazyVim's)
  pcall(vim.keymap.del, "n", "K", { buffer = buf })

  -- set buffer-local K to lspsaga
  vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", {
    buffer = buf,
    silent = true,
    desc = "LSP Hover (Lspsaga)",
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    -- LazyVim often sets K later via schedule; run after it
    vim.defer_fn(function()
      enforce(args.buf)
    end, 200)
    vim.defer_fn(function()
      enforce(args.buf)
    end, 800)
  end,
})

-- Backstop: entering a buffer/window re-enforces if something changed
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = group,
  callback = function(args)
    vim.defer_fn(function()
      enforce(args.buf)
    end, 50)
  end,
})
