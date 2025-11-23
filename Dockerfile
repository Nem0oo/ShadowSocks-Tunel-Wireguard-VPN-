FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# Installer Shadowsocks + WireGuard + dépendances
RUN apt-get update && apt-get install -y \
    shadowsocks-libev \
    wireguard-tools \
    iproute2 \
    procps \
    iptables \
    ca-certificates \
    wget \
    openresolv \
    && rm -rf /var/lib/apt/lists/*

# Télécharger v2ray-plugin DANS le conteneur
RUN wget -O /tmp/v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz \
    && tar -xzf /tmp/v2ray-plugin.tar.gz -C /tmp \
    && mv /tmp/v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin \
    && chmod +x /usr/local/bin/v2ray-plugin \
    && rm /tmp/v2ray-plugin.tar.gz

# Copier le script d'entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Créer /dev/net/tun (nécessaire pour WireGuard)
RUN mkdir -p /dev/net && \
    [ -c /dev/net/tun ] || mknod /dev/net/tun c 10 200

ENTRYPOINT ["/entrypoint.sh"]
