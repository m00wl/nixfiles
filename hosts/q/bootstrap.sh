#!/usr/bin/env sh

usage() {
  cat <<EOF
Usage: $0 -n ISO_PATH

  -n ISO_PATH   Path to the NixOS install image (required).
  -h            Show this help message.
EOF
  exit 1
}

NIXOS_ISO=""

while getopts "n:h" opt; do
  case "$opt" in
    n) NIXOS_ISO="$OPTARG" ;;
    h) usage ;;
    \?) echo "ERROR: Unknown option: -$OPTARG" >&2; usage ;;
  esac
done

shift $((OPTIND - 1))

if [ -z "$NIXOS_ISO" ]; then
  echo "ERROR: -n ISO_PATH for NixOS install image is required." >&2 
  usage
fi

if [ ! -f "$NIXOS_ISO" ]; then
  echo "ERROR: NixOS install image not found: $NIXOS_ISO" >&2
  usage
fi

virt-install \
  --name "laforge" \
  --vcpus 1 \
  --ram 2048 \
  --autostart \
  --boot uefi \
  --disk format=qcow2,size=16 \
  --console pty,target_type=virtio \
  --autoconsole none \
  --graphics none \
  --network bridge=br0,model=virtio \
  --osinfo nixos-unknown \
  --cdrom "$NIXOS_ISO"
