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
curl -o v4l2loopback-0.13.2-4.fc42.x86_64.rpm https://koji.rpmfusion.org/kojifiles/packages/v4l2loopback/0.13.2/4.fc42/x86_64/v4l2loopback-0.13.2-4.fc42.x86_64.rpm
curl -o akmod-v4l2loopback-0.13.2-2.fc42.x86_64.rpm https://koji.rpmfusion.org/kojifiles/packages/v4l2loopback-kmod/0.13.2/2.fc42/x86_64/akmod-v4l2loopback-0.13.2-2.fc42.x86_64.rpm
dnf5 remove v4l2loopback -y
dnf5 install -y ./v4l2loopback-0.13.2-4.fc42.x86_64.rpm ./akmod-v4l2loopback-0.13.2-2.fc42.x86_64.rpm

# install rpms
dnf5 install -y ${packages[@]}
