#!/bin/sh
set -e
# Required env (set as Staxa service env vars, never commit to the repo):
#   VLESS_UUID  - uuid for the VLESS user
#   WS_PATH     - websocket path, e.g. /xxxxxxxxxxxxxxxx
# Optional:
#   PORT        - port Staxa ingress routes to (default 8080, must match service port in tenant payload)
PORT="${PORT:-8080}"
: "${VLESS_UUID:?VLESS_UUID env missing}"
: "${WS_PATH:?WS_PATH env missing}"

sed -e "s|__PORT__|${PORT}|g" -e "s|__WS_PATH__|${WS_PATH}|g" \
    /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
sed -e "s|__VLESS_UUID__|${VLESS_UUID}|g" -e "s|__WS_PATH__|${WS_PATH}|g" \
    /etc/sing-box/config.json.template > /etc/sing-box/config.json

sing-box check -c /etc/sing-box/config.json
sing-box run -c /etc/sing-box/config.json &
exec nginx -g 'daemon off;'
