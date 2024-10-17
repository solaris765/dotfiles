#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type bw >/dev/null 2>&1 && exit

echo "Installing Bitwarden-CLI"
sudo dnf install curl jq

REPO="bitwarden/clients"
ASSET_PATTERN="bw-linux-.*\.zip"

# Fetch all releases
releases=$(curl -s "https://api.github.com/repos/$REPO/releases")

# Find the latest release with a tag starting with "CLI"
latest_cli_release=$(echo "$releases" | jq -r '.[] | select(.tag_name | startswith("cli-")) | .tag_name' | sort -V | tail -n1)

if [ -z "$latest_cli_release" ]; then
    echo "No CLI release found."
    exit 1
fi

echo "Latest CLI release: $latest_cli_release"

# Fetch the specific release
release_info=$(curl -s "https://api.github.com/repos/$REPO/releases/tags/$latest_cli_release")

# Extract the download URL for the matching asset
download_url=$(echo "$release_info" | jq -r --arg PATTERN "$ASSET_PATTERN" '.assets[] | select(.name | test($PATTERN)) | .browser_download_url')

if [ -z "$download_url" ]; then
    echo "No matching asset found in the latest CLI release."
    exit 1
fi

# Extract the filename from the URL
filename=$(basename "$download_url")

# Download the asset
echo "Downloading $filename..."
curl -L -o "$filename" "$download_url"

echo "Download complete: $filename"

unzip $filename
rm $filename
sudo mv bw /usr/local/bin/bw
sudo chmod +x /usr/local/bin/bw