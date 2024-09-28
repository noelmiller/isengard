#!/bin/bash

set -ouex pipefail

sed "/^favorite-apps=/s/\[.*\]/['org.gnome.Ptyxis.desktop', 'io.github.zen_browser.zen.desktop', 'org.gnome.Nautilus.desktop', 'dev.zed.Zed.desktop', 'steam.desktop', 'org.gnome.Software.desktop']/" /etc/dconf/db/local.d/03-bazzite-dash

sed -i 's/tap-to-click=true/tap-to-click=false/' /etc/dconf/db/gdm.d/02-bazzite-global

sed -i 's/tap-to-click=true/tap-to-click=false/' /etc/dconf/db/local.d/02-bazzite-global
