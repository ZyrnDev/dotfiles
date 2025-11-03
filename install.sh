#!/bin/bash

set -euo pipefail

sudo mkdir -p /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/charm.gpg ] || [ ! -f /etc/apt/sources.list.d/charm.list ]; then
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update
fi

grep -v '^#' packages | xargs -r sudo apt install -yq
clear

for dir in `find . -maxdepth 1 -type d -not -path '.' | grep -v '\.git'`; do
    stow --target="$HOME" --restow  "${dir##*/}"
done
