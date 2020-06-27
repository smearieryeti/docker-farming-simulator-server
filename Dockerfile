FROM ubuntu:bionic

ARG MONO_VER="5.1.0"
ARG GECKO_VER="2.47.1"

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        wget \
    && echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' > /etc/apt/sources.list.d/wine.list \
    && echo 'deb http://ppa.launchpad.net/cybermax-dexter/sdl2-backport/ubuntu bionic main' > /etc/apt/sources.list.d/dexter.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BBB8BD3BBE6AD3419048EDC50795A9A788A59C82 \
    && curl -fsSL https://dl.winehq.org/wine-builds/winehq.key | apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        haproxy \
        openssh-server \
        supervisor \
        winbind \
        winehq-stable \
        winetricks \
        xvfb \
    && mkdir -p /usr/share/wine/mono /usr/share/wine/gecko \
    && wget https://dl.winehq.org/wine/wine-mono/${MONO_VER}/wine-mono-${MONO_VER}-x86.msi \
        -O /usr/share/wine/mono/wine-mono-${MONO_VER}-x86.msi \
    && wget https://dl.winehq.org/wine/wine-gecko/${GECKO_VER}/wine_gecko-${GECKO_VER}-x86.msi \
        -O /usr/share/wine/gecko/wine_gecko-${GECKO_VER}-x86.msi \
    && wget https://dl.winehq.org/wine/wine-gecko/${GECKO_VER}/wine_gecko-${GECKO_VER}-x86_64.msi \
        -O /usr/share/wine/gecko/wine_gecko-${GECKO_VER}-x86_64.msi \
    && echo 'X11UseLocalhost no' >> /etc/ssh/sshd_config \
    && mkdir /run/sshd \
    && useradd -ms /bin/bash farmer \
    && mkdir /app \
    && chown farmer:farmer /app \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
    && apt-get autoclean -y

USER farmer
ENV WINEPREFIX=/app
RUN winecfg \
    && winetricks --unattended settings win10
USER root

COPY files/supervisord.conf /etc/supervisor/supervisord.conf
COPY files/haproxy.cfg /etc/haproxy/haproxy.cfg
COPY files/run-farming-simulator.sh /usr/local/bin/run-farming-simulator

RUN chmod +x /usr/local/bin/run-farming-simulator

EXPOSE 8080
CMD ["/usr/bin/supervisord"]
