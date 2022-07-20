# Host Configurations

## Structure

This folder contains the configurations for each NixOS host.
The `hardware-configuration.nix` and `configuration.nix` for each machine are
stored in subfolders on a per host basis.
Additional provisioning steps beyond the general process described below,
if necessary, can be found there as well.
Be sure to update `hardware-configuration.nix` if you transition a machine to
different hardware!

## Secrets

Secrets are provisioned with [sops](https://github.com/mozilla/sops) using
[sops-nix](https://github.com/Mic92/sops-nix).

Host-independent secrets are collected in this top-level directory.
Non-universal secrets should be moved to host-specific `secrets.yaml` files in
their respective subdirectories.

## Bootstrap Process

This describes the general bootstrap process to provision a new UEFI system for
the NixOS install:

Create a `DISK` variable for convenience:

```bash
DISK=/dev/disk/by-id/...
```

If necessary, zap already exisiting GPT and MBR partitions:
```bash
sgdisk -Z $DISK
```

Create 512MiB EFI partition and a ZFS partition with the remaining disk space:

```bash
sgdisk -n 1:0:+512M -N 2 -t 1:EF00 -t 2:BF01 $DISK
```

Create ZFS root pool:

```bash
zpool create -O mountpoint=none     \
             -O canmount=off        \
             -O compression=lz4     \
             -O relatime=on         \
             -O xattr=sa            \
             -O acltype=posixacl    \
             -O dnodesize=auto      \
             -O normalization=formD \
             -o ashift=12           \
             -o autotrim=on         \
             rpool $DISK-part2
```

Create ZFS datasets. Be sure to adapt the size of the `reserved` dataset
appropriately:

```bash
zfs create -o mountpoint=none            \
           -o refreservation=1G          \
           rpool/reserved
zfs create -o mountpoint=none            \
           -o encryption=aes-256-gcm     \
           -o keylocation=prompt         \
           -o keyformat=passphrase       \
           rpool/nixos
zfs create -o mountpoint=legacy          \
           -o com.sun:auto-snapshot=true \
           rpool/nixos/root
zfs create -o mountpoint=legacy          \
           -o com.sun:auto-snapshot=true \
           rpool/nixos/home
zfs create -o mountpoint=legacy          \
           rpool/nixos/nix
zfs create -o mountpoint=legacy          \
           -o setuid=off                 \
           -o devices=off                \
           -o sync=disabled              \
           rpool/nixos/tmp
```

Mount NixOS root to `/mnt`:

```bash
mount -t zfs rpool/nixos/root /mnt
```

Prepare mountpoints:

```bash
mkdir /mnt/{home,nix,tmp,boot}
mkfs.vfat $DISK-part1
```

Mount `home/`, `nix/`, `tmp/` and `boot/`:

```bash
mount -t zfs rpool/root/home /mnt/home/
mount -t zfs rpool/root/nix /mnt/nix/
mount -t zfs rpool/root/tmp /mnt/tmp/
mount $DISK-part1 /mnt/boot/
```

Fix permissions on `tmp/`:

```bash
chmod 777 /mnt/tmp
```

Generate NixOS configuration:

```bash
nixos-generate-config --root /mnt
```

Edit generated configuration:

- add minimal system information (`networking.hostname`, `time.timezone`, etc.)
- add user account
(remember to set password with `mkpasswd -m sha-512` and
`users.users.<name>.initialHashedPassword`)
- for ZFS to work add:
```nix
{
  boot.supportedFilesytems = [ "zfs" ];
  networking.hostId = ""; # e.g. obtain from $(head -c 8 /etc/machine-id)
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
}
```
- activate flakes support:
```nix
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
```

Install NixOS:

```bash
nixos-install
```

Set `root` password and reboot.

## Install Existing Configuration

Clone git repository:

```bash
git clone git@github.com:m00wl/nixos-config.git ~/.nixos-config
```

Symlink `flake.nix`:

```bash
ln -s ~/.nixos-config/flake.nix /etc/nixos/
```

Make sure that `networking.hostname` aligns with a valid NixOS configuration in
`flake.nix`.

For new hosts, create a folder with matching name and tweak `flake.nix`
accordingly.

If necessary, update `hardware-configuration.nix` of this host:

```bash
cp /etc/nixos/hardware-configuration.nix ~/.nixos-config/hosts/$(hostname)/
```

If necessary, update `.sops.yaml` to have access to exisiting secrets.

Rebuild the system:

```bash
nixos-rebuild switch
```
