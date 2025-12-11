# `q`

This is the main virtualization host.

## Extra Bootstrap Steps

### Prepare remote unlock

After disk partitioning, generate initrd ssh keys.

```bash
mkdir -p /mnt/etc/secrets/initrd
ssh-keygen -t ed25519 -N "" -f /mnt/etc/secrets/initrd/ssh_host_ed25519_key
```
### Provision VMs

After NixOS installation, build the custom installer image and bootstrap VMs.

```bash
nix build .#nixosConfigurations.cochrane.config.system.build.isoImage
./bootstrap.sh -n ./result/iso/<INSTALLER.ISO>
```

Install VMs (virsh console, ssh, nixos-anywhere, etc.).
