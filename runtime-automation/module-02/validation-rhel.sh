#!/bin/sh
echo "Validating module-02" >> /tmp/progress.log

if ! runuser -u rhel -- podman image exists localhost/curl:local-ca 2>/dev/null; then
    echo "FAIL: Image curl:local-ca not found" >> /tmp/progress.log
    echo "HINT: Did you complete Step 3 to build the curl:local-ca image?" >> /tmp/progress.log
    exit 1
fi

echo "PASS: curl:local-ca image exists" >> /tmp/progress.log
exit 0
