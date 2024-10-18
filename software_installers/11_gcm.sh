#!/bin/sh
set -eu

exit 0 # Disabled

#gcm
if ! command -v git-credential-manager &> /dev/null; then
    echo "Installing GCM"
    curl -L https://aka.ms/gcm/linux-install-source.sh | sh
    git-credential-manager configure
    git config --global credential.credentialStore secretservice
fi

exit 0
