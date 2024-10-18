#!/bin/bash

# Start or connect to ssh-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    # Check for existing ssh-agent
    if [ -f ~/.ssh-agent-info ]; then
        . ~/.ssh-agent-info > /dev/null
    fi
    
    # If agent isn't running, start a new one
    if ! ssh-add -l &>/dev/null; then
        (umask 066; ssh-agent -t 12h > ~/.ssh-agent-info)
        . ~/.ssh-agent-info > /dev/null
    fi
fi

# Function to add key to agent
add_key_to_agent() {
    local key_file="$1"
    local key_name=$(basename "$key_file")
    
    if ! ssh-add -l 2>/dev/null | grep -q "$key_name"; then
        echo "Adding $key_name to agent..."
        ssh-add "$key_file"
    fi
}

# Only add keys if the agent is empty
if ! ssh-add -l &>/dev/null; then
    echo "No keys in agent. Adding keys..."
    # Add all private keys from ~/.ssh/ids
    for key in ~/.ssh/ids/*; do
        if [[ -f "$key" && ! "$key" =~ \.pub$ ]]; then
            add_key_to_agent "$key"
        fi
    done
fi
