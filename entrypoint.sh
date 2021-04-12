#!/usr/bin/env bash
# Inspired by https://github.com/boldt/turn-server-docker-image/blob/master/deploy-turnserver.sh

set -e

if [[ -z "$COTURN_SECRET" ]]; then
    echo "\$COTURN_SECRET is required"
    exit 2
fi
if [[ -z "$COTURN_REALM" ]]; then
    echo "\$COTURN_REALM is required"
    exit 2
fi

MIN_PORT=${MIN_PORT:-65435}
MAX_PORT=${MAX_PORT:-65535}
VERBOSE=${VERBOSE:-false}
set -x
internal_ip="$(ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"
external_ip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
set +x

template=$(cat <<EOT
listening-port=3478
#tls-listening-port=5349
min-port=$MIN_PORT
max-port=$MAX_PORT
listening-ip="$internal_ip"
relay-ip="$internal_ip"
external-ip="$external_ip"

use-auth-secret
static-auth-secret="$COTURN_SECRET"
realm="$COTURN_REALM"

no-stdout-log
log-file=stdout
EOT
)
if [[ "$VERBOSE" == true ]]; then
    template+=$'\nverbose'
fi

set -v

echo "$template" | tee /etc/turnserver.conf | grep -v 'secret'

echo "Starting TURN server..."
turnserver
