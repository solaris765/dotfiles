#!/bin/sh
set -eu

#slack 
if ! command -v slack &> /dev/null; then
    echo "Installing Slack"
    curl "https://slack.com/downloads/instructions/linux?ddl=1&build=rpm" --output ~/Downloads/slack.rpm
    sudo dnf install -y ~/Downloads/slack.rpm
fi

exit 0
