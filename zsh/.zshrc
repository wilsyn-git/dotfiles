# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k

alias alg='ssh -i ~/Documents/PEMFiles/AWSLinuxGuy.pem ec2-user@44.202.129.251'
alias lcs='ssh -l cvadmin 172.19.157.208'
alias webguy='ssh -i ~/.ssh/groverwebdemo.key opc@129.146.160.162'
alias ocics='ssh -i ~/.ssh/grovercommvault.key opc@137.131.23.122'
alias ws='cd ~/OneDrive/workspace/'


alias ls='eza --group-directories-first'
alias ll='eza -lha --git'
alias la='eza -lha --git'
alias lt='eza --tree --level=2'

timedate() {
    time && date
}

sc() {
  source "$HOME/.zshrc" && echo "Reloaded ~/.zshrc"
}

brewu() {
    brew update && brew upgrade
}

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH=$PATH:$HOME/.local/opt/go/bin
export PATH=$PATH:$HOME/.local/opt/go/bin
export PATH=$PATH:$HOME/go/bin
export XDG_CONFIG_HOME="$HOME/.config"


# Added by Antigravity
export PATH="/Users/sam/.antigravity/antigravity/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
