# Additional Bootstrap Process

This document describes the additional bootstrap process for `slnix`.

## `slnix` v0.2

`slnix` is now a Raspberry Pi 3 Model B+ connected to an external hard drive for storage.
Therefore, it does **not** follow the general bootstrap process for UEFI systems as described before.

### Raspberry Pi Bootstrap

This is largely based on the guide from the wiki: [NixOS on ARM/Raspberry Pi 3](https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_3).

The SD-card images already contain an `ext4`-formatted root partition that automatically resizes on first boot.

For the external hard drive, create a `DISK` variable for convenience:

```bash
DISK=/dev/disk/by-id/...
```

Create 2GiB Linux SWAP partition and a ZFS partition with the remaining disk space:

```bash
sgdisk -n 1:0:+2G -N 2 -t 1:8200 -t 2:BF01 $DISK
```

Set up and activate Linux SWAP area:

```bash
mkswap -L swap $DISK-part1
swapon $DISK-part1
```

Create ZFS data pool:

```bash
zpool create -O mountpoint=none \
             -O atime=off \
             -O compression=lz4 \
             -O xattr=sa \
             -O acltype=posixacl
             -o ashift=12 \
             dpool $DISK-part2
```

Create ZFS datasets. Be sure to adapt the size of the `reserved` dataset appropriately:

```bash
zfs create -o mountpoint=none \
           -o encryption=aes-256-gcm \
           -o keyformat=passphrase \
           dpool/root
zfs create -o mountpoint=legacy \
           -o com.sun:auto-snapshot=true \
           dpool/root/data
zfs create -o mountpoint=none \
           -o reservation=64G \
           dpool/reserved
```

Prepare mountpoint:

```bash
mkdir /data
```

Mount `/data`:

```bash
mount -t zfs dpool/root/data /data
```

Generate NixOS configuration (mainly for filesystems in `hardware-configuration.nix`):

```bash
nixos-generate-config
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

Set `root` password and activate the new configuration.
Be sure not to use `nixos-install` but rather just build the configuration manually.
This is due to the nature of the SD-card image that already deploys a ready-to-go system:

```bash
passwd
nixos-rebuild switch
```

For installing the flake-based configuration, please follow the instructions from before.

## `slnix` v0.1

### Provision Storage Pool

Create ZFS data pool:

```bash
zpool create -O mountpoint=none \
             -O atime=off \
             -O compression=lz4 \
             -O xattr=sa \
             -O acltype=posixacl \
             -oashift=12 \
             dpool raidz1 /dev/sda /dev/sdb /dev/sdc /dev/sdd
```

Create ZFS datasets. Be sure to adapt the size of the `reserved` dataset appropriately:

```bash
zfs create -o mountpoint=none \
           -o encryption=aes-256-gcm \
           -o keyformat=passphrase \
           dpool/root
zfs create -o mountpoint=legacy \
           -o com.sun:auto-snapshot=true \
           dpool/root/data
zfs create -o mountpoint=none \
           -o reservation=64G \
           dpool/reserved
```

Prepare mountpoint:

```bash
mkdir /data
```

Mount ZFS data root to `/data`

```bash
mount -t zfs dpool/root/data /data
```
