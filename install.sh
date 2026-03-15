#!/bin/bash
set -euo pipefail
set -x

if ! ./ssh-node.sh 1 "cat /home/zac/.init_done" | grep 'done'; then
  echo "init not done"
  exit 1
fi

./ssh-node.sh 1 "sudo hostname k8s-node-01"
./ssh-node.sh 2 "sudo hostname k8s-node-02"
./ssh-node.sh 3 "sudo hostname k8s-node-03"

./ssh-node.sh 1 "bash" < install_control_node.sh
echo "sudo cat /var/lib/rancher/rke2/server/node-token" | ./ssh-node.sh 1 | tail -n 1 > node-token
NODE_TOKEN="$(cat node-token)"
sed -i "s/^\(SERVER_TOKEN=\).*$/\1${NODE_TOKEN}/" install_worker_node.sh

# https://docs.rke2.io/cluster_access
echo "sudo cat /etc/rancher/rke2/rke2.yaml" | ./ssh-node.sh 1 > rke2.yaml
sed -i 's/127.0.0.1/192.168.100.101/g' rke2.yaml

./ssh-node.sh 2 "bash" < install_worker_node.sh
./ssh-node.sh 3 "bash" < install_worker_node.sh

# --kubeconfig rke2.yaml
export KUBECONFIG=rke2.yaml
kubectl get pods --all-namespaces
kubectl get nodes
kubectl describe node k8s-node-01
