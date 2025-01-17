# Build stage
FROM alpine:3.21 as builder

# Install build dependencies
RUN apk add --no-cache \
    autoconf=2.72-r0 \
    automake=1.17-r0 \
    build-base=0.5-r3 \
    libnl3-dev=3.11.0-r0 \
    libnfnetlink-dev=1.0.2-r3 \
    openssl-dev=3.3.2-r4 \
    linux-headers=6.6-r1 \
    git=2.47.2-r0

# Clone and build keepalived
RUN git clone https://github.com/acassen/keepalived.git /tmp/keepalived && \
    cd /tmp/keepalived && \
    ./build_setup && \
    ./configure --disable-dynamic-linking && \
    make && \
    make install

# Final stage
FROM alpine:3.21

# Install runtime dependencies
RUN apk add --no-cache \
    libnl3=3.11.0-r0 \
    libnfnetlink=1.0.2-r3 \
    openssl=3.3.2-r4 \
    ipvsadm=1.31-r3 \
    gettext=0.22.5-r0

# Copy keepalived from builder
COPY --from=builder /usr/local/sbin/keepalived /usr/local/sbin/

# Create directory for keepalived configuration
RUN mkdir -p /etc/keepalived /conf

# Copy configuration template
COPY conf/keepalived.conf_tpl /conf/

# Copy and set up entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Expose relevant ports
EXPOSE 112/udp

# Set entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
