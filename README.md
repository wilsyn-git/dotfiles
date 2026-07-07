# dotfiles

My personal macOS dotfiles — shell, terminal, editor, and file-manager config that I can carry between machines.

The repo is laid out as [GNU Stow](https://www.gnu.org/software/stow/) packages: each top-level folder mirrors the layout of `$HOME`, so stowing a folder symlinks its contents into the right place.

## What's inside

| Package | Symlinks to | What it configures |
| --- | --- | --- |
| `zsh/` | `~/.zshrc` | Zsh shell — plugin manager, aliases, and helper functions |
| `p10k/` | `~/.p10k.zsh` | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt (generated config) |
| `nvim/` | `~/.config/nvim/` | Neovim (Lua, [lazy.nvim](https://github.com/folke/lazy.nvim)) |
| `tmux/` | `~/.config/tmux/tmux.conf` | tmux terminal multiplexer |
| `yazi/` | `~/.config/yazi/` | [Yazi](https://github.com/sxyazi/yazi) terminal file manager |

## Install

```sh
# 1. Install GNU Stow (macOS)
brew install stow

# 2. Clone the repo
git clone https://github.com/wilsyn-git/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. Symlink the packages you want
stow zsh p10k nvim tmux yazi

# ...or just one
stow nvim
```

Stow creates symlinks relative to the parent directory, so cloning into `~/dotfiles` targets `$HOME` automatically. To remove a package's symlinks, use `stow -D <package>`.

Most of the heavy lifting bootstraps itself on first run:

- **zsh** auto-clones [zinit](https://github.com/zdharma-continuum/zinit) (plugin manager) and pulls in Powerlevel10k.
- **nvim** auto-clones lazy.nvim and installs plugins on first launch.
- **tmux** needs [TPM](https://github.com/tmux-plugins/tpm) at `~/.tmux/plugins/tpm`; press `prefix + I` to install plugins.

## Tools these configs expect

Beyond the plugin managers above, the configs assume these are installed (mostly via Homebrew):

- [`eza`](https://github.com/eza-community/eza) — modern `ls` (used by the `ls`/`ll`/`la`/`lt` aliases)
- [`neovim`](https://neovim.io/) 0.11+ — the treesitter setup uses the `main` branch API
- [`yazi`](https://github.com/sxyazi/yazi) — file manager
- [`tmux`](https://github.com/tmux/tmux)
- [`pyenv`](https://github.com/pyenv/pyenv) — optional; initialized only if present
- `python3` + [Pillow](https://python-pillow.org/) — for the `mkspritesheet` function
- [`reminders-cli`](https://github.com/keith/reminders-cli) — for the `rag` grocery function

## Highlights

### Zsh (`zsh/.zshrc`)

- **Plugin manager:** zinit, auto-installed on first shell start
- **Listing aliases:** `ls`/`ll`/`la`/`lt` all backed by `eza` (git-aware, tree view)
- **Handy functions:**
  - `sc` — reload `~/.zshrc`
  - `brewu` — `brew update` + `brew upgrade --greedy-auto-updates`
  - `ql <file>` — Quick Look preview from the terminal
  - `rag <items>` — add comma-separated items to the "Groceries" list in Reminders
  - `mkspritesheet` — stitch numbered 128×128 RGBA PNGs into a sprite sheet
  - `newblog` / `newgallery` / `contentfarm` — content helpers for a personal site project

### Neovim (`nvim/.config/nvim/`)

- Bootstraps **lazy.nvim** automatically
- **Colorscheme:** [tokyonight](https://github.com/folke/tokyonight.nvim) (night)
- **Plugins:** nvim-treesitter (`main` branch, wide language set), Telescope + plenary
- **Leader:** `<Space>`; Telescope maps under `<leader>f*`, plus `<leader>w`/`q`/`e`/`tw`
- Relative line numbers, 4-space expandtab, system clipboard, persistent undo

### tmux (`tmux/.config/tmux/tmux.conf`)

- 1-based window indexing, mouse on, 10k-line history
- TPM with `tmux-sensible`
- Passthrough, extended keys, and focus-events enabled (for terminal/editor integration)
- `prefix + r` reloads the config

### Yazi (`yazi/.config/yazi/`)

- Shows hidden files, size linemode, sorted by most-recently-modified
- Keymaps: `E` opens with the default app, `T` opens a new tab
