# Host Configurations

This folder contains the configurations for each NixOS host.
`hardware-configuration.nix` and `configuration.nix` for each machine are stored
in subfolders on a per host basis.
Additional provisioning steps beyond the general process described below,
if necessary, can be found there as well.
Be sure to update `hardware-configuration.nix` if you transition a machine to
different hardware!

## Bootstrap Process

This describes the general bootstrap process to provision a new system for the
NixOS install:

Create a `DISK` variable for convenience:

```bash
DISK=/dev/disk/by-id/...
```

Create 512MiB EFI partition and a ZFS partition with the remaining disk space:

```bash
sgdisk -n 1:0:+512M -N 2 -t 1:EF00 -t 2:BF01 $DISK
```

Create ZFS root pool:

```bash
zpool create -O mountpoint=none \
             -O atime=off \
             -O compression=lz4 \
             -O xattr=sa \
             -O acltype=posixacl
             -o ashift=12 \
             rpool $DISK-part2
```

Create ZFS datasets. Be sure to adapt the size of the `reserved` dataset
appropriately:

```bash
zfs create -o mountpoint=none \
           -o encryption=aes-256-gcm \
           -o keyformat=passphrase \
           rpool/root
zfs create -o mountpoint=legacy \
           -o com.sun:auto-snapshot=true \
           rpool/root/nixos
zfs create -o mountpoint=legacy \
           -o com.sun:auto-snapshot=true \
           rpool/root/home
zfs create -o mountpoint=legacy \
           -o setuid=off \
           -o devices=off \
           -o sync=disabled \
           rpool/root/tmp
zfs create -o mountpoint=none \
           -o reservation=1G \
           rpool/reserved
```

Mount ZFS root to `/mnt`:

```bash
mount -t zfs rpool/root/nixos /mnt
```

Prepare mountpoints:

```bash
mkdir /mnt/{home,tmp,boot}
mkfs.vfat $DISK-part1
```

Mount `home/`, `tmp/` and `boot/`:

```bash
mount -t zfs rpool/root/home /mnt/home/
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
- add `networking.hostId` (from `head -c 8 /etc/machine-id`) for ZFS to work
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
git clone git@github.com:m00wl/nixos-config.git ~/
```

Symlink `flake.nix`:

```bash
ln -s ~/nixos-config/flake.nix /etc/nixos/
```

Make sure that `networking.hostname` aligns with a valid NixOS configuration in
`flake.nix`.
If necessary, update `hardware-configuration.nix` of this host:

```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hosts/$(hostname)/
```

Rebuild system:

```bash
nixos-rebuild switch
```
