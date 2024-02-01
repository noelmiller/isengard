### 1. BUILD ARGS
## These enable the produced image to be different by passing different build args.
## They are provided on the commandline when building in a terminal, but the github
## workflow provides them when building in Github Actions. Changes to the workflow
## build.xml will override changes here.

## SOURCE_IMAGE arg can be anything from ublue upstream: silverblue, kinoite, sericea, vauxite, mate, lxqt, base
ARG SOURCE_IMAGE="kinoite"
## SOURCE_SUFFIX arg should be "main", nvidia users should use "nvidia"
ARG SOURCE_SUFFIX="main"
## FEDORA_VERSION arg must be a version built by ublue: 37 or 38 as of today
ARG FEDORA_VERSION="39"

### 2. SOURCE IMAGE
## this is a standard Containerfile FROM using the build ARGs above to select the right upstream image
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}-${SOURCE_SUFFIX}:${FEDORA_VERSION} AS isengard

ARG IMAGE_NAME="${IMAGE_NAME:-isengard}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-noelmiller}"
ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
ARG AKMODS_FLAVOR="${AKMODS_FLAVOR:-fsync}"
ARG IMAGE_BRANCH="${IMAGE_BRANCH:-main}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-39}"

### 3. PRE-MODIFICATIONS

## this directory is needed to prevent failure with some RPM installs
RUN mkdir -p /var/lib/alternatives

## Copy System files to be used in image
COPY system_files /

## Setup Copr Repositories
RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite/repo/fedora-$(rpm -E %fedora)/kylegospo-bazzite-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-bazzite.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite-multilib/repo/fedora-$(rpm -E %fedora)/kylegospo-bazzite-multilib-fedora-$(rpm -E %fedora).repo?arch=x86_64 -O /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/vk_hdr_layer/repo/fedora-$(rpm -E %fedora)/kylegospo-vk_hdr_layer-fedora-$(rpm -E %fedora).repo?arch=x86_64 -O /etc/yum.repos.d/_copr_kylegospo-vk_hdr_layer.repo && \
    wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo?arch=x86_64 -O /etc/yum.repos.d/_copr_ublue-os-staging.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-$(rpm -E %fedora)/kylegospo-system76-scheduler-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/LatencyFleX/repo/fedora-$(rpm -E %fedora)/kylegospo-LatencyFleX-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/hl2linux-selinux/repo/fedora-$(rpm -E %fedora)/kylegospo-hl2linux-selinux-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-hl2linux-selinux.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/obs-vkcapture/repo/fedora-$(rpm -E %fedora)/kylegospo-obs-vkcapture-fedora-$(rpm -E %fedora).repo?arch=x86_64 -O /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/rom-properties/repo/fedora-$(rpm -E %fedora)/kylegospo-rom-properties-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/prompt/repo/fedora-$(rpm -E %fedora)/kylegospo-prompt-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-prompt.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/joycond/repo/fedora-$(rpm -E %fedora)/kylegospo-joycond-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-joycond.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/VTFLib/repo/fedora-$(rpm -E %fedora)/kylegospo-VTFLib-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-VTFLib.repo && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/webapp-manager/repo/fedora-$(rpm -E %fedora)/kylegospo-webapp-manager-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_kylegospo-webapp-manager.repo && \
    wget https://copr.fedorainfracloud.org/coprs/che/nerd-fonts/repo/fedora-$(rpm -E %fedora)/che-nerd-fonts-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_che-nerd-fonts.repo && \
    wget https://copr.fedorainfracloud.org/coprs/ycollet/audinux/repo/fedora-$(rpm -E %fedora)/ycollet-audinux-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_ycollet-audinux.repo

### 4. MODIFICATIONS
## make modifications desired in your image and install packages here, a few examples follow

## Install kernel-fsync
RUN wget https://copr.fedorainfracloud.org/coprs/sentry/kernel-fsync/repo/fedora-$(rpm -E %fedora)/sentry-kernel-fsync-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_sentry-kernel-fsync.repo && \
    rpm-ostree cliwrap install-to-root / && \
    rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:sentry:kernel-fsync \
        kernel \
        kernel-core \
        kernel-modules \
        kernel-modules-core \
        kernel-modules-extra \
        kernel-uki-virt

## Add ublue packages, add needed negativo17 repo and then immediately disable due to incompatibility with RPMFusion
COPY --from=ghcr.io/ublue-os/akmods:${AKMODS_FLAVOR}-${FEDORA_MAJOR_VERSION} /rpms /tmp/akmods-rpms
RUN sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    wget https://negativo17.org/repos/fedora-multimedia.repo -O /etc/yum.repos.d/negativo17-fedora-multimedia.repo && \
    rpm-ostree install \
        /tmp/akmods-rpms/kmods/*xone*.rpm \
        /tmp/akmods-rpms/kmods/*openrazer*.rpm \
        /tmp/akmods-rpms/kmods/*v4l2loopback*.rpm \
        /tmp/akmods-rpms/kmods/*wl*.rpm \
        /tmp/akmods-rpms/kmods/*gcadapter_oc*.rpm \
        /tmp/akmods-rpms/kmods/*nct6687*.rpm \
        /tmp/akmods-rpms/kmods/*evdi*.rpm \
        /tmp/akmods-rpms/kmods/*zenergy*.rpm \
        /tmp/akmods-rpms/kmods/*ayn-platform*.rpm \
        /tmp/akmods-rpms/kmods/*bmi260*.rpm \
        /tmp/akmods-rpms/kmods/*bmi323*.rpm \
        /tmp/akmods-rpms/kmods/*rtl8814au*.rpm \
        /tmp/akmods-rpms/kmods/*ryzen-smu*.rpm && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo 

## Update packages that commonly cause build issues for Steam
RUN rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        vulkan-loader \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        gnutls \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        glib2 \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        gtk3 \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        atk \
        at-spi2-atk \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libaom \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        gstreamer1 \
        gstreamer1-plugins-base \
        gstreamer1-plugins-bad-free-libs \
        gstreamer1-plugins-good-qt \
        gstreamer1-plugins-good \
        gstreamer1-plugins-bad-free \
        gstreamer1-plugin-libav \
        gstreamer1-plugins-ugly-free \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        python3 \
        python3-libs \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libdecor \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libtirpc \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libuuid \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libblkid \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        libmount \
        || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
        glibc \
        glibc-common \
        || true && \
    rpm-ostree override remove \
        glibc32 \
        || true

# Install Valve's patched Mesa and Pipewire
RUN rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib \
        mesa-filesystem \
        mesa-dri-drivers \
        mesa-libEGL \
        mesa-libgbm \
        mesa-libGL \
        mesa-libglapi \
        mesa-vulkan-drivers \
        mesa-libOSMesa \
        pipewire \
        pipewire-alsa \
        pipewire-gstreamer \
        pipewire-jack-audio-connection-kit \
        pipewire-jack-audio-connection-kit-libs \
        pipewire-libs \
        pipewire-pulseaudio \
        pipewire-utils

## Remove unneeded packages
RUN rpm-ostree override remove \
        ublue-os-update-services \
        firefox \
        firefox-langpacks && \
    rpm-ostree override remove \
        power-profiles-daemon \
        || true && \
    rpm-ostree override remove \
        tlp \
        tlp-rdw \
        || true

## Install new packages
RUN rpm-ostree install \
        subscription-manager \
        cockpit-bridge \
        cockpit-system \
        cockpit-selinux \
        cockpit-networkmanager \
        cockpit-storaged \
        cockpit-podman \
        cockpit-machines \
        cockpit-kdump \
        gh \
        code \
        libguestfs-tools \
        NetworkManager-tui \
        virt-install \
        virt-manager \
        virt-viewer \
        syncthing \
        python3-pip \
        libadwaita \
        duperemove \
        xwininfo \
        xrandr \
        rmlint \
        compsize \
        input-remapper \
        system76-scheduler \
        tuned \
        tuned-ppd \
        tuned-utils \
        tuned-utils-systemtap \
        tuned-gtk \
        tuned-profiles-atomic \
        tuned-profiles-cpu-partitioning \
        powertop \
        hl2linux-selinux \
        joycond \
        ladspa-caps-plugins \
        ladspa-noise-suppression-for-voice \
        python3-icoextract \
        tailscale \
        webapp-manager \
        btop \
        lshw \
        pulseaudio-utils \
        playerctl \
        unrar \
        libxcrypt-compat \
        mesa-libGLU \
        vulkan-tools \
        glibc.i686 \
        extest.i686 \
        twitter-twemoji-fonts \
        google-noto-sans-cjk-fonts \
        lato-fonts \
        fira-code-fonts \
        nerd-fonts \
        glow \
        gum \
        setools \
        redhat-lsb-core && \
    pip install --prefix=/usr topgrade && \
    rpm-ostree install \
        ublue-update && \
    sed -i '1s/^/[include]\npaths = ["\/etc\/ublue-os\/topgrade.toml"]\n\n/' /usr/etc/ublue-update/topgrade-user.toml && \
    sed -i 's/min_battery_percent.*/min_battery_percent = 20.0/' /usr/etc/ublue-update/ublue-update.toml && \
    sed -i 's/max_cpu_load_percent.*/max_cpu_load_percent = 100.0/' /usr/etc/ublue-update/ublue-update.toml && \
    sed -i 's/max_mem_percent.*/max_mem_percent = 90.0/' /usr/etc/ublue-update/ublue-update.toml && \
    sed -i 's/dbus_notify.*/dbus_notify = false/' /usr/etc/ublue-update/ublue-update.toml && \
    sed -i 's@Name=tuned-gui@Name=TuneD Manager@g' /usr/share/applications/tuned-gui.desktop && \
    ln -s /usr/share/fonts/google-noto-sans-cjk-fonts /usr/share/fonts/noto-cjk && \
    wget https://raw.githubusercontent.com/KyleGospo/steam-proton-mf-wmv/master/installcab.py -O /usr/bin/installcab && \
    wget https://github.com/KyleGospo/steam-proton-mf-wmv/blob/master/install-mf-wmv.sh -O /usr/bin/install-mf-wmv && \
    wget https://raw.githubusercontent.com/jlu5/icoextract/master/exe-thumbnailer.thumbnailer -O /usr/share/thumbnailers/exe-thumbnailer.thumbnailer && \
    wget https://gitlab.com/popsulfr/steamos-btrfs/-/raw/11114e4ff791eb2c385814c2fcbac6a83f144f35/files/usr/lib/systemd/system/btrfs-dedup@.service -O /usr/lib/systemd/system/btrfs-dedup@.service && \
    wget https://gitlab.com/popsulfr/steamos-btrfs/-/raw/11114e4ff791eb2c385814c2fcbac6a83f144f35/files/usr/lib/systemd/system/btrfs-dedup@.timer -O /usr/lib/systemd/system/btrfs-dedup@.timer

## Install Steam, plus supporting packages
RUN rpm-ostree install \
        at-spi2-core.i686 \
        atk.i686 \
        vulkan-loader.i686 \
        mesa-vulkan-drivers.i686 \
        alsa-lib.i686 \
        fontconfig.i686 \
        gtk2.i686 \
        libICE.i686 \
        libnsl.i686 \
        libxcrypt-compat.i686 \
        libpng12.i686 \
        libXext.i686 \
        libXinerama.i686 \
        libXtst.i686 \
        libXScrnSaver.i686 \
        NetworkManager-libnm.i686 \
        nss.i686 \
        pulseaudio-libs.i686 \
        libcurl.i686 \
        systemd-libs.i686 \
        libva.i686 \
        libvdpau.i686 \
        libdbusmenu-gtk3.i686 \
        libatomic.i686 \
        pipewire-alsa.i686 \
        clinfo && \
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo && \
    sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree.repo && \
    sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo && \
    sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/fedora-updates.repo && \
    rpm-ostree install \
        steam && \
    sed -i '0,/enabled=1/s//enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo && \
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree.repo && \
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo && \
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/fedora-updates.repo && \
    rpm-ostree install \
        wxGTK \
        libFAudio \
        protontricks \
        latencyflex-vulkan-layer \
        vkBasalt.x86_64 \
        vkBasalt.i686 \
        mangohud.x86_64 \
        mangohud.i686 \
        vk_hdr_layer.x86_64 \
        vk_hdr_layer.i686 \
        gperftools-libs.i686 \
        goverlay \
        obs-vkcapture.x86_64 \
        obs-vkcapture.i686

## Configure KDE & GNOME
RUN rpm-ostree override remove \
        plasma-welcome \
        qt5-qdbusviewer && \
    rpm-ostree install \
        kdeconnectd \
        kdeplasma-addons \
        rom-properties-kf5 \
        qvtf \
        prompt && \
    git clone https://github.com/maxiberta/kwin-system76-scheduler-integration.git --depth 1 /tmp/kwin-system76-scheduler-integration && \
    kpackagetool5 --type=KWin/Script --global --install /tmp/kwin-system76-scheduler-integration && \
    rm -rf /tmp/kwin-system76-scheduler-integration && \
    sed -i '/<entry name="launchers" type="StringList">/,/<\/entry>/ s/<default>[^<]*<\/default>/<default>applications:org.gnome.Prompt.desktop,preferred:\/\/browser,preferred:\/\/filemanager,applications:code.desktop,applications:steam.desktop<\/default>/' /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml && \
    sed -i '/<entry name="favorites" type="StringList">/,/<\/entry>/ s/<default>[^<]*<\/default>/<default>org.gnome.Prompt.desktop,preferred:\/\/browser,org.kde.dolphin.desktop,code.desktop,steam.desktop<\/default>/' /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml && \
    sed -i 's@\[Desktop Action new-window\]@\[Desktop Action new-window\]\nX-KDE-Shortcuts=Ctrl+Alt+T@g' /usr/share/applications/org.gnome.Prompt.desktop && \
    sed -i 's@Exec=prompt@Exec=kde-prompt@g' /usr/share/applications/org.gnome.Prompt.desktop && \
    cp /usr/share/applications/org.gnome.Prompt.desktop /usr/share/kglobalaccel/org.gnome.Prompt.desktop && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/org.kde.konsole.desktop && \
    rm -f /usr/share/kglobalaccel/org.kde.konsole.desktop && \
    systemctl enable kde-sysmonitor-workaround.service

### 5. POST-MODIFICATIONS
## these commands leave the image in a clean state after local modifications
# Cleanup & Finalize
RUN /tmp/image-info.sh && \
    rm -f /etc/profile.d/toolbox.sh && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/shredder.desktop && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/nvtop.desktop && \
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nNoDisplay=true@g' /usr/share/applications/btop.desktop && \
    rm -f /usr/share/vulkan/icd.d/lvp_icd.*.json && \
    echo "import \"/usr/share/ublue-os/just/isengard.just\"" >> /usr/share/ublue-os/justfile && \
    sed -i 's/stage/none/g' /etc/rpm-ostreed.conf && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-staging.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-system76-scheduler.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-hl2linux-selinux.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-vk_hdr_layer.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-prompt.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-joycond.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-VTFLib.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_kylegospo-webapp-manager.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_che-nerd-fonts.repo && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/tailscale.repo && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf && \
    sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf && \
    mkdir -p /usr/etc/flatpak/remotes.d && \
    wget -q https://dl.flathub.org/repo/flathub.flatpakrepo -P /usr/etc/flatpak/remotes.d && \
    systemctl enable com.system76.Scheduler.service && \
    systemctl enable tuned.service && \
    systemctl enable btrfs-dedup@var-home.timer && \
    systemctl enable displaylink.service && \
    systemctl enable input-remapper.service && \
    systemctl unmask isengard-flatpak-manager.service && \
    systemctl enable isengard-flatpak-manager.service && \
    systemctl disable rpm-ostreed-automatic.timer && \
    systemctl enable ublue-update.timer && \
    systemctl enable incus-workaround.service && \
    systemctl enable tailscaled.service && \
    systemctl enable dev-hugepages1G.mount && \
    systemctl enable joycond && \
    sed -i '/^PRETTY_NAME/s/Kinoite/Isengard/' /usr/lib/os-release && \
    systemctl --global enable com.system76.Scheduler.dbusproxy.service && \
    mkdir -p /usr/etc/default && \
    rm -rf \
        /tmp/* \
        /var/* && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp && \
    mkdir -p /var/lib/bluetooth && \
    chmod -R 755 /var/lib/bluetooth && \
    ostree container commit
