#!/bin/sh
set -eu

# Node
if ! command -v node &> /dev/null || ! command -v bun &> /dev/null || ! command -v nvm &> /dev/null; then
    echo "Installing NodeJS tooling"
    sudo dnf install -y nodejs
    curl -fsSL https://bun.sh/install | bash
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

exit 0
