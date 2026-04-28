#!/bin/sh
echo "Solving module-02" >> /tmp/progress.log

cat > ~/Containerfile.pem << 'EOF'
FROM registry.access.redhat.com/hi/curl:latest-builder as builder
COPY ca.pem /tmp/
USER root
RUN trust anchor /tmp/ca.pem
USER ${CONTAINER_DEFAULT_USER}
FROM registry.access.redhat.com/hi/curl:latest
COPY --from=builder /etc/pki/ca-trust/extracted /etc/pki/ca-trust/extracted
EOF

podman build -t curl:local-ca -f ~/Containerfile.pem ~
podman run --net=host --rm curl:local-ca https://localhost:8443
podman stop caddy-ssl

echo "Solve module-02 complete" >> /tmp/progress.log
