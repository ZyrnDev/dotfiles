#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR/common.sh"

if [ $# -lt 2 ]; then
    log fatal "Usage: $0 <file> <function> [<index>]"
fi

FILE="${1}"
FUNCTION="${2}"
INDEX="${3-$(counter)}"

FILE=$FILE

# STDIN contains the CSV row to use
function telescope() {
    local ROW="$(cat)"

    local EMAIL="$(echo "$ROW" | cut -d, -f1)"
    local PASSWORD="$(echo "$ROW" | cut -d, -f3)"

    xdotool windowactivate --sync "$WINDOW"

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$EMAIL"
    xdotool key --window "$WINDOW" Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$PASSWORD"
    xdotool key --window "$WINDOW" Tab

    xdotool key --window "$WINDOW" Down Down Down Up Up Up Tab space Tab Tab Tab
}

# STDIN contains the CSV row to use
function superset() {
    local ROW="$(cat)"

    local EMAIL="$(echo "$ROW" | cut -d, -f1)"
    local NAME="$(echo "$ROW" | cut -d, -f2)"
    local FIRST_NAME="$(echo "$NAME" | cut -d' ' -f1)"
    local LAST_NAME="$(echo "$NAME" | cut -d' ' -f2-)"
    local PASSWORD="$(echo "$ROW" | cut -d, -f3)"

    xdotool windowactivate --sync "$WINDOW"

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$FIRST_NAME"
    xdotool key --window "$WINDOW" Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$LAST_NAME"
    xdotool key --window "$WINDOW" Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$EMAIL"
    xdotool key --window "$WINDOW" Tab

    xdotool key --window "$WINDOW" space Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$EMAIL"
    xdotool key --window "$WINDOW" Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "View Only"
    xdotool key --window "$WINDOW" Return Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$PASSWORD"
    xdotool key --window "$WINDOW" Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$PASSWORD"
    xdotool key --window "$WINDOW" Tab
}

# STDIN contains the CSV row to use
function email() {
    local ROW="$(cat)"

    local EMAIL="$(echo "$ROW" | cut -d, -f1)"
    local NAME="$(echo "$ROW" | cut -d, -f2)"
    local FIRST_NAME="$(echo "$NAME" | cut -d' ' -f1)"

    xdotool windowactivate --sync "$WINDOW"

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$EMAIL"
    xdotool key --window "$WINDOW" Tab

    xdotool key --window "$WINDOW" Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "Canopus - Account Setup & Onboarding"
    xdotool key --window "$WINDOW" Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        --file <(cat <<EOF | sed 's/$/\r/g' | tr -d '\n'
Hi $FIRST_NAME,

To get started see the FAQ in Canopus Teams channel: How to Login | Frequently Asked Questions
https://aus01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fteams.microsoft.com%2Fl%2Fmessage%2F19%3A91017712d0b341f388784630dd3f05a2%40thread.tacv2%2F1779947118802%3FtenantId%3De37d725c-ab5c-4624-9ae5-f0533e486437%26groupId%3Dd3e1819a-0d1b-4f83-a31f-20bd0684ab8f%26parentMessageId%3D1779947118802%26teamName%3DCanopus%2520-%2520ANU%26channelName%3DFrequently%2520Asked%2520Questions%26createdTime%3D1779947118802&data=05%7C02%7CMitchell.Lee%40anu.edu.au%7Ce7177b94868d430b79b808dec6a0f56e%7Ce37d725cab5c46249ae5f0533e486437%7C0%7C0%7C639166591771323240%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=mHwgR6W6MvGi1c2UhBSM1PgTdVaMe671HVrORezp4QY%3D&reserved=0

Your username is: $EMAIL
Your temporary password can be viewed a single time via the following link (expires in 7 day):
https://send.bitwarden.com/#SuuCQgTBwU-Iu7RlAEQdow/SG_AoscKcQ9De-zDXW5r5g

Please note that this temporary password, so change your password after logging in for the first time.
Additionally, your username is case sensitive, so please ensure you enter it exactly as provided.

Warm Regards,
Mitch - Platform Engineer @ Canopus
EOF
        )
}

function bitwarden() {
    local ROW="$(cat)"

    local EMAIL="$(echo "$ROW" | cut -d, -f1)"
    local PASSWORD="$(echo "$ROW" | cut -d, -f3)"

    xdotool windowactivate --sync "$WINDOW"

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "Canopus Temporary Password - $EMAIL"
    xdotool key --window "$WINDOW" Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "$PASSWORD"
    xdotool key --window "$WINDOW" Tab

    xdotool key --window "$WINDOW" space
    xdotool key --window "$WINDOW" Tab

    xdotool key --window "$WINDOW" Tab
    xdotool key --window "$WINDOW" Tab

    xdotool type --window "$WINDOW" \
        --clearmodifiers \
        "1"
}

if [ "$(type -t "$FUNCTION")" != "function" ]; then
    log fatal "Unknown function handler: $FUNCTION" file "$FILE" function "$FUNCTION"
fi

if [ ! -f "$FILE" ]; then
    log fatal "File does not exist." file "$FILE"
fi

if [ "$INDEX" -lt 1 ]; then
    log fatal "Requested index is less than 1." requested_index "$INDEX"
fi

if [ "$(wc -l < "$FILE")" -lt "$INDEX" ]; then
    log fatal "Requested index is out of bounds." line_count "$(wc -l < "$FILE")" requested_index "$INDEX"
fi

WINDOW=$(xdotool selectwindow)

sed -n "${INDEX}p" "$FILE" \
    | "$FUNCTION"
