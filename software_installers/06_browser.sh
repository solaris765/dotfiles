#!/bin/sh
set -eu

if ! command -v brave-browser &> /dev/null; then
    echo "Installing Web Browser"
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf install -y brave-browser

    echo "### Installing bitwarden browser plugin"
    BITWARDEN_ID=nngceckbapebfimnlniiiahkandclblb
    EXTENSIONS_PATH=/opt/brave.com/brave/extensions
    sudo mkdir -p $EXTENSIONS_PATH
    sudo echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' > "${EXTENSIONS_PATH}/${BITWARDEN_ID}.json"

    sudo update-alternatives --set x-www-browser $(which brave-browser)
fi

exit 0
