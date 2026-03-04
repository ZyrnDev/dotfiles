alias zr='zentr'
alias zl='zellij-layout'

alias xc='xclip -in -selection clipboard'
alias xp='xclip -out -selection clipboard'

# Git aliases
alias gf='git fetch'
alias gs='git status'
alias gu='git fetch && git merge'
alias gr='git-rebase'

# Tailscale CLI alias
alias ts='tailscale'
alias tsh='tailscale status --json | jq -r '.Peer[].HostName' | gum filter'

# BitWarden CLI aliases
alias bw='bitwarden'
alias bwp='bitwarden-password'
