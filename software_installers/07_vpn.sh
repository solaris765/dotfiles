#!/bin/sh
set -eu

# PriTunl
if ! command -v pritunl-client &> /dev/null; then
    echo "Prepping VPN"
    xdg-open https://vpn.lifemd.io/sso/request
fi

exit 0
