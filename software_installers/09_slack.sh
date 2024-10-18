#!/bin/sh
set -eu

#slack 
if ! command -v slack &> /dev/null; then
    echo "Installing Slack"
    cd ~/Downloads
    curl https://slack.com/downloads/instructions/linux?ddl=1&build=rpm --output slack.rpm
    sudo dnf install -y ./slack.rpm
fi

exit 0
