#!/bin/bash

set -ouex pipefail

# Download Protonmail RPM
curl -o /tmp/ProtonMail-desktop-beta.rpm https://proton.me/download/mail/linux/ProtonMail-desktop-beta.rpm

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
  "zed"
)

utility_packages=(
  "syncthing"
  "displaylink"
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

rpm-ostree install ${packages[@]} /tmp/ProtonMail-desktop-beta.rpm
