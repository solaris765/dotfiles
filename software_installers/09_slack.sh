#!/bin/sh
set -eu

#slack
if ! command -v slack &> /dev/null; then
    echo "Installing Slack"
    filename="~/Downloads/slack.rpm"
    
    if curl --silent -o "${filename}" -L "https://slack.com/downloads/instructions/linux?ddl=1&build=rpm"; then
        sudo dnf install -y ~/Downloads/slack.rpm
    else
        exit 1
    fi
fi

exit 0
