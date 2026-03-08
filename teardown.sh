#!/bin/bash
set -euo pipefail

DESTROY=false
DISKS=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--destroy)
      DESTROY=true
      shift
      ;;
    --disks)
      DISKS=true
      shift
      ;;
    -*)
      echo "Unknown option '$1'" >&2
      exit 1
  esac
done

for i in {1..3}; do
  VM_NAME="$(printf "k8s-node-%02d" "$i")"
  VM_STATE="$(virsh domstate "${VM_NAME}" 2>/dev/null || true)"

  if [[ -z "${VM_STATE}" ]]; then
    echo "${VM_NAME} does not exist, nothing to do"
    continue
  fi

  if [[ "${DESTROY}" == true ]]; then
    if [[ "${VM_STATE}" == 'running' ]]; then
      echo "Force-stopping ${VM_NAME}..."
      virsh destroy "${VM_NAME}" || true
    fi

    echo "Deleting ${VM_NAME}..."
    virsh undefine "${VM_NAME}" || true
  else
    if [[ "${VM_STATE}" == 'running' ]]; then
      echo "Shutting down ${VM_NAME}..."
      virsh shutdown "${VM_NAME}" || true
    fi
  fi
done

if [[ "${DESTROY}" == true ]] && [[ "${DISKS}" == true ]]; then
  echo "Destroying VM disks"
  rm -rf disks
fi

NETWORK_NAME="k8s-network"
if virsh net-info "${NETWORK_NAME}" >/dev/null 2>&1; then
  if [[ "$DESTROY" == true ]]; then
    echo "Deleting network ${NETWORK_NAME}"
    virsh net-destroy "${NETWORK_NAME}"
    virsh net-undefine "${NETWORK_NAME}"
  fi
fi
