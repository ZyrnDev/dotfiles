#!/usr/bin/env bash

set -euo pipefail

# Source - https://stackoverflow.com/a

# Posted by c.gutierrez, modified by community. See post 'Timeline' for change history

# Retrieved 2025-11-11, License - CC BY-SA 4.0

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }


