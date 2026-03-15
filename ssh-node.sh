#!/bin/bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "expected node number" >&2
    exit 1
fi

TF_OUTPUT_NAME="$(printf 'k8s_node_%02d_ip' $1)"
shift

NODE_IP="$(terraform -chdir=terraform output -raw "${TF_OUTPUT_NAME}")"
ssh "root@${NODE_IP}" "$@"
