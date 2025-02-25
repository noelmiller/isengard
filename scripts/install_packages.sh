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

# install rpms
dnf5 install -y ${packages[@]}

# install fzf-tab-completion
# git clone https://github.com/lincheney/fzf-tab-completion.git /usr/share/ublue-os/fzf-tab-completion
