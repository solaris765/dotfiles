#!/bin/sh

# if "Dell Inc. DELL S3422DWG HSRTS63" is enabled, and "eDP-1" is enabled, move the position of "eDP-1" to the right of "Dell Inc. DELL S3422DWG HSRTS63"

UltraWide=$(hyprctl monitors all -j | jq -r '.[] | select(.description == "Dell Inc. DELL S3422DWG HSRTS63") | .disabled')
eDP1=$(hyprctl monitors all -j | jq -r '.[] | select(.name == "eDP-1") | .disabled')

if [ "$UltraWide" = "false" ] && [ "$eDP1" = "false" ]; then
  echo "UltraWide and eDP-1 are enabled"
  hyprctl keyword monitor eDP-1,preferred,auto-down
elif [ "$eDP1" = "false" ]; then
  echo "eDP-1 is enabled"
  hyprctl keyword monitor eDP-1,preferred,auto,1
else
  echo "eDP-1 is disabled"
fi
