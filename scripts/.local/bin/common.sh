#!/usr/bin/env bash

set -euo pipefail

for dependency in gum; do
    if ! command -v "$dependency" &> /dev/null; then
        echo "Error: $dependency is not installed." >&2
        exit 1
    fi
done

function log() {
    local level="$1"
    shift;
    gum log --time rfc822 --structured --level "$level" "$@"
}

# # Source - https://stackoverflow.com/a
# # Posted by c.gutierrez, modified by community. See post 'Timeline' for change history
# # Retrieved 2025-11-11, License - CC BY-SA 4.0
# yell() { echo "$0: $*" >&2; }
# die() { yell "$*"; exit 111; }
# try() { "$@" || die "cannot $*"; }
