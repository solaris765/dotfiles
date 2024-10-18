#!/bin/sh
set -eu

# docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker"
    sudo dnf -y install dnf-plugins-core
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker

    sudo groupadd docker
    sudo usermod -aG docker $USER

    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
fi

exit 0
