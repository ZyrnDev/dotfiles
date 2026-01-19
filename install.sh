#!/bin/bash

set -euo pipefail

SKIP_PACKAGES=false

# handle args
for arg in "$@"; do
    case $arg in
        --skip-packages)
        SKIP_PACKAGES=true
        shift
        ;;
        *)
        gum log -l fatal "Unknown argument: $arg"
        ;;
    esac
done

if [ "$SKIP_PACKAGES" = false ]; then
    sudo mkdir -p /etc/apt/keyrings
    if [ ! -f /etc/apt/keyrings/charm.gpg ] || [ ! -f /etc/apt/sources.list.d/charm.list ]; then
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update
    fi

    grep -v '^#' packages | xargs -r sudo apt install -yq
    curl -fsSL 'https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz' | tar -xz -C ~/.local/bin zellij
    curl -fsSL 'https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage' -o ~/.local/bin/nvim && chmod +x ~/.local/bin/nvim
fi

for dir in `find . -maxdepth 1 -type d -not -path '.' | grep -v '\.git'`; do
    stow --target="$HOME" --restow  "${dir##*/}"
done
