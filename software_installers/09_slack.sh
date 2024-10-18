#!/bin/sh
set -eu

#slack
if ! command -v slack &> /dev/null; then
    echo "Installing Slack"
        sudo bash -c 'cat <<EOF > /etc/yum.repos.d/slack.repo
[slack]
name=slack
baseurl=https://packagecloud.io/slacktechnologies/slack/fedora/21/x86_64
enabled=1
gpgcheck=0
gpgkey=https://packagecloud.io/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF'
    sudo dnf install -y slack
fi

exit 0
