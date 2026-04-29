#!/bin/sh
echo "Validating module-01" >> /tmp/progress.log

if ! runuser -u rhel -- podman image exists localhost/caddy:ssl 2>/dev/null; then
    echo "FAIL: Image localhost/caddy:ssl not found" >> /tmp/progress.log
    echo "HINT: Did you complete Step 2 to build the caddy:ssl image?" >> /tmp/progress.log
    exit 1
fi

if [ ! -f /home/rhel/ca.pem ]; then
    echo "FAIL: ca.pem not found in home directory" >> /tmp/progress.log
    echo "HINT: Did you complete Step 5? Extract root.key and root.crt from the running container and combine them into ca.pem" >> /tmp/progress.log
    exit 1
fi

echo "PASS: caddy:ssl image exists and ca.pem is present" >> /tmp/progress.log
exit 0
