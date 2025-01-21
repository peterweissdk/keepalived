#!/bin/sh
set -e

# Check if keepalived process is running
if ! pgrep keepalived >/dev/null; then
    echo "Keepalived process is not running"
    exit 1
fi

# Verify VIRTUAL_IPS environment variable is set
if [ -z "$VIRTUAL_IPS" ]; then
    echo "VIRTUAL_IPS environment variable is not set"
    exit 1
fi

# Check if configured virtual IPs are active on network interfaces
echo "$VIRTUAL_IPS" | tr ',' '\n' | while read -r vip; do
    # Extract just the IP address part if CIDR notation is used (e.g., 192.168.1.100/24 -> 192.168.1.100)
    ip_addr=$(echo "$vip" | cut -d'/' -f1)
    if ! ip addr show | grep -q "$ip_addr"; then
        echo "Virtual IP $ip_addr is not configured on any interface"
        exit 1
    fi
done

echo "Keepalived is healthy"
exit 0
