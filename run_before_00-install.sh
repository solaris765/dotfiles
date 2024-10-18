#!/bin/sh

if ! command -v rbw &> /dev/null; then  
  sudo dnf install -y rbw
fi

rbw config set email mrhodesdev@gmail.com
rbw login
