FROM archlinux

RUN pacman -Sy && \
    pacman -S --noconfirm base-devel git ccache && \
    useradd builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    mkdir -p /home/builder && chown builder /home/builder

USER builder
RUN mkdir -p /home/builder/.ccache && mkdir -p /home/builder/pkg && mkdir -p /home/builder/dist
WORKDIR /home/builder
VOLUME /home/builder/.ccache
VOLUME /home/builder/pkg
VOLUME /home/builder/dist
