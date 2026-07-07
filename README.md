# dotfiles

My personal macOS dotfiles — shell, terminal, editor, and file-manager config that I can carry between machines. The visual theme is [Tokyo Night](https://github.com/folke/tokyonight.nvim) across Ghostty, tmux, and Neovim.

The repo is laid out as [GNU Stow](https://www.gnu.org/software/stow/) packages: each top-level folder mirrors the layout of `$HOME`, so stowing a folder symlinks its contents into the right place.

## What's inside

| Package | Symlinks to | What it configures |
| --- | --- | --- |
| `btop/` | `~/.config/btop/` | [btop](https://github.com/aristocratos/btop) resource monitor |
| `ccstatusline/` | `~/.config/ccstatusline/` | [ccstatusline](https://github.com/sirmalloc/ccstatusline) status line for Claude Code |
| `ghostty/` | `~/.config/ghostty/` | [Ghostty](https://ghostty.org/) terminal emulator |
| `git/` | `~/.gitconfig`, `~/.config/git/ignore` | Git config + global ignore |
| `nvim/` | `~/.config/nvim/` | Neovim (Lua, [lazy.nvim](https://github.com/folke/lazy.nvim)) |
| `p10k/` | `~/.p10k.zsh` | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt (generated config) |
| `tmux/` | `~/.config/tmux/tmux.conf` | tmux terminal multiplexer |
| `yazi/` | `~/.config/yazi/` | [Yazi](https://github.com/sxyazi/yazi) terminal file manager |
| `zsh/` | `~/.zshrc` | Zsh shell — plugin manager, aliases, and helper functions |

There's intentionally no `htop/` package: `~/.config/htop` is root-owned on this machine, so its config couldn't be imported into the repo. `htop` is still in the Brewfile as a lighter alternative to btop.

## Install

```sh
git clone https://github.com/wilsyn-git/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` runs `brew bundle --file=Brewfile` to install every tool these configs expect, then stows all nine packages. Restart your shell afterward (`exec zsh`).

### Manual install

If you'd rather do it by hand, or only want a subset of packages:

```sh
# 1. Install GNU Stow (macOS)
brew install stow

# 2. Clone the repo
git clone https://github.com/wilsyn-git/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. Symlink the packages you want
stow btop ccstatusline ghostty git nvim p10k tmux yazi zsh

# ...or just one
stow nvim
```

Stow creates symlinks relative to the parent directory, so cloning into `~/dotfiles` targets `$HOME` automatically. To remove a package's symlinks, use `stow -D <package>`.

Most of the heavy lifting bootstraps itself on first run:

- **zsh** auto-clones [zinit](https://github.com/zdharma-continuum/zinit) (plugin manager) and pulls in Powerlevel10k.
- **nvim** auto-clones lazy.nvim and installs plugins on first launch.
- **tmux** needs [TPM](https://github.com/tmux-plugins/tpm) cloned once to `~/.tmux/plugins/tpm`:
  ```sh
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ```
  Then start tmux and press `prefix + I` to install plugins.

### Secrets / machine-specific config

Anything private or machine-specific (SSH aliases, API keys, per-machine `PATH` tweaks, etc.) lives in `~/.zshrc.local`, which is **not** tracked by this repo. `zsh/.zshrc` sources it automatically if it exists:

```sh
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
```

## Tools these configs expect

`Brewfile` captures all of these — running `./install.sh` (or `brew bundle --file=Brewfile`) installs them in one shot:

- [`eza`](https://github.com/eza-community/eza) — modern `ls` (used by the `ls`/`ll`/`la`/`lt` aliases)
- [`fzf`](https://github.com/junegunn/fzf) — Ctrl-R/Ctrl-T/Alt-C keybindings and fzf-tab's fuzzy completion menu
- [`fd`](https://github.com/sharkdp/fd) and [`ripgrep`](https://github.com/BurntSushi/ripgrep) — used by Telescope in Neovim
- [`neovim`](https://neovim.io/) 0.11+ — the treesitter setup uses the `main` branch API
- [`yazi`](https://github.com/sxyazi/yazi) — file manager
- [`tmux`](https://github.com/tmux/tmux)
- [`btop`](https://github.com/aristocratos/btop) / [`htop`](https://htop.dev/) — resource monitors
- [`pyenv`](https://github.com/pyenv/pyenv) — optional; initialized only if present
- `python3` + [Pillow](https://python-pillow.org/) — for the `mkspritesheet` function
- [`reminders-cli`](https://github.com/keith/reminders-cli) — for the `rag` grocery function
- [`git-filter-repo`](https://github.com/newren/git-filter-repo) — occasional history rewriting
- [Ghostty](https://ghostty.org/) + the Droid Sans Mono Nerd Font — terminal + font

## Highlights

### Zsh (`zsh/.zshrc`)

- **Plugin manager:** zinit, auto-installed on first shell start, loading Powerlevel10k, zsh-completions, fzf-tab, zsh-autosuggestions, and zsh-syntax-highlighting
- **History:** 50,000-entry shared history (`SHARE_HISTORY`), deduped and immediately appended across sessions
- **fzf keybindings:** Ctrl-R (history search), Ctrl-T (file search), Alt-C (cd into a directory) via `fzf --zsh`, plus fzf-tab's fuzzy Tab-completion menu
- **Listing aliases:** `ls`/`ll`/`la`/`lt` all backed by `eza` (git-aware, tree view)
- **Handy functions:**
  - `sc` — reload `~/.zshrc`
  - `brewu` — `brew update` + `brew upgrade --greedy-auto-updates -y`
  - `ql <file>` — Quick Look preview from the terminal
  - `rag <items>` — add comma-separated items to the "Groceries" list in Reminders
  - `mkspritesheet` — stitch numbered 128×128 RGBA PNGs into a sprite sheet
  - `newblog` / `newgallery` / `contentfarm` — content helpers for a personal site project

### tmux (`tmux/.config/tmux/tmux.conf`)

- 1-based window/pane indexing, mouse on, 10k-line history
- Truecolor (`RGB` terminal-overrides for Ghostty/xterm-256color) and passthrough/extended-keys/focus-events enabled for terminal and editor integration
- vi-style copy-mode: `v` to begin selection, `y` to copy straight to `pbcopy`
- **Tokyo Night** status bar (session name, current window, prefix indicator, date/time)
- TPM with `tmux-sensible` and [`vim-tmux-navigator`](https://github.com/christoomey/vim-tmux-navigator) — Ctrl-h/j/k/l moves seamlessly between tmux panes and Neovim splits
- `prefix + r` reloads the config in place

### Neovim (`nvim/.config/nvim/`)

- Bootstraps **lazy.nvim** automatically; plugin specs are split one-per-file under `lua/plugins/`
- **Colorscheme:** [tokyonight](https://github.com/folke/tokyonight.nvim) (night)
- **LSP:** [mason.nvim](https://github.com/mason-org/mason.nvim) + mason-lspconfig install and wire up language servers automatically (`lua_ls` by default — run `:Mason` to add more)
- **Completion:** [blink.cmp](https://github.com/saghen/blink.cmp), feeding LSP capabilities into every server
- **Statusline:** [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- **Git:** [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) for in-buffer git hunks/blame
- **File explorer:** [oil.nvim](https://github.com/stevearc/oil.nvim) — `<leader>e` opens it in place of netrw
- **Discoverability:** [which-key.nvim](https://github.com/folke/which-key.nvim) shows available keymaps as you type
- **Editing:** autopairs, nvim-treesitter (`main` branch, wide language set)
- **Fuzzy finding:** Telescope + plenary — `<leader>ff` find files, `<leader>fg` live grep, `<leader>fb` buffers, `<leader>fh` help tags
- **Leader:** `<Space>`; other maps include `<leader>w` (save), `<leader>q` (quit), `<leader>tw` (toggle wrap)
- Relative line numbers, 4-space expandtab, system clipboard, persistent undo

### Ghostty (`ghostty/.config/ghostty/config`)

Tokyo Night theme, Droid Sans Mono Nerd Font at size 16, thickened font rendering, and a translucent/blurred background.

### btop (`btop/.config/btop/btop.conf`)

Resource monitor configuration — themes, update rate, and displayed panes.

### ccstatusline (`ccstatusline/.config/ccstatusline/settings.json`)

Status line layout for Claude Code, showing model, context usage, session cost, and git branch/worktree info.
