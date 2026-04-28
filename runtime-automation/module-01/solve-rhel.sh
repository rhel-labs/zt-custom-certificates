#!/bin/sh
echo "Solving module-01" >> /tmp/progress.log

cat > ~/webserver/Containerfile << 'EOF'
FROM registry.access.redhat.com/hi/caddy:latest
COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html /usr/share/caddy/
EOF

podman build -t caddy:ssl -f ~/webserver/Containerfile ~/webserver
podman run --rm -d --name caddy-ssl -p 8443:8443 -v ~/webserver:/usr/share/caddy:ro,Z caddy:ssl
sleep 2
podman cp caddy-ssl:/data/caddy/pki/authorities/local/root.key .
podman cp caddy-ssl:/data/caddy/pki/authorities/local/root.crt .
cat root.key root.crt > ca.pem

echo "Solve module-01 complete" >> /tmp/progress.log
