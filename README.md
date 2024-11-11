![Isengard Logo](assets/logo.jpg)

# Isengard
[![build-isengard](https://github.com/noelmiller/isengard/actions/workflows/build.yml/badge.svg)](https://github.com/noelmiller/isengard/actions/workflows/build.yml) [![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/isengard)](https://artifacthub.io/packages/search?repo=isengard)

Custom Fedora Atomic Image for Desktops and Laptops. This is my take on what the modern Linux Desktop should look like.

**Note: I do not have images for Nvidia or other variants of Bazzite. I may add them if there is demand.**

# Purpose

This is an image that is built on the work of [Universal Blue](https://github.com/ublue-os), [Bazzite](https://github.com/ublue-os/bazzite), and [Fedora Kinoite](https://fedoraproject.org/kinoite/) projects.

The `Containerfile` is built directly off of [Bazzite](https://github.com/ublue-os/bazzite).

**This image is not recommended for general usage.**

If you want images designed for general consumption, I suggest using [Bazzite](https://github.com/ublue-os/bazzite) or [Bluefin](https://github.com/ublue-os/bluefin) from the Universal Blue project.

# Features

These are the features included in my image!

## Packages

In addition to the packages included in [Bazzite](https://github.com/ublue-os/bazzite), I include the following installed by default:

### Layered Packages (through RPM-Ostree)

#### System Administration

- Libvirtd, Qemu, and Virt-Manager
- Subscription-Manager (For running RHEL containers)
- Cockpit (Not enabled by default)
- Cockpit Plugins
  - cockpit-navigator
  - cockpit-bridge
  - cockpit-system
  - cockpit-selinux
  - cockpit-networkmanager
  - cockpit-storaged
  - cockpit-podman
  - cockpit-machines
  - cockpit-kdump

#### Programming

- VSCode
- Zed
- GH (Github CLI)
- Nushell

#### Utilities

- Syncthing
- Protonmail Desktop
- Stow

### System Flatpaks

#### Browser

- Zen Browser
- Google Chrome

#### Communications

- Slack
- Discord (using Vesktop)
- Element
- Signal

#### Programming

- Podman Desktop

#### Utilities

- VLC
- Calibre
- OBS DroidCam Plugin

#### Gaming

- XIVLauncher (FFXIV Launcher)
- OSU Lazer
- Dolphin Emulator
- Fightcade

#### Design

- Inkscape
- Gimp

## Cockpit

I do not enable cockpit by default as I use this image on my laptop as well.

### Caveat

Cockpit is not installed in the traditional way it normally is on Fedora Workstation. It must be run in a container. You can still run it as a service on boot, but the install method is different.

### Install and Configure Cockpit

Here are the steps required:

1. Run the Cockpit web service with a privileged container (as root):

`podman container runlabel --name cockpit-ws RUN quay.io/cockpit/ws`

2. Make Cockpit start on boot (as root):

`podman container runlabel INSTALL quay.io/cockpit/ws`

`systemctl enable cockpit.service`

The full documentation for cockpit can be found [here](https://cockpit-project.org/running.html#coreos).

## Using the Image

If you do decide you want to try my image, you will want to rebase from Fedora Kinoite using this command:

```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/noelmiller/isengard:latest
```

After rebase, you will need to run the command below to install all flatpaks that are shipped with Bazzite and Isengard

```bash
ujust _install-isengard-flatpaks
```

If there is demand, I may publish ISOs.

## Verification

These images are signed with sigstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/noelmiller/isengard
```

## Special Thanks

The contributors at Universal Blue, Bazzite, and Fedora are amazing. This image would not exist without the incredible work they do every day!
