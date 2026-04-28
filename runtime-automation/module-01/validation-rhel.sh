#!/bin/sh
echo "Validating module-01" >> /tmp/progress.log

if ! runuser -u rhel -- podman image exists localhost/caddy:ssl; then
    echo "FAIL: Image localhost/caddy:ssl not found" >> /tmp/progress.log
    echo "HINT: Build the image with: podman build -t caddy:ssl -f ~/webserver/Containerfile ~/webserver" >> /tmp/progress.log
    exit 1
fi

if [ ! -f /home/rhel/ca.pem ]; then
    echo "FAIL: ca.pem not found in home directory" >> /tmp/progress.log
    echo "HINT: Extract the CA from the running caddy-ssl container with podman cp, then combine with: cat root.key root.crt > ca.pem" >> /tmp/progress.log
    exit 1
fi

echo "PASS: caddy:ssl image exists and ca.pem is present" >> /tmp/progress.log
exit 0
