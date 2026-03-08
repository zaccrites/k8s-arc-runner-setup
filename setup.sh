#!/bin/bash
set -euo pipefail

# https://cloud-images.ubuntu.com/jammy/20260216/
IMG_NAME="cloud_vm_image.img"
IMG_URL="https://cloud-images.ubuntu.com/jammy/20260216/jammy-server-cloudimg-amd64.img"
if [[ ! -f "${IMG_NAME}" ]]; then
  echo "Downloading Ubuntu server cloud-init image"
  wget "${IMG_URL}" -O "${IMG_NAME}" --progress=bar:force
fi

NETWORK_NAME="k8s-network"
echo "Creating network ${NETWORK_NAME}"
virsh net-define "k8s-network.xml"
virsh net-start "${NETWORK_NAME}"

mkdir -p disks
for i in {1..3}; do
  VM_DISK_SIZE=20G
  VM_DISK="$(printf "disks/k8s_node_%02d.qcow2" "$i")"
  if [[ ! -f "${VM_DISK}" ]]; then
    echo "Creating disk image ${VM_DISK} of size ${VM_DISK_SIZE}"
    qemu-img create -f qcow2 -b "$(realpath "$IMG_NAME")" -F qcow2 "${VM_DISK}" "${VM_DISK_SIZE}"
  fi

  VM_NAME="$(printf "k8s-node-%02d" "$i")"
  MAC_ADDRESS="$(printf "52:54:00:00:00:%02x" "$i")"
  echo "Creating VM ${VM_NAME}"
  export VM_NAME
  virt-install \
    --name "$VM_NAME" \
    --ram 2048 \
    --vcpus 2 \
    --disk path="$(realpath "${VM_DISK}"),format=qcow2" \
    --import \
    --os-variant ubuntujammy \
    --network "network=${NETWORK_NAME},mac=${MAC_ADDRESS},model=virtio" \
    --cloud-init user-data=user-data.yaml \
    --graphics none \
    --noautoconsole

done




