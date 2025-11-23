#!/bin/bash
set -e

echo "[WG] Starting WireGuard..."
wg-quick up wg0

echo "[SS] Starting Shadowsocks..."
exec ss-server \
  -s 0.0.0.0 \
  -p "${VIRTUAL_PORT}" \
  -m "${SS_METHOD}" \
  -k "${SS_PASSWORD}" \
  --plugin v2ray-plugin \
  --plugin-opts "${PLUGIN_OPTS}"
