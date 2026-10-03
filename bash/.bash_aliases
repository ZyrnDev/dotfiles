# Custom Scripts & Tools
alias zr='zentr'
alias zl='zellij-layout'

# AI
alias ai='opencode'
alias aic='opencode session list --format json | jq -r ".[].id" | xargs -r opencode session delete'
# alias ais="opencode --session `opencode session list --format json | jq -r '.[] | \"\(.title) (\(.id))\"' | gum filter | sed -E 's/.* \((.*)\)$/\1/'`"

# Clipboard
alias xc='xclip -in -selection clipboard'
alias xp='xclip -out -selection clipboard'

# X11
alias xws='xwindow-select'
alias xwp='xwindow-paste --id=$(xdotool selectwindow)'

# Git
alias ga='git add'
alias gac='git-auto-commit'
alias gf='git fetch'
alias gs='git status'
alias gu='git fetch && git merge'
alias gr='git-rebase'

# Tailscale CLI
alias ts='tailscale'
alias tsh='tailscale status --json | jq -r '.Peer[].HostName' | gum filter'
alias tsf='fix-tailscale'

# BitWarden CLI
alias bw='rbw'
alias bwp='bitwarden-password --clipboard'

# Go
alias go='docker run --rm --network=host -w /app -v "$(pwd):/app" golang:latest'
