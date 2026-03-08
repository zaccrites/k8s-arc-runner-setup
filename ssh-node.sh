#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "ERROR: expected VM number" >&2
  exit 1
fi

VM_IP="$(printf "192.168.100.1%02d" "$1")"
shift

ssh \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -o LogLevel=ERROR \
  "zac@${VM_IP}" \
  "$@"

