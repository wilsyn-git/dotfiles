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

alias ws='cd ~/OneDrive/workspace/'

# Machine-specific / private config (SSH aliases, secrets, etc.).
# Kept out of version control — see ~/.zshrc.local (not committed to this repo).
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

alias ls='eza --group-directories-first'
alias ll='eza -lha --git'
alias la='eza -lha --git'
alias lt='eza --tree --level=2'

ql() {
    qlmanage -p "$@" >& /dev/null &
}




timedate() {
    time && date
}

sc() {
  source "$HOME/.zshrc" && echo "Reloaded ~/.zshrc"
}

brewu() {
    brew update && brew upgrade --greedy-auto-updates -y
}

unnote() {
    killall NotificationCenter
}


# tentenbits helpers
newblog() {
  if [[ -z "$1" ]]; then
    echo "Usage: newblog <slug>"
    echo "Example: newblog my-trip-to-tokyo"
    return 1
  fi
  local root="$HOME/code/tentenbits"
  local target="$root/src/content/blog/$1"
  if [[ -d "$target" ]]; then
    echo "Error: $target already exists"
    return 1
  fi
  mkdir -p "$target"
  cp "$root/src/content/templates/blog-post.md" "$target/index.md"
  echo "Created blog post at src/content/blog/$1/"
  cd "$target"
}

newgallery() {
  if [[ -z "$1" ]]; then
    echo "Usage: newgallery <slug>"
    echo "Example: newgallery disney-springs-march-2026"
    return 1
  fi
  local root="$HOME/code/tentenbits"
  local target="$root/src/content/gallery/$1"
  if [[ -d "$target" ]]; then
    echo "Error: $target already exists"
    return 1
  fi
  mkdir -p "$target"
  cp "$root/src/content/templates/gallery.md" "$target/index.md"
  echo "Created gallery at src/content/gallery/$1/"
  cd "$target"
}

contentfarm() {
  if [[ -z "$*" ]]; then
    echo "Usage: contentfarm <commit message>"
    echo "Example: contentfarm fixed my hawaii blog"
    return 1
  fi
  local root="$HOME/code/tentenbits"
  cd "$root" || { echo "Error: can't cd to $root"; return 1; }
  git add -A
  git commit -m "$*" || { echo "Nothing to commit"; return 0; }
  git push && echo "Pushed to remote"
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

# Add one or more comma-separated grocery items to the "Groceries" list in Reminders
rag() {
  local list="Groceries"
  local input item

  # Combine all args into one string (so rag "Green Peppers, Onions" works too)
  input="$*"

  # Split on commas
  local -a items
  items=("${(@s:,:)input}")

  for item in "${items[@]}"; do
    # Trim leading/trailing whitespace
    item="${item#"${item%%[![:space:]]*}"}"
    item="${item%"${item##*[![:space:]]}"}"

    # Skip empty entries (e.g., trailing comma)
    [[ -z "$item" ]] && continue

    reminders add "$list" "$item"
  done
}

mkspritesheet() {
  local files=()
  for f in [0-9]*.png; do
    [[ -f "$f" ]] || continue
    files+=("$f")
  done

  if (( ${#files[@]} == 0 )); then
    echo "No numbered PNG files (1xxx.png, 2xxx.png, ...) found in current directory"
    return 1
  fi

  # Sort numerically by leading digits
  files=($(printf '%s\n' "${files[@]}" | sort -n))

  # Validate each file is 128x128 RGBA
  for f in "${files[@]}"; do
    local info
    info=$(python3 -c "
from PIL import Image
img = Image.open('$f')
print(f'{img.size[0]} {img.size[1]} {img.mode}')
" 2>/dev/null)
    if [[ -z "$info" ]]; then
      echo "Error: could not read $f (is Pillow installed?)"
      return 1
    fi
    local w h mode
    read w h mode <<< "$info"
    if [[ "$w" != "128" || "$h" != "128" ]]; then
      echo "Error: $f is ${w}x${h}, expected 128x128"
      return 1
    fi
    if [[ "$mode" != "RGBA" ]]; then
      echo "Error: $f mode is $mode, expected RGBA (transparency)"
      return 1
    fi
  done

  local foldername="${PWD##*/}"
  local outfile="${foldername}_spritesheet.png"
  local count=${#files[@]}
  local filelist=$(printf '"%s",' "${files[@]}")
  filelist="[${filelist%,}]"

  python3 -c "
from PIL import Image
files = $filelist
n = len(files)
gap = 1
width = n * 128 + (n - 1) * gap
canvas = Image.new('RGBA', (width, 128), (0, 0, 0, 0))
for i, f in enumerate(files):
    img = Image.open(f)
    canvas.paste(img, (i * (128 + gap), 0), img)
canvas.save('$outfile')
print(f'Created $outfile ({width}x128) from {n} sprites')
"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sam/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sam/Downloads/google-cloud-sdk/completion.zsh.inc'; fi


# Added by Antigravity CLI installer
export PATH="/Users/sam/.local/bin:$PATH"
