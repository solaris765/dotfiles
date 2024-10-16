#!/bin/bash

# Check that exports will be set in the current shell
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "This script must be sourced to work properly"
    exit 1
fi

# parse profiles in ~/.aws/config
PROFILES=$(grep -E '^\[profile' ~/.aws/config | awk '{print $2}' | sed 's/\]//g')

# add clear option
PROFILES="$PROFILES clear"

# Show menu and ask for input
echo "Select a profile to assume:"
select PROFILE in $PROFILES; do test -n "$PROFILE" && break; echo ">>> Invalid Selection"; done

if [ "$PROFILE" = "clear" ]; then
    unset AWS_DEFAULT_PROFILE
    unset AWS_PROFILE

    # remove from ~/.bashrc.d/aws.sh
    sed -i '/AWS_DEFAULT_PROFILE/d' ~/.bashrc.d/aws.sh
    sed -i '/AWS_PROFILE/d' ~/.bashrc.d/aws.sh

    echo "Cleared AWS profile"
    return
fi

# Assume role
export AWS_DEFAULT_PROFILE=$PROFILE
export AWS_PROFILE=$PROFILE

# add to ~/.bashrc.d/aws.tmp.sh
echo "export AWS_DEFAULT_PROFILE=$PROFILE" > ~/.bashrc.d/aws.tmp.sh
echo "export AWS_PROFILE=$PROFILE" >> ~/.bashrc.d/aws.tmp.sh

aws sts get-caller-identity
