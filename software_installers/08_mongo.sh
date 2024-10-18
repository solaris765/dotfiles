#!/bin/sh
set -eu

# MongoDB
if ! command -v mongod &> /dev/null; then
    echo "Installing Mongodb"
    sudo bash -c 'cat <<EOF > /etc/mongod.conf
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
EOF'

    sudo bash -c 'cat <<EOF > /etc/yum.repos.d/mongodb-org-8.0.repo
[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
EOF'

    sudo dnf install -y -y mongodb-org
    sudo systemctl start mongod
    sudo systemctl enable mongod
    mongosh --eval "rs.initiate({_id: \"rs0\",version: 1,members: [{ _id: 0, host : \"localhost:27017\" }]})"
fi

exit 0
