# 💾 Keepalived Docker Container

[![Static Badge](https://img.shields.io/badge/Docker-Container-white?style=flat&logo=docker&logoColor=white&logoSize=auto&labelColor=black)](https://docker.com/)
[![Static Badge](https://img.shields.io/badge/Alpine-V3.21-white?style=flat&logo=alpinelinux&logoColor=white&logoSize=auto&labelColor=black)](https://www.alpinelinux.org/)
[![Static Badge](https://img.shields.io/badge/KeepAliveD-V2.3.2-white?style=flat&logoColor=white&labelColor=black)](https://keepalived.org/)
[![Static Badge](https://img.shields.io/badge/GPL-V3-white?style=flat&logo=gnu&logoColor=white&logoSize=auto&labelColor=black)](https://www.gnu.org/licenses/gpl-3.0.en.html/)
[![Lint Code Base](https://github.com/peterweissdk/keepalived/actions/workflows/linter.yml/badge.svg?branch=main)](https://github.com/peterweissdk/keepalived/actions/workflows/linter.yml)
[![Docker Build](https://github.com/peterweissdk/keepalived/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/peterweissdk/keepalived/actions/workflows/docker-publish.yml)

A lightweight, Alpine-based Docker container for running Keepalived with VRRP (Virtual Router Redundancy Protocol) support.

## ✨ Features

- **Alpine-based**: Lightweight and secure base image
- **VRRP support**: High availability with Virtual Router Redundancy Protocol (VRRP)
- **Easy Configuration**: Configure Keepalived using environment variables
- **Health Checks**: Monitor service health with built-in Docker health checks

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

# Run the container using the provided Docker Compose and .env file
docker compose up -d
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Example |

- `VRRP_INSTANCE`: VRRP instance name - VI_1
- `INTERFACE`: Network interface - eth0
- `STATE`: Node state (MASTER/BACKUP) - MASTER
- `PRIORITY`: Node priority (1-255) - 100
- `ROUTER_ID`: Unique router ID - 50
- `VIRTUAL_IPS`: Virtual IP address - 192.168.1.100/24
- `UNICAST_SRC_IP`: Source IP for unicast - 192.168.1.101
- `UNICAST_PEERS`: Peer IP address - 192.168.1.102

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
├── docker-compose.yml
├── LICENSE
└── README.md
```

## 🔍 Health Check

The container includes a comprehensive health check system that monitors:

1. Keepalived Process Status
   - Verifies the keepalived daemon is running

2. Virtual IP environment variable
   - Verifies the VIRTUAL_IPS environment variable is set
   
3. Virtual IP Configuration
   - Confirms configured virtual IPs are active on network interfaces
   - Supports multiple IPs and CIDR notation

Health checks run every 30 seconds with the following parameters:
```

Vdockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD ["/healthcheck.sh"]
```iew container health status:
```bash
# View health status
docker inspect --format='{{.State.Health.Status}}' keepalived

# View detailed health check history
docker inspect --format='{{json .State.Health}}' keepalived | jq

# Watch health status in real-time
watch -n 5 'docker inspect --format="{{.State.Health.Status}}" keepalived'
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Code Quality

This repository uses [Super-Linter](https://github.com/super-linter/super-linter) to maintain code quality. The linter will run automatically on all pull requests and pushes to main/master branches.

## 🆘 Support

If you encounter any issues or need support, please file an issue on the GitHub repository.

## 📄 License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v3.0 - see the [LICENSE](LICENSE) file for details.