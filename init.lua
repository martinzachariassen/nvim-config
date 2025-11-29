-- Optional: speed up startup on Neovim 0.9+
if vim.loader then
  vim.loader.enable()
end

-- Bootstrap LazyVim + plugins via lua/config/lazy.lua
require("config.lazy")
