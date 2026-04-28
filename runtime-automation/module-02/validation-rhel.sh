#!/bin/sh
echo "Validating module-02" >> /tmp/progress.log

if ! runuser -u rhel -- podman image exists localhost/curl:local-ca; then
    echo "FAIL: Image localhost/curl:local-ca not found" >> /tmp/progress.log
    echo "HINT: Build the image with: podman build -t curl:local-ca -f ~/Containerfile.pem ~" >> /tmp/progress.log
    exit 1
fi

if ! runuser -u rhel -- podman ps --filter name=caddy-ssl --format '{{.Names}}' | grep -q caddy-ssl; then
    echo "FAIL: caddy-ssl container is not running" >> /tmp/progress.log
    echo "HINT: Start the Caddy SSL server: podman run --rm -d --name caddy-ssl -p 8443:8443 -v ~/webserver:/usr/share/caddy:ro,Z caddy:ssl" >> /tmp/progress.log
    exit 1
fi

if ! runuser -u rhel -- podman run --net=host --rm curl:local-ca https://localhost:8443 > /dev/null 2>&1; then
    echo "FAIL: curl:local-ca could not connect to https://localhost:8443" >> /tmp/progress.log
    echo "HINT: Verify that ca.pem was correctly built and that caddy-ssl is running" >> /tmp/progress.log
    exit 1
fi

echo "PASS: curl:local-ca image exists and successfully connected to https://localhost:8443" >> /tmp/progress.log
exit 0
