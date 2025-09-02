#!/bin/bash

set -euo pipefail

grep -v '^#' packages | xargs -r sudo apt install -yq && clear

for dir in `find . -maxdepth 1 -type d -not -path '.' | grep -v '\.git'`; do
    stow --target="$HOME" --restow  "${dir##*/}"
done
