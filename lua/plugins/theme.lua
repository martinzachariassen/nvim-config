local function omarchy_theme_spec()
  local config_home = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")
  local omarchy_theme_file = config_home .. "/omarchy/current/theme/neovim.lua"

  if vim.fn.filereadable(omarchy_theme_file) == 1 then
    local ok, spec = pcall(dofile, omarchy_theme_file)
    if ok and type(spec) == "table" then
      return spec
    end
  end

  return nil
end

local spec = omarchy_theme_spec()
if spec then
  return spec
end

-- Fallback if Omarchy theme file is missing/broken
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = { flavour = "mocha" },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
