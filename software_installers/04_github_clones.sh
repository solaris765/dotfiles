#!/bin/sh
set -eu
script_dir="$(dirname "$(readlink -f "$0")")"
source $script_dir/__helpers.sh

echo "Installing github software builds"
mkdir -p ~/.git-software
cd ~/.git-software

if ! command -v swww &> /dev/null; then
    ## swww
    echo "  SWWW"
    download_and_extract_latest_release LGFae swww
    cargo build --release
    ln -s $HOME/.git-software/swww/target/release/swww $HOME/.local/bin/swww
    ln -s $HOME/.git-software/swww/target/release/swww-daemon $HOME/.local/bin/swww-daemon
    cd ..
fi

exit 0
