#!/usr/bin/env bash
set -euo pipefail

./install.sh --skip-packages
clear
git-auto-commit
