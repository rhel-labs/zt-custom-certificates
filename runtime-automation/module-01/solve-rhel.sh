#!/bin/sh
echo "Solving module-01" >> /tmp/progress.log

# Write Containerfile as root before switching to rhel user context
cat > /home/rhel/webserver/Containerfile << 'EOF'
FROM registry.access.redhat.com/hi/caddy:latest
COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html /usr/share/caddy/
EOF
chown rhel:rhel /home/rhel/webserver/Containerfile

runuser -l rhel << 'RHEL_EOF'
podman build -t caddy:ssl -f ~/webserver/Containerfile ~/webserver
podman run --rm -d --name caddy-ssl -p 8443:8443 -v ~/webserver:/usr/share/caddy:ro,Z caddy:ssl
until podman exec caddy-ssl test -f /data/caddy/pki/authorities/local/root.crt 2>/dev/null; do sleep 1; done
podman run --net=host --rm registry.access.redhat.com/hi/curl https://localhost:8443
podman cp caddy-ssl:/data/caddy/pki/authorities/local/root.key ~/
podman cp caddy-ssl:/data/caddy/pki/authorities/local/root.crt ~/
cat ~/root.key ~/root.crt > ~/ca.pem
ls -la ~/root.key ~/root.crt ~/ca.pem
RHEL_EOF

echo "Solve module-01 complete" >> /tmp/progress.log
