#!/bin/sh
set -e

# Check if keepalived process is running
if ! pgrep keepalived >/dev/null; then
    echo "Keepalived process is not running"
    exit 1
fi

# Check if VRRP is active by looking at network interfaces
if ! ip addr show | grep -q "$(cat /etc/keepalived/keepalived.conf | grep virtual_ipaddress -A 1 | tail -n1 | tr -d ' ')"; then
    echo "Virtual IP is not configured"
    exit 1
fi

# Check if keepalived is listening on VRRP port (112)
if ! ss -nlu | grep -q ':112'; then
    echo "Keepalived is not listening on VRRP port"
    exit 1
fi

echo "Keepalived is healthy"
exit 0
