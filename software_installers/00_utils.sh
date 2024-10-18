#!/bin/sh
set -eu

# Utils
echo "Installing Utils"
sudo dnf install -y vim curl git jq Thunar solaar wireplumber NetworkManager go gcc-go keychain powerline-fonts fira-code-fonts

exit 0
