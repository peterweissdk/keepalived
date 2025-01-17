# 💾 Keepalived Docker Container

A lightweight, Alpine-based Docker container for running Keepalived with VRRP (Virtual Router Redundancy Protocol) support.

## ✨ Features

- Alpine-based for minimal footprint
- VRRP support for high availability
- Environment variable configuration
- Built-in health monitoring
- Supports multiple virtual IPs
- Unicast peer support
- Docker health checks

## 🚀 Quick Start

Run the container:
```bash
# Pull the image
docker pull peterweissdk/keepalived

# Run with custom configuration
docker run -d \
  --name keepalived \
  --restart=unless-stopped \
  --cap-add=NET_ADMIN \
  --cap-add=NET_BROADCAST \
  --cap-add=NET_RAW \
  --net=host \
  --env-file .env \
  keepalived:latest
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| INTERFACE | Network interface to use | eth0 |
| STATE | Initial VRRP state (MASTER/BACKUP) | MASTER |
| PRIORITY | Node priority (higher number = higher priority) | 200 |
| ROUTER_ID | Unique router ID | 52 |
| VIRTUAL_IPS | Virtual IP addresses (comma-separated) | 192.168.1.100/24 |
| UNICAST_SRC_IP | Source IP for unicast VRRP | 192.168.1.4 |
| UNICAST_PEERS | Peer IPs for unicast VRRP | 192.168.1.6 |

### Required Capabilities

- NET_ADMIN: For network interface configuration
- NET_BROADCAST: For VRRP advertisements
- NET_RAW: For raw socket access

## 🏗️ Building from Source

```bash
# Clone the repository
git clone https://github.com/peterweissdk/keepalived.git
cd keepalived

# Build the image
docker build -t keepalived:latest .
```

## 📝 Directory Structure

```bash
keepalived/
├── conf/
│   └── keepalived.conf_tpl
├── .env
├── Dockerfile
├── docker-entrypoint.sh
├── healthcheck.sh
├── LICENSE
└── README.md
```

## 🔍 Health Check

The container includes a comprehensive health check system that monitors:

1. Keepalived Process Status
   - Verifies the keepalived daemon is running

2. Virtual IP Configuration
   - Confirms configured virtual IPs are active on network interfaces
   - Supports multiple IPs and CIDR notation

3. VRRP Service Status
   - Checks if keepalived is listening on VRRP port (112)

Health checks run every 30 seconds with the following parameters:
```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD ["/healthcheck.sh"]
```

View container health status:
```bash
docker inspect --format='{{.State.Health.Status}}' keepalived
```
## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🆘 Support

If you encounter any issues or need support, please file an issue on the GitHub repository.

## 📄 License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v3.0 - see the [LICENSE](LICENSE) file for details.