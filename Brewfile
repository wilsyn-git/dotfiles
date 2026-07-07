# Brewfile — dependencies for this dotfiles repo.
#
# NOT included here because they self-bootstrap on first run:
#   - zinit             (zsh plugin manager; zsh/.zshrc clones it automatically)
#   - Powerlevel10k     (pulled in via zinit)
#   - TPM               (tmux plugin manager; clone it to ~/.tmux/plugins/tpm once,
#                         then `prefix + I` inside tmux — see README)
#   - lazy.nvim         (nvim plugin manager; init.lua clones it automatically)
#
# Usage:
#   brew bundle --file=Brewfile

# --- Core / stow ---
brew "stow"          # symlink manager used to install these dotfiles
brew "git"           # version control

# --- Shell (zsh/.zshrc) ---
brew "fzf"           # Ctrl-R/Ctrl-T/Alt-C keybindings + fzf-tab completion menu
brew "eza"           # modern `ls`, backs the ls/ll/la/lt aliases
brew "pyenv"         # Python version manager, initialized if present

# --- Neovim (nvim/) ---
brew "neovim"        # editor; 0.11+ required (treesitter uses `main`-branch API)
brew "fd"            # fast file finder, used by Telescope
brew "ripgrep"       # fast grep, used by Telescope live_grep

# --- tmux (tmux/) ---
brew "tmux"

# --- Yazi (yazi/) ---
brew "yazi"          # terminal file manager

# --- btop (btop/) ---
brew "btop"          # resource monitor
brew "htop"          # lighter alternative monitor (no dotfiles package: ~/.config/htop
                      # is root-owned on this machine, so its config isn't stowed here)

# --- git helpers ---
brew "git-filter-repo"  # history rewriting, not part of everyday git but handy to have

# --- Terminal (ghostty/) ---
cask "ghostty"
# Nerd Font used by ghostty/.config/ghostty/config (font-family = "Droid Sans Mono
# Nerd Font Complete"). Verified name via `brew search`/`brew info --cask`.
cask "font-droid-sans-mono-nerd-font"

# --- Reminders CLI, used by the `rag` grocery-list function in zsh/.zshrc ---
brew "keith/formulae/reminders-cli"  # taps keith/formulae; installs the `reminders` binary
