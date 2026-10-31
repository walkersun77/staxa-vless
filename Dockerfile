FROM alpine:3.20
# sing-box (VLESS+WS server) + nginx (decoy site on /, WS reverse-proxy on $WS_PATH)
RUN apk add --no-cache nginx curl ca-certificates && \
    SB_VER=1.11.15 && \
    curl -fsSL -o /tmp/sb.tar.gz "https://github.com/SagerNet/sing-box/releases/download/v${SB_VER}/sing-box-${SB_VER}-linux-arm64.tar.gz" && \
    tar -xzf /tmp/sb.tar.gz -C /tmp && \
    install -m 755 /tmp/sing-box-*/sing-box /usr/local/bin/sing-box && \
    rm -rf /tmp/sb.tar.gz /tmp/sing-box-*
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY config.json.template /etc/sing-box/config.json.template
COPY index.html /usr/share/nginx/html/index.html
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# NOTE: sing-box release arch above is arm64 (Staxa runs on Hetzner CAX = ARM).
# If the build log shows exec format error, switch the tarball to linux-amd64.
EXPOSE 8080
CMD ["/entrypoint.sh"]
