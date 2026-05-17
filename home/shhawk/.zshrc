#############################################
###              ZSH CONFIG                ###
##############################################

##########  ENV & PATH  ##########

export ZSH="$HOME/.oh-my-zsh"

# PATH propre, sans doublons
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:$PATH"
typeset -U path PATH

##########  FONCTIONS / UTILITAIRES ##########

alias zr='source ~/.zshrc'
alias d='$EDITOR .'
alias ajm='sshpass -p "B@iC8D\$c7d4i8mefYw" ssh -o StrictHostKeyChecking=no debian@149.202.59.73'

##########  OH-MY-ZSH  ##########

ZSH_THEME="agnosterzak"

plugins=(
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

##########  FASTFETCH / POKEMON  ##########

pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

##########  FZF (CTRL+R historique fuzzy) ##########

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

##########  HISTOIRE ZSH ##########

HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000

setopt appendhistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt sharehistory

##########  OPTIONS ZSH UTILES ##########

setopt autocd
setopt correct
setopt completealiases
setopt interactivecomments

##########  ALIAS FLEMME ##########

alias install='sudo dnf install'
alias update='sudo dnf update && sudo dnf upgrade'

##########  ALIAS LS (via lsd) ##########

if command -v lsd >/dev/null 2>&1; then
    alias ls='lsd'
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls --tree'
else
    alias ls='ls --color=auto'
    alias l='ls -l'
    alias la='ls -A'
    alias lla='ls -la'
fi

##########  ALIAS COURANTS ##########

alias e="$EDITOR"
alias se="sudo $EDITOR"
alias c="clear"

unalias up 2>/dev/null

function up() {
  local level=${1:-1}

  if ! [[ "$level" == <-> ]]; then
    echo "Usage: up [nombre]" >&2
    return 1
  fi

  local target="$PWD"

  for ((i = 0; i < level; i++)); do
    [[ "$target" == "/" ]] && break
    target=${target%/*}
    [[ -z "$target" ]] && target="/"
  done

  cd "$target" || return
}

alias ff='find . -iname'
alias pg='ps aux | grep -i'
alias used='lsof -i -P -n'
alias uptime="uptime -p"

##########  ALIAS GIT ##########

alias gg='git log --graph --pretty=format:"%C(yellow)%h%Creset%C(bold blue)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias ga="git add"
alias gs="git status -sb"
alias gd="git difftool"
alias gdc="git difftool --cached"
alias gp="git push"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcm="git commit -m"
alias gcs="git commit -S -m"
alias gx="git reset --hard @"
alias gu="git reset @ --"
alias gri='git rebase -i --autosquash'
alias gpf='git push --force-with-lease'
alias gcfx='git commit --fixup HEAD'
alias gpl='git pull --rebase --prune'

gwork() {
  echo "-----------------"
  echo "Branche actuelle :"
  echo "-----------------"
  git branch --show-current 2>/dev/null || echo "Pas un repo git"

  echo
  echo "-----------------"
  echo "Statut :"
  echo "-----------------"
  git status -sb 2>/dev/null || return

  echo
  echo "-----------------"
  echo "Derniers commits :"
  echo "-----------------"
  git log --oneline -5 --decorate 2>/dev/null
}

##########  ALIAS CYBER / REVERSE / BINAIRE ##########

alias elf='readelf -a'
alias sect='objdump -h'
alias dasm='objdump -d -Mintel'
alias archf='file -L'
alias hx='hexdump -C'
alias str4='strings -n 4'
alias bdiff='diff <(xxd "$1") <(xxd "$2")'

alias protect='checksec --file'
alias gdbg='gdb -q -ex "init-pwndbg"'
alias nocore='ulimit -c 0'

alias gccf='gcc -Wall -Wextra -O2'
alias asm64='nasm -f elf64'
alias asm32='nasm -f elf32'
alias run='./a.out'

alias pn='ping -c 3'
alias nmr='sudo nmap -T4 -A -v'
alias nmf='sudo nmap -sV -sC -T4'
alias myip='curl ifconfig.me'
alias ipinfo='curl ifconfig.me/all'
alias ports="ss -tulpen"
alias sniff='sudo tcpdump -i any -vv -nn'

killport() {
  if [ -z "$1" ]; then
    echo "Usage: killport <port>" >&2
    return 1
  fi
  sudo kill -9 "$(sudo lsof -t -i:$1)" 2>/dev/null || echo "Rien sur le port $1"
}

##########  EXTRACT ##########

extract() {
  if [ -z "$1" ]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|exe|tar.bz2|tar.gz|tar.xz>"
    return 1
  fi

  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xvjf "$1" ;;
      *.tar.gz)  tar xvzf "$1" ;;
      *.tar.xz)  tar xvJf "$1" ;;
      *.lzma)    unlzma "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x -ad "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xvf "$1" ;;
      *.tbz2)    tar xvjf "$1" ;;
      *.tgz)     tar xvzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *.xz)      unxz "$1" ;;
      *.exe)     cabextract "$1" ;;
      *)         echo "extract: '$1' - méthode d'archivage inconnue !" ;;
    esac
  else
    echo "$1 - file does not exist"
  fi
}

##########  AUTO VENV PYTHON ##########

_auto_venv() {
  if [[ -n "$VIRTUAL_ENV" && ! -d "./.venv" ]]; then
    deactivate 2>/dev/null
  elif [[ -z "$VIRTUAL_ENV" && -d "./.venv" ]]; then
    source "./.venv/bin/activate" 2>/dev/null && echo "[venv activé]"
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _auto_venv
_auto_venv

##########  TIMER DE VERROUILLAGE ##########

timelock() {
  if [[ -z "$1" ]]; then
    echo "Usage : timelock <DURATION>"
    echo "Exemples : timelock 10m | timelock 1h | timelock 25s"
    return 1
  fi

  if ! command -v termdown >/dev/null 2>&1; then
    echo "Erreur : termdown n'est pas installé."
    echo "Installe-le avec : sudo dnf install termdown"
    return 1
  fi

  if ! command -v hyprlock >/dev/null 2>&1; then
    echo "Erreur : hyprlock n'est pas installé."
    echo "Installe-le avec : sudo dnf install hyprlock"
    return 1
  fi

  local timespec="$*"
  echo "Verrouillage programmé dans : $timespec (Ctrl+C pour annuler)"
  echo

  termdown "$timespec"
  local status=$?

  if (( status != 0 )); then
    echo "Timer interrompu (code $status) : aucun verrouillage."
    return $status
  fi

  hyprlock
}

alias wl='hyprlock'

##########  DOTFILES EXPORT ##########

dotexport() {
  local repo="$HOME/Dotfiles"

  echo "[*] Sync vers $repo"
  mkdir -p "$repo"

  if [[ ! -w "$repo" ]]; then
    echo "[-] Le dossier $repo n'est pas inscriptible."
    echo "    Corrige les droits avec :"
    echo "    sudo chown -R $USER:$USER \"$repo\""
    return 1
  fi

  local items=(
    "$HOME/.zshrc"
    "$HOME/.gitconfig"
    "$HOME/.config/kitty"
    "$HOME/.config/hypr"
    "$HOME/.config/nvim"
    "$HOME/.config/fastfetch"
    "$HOME/.config/tmux"
  )

  for item in "${items[@]}"; do
    if [[ -e "$item" ]]; then
      echo "  -> $item"
      rsync -avh --delete --relative "$item" "$repo"/
    else
      echo "  (skip) $item n'existe pas"
    fi
  done

  echo
  echo "[*] Export terminé."
  echo "[*] État Git :"
  git -C "$repo" status --short
}



#########################FIN #################################

# opencode
export PATH=/home/shhawk/.opencode/bin:$PATH
