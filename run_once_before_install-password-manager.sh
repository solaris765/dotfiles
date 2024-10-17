#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type bw >/dev/null 2>&1 && exit

echo "Installing Bitwarden-CLI

curl "https://vault.bitwarden.com/download/?app=cli&platform=linux" --output bw
sudo mv bw /usr/local/bin/bw
sudo chmod +x /usr/local/bin/bw