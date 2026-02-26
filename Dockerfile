# Build stage
FROM alpine:3.23 AS builder

WORKDIR /build

# Install build dependencies
RUN apk add --no-cache \
    autoconf \
    automake \
    build-base \
    libnl3-dev \
    libnfnetlink-dev \
    openssl-dev \
    linux-headers \
    git

# Clone and build keepalived
RUN git clone https://github.com/acassen/keepalived.git . && \
    ./build_setup && \
    ./configure --disable-dynamic-linking && \
    make && \
    make install

# Final stage
FROM alpine:3.23

# Add OCI labels
LABEL org.opencontainers.image.title="Keepalived"
LABEL org.opencontainers.image.description="High availability VRRP load balancer"
LABEL org.opencontainers.image.vendor="Peter Weiss"
# LABEL org.opencontainers.image.version=${version}
# LABEL org.opencontainers.image.created=${buildDate}
# (Docker HUB) LABEL "org.opencontainers.image.url"
LABEL org.opencontainers.image.source="https://github.com/peterweissdk/keepalived"
# LABEL org.opencontainers.image.revision=${revision}
# LABEL "org.opencontainers.image.documentation"
LABEL org.opencontainers.image.licenses="GNU GENERAL PUBLIC LICENSE v3.0"
# Indicate that Git metadata is not needed
LABEL org.opencontainers.image.source.no-git=true

# Install runtime dependencies
RUN apk add --no-cache \
    libnl3 \
    libnfnetlink \
    openssl \
    ipvsadm \
    gettext \
    iproute2

# Copy keepalived from builder
COPY --from=builder /usr/local/sbin/keepalived /usr/local/sbin/

# Set working directory
WORKDIR /etc/keepalived

# Create directory for keepalived configuration
RUN mkdir -p /conf

# Copy configuration template and scripts
COPY conf/keepalived.conf_tpl /conf/
COPY healthcheck.sh /
COPY docker-entrypoint.sh /
RUN chmod +x /healthcheck.sh /docker-entrypoint.sh

# Create directory for user scripts
RUN mkdir -p /usr/local/bin /usr/local/scripts

# Copy wrapper script
COPY scripts/check_and_run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/check_and_run.sh

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD ["sh", "-c", "/healthcheck.sh"]

# Expose relevant ports
EXPOSE 112/udp

# Set entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
