# `q`

This is the main virtualization host.

## Extra Bootstrap Steps

Generate initrd ssh keys after disk partitioning and before NixOS install.

```bash
mkdir -p /mnt/etc/secrets/initrd
ssh-keygen -t ed25519 -N "" -f /mnt/etc/secrets/initrd/ssh_host_ed25519_key
```
