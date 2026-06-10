# ============================================================
# Bash basics
# ============================================================

# Enable colors
export CLICOLOR=1
export LS_COLORS='di=34:ln=36:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;43:tw=30;42:ow=30;43'

# Better history
export HISTCONTROL=ignoreboth
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend
shopt -s cmdhist

# ============================================================
# oh-my-posh prompt
# ============================================================

eval "$(oh-my-posh init bash --config 'C:\Users\khalf\AppData\Local\Programs\oh-my-posh\themes\stelbent.minimal.omp.json')"

# ============================================================
# zoxide
# ============================================================

export PATH="$PATH:/c/ProgramData/chocolatey/bin"
eval "$(zoxide init bash)"

# ============================================================
# Git aliases (modern Git)
# ============================================================

alias g='git'
alias gs='git status'
alias gsw='git switch'
alias gswc='git switch -c'
alias ga='gax'
alias gaa='git add .'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'

alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'

alias gl='git log --oneline --graph --decorate'
alias gll='git log --stat'
alias glp='git log -p'

alias gfo='git fetch origin'
alias gpl='git pull'
alias gp='git push'

alias grs='git restore'
alias grss='git restore --staged'

alias gm='git merge'
alias gma='git merge --abort'

# Quick commit
alias gcap='git add . && git commit -m'

# Branches
alias dev='git switch develop'

alias sit='git switch pym-sit/haabeel'
alias rsit='git switch r1/pym-sit/haabeel'

alias uat='git switch pym-uat/haabeel'
alias ruat='git switch r1/pym-uat/haabeel'

# ============================================================
# Quality of life
# ============================================================

alias clr='clear'
alias vbsh='vi ~/.bashrc'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias pym='z frontend && pnpm dev'
# ============================================================
# Colorized, indexed git status
# ============================================================

function gsn {
  git status --short | awk '
  BEGIN {
    RESET="\033[0m"
    GREEN="\033[32m"   # staged
    YELLOW="\033[33m"  # unstaged
    BLUE="\033[34m"    # staged + unstaged
    MAGENTA="\033[35m" # untracked
  }
  {
    x = substr($0, 1, 1)
    y = substr($0, 2, 1)
    path = substr($0, 4)

    if ($0 ~ /^\?\?/) {
      color = MAGENTA
    } else if (x != " " && y != " ") {
      color = BLUE
    } else if (x != " ") {
      color = GREEN
    } else if (y != " ") {
      color = YELLOW
    } else {
      color = RESET
    }

    printf "%s%2d.%s %s%s%s\n", color, NR-1, RESET, color, $0, RESET
  }'
}

# ============================================================
# Index-based git add (gax 0 2 3)
# ============================================================

function gax {
  if [ "$#" -eq 0 ]; then
    git add .
    return
  fi

  local i=0
  git status --short | while IFS= read -r line; do
    file="${line#?? }"
    for arg in "$@"; do
      if [ "$arg" = "$i" ]; then
        git add "$file"
      fi
    done
    i=$((i + 1))
  done
}

# ============================================================
# Push current branch and set upstream automatically
# ===========================================================

function gpso { git push -u origin "$(git branch --show-current)"; }

# =============================================================
# Branch switcher
# =============================================================
function gbs() {
    local branch

    branch=$(
        git branch --all --format='%(refname:short)' |
        sed 's#^origin/##' |
        sort -u |
        fzf --height 40% --reverse
    )

    [ -n "$branch" ] && git switch "$branch"
}

# =============================================================
# Branch Switcher (Recent Branches)
# =============================================================
function gbr() {
    git for-each-ref \
        --sort=-committerdate \
        refs/heads \
        --format='%(refname:short)' |
    head -20 |
    fzf --height 40% --reverse |
    xargs git switch
}

# ============================================================ #
# End of .bashrc                                               #
# ============================================================ #
