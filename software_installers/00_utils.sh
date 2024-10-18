#!/bin/sh
set -eu

# Utils
if ! command -v vim &> /dev/null || ! command -v curl &> /dev/null || ! command -v git &> /dev/null || ! command -v jq &> /dev/null || ! command -v seahorse &> /dev/null || ! command -v Thunar &> /dev/null || ! command -v solaar &> /dev/null || ! command -v wireplumber &> /dev/null || ! command -v NetworkManager &> /dev/null; then
    echo "Installing Utils"
    sudo dnf install -y vim curl git jq seahorse Thunar solaar wireplumber NetworkManager go gcc-go
fi

exit 0
