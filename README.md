<div align="center">

```
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
```

**Personal Neovim configuration — fast, focused, AI-augmented.**

[![Neovim](https://img.shields.io/badge/Neovim-%3E%3D0.10-57A143?style=flat-square&logo=neovim&logoColor=white)](https://neovim.io)
[![LazyVim](https://img.shields.io/badge/LazyVim-v8-7B68EE?style=flat-square)](https://lazyvim.org)
[![Lua](https://img.shields.io/badge/Lua-5.1-2C2D72?style=flat-square&logo=lua&logoColor=white)](https://www.lua.org)
[![macOS](https://img.shields.io/badge/macOS-only-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos)

</div>

---

Built on [LazyVim](https://lazyvim.org) with local AI (Ollama), GitHub Copilot, multi-language LSP, and a clean developer workflow.

---

## Prerequisites

Install the following before cloning. All are available via [Homebrew](https://brew.sh).

```bash
brew install neovim          # >= 0.10 required
brew install git
brew install node            # required by TypeScript, JSON, Docker LSPs
brew install python          # required by Python LSP
brew install ripgrep         # used by telescope/fuzzy search
brew install fd              # used by telescope file search
brew install lazygit         # git UI built into LazyVim
brew install stylua          # Lua formatter
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font   # icons & glyphs
```

For Java support, install a JDK:

```bash
brew install --cask temurin   # Eclipse Temurin (recommended)
```

For AI completions via `codecompanion.nvim`, install [Ollama](https://ollama.com):

```bash
brew install ollama
```

---

## Installation

**1. Clone this repo to the Neovim config directory:**

```bash
git clone https://github.com/<your-username>/nvim-config.git ~/.config/nvim
```

**2. Start Neovim** — lazy.nvim will bootstrap itself and install all plugins automatically:

```bash
nvim
```

Wait for the plugin installation to complete (you can follow progress with `:Lazy`).

**3. Restart Neovim** to ensure all plugins are fully initialized.

---

## AI Setup

This config uses two AI providers:

### Ollama (local, offline)

Used by `codecompanion.nvim` for chat, inline edits, reviews, and commit messages.

```bash
ollama serve                        # start the Ollama daemon (or set it to auto-start)
ollama pull qwen3-coder:30b         # big model — chat, reviews, commits
ollama pull qwen2.5-coder:14b       # small model — fast inline completions
```

Ollama can be set to auto-start on login:

```bash
brew services start ollama
```

### GitHub Copilot (cloud)

Used for inline suggestion completions.

Inside Neovim, run:

```
:Copilot auth
```

Follow the device-flow prompts to authenticate with your GitHub account.

---

## Verify the Setup

Run the built-in health check to confirm dependencies are satisfied:

```
:checkhealth
```

Key things to check:
- `vim.provider` — Python/Node providers should be OK (Perl/Ruby are intentionally disabled)
- `lazy` — all plugins should be installed
- `mason` — LSP servers install on first open of a relevant file type

To manually sync/update plugins:

```
:Lazy sync
```

---

## What's Included

| Category | Details |
|---|---|
| **Plugin manager** | [lazy.nvim](https://github.com/folke/lazy.nvim) (auto-bootstrapped) |
| **Base distro** | [LazyVim v8](https://lazyvim.org) |
| **Colorscheme** | tokyonight (moon) |
| **File explorer** | neo-tree |
| **Completion** | nvim-cmp with LSP, path, buffer sources |
| **AI — local** | codecompanion.nvim → Ollama (`qwen3-coder:30b` / `qwen2.5-coder:14b`) |
| **AI — cloud** | GitHub Copilot inline suggestions |
| **Debugging** | DAP core |
| **Testing** | neotest |
| **LSP languages** | Java, Python, TypeScript, JSON, YAML, Helm, Docker |
| **Formatting** | conform.nvim (`google-java-format` for Java, `xmlformat` for XML/MXML) |
| **Linting** | ESLint |
| **Git UI** | lazygit (via snacks) |

---

## Key Mappings

`<leader>` is `Space`.

| Mapping | Mode | Action |
|---|---|---|
| `jk` | Insert | Exit insert mode |
| `<leader>ac` | Normal / Visual | AI: Open chat |
| `<leader>ax` | Visual | AI: Explain selection |
| `<leader>ai` | Visual | AI: Improve selection (inline) |
| `<leader>ar` | Visual | AI: Review selection |
| `<leader>at` | Visual | AI: Generate tests |
| `<leader>aG` | Normal | AI: Conventional Commit from git diff |
| `<leader>am1` | Normal | AI: Switch to big model (qwen3-coder:30b) |
| `<leader>am3` | Normal | AI: Switch to small model (qwen2.5-coder:14b) |
| `K` | Normal | LSP hover doc (Lspsaga) |
| `<C-e>` | Insert | Accept Copilot suggestion |
| `<C-n>` / `<C-p>` | Insert | Next / previous Copilot suggestion |
| `<C-x>` | Insert | Dismiss Copilot suggestion |

All other LazyVim default mappings apply — see `:LazyVimDocs` or [lazyvim.org/keymaps](https://lazyvim.org/keymaps).

---

## Repository Layout

```
init.lua                        # entry point — loads lua/config/lazy.lua
lazyvim.json                    # enabled LazyVim extras
lua/
  config/
    lazy.lua                    # lazy.nvim bootstrap + plugin spec loader
    options.lua                 # global vim options
    keymaps.lua                 # global keymaps
    autocmds.lua                # global autocommands
  plugins/
    ai_codecompanion.lua        # codecompanion.nvim (Ollama)
    ai_copilot.lua              # GitHub Copilot suggestions
    completion_cmp.lua          # nvim-cmp tweaks
    formatting_java.lua         # google-java-format via conform
    formatting_xml.lua          # xmlformat via conform
    lspsaga.lua                 # hover doc override (K)
    neo-tree.lua                # file explorer tweaks
    ui_snacks.lua               # snacks.nvim tweaks
    ui_theme.lua                # tokyonight colorscheme
    meta_disable_news.lua       # suppress LazyVim/Neovim news popups
after/
  ftplugin/                     # filetype-specific indent overrides
    java.lua, json.lua, lua.lua, yaml.lua, yml.lua
```
