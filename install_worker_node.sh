#!/bin/bash
set -euo pipefail
set -x
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sudo sh -

sudo systemctl enable rke2-agent.service

# sudo mkdir -p /etc/rancher/rke2/
# sudo vim /etc/rancher/rke2/config.yaml

# sudo cat /var/lib/rancher/rke2/server/node-token
SERVER_TOKEN=K10675aaf3098bb74797e9a60aa9fdcaccf78743472149cf4a6f52e5438c589fdaf::server:95c202a37fb232b5d24e120aa7fcab40
SERVER_IP=192.168.100.101
CONFIG_PATH=/etc/rancher/rke2/config.yaml

sudo mkdir -p "$(dirname "${CONFIG_PATH}")"
echo "server: https://${SERVER_IP}:9345" | sudo tee "${CONFIG_PATH}"
echo "token: ${SERVER_TOKEN}" | sudo tee -a "${CONFIG_PATH}"

sudo systemctl start rke2-agent.service

