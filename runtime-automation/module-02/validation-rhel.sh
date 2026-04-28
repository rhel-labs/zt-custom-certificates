#!/bin/sh
echo "Validating module-02" >> /tmp/progress.log

# Check that the curl:local-ca image was built
if ! podman image exists localhost/curl:local-ca; then
    echo "FAIL: Image localhost/curl:local-ca not found"
    echo "HINT: Build the image with: podman build -t curl:local-ca -f ~/Containerfile.pem ~"
    exit 1
fi

# Test that the custom curl image can connect to the Caddy SSL server
# caddy-ssl must still be running for this check; if it's stopped, start it first
if ! podman ps --filter name=caddy-ssl --format '{{.Names}}' | grep -q caddy-ssl; then
    echo "FAIL: caddy-ssl container is not running"
    echo "HINT: Start the Caddy SSL server: podman run --rm -d --name caddy-ssl -p 8443:8443 -v ~/webserver:/usr/share/caddy:ro,Z caddy:ssl"
    exit 1
fi

if ! podman run --net=host --rm curl:local-ca https://localhost:8443 > /dev/null 2>&1; then
    echo "FAIL: curl:local-ca could not connect to https://localhost:8443"
    echo "HINT: Verify that ca.pem was correctly built and that caddy-ssl is running"
    exit 1
fi

echo "PASS: curl:local-ca image exists and successfully connected to https://localhost:8443"
exit 0
