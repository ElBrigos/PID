FROM debian:bookworm

# Configuration de base
RUN apt-get update && echo 'root:root' | chpasswd && \
    printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d && \
    apt-get install -y systemd systemd-sysv dbus dbus-user-session wget curl sudo && \
    printf "systemctl start systemd-logind" >> /etc/profile

# Ajouter les dépôts de Proxmox
RUN echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list && \
    wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

# Mise à jour et installation de Proxmox
RUN apt update && apt full-upgrade -y && \
    apt install proxmox-ve postfix open-iscsi chrony -y

# Démarrage avec systemd
CMD ["bash"]
ENTRYPOINT ["/sbin/init"]
