#!/bin/bash

set -ouex pipefail

echo "Installing Warp"

# On libostree systems, /opt is a symlink to /var/opt,
# which actually only exists on the live system. /var is
# a separate mutable, stateful FS that's overlaid onto
# the ostree rootfs. Therefore we need to install it into
# /usr/lib/1Password instead, and dynamically create a
# symbolic link /opt/1Password => /usr/lib/1Password upon
# boot.

# Prepare staging directory
mkdir -p /var/opt # -p just in case it exists
# for some reason...

# Configure Repositories
rpm --import https://releases.warp.dev/linux/keys/warp.asc
sh -c 'echo -e "[warpdotdev]\nname=warpdotdev\nbaseurl=https://releases.warp.dev/linux/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://releases.warp.dev/linux/keys/warp.asc" > /etc/yum.repos.d/warpdotdev.repo'
dnf5 -y install warp-terminal

# And then we do the hacky dance!
mv /var/opt/warpdotdev /usr/lib/warpdotdev # move this over here

# Create a symlink /usr/bin/warp-terminal => /opt/warpdotdev/warp-terminal/warp
rm /usr/bin/warp-terminal
ln -s /opt/warpdotdev/warp-terminal/warp /usr/bin/warp-terminal