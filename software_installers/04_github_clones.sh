#!/bin/sh
set -eu

echo "Installing github software builds"
mkdir -p ~/.git-software
cd ~/.git-software

if ! command -v swww &> /dev/null; then
    ## swww
    echo "  SWWW"
    ghRepoCloneLatestRelease LGFae/swww
    cd swww
    cargo build --release
    ln -s $HOME/.git-software/swww/target/release/swww $HOME/.local/bin/swww
    ln -s $HOME/.git-software/swww/target/release/swww-daemon $HOME/.local/bin/swww-daemon
    cd ..
fi

exit 0
