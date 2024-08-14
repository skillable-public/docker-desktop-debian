FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive

# set version for s6 overlay
ARG S6_OVERLAY_VERSION="3.2.0.0"
ARG S6_OVERLAY_ARCH="x86_64"

RUN \
  apt update && \
  apt install -y \
    xz-utils

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz

# add s6 optional symlinks
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

ENTRYPOINT ["/init"]

RUN \
  echo "**** install apt-utils and locales ****" && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    apt-utils \
    locales && \
  echo "**** install packages ****" && \
  apt-get install -y \
    cron \
    curl \
    gnupg \
    netcat-traditional \
    tzdata \
    wget && \
  echo "**** add all sources ****" && \
  echo "deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
  echo "deb-src http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
  echo "deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
  echo "deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
  echo "deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
  echo "deb-src http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
  echo "deb http://security.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
  echo "deb-src http://security.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
  rm -f /etc/apt/sources.list.d/debian.sources && \
  echo "**** generate locale ****" && \
  locale-gen en_US.UTF-8 && \
  echo "**** cleanup ****" && \
  apt-get -y autoremove && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /var/log/* \
    /usr/share/man

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    ca-certificates \
    dbus-x11 \
    dnsutils \
    ffmpeg \
    file \
    fonts-noto-color-emoji \
    fonts-noto-core \
    fuse-overlayfs \
    intel-media-va-driver \
    iputils-ping \
    libdatetime-perl \
    libfontenc1 \
    libfreetype6 \
    libgbm1 \
    libgcrypt20 \
    libgl1-mesa-dri \
    libglu1-mesa \
    libgnutls30 \
    libgomp1 \
    libhash-merge-simple-perl \
    liblist-moreutils-perl \
    libp11-kit0 \
    libpam0g \
    libpixman-1-0 \
    libscalar-list-utils-perl \
    libswitch-perl \
    libtasn1-6 \
    libtry-tiny-perl \
    libvulkan1 \
    libwebp7 \
    libx11-6 \
    libxau6 \
    libxcb1 \
    libxcursor1 \
    libxdmcp6 \
    libxext6 \
    libxfixes3 \
    libxfont2 \
    libxinerama1 \
    libxshmfence1 \
    libxtst6 \
    libyaml-tiny-perl \
    locales-all \
    mesa-va-drivers \
    mesa-vulkan-drivers \
    nginx \
    nodejs \
    openbox \
    openssh-client \
    openssl \
    pciutils \
    perl \
    procps \
    pulseaudio \
    pulseaudio-utils \
    python3 \
    software-properties-common \
    ssl-cert \
    sudo \
    tar \
    traceroute \
    util-linux \
    vulkan-tools \
    x11-apps \
    x11-common \
    x11-utils \
    x11-xkb-utils \
    x11-xkb-utils \
    x11-xserver-utils \
    xauth \
    xdg-utils \
    xfonts-base \
    xkb-data \
    xserver-common \
    xserver-xorg-core \
    xserver-xorg-video-amdgpu \
    xserver-xorg-video-ati \
    xserver-xorg-video-intel \
    xserver-xorg-video-nouveau \
    xserver-xorg-video-qxl \
    xterm \
    xutils \
    zlib1g

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    dolphin \
    gwenview \
    kde-config-gtk-style \
    kdialog \
    kfind \
    khotkeys \
    kio-extras \
    knewstuff-dialog \
    konsole \
    ksystemstats \
    kwin-addons \
    kwin-x11 \
    kwrite \
    plasma-desktop \
    plasma-workspace \
    qml-module-qt-labs-platform \
    systemsettings && \
  echo "**** kde tweaks ****" && \
  sed -i \
    's/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g' \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

RUN \
  install -d -m 0755 /etc/apt/keyrings && \
  wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null && \
  echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null && \
  echo 'Package: *' > /etc/apt/preferences.d/mozilla && \
  echo 'Pin: origin packages.mozilla.org' >> /etc/apt/preferences.d/mozilla && \
  echo 'Pin-Priority: 1000' >> /etc/apt/preferences.d/mozilla && \
  apt-get update && apt-get install -y \
    firefox

RUN \
  echo "**** install noVNC ****" && \
  apt-get update && \
  apt-get install -y \
    tigervnc-standalone-server \
    novnc && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

RUN \
  useradd \
  -u 1000 -U \
  -d /home/user \
  -s /bin/bash user && \
  echo "user:user" | chpasswd && \
  usermod -aG sudo user && \
  mkdir -p /home/user && \
  chown 1000:1000 /home/user

COPY /root /

RUN \
  chmod 744 /etc/s6-overlay/s6-rc.d/*/run

# ports and volumes
EXPOSE 6080
  