#!/usr/bin/env bash
set -euo pipefail

cat << EOF | column -t -s ' '
ACTION DIRECTION SOURCE DESTINATION
ALLOW INBOUND mars5.sdn.unsw.edu.au:* mercury2.canopusnet.dev:3000
ALLOW INBOUND mercury2.canopusnet.dev:* mars5.sdn.unsw.edu.au:5003
ALLOW INBOUND mercury2.canopusnet.dev:* mars5.sdn.unsw.edu.au:6667
ALLOW INBOUND mercury2.canopusnet.dev:* mars5.sdn.unsw.edu.au:8083
ALLOW INBOUND mercury2.canopusnet.dev:* mars5.sdn.unsw.edu.au:29092
EOF

# ./install.sh --skip-packages
# clear
# git-auto-commit
