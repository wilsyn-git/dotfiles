#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# 1. Install Homebrew dependencies
if command -v brew >/dev/null 2>&1; then
  brew bundle --file=Brewfile
else
  echo "Homebrew not found — install it first: https://brew.sh" >&2
  exit 1
fi

# 2. Symlink dotfiles with GNU Stow (explicit package list)
PACKAGES=(btop ccstatusline ghostty git nvim p10k tmux yazi zsh)
stow -v "${PACKAGES[@]}"

echo "Done. Restart your shell (or 'exec zsh'). In tmux, press prefix+I to install plugins; Neovim installs plugins on first launch."
