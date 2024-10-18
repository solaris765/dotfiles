#!/bin/bash

echo "Settin up ssh-agent"

# Set the directory to save attachments
ATTACHMENT_DIR=".ssh/ids"

mkdir -p $ATTACHMENT_DIR

# Get all attachments for the item
attachments=$(rbw get ssh --raw | jq -r '.fields.[]')

# Loop through each attachment and download it
echo "$attachments" | jq -c '.' | while read attachment; do
    attachment_filename=$(echo $attachment | jq -r '.name')
    if [[ "${attachment_filename}" == *.pub ]]; then
        echo $attachment | jq -r '.value' > "$ATTACHMENT_DIR/${attachment_filename}"

        sudo chmod 644 "$ATTACHMENT_DIR/${attachment_filename}"
    else
        echo $attachment | jq -r '.value' | base64 -d > "$ATTACHMENT_DIR/${attachment_filename}"

        sudo chmod 600 "$ATTACHMENT_DIR/${attachment_filename}"
    fi
    
    echo "Downloaded: ${attachment_filename}"
done

echo "All attachments from 'ssh' have been downloaded to $ATTACHMENT_DIR"
