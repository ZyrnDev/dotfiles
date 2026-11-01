# shellcheck shell=bash
# Shared by agent-vault (client) and agent-vault-broker. Each sources the copy
# that sits next to it, so the root-owned broker only ever loads root-owned code.

AV_LIB_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
AV_INSTALLED_BROKER=/usr/local/lib/agent-vault/agent-vault-broker
AV_CONF=/etc/agent-vault.conf
AV_DEFAULT_TTL=30m
AV_MAX_TTL=86400

###############################
# messages
###############################

function av_die() {
    echo "agent-vault: $*" >&2
    exit 1
}

# exit 3 lets callers tell "not allowed" apart from errors
function av_deny() {
    echo "agent-vault: $*" >&2
    exit 3
}

###############################
# config
###############################

# the rbw owner; read as data rather than sourced, since agents run this too
function av_owner() {
    local owner=""
    [ -r "$AV_CONF" ] && owner=$(sed -n 's/^AGENT_VAULT_OWNER=//p' "$AV_CONF" | head -n 1)
    echo "${AGENT_VAULT_OWNER:-${owner:-$(id -un)}}"
}

# the root-owned copy is what sudoers allows; fall back to the dotfiles copy
function av_broker_path() {
    if [ -n "${AGENT_VAULT_BROKER:-}" ]; then
        echo "$AGENT_VAULT_BROKER"
    elif [ -x "$AV_INSTALLED_BROKER" ]; then
        echo "$AV_INSTALLED_BROKER"
    else
        echo "$AV_LIB_DIR/agent-vault-broker"
    fi
}

###############################
# validation
###############################

# 90s, 30m, 2h, 1d -> seconds
function av_parse_ttl() {
    local ttl="$1" n unit
    [[ $ttl =~ ^([0-9]+)([smhd]?)$ ]] || av_die "bad ttl: $ttl (use e.g. 90s, 30m, 2h)"
    n=$((10#${BASH_REMATCH[1]}))
    unit="${BASH_REMATCH[2]}"
    case "$unit" in
        m) n=$((n * 60)) ;;
        h) n=$((n * 3600)) ;;
        d) n=$((n * 86400)) ;;
    esac
    [ "$n" -gt 0 ] && [ "$n" -le "$AV_MAX_TTL" ] || av_die "ttl must be between 1s and ${AV_MAX_TTL}s"
    echo "$n"
}

function av_is_uint() {
    [[ $1 =~ ^[0-9]+$ ]]
}

function av_is_token() {
    [[ $1 =~ ^av_[A-Za-z0-9_-]{32,}$ ]]
}

# NAME or NAME#field; NAME is an rbw name or UUID
function av_check_item() {
    [[ -n $1 && $1 != \#* && $1 != *$'\n'* ]] || av_die "bad item: $1"
}

###############################
# tokens
###############################

function av_new_token() {
    echo "av_$(head -c 32 /dev/urandom | base64 | tr '+/' '-_' | tr -d '=\n')"
}

function av_new_id() {
    od -An -N4 -tx1 /dev/urandom | tr -d ' \n'
}

function av_hash() {
    printf '%s' "$1" | sha256sum | cut -d' ' -f1
}
