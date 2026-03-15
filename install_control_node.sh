#!/bin/bash
set -euo pipefail
set -x

# https://docs.rke2.io/install/quickstart

curl -sfL https://get.rke2.io | sudo sh -

CONFIG=/etc/rancher/rke2/config.yaml
if [[ -f "${CONFIG}" ]]; then
  echo "${CONFIG} exists!"
  sudo cat "${CONFIG}"
else
  sudo mkdir -p "$(dirname "${CONFIG}")"
fi

cat <<EOF | sudo tee -a "${CONFIG}"
write-kubeconfig-mode: "0644"
# Force systemd cgroup driver
kubelet-arg:
  - "cgroup-driver=systemd"
  # Bypass the "0 capacity" issue from earlier
  - "eviction-hard=imagefs.available<1%,nodefs.available<1%"
EOF

sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service

