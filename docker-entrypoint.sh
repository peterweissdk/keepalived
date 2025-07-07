#!/bin/sh
set -e

# Set timezone if provided
if [ -n "$TZ" ]; then
    ln -snf /usr/share/zoneinfo/"$TZ" /etc/localtime
    echo "$TZ" > /etc/timezone
fi

# Format the UNICAST_PEERS for proper indentation
export UNICAST_PEERS=$(echo "$UNICAST_PEERS" | tr ',' '\n' | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g' | sed 's/^/        /')

# Generate keepalived configuration from template
envsubst < /conf/keepalived.conf_tpl > /etc/keepalived/keepalived.conf

# Log the keepalived version
keepalived --version

# Start keepalived in non-daemon mode with console logging
exec keepalived --dont-fork --log-console --log-detail --dump-conf