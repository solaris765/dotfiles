#!/bin/sh

# Function to download and extract the latest release tarball
download_and_extract_latest_release() {
    local username=$1
    local repo=$2
    
    # Get the latest release info
    local release_url="https://api.github.com/repos/$username/$repo/releases/latest"
    local tarball_url=$(curl -s $release_url | grep "tarball_url" | cut -d '"' -f 4)
    
    if [ -z "$tarball_url" ]; then
        echo "Error: Could not find latest release tarball URL."
        exit 1
    fi
    
    # Download the tarball
    local filename="${repo}-latest.tar.gz"
    echo "Downloading latest release tarball to $filename..."
    curl -L -o "$filename" "$tarball_url"
    
    if [ $? -ne 0 ]; then
        echo "Error: Download failed."
        exit 1
    fi
    
    echo "Download complete: $filename"
    
    # Create extraction directory
    local extract_dir="${repo}-latest"
    mkdir -p "$extract_dir"
    
    # Extract the tarball
    echo "Extracting tarball to $extract_dir..."
    tar -xzf "$filename" -C "$extract_dir" --strip-components 1
    
    if [ $? -eq 0 ]; then
        echo "Extraction complete. Files are in $extract_dir"
        # Optionally remove the tarball
        rm "$filename"
        echo "Removed $filename"
        cd $extract_dir
    else
        echo "Error: Extraction failed."
        exit 1
    fi
}