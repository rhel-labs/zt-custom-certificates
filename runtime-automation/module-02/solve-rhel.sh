#!/bin/sh
echo "Solving module-02" >> /tmp/progress.log

# Write Containerfile as root before switching to rhel user context
cat > /home/rhel/Containerfile.pem << 'EOF'
FROM registry.access.redhat.com/hi/curl:latest-builder as builder
COPY ca.pem /tmp/
USER root
RUN trust anchor /tmp/ca.pem
USER ${CONTAINER_DEFAULT_USER}
FROM registry.access.redhat.com/hi/curl:latest
COPY --from=builder /etc/pki/ca-trust/extracted /etc/pki/ca-trust/extracted
EOF
chown rhel:rhel /home/rhel/Containerfile.pem

runuser -l rhel << 'RHEL_EOF'
podman build -t curl:local-ca -f ~/Containerfile.pem ~
podman run --net=host --rm curl:local-ca https://localhost:8443
podman stop caddy-ssl
RHEL_EOF

echo "Solve module-02 complete" >> /tmp/progress.log
