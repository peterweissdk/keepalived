#!/bin/sh
set -e

# Set timezone if provided
if [ -n "$TZ" ]; then
    ln -snf /usr/share/zoneinfo/"$TZ" /etc/localtime
    echo "$TZ" > /etc/timezone
fi

# Log the keepalived version
keepalived --version

# Start keepalived in non-daemon mode with console logging
exec keepalived --dont-fork --log-console --log-detail --dump-conf