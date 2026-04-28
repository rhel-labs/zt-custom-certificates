#!/bin/sh
echo "Validating module-01" >> /tmp/progress.log

# Check that the caddy:ssl image was built
if ! podman image exists localhost/caddy:ssl; then
    echo "FAIL: Image localhost/caddy:ssl not found"
    echo "HINT: Build the image with: podman build -t caddy:ssl -f ~/webserver/Containerfile ~/webserver"
    exit 1
fi

# Check that ca.pem exists in the home directory
if [ ! -f ~/ca.pem ]; then
    echo "FAIL: ca.pem not found in home directory"
    echo "HINT: Extract the CA from the running caddy-ssl container with podman cp, then combine with: cat root.key root.crt > ca.pem"
    exit 1
fi

echo "PASS: caddy:ssl image exists and ca.pem is present"
exit 0
