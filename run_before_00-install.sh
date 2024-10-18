#!/bin/sh

if ! command -v rbw &> /dev/null; then
    sudo dnf install -y rbw
fi

rbw unlocked
exit_status=$?
# Determine status and store result
if [ $exit_status -eq 1 ]; then
    rbw config set email mrhodesdev@gmail.com
    rbw login
fi

# Elevate perms early so sub scripts don't need to wait on elevation
sudo true
