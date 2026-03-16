#!/usr/bin/env bash
set -euo pipefail

for dependency in gum; do
    if ! command -v "$dependency" &> /dev/null; then
        echo "Error: $dependency is not installed." >&2
        exit 1
    fi
done

function log() {
    if [ $# -lt 1 ]; then
        log fatal 'log requires at least one argument'
    fi
    local level="$1"
    shift
    gum log --time rfc822 --structured --level "$level" "$@"
}

function prompt_choice() {
    if [ $# -lt 1 ]; then
        log error 'prompt_choice requires at least one argument, try: prompt_choice <ID> [<option>]...'
    fi
    local ID="$1"
    shift
    if [ "${HEADLESS:-false}" = true ] && [ ! -v "$ID" ]; then
        log error "environment variable is not set" variable "$ID"
    elif [ -v "$ID" ]; then
        grep -xF "${!ID:-}" | head -n 1 \
          || log error "environment variable does not match any of the options" variable "$ID" value "${!ID:-}"
    else
        gum choose "$@"
    fi
}

###############################
# string helpers
###############################

function trim() {
    sed -E 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

################################
## jq helpers
################################
#
#function to-json() {
#    jq -R '.'
#}
#
#function to-object() {
#    if [ "$#" -ne 1 ]; then
#        echo "Usage: to-object <key>" 1>&2
#        exit 1
#    fi
#    jq --arg key "$1" '{($key): .}'
#}
#
#function to-array() {
#    jq -s '.'
#}
#
#function merge() {
#    jq -s 'add'
#}
