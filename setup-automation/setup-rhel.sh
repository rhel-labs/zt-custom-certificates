#!/bin/bash
USER=rhel

echo "Adding wheel" > /root/post-run.log
usermod -aG wheel rhel

echo "Starting setup for zt-custom-certificates" > /tmp/progress.log

chmod 666 /tmp/progress.log

# Fetch setup files
TMPDIR=/tmp/lab-setup-$$
git clone --single-branch --branch ${GIT_BRANCH:-main} --no-checkout \
  --depth=1 --filter=tree:0 ${GIT_REPO} $TMPDIR
git -C $TMPDIR sparse-checkout set --no-cone /setup-files
git -C $TMPDIR checkout
SETUP_FILES=$TMPDIR/setup-files

# Create working directory
mkdir -p /home/rhel/webserver

# Copy exercise files
cp $SETUP_FILES/webserver/index.html /home/rhel/webserver/index.html
cp $SETUP_FILES/webserver/Caddyfile /home/rhel/webserver/Caddyfile
echo "Web content files copied" >> /tmp/progress.log

# Pre-pull images to reduce wait time during lab
podman pull registry.access.redhat.com/hi/caddy:latest
podman pull registry.access.redhat.com/hi/curl:latest
podman pull registry.access.redhat.com/hi/curl:latest-builder
echo "Images pre-pulled" >> /tmp/progress.log

rm -rf $TMPDIR
chown -R rhel:rhel /home/rhel

echo "Setup complete" >> /tmp/progress.log
