#!/bin/bash
set -euo pipefail
set -x

terraform/run.sh apply
ansible-playbook -i ansible/inventory.yaml ansible/provision-k8s.yaml
sed -i "s/127.0.0.1/$(terraform -chdir=terraform output -raw k8s_node_01_ip)/g" rke2_kubeconfig.yaml
