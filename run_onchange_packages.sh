#!/bin/sh

# Utils
if ! command -v vim &> /dev/null || ! command -v curl &> /dev/null || ! command -v git &> /dev/null || ! command -v jq &> /dev/null || ! command -v seahorse &> /dev/null || ! command -v Thunar &> /dev/null || ! command -v solaar &> /dev/null || ! command -v wireplumber &> /dev/null || ! command -v NetworkManager &> /dev/null; then
    echo "Installing Utils"
    sudo dnf install -y vim curl git jq seahorse Thunar solaar wireplumber NetworkManager
fi

# Terminal
if ! command -v foot &> /dev/null || ! command -v tmux &> /dev/null; then
    echo "Installing Terminal tools"
    sudo dnf install -y foot tmux
fi

# Node
if ! command -v node &> /dev/null || ! command -v bun &> /dev/null || ! command -v nvm &> /dev/null; then
    echo "Installing NodeJS tooling"
    sudo dnf install -y node
    curl -fsSL https://bun.sh/install | bash
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# hyprland
if ! command -v hyprland &> /dev/null; then
    echo "Installing Hyprland Tooling"
    sudo dnf install -y hyprcursor.x86_64 hyprcursor-devel.x86_64 hypridle.x86_64 hyprland.x86_64 hyprland-devel.x86_64 hyprland-protocols-devel.noarch hyprlang.x86_64 hyprlang-devel.x86_64 hyprlock.x86_64 hyprpicker.x86_64 hyprutils.x86_64 hyprutils-devel.x86_64 hyprwayland-scanner-devel.x86_64 xdg-desktop-portal-hyprland.x86_64 
    sudo dnf install -y wofi waybar
fi

# Helper
ghRepoCloneLatestRelease ()
{
    [[ ${1} =~ / ]] &&
        wget -qO- https://github.com/${1}/$(curl -s https://github.com/${1}/releases |
            grep -m1 -Eo "archive/refs/tags/[^/]+\.tar\.gz") |
                tar --strip-components=1 -xzv >/dev/null
}

# Local Software
if ! command -v swww &> /dev/null; then
    echo "Installing github software builds"
    mkdir -p ~/.git-software
    cd ~/.git-software

    ## swww
    echo "  SWWW"
    ghRepoCloneLatestRelease LGFae/swww
    cd swww
    cargo build --release
    ln -s $HOME/.git-software/swww/target/release/swww $HOME/.local/bin/swww
    ln -s $HOME/.git-software/swww/target/release/swww-daemon $HOME/.local/bin/swww-daemon
    cd ..
fi

cd ~

# VSCode
if ! command -v code &> /dev/null; then
    echo "Installing VSCode"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

    dnf check-update
    sudo dnf install -y code # or code-insiders
fi

# browser
if ! command -v brave-browser &> /dev/null; then
    echo "Installing Web Browser"
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf install -y brave-browser

    echo "### Installing bitwarden browser plugin"
    BITWARDEN_ID=nngceckbapebfimnlniiiahkandclblb
    EXTENSIONS_PATH=/opt/brave.com/brave/extensions
    mkdir -p $EXTENSIONS_PATH
    echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' > "${EXTENSIONS_PATH}/${BITWARDEN_ID}.json"
fi

# PriTunl
echo "Prepping VPN"
xdg-open https://vpn.lifemd.io/sso/request

# MongoDB
if ! command -v mongod &> /dev/null; then
    echo "Installing Mongodb"
    sudo cat <<EOF > /etc/mongod.conf
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# Where and how to store data.
storage:
  dbPath: /var/lib/mongo

# how the process runs
processManagement:
  timeZoneInfo: /usr/share/zoneinfo

# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.


#security:

#operationProfiling:

replication:
  replSetName: rs0

#sharding:

## Enterprise-Only Options

#auditLog:
EOF

    sudo cat <<EOF > /etc/yum.repos.d/mongodb-org-8.0.repo
[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
EOF

    sudo dnf install -y -y mongodb-org
    sudo systemctl start mongod
    sudo systemctl enable mongod
    mongosh --eval "rs.initiate({_id: \"rs0\",version: 1,members: [{ _id: 0, host : \"localhost:27017\" }]})"
fi

#slack 
if ! command -v slack &> /dev/null; then
    echo "Installing Slack"
    cd ~/Downloads
    curl https://slack.com/downloads/instructions/linux?ddl=1&build=rpm --output slack.rpm
    sudo dnf install -y ./slack.rpm
fi

# docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker"
    sudo dnf -y install dnf-plugins-core
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker

    sudo groupadd docker
    sudo usermod -aG docker $USER

    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
fi

#gcm
if ! command -v git-credential-manager &> /dev/null; then
    echo "Installing GCM"
    curl -L https://aka.ms/gcm/linux-install-source.sh | sh
    git-credential-manager configure
    git config --global credential.credentialStore secretservice
fi