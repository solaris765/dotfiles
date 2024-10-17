#!/bin/bash

echo "Settin up ssh-agent"

# Set the directory to save attachments
ATTACHMENT_DIR=".ssh/ids"

mkdir -p $ATTACHMENT_DIR

# Set the item ID of the record containing the attachments
ITEM_ID="139768c4-266a-4569-afd3-b20b017fb8ed"

item=$(bw get item $ITEM_ID)
item_name=$(echo $item | jq -r '.name')

# Get all attachments for the item
attachments=$(echo $item | jq '.attachments')

# Loop through each attachment and download it
echo "$attachments" | jq -c '.[]' | while read attachment; do
    attachment_id=$(echo $attachment | jq -r '.id')
    attachment_filename=$(echo $attachment | jq -r '.fileName')
    
    # Download the attachment
    bw get attachment $attachment_id --itemid $ITEM_ID --output "$ATTACHMENT_DIR/${attachment_filename}"
    
    echo "Downloaded: ${attachment_filename}"
done

echo "All attachments from '$item_name' have been downloaded to $ATTACHMENT_DIR"

source .bash_profile