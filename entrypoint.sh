#!/usr/bin/env bash
# Inspired by https://github.com/boldt/turn-server-docker-image/blob/master/deploy-turnserver.sh

set -ex
if [[ -z "$INTERNAL_IP" ]]; then
    INTERNAL_IP="$(ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')"
fi
if [[ -z "$EXTERNAL_IP" ]]; then
    EXTERNAL_IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
    if [[ -z "$EXTERNAL_IP" ]]; then
        EXTERNAL_IP="$(dig -4 +short myip.opendns.com @resolver1.opendns.com)"
    fi
fi
export INTERNAL_IP EXTERNAL_IP
set +x

/env2config
echo "Starting TURN server..."
turnserver
