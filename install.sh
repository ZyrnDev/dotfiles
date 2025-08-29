#!/bin/bash

set -euo pipefail

grep -v '^#' packages | xargs -r sudo apt install -yq

for dir in `find . -maxdepth 1 -type d -not -path '.'`; do
    stow --target="$HOME" --restow  "${dir##*/}"
done
