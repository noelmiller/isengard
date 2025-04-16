#!/bin/bash

set -ouex pipefail

# Packages

sysadmin_packages=(
  "subscription-manager"
  "cockpit-navigator"
  "cockpit-bridge"
  "cockpit-system"
  "cockpit-selinux"
  "cockpit-networkmanager"
  "cockpit-storaged"
  "cockpit-podman"
  "cockpit-machines"
  "cockpit-kdump"
  "libguestfs-tools"
  "NetworkManager-tui"
  "virt-install"
  "virt-manager"
  "virt-viewer"
)

programming_packages=(
  "code"
  "gh"
  "insync"
  "nodejs"
)

# including firefox because vscode needs it
utility_packages=(
  "firefox"
  "keyd"
  "neohtop"
  "syncthing"
  "stow"
  "scrcpy"
)

docker_packages=(
  "docker-ce"
  "docker-ce-cli"
  "containerd.io"
  "docker-buildx-plugin"
  "docker-compose-plugin"
)

packages=(
  ${sysadmin_packages[@]}
  ${programming_packages[@]}
  ${utility_packages[@]}
  ${docker_packages[@]}
)

# v4l2loopback
dnf5 remove v4l2loopback -y

KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+.\d+.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//' | tail -n 1)"

dnf -y install dkms gcc-c++

# The nvidia-open driver tries to use the kernel from the host. (uname -r), just override it and let it do whatever otherwise
# FIXME: remove this workaround please at some point
cat >/tmp/fake-uname <<EOF
#!/usr/bin/env bash

if [ "\$1" == "-r" ] ; then
  echo ${QUALIFIED_KERNEL}
  exit 0
fi

exec /usr/bin/uname \$@
EOF
install -Dm0755 /tmp/fake-uname /tmp/bin/uname

curl -fSsL https://github.com/v4l2loopback/v4l2loopback/archive/refs/tags/v0.13.2.tar.gz | tar xfz - 
cd v4l2loopback-0.13.2
PATH=/tmp/bin:$PATH make
PATH=/tmp/bin:$PATH make install
PATH=/tmp/bin:$PATH depmod -a

# install rpms
dnf5 install -y ${packages[@]}
