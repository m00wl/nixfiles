# Host Configurations

## Structure

This folder contains the configurations for each NixOS host.
The `hardware-configuration.nix` and `configuration.nix` for each machine are stored in subfolders on a per host basis.
Additional provisioning steps beyond the general processes described below, if necessary, can be found there as well.
Be sure to update `hardware-configuration.nix` if you transition a machine to different hardware!

## Secrets

Secrets are provisioned with [sops](https://github.com/mozilla/sops) using [sops-nix](https://github.com/Mic92/sops-nix).

Host-independent secrets are collected in this top-level directory.
Non-universal secrets should be moved to host-specific `secrets.yaml` files in their respective subdirectories.

## Bootstrap Process

### UEFI Systems

This section describes the general bootstrap process to provision a new UEFI system for the NixOS install:

Create a `DISK` variable for convenience:

```bash
DISK=/dev/disk/by-id/...
```

If necessary, delete ZFS labels and zap already exisiting GPT and MBR partitions:

```bash
zpool labelclear $DISK
sgdisk -Z $DISK
```

Partition the disk with the following layout:

| Number  | Size                  | Description                 |
| ------- | --------------------- | --------------------------- |
| 1       | 512MiB                | EFI system partition (ESP)  |
| 2       | remaining disk space  | ZFS                         |
| 3       | RAM size              | Linux swap (optional)       |

```bash
sgdisk        \
 -n 1:0:+512M \
 -N 2         \
 -n 3:-4G:0   \
 -t 1:EF00    \
 -t 2:BF01    \
 -t 3:8200    \
 $DISK
```

Create ZFS root pool:

```bash
zpool create               \
    -o ashift=12           \
    -o autotrim=on         \
    -R /mnt                \
    -O acltype=posixacl    \
    -O canmount=off        \
    -O compression=lz4     \
    -O dnodesize=auto      \
    -O normalization=formD \
    -O relatime=on         \
    -O xattr=sa            \
    -O mountpoint=/        \
    rpool                  \
    $DISK-part2
```

Create ZFS datasets.
Be sure to adapt the size of the `reserved` dataset appropriately:

```bash
zfs create                     \
 -o mountpoint=none            \
 -o refreservation=16G         \
 rpool/reserved
zfs create                     \
 -o canmount=off               \
 -o mountpoint=none            \
 -o encryption=on              \
 -o keylocation=prompt         \
 -o keyformat=passphrase       \
 rpool/nixos
zfs create                     \
 -o canmount=on                \
 -o mountpoint=/               \
 -o com.sun:auto-snapshot=true \
 rpool/nixos/root
zfs create                     \
 -o canmount=on                \
 -o mountpoint=/home           \
 -o com.sun:auto-snapshot=true \
 rpool/nixos/home
zfs create                     \
 -o canmount=on                \
 -o mountpoint=/nix            \
 rpool/nixos/nix
zfs create                     \
 -o mountpoint=/tmp            \
 -o setuid=off                 \
 -o devices=off                \
 -o sync=disabled              \
 rpool/nixos/tmp
```

Fix permissions on `tmp/`:

```bash
chmod 777 /mnt/tmp
```

Prepare `boot` partition:

```bash
mkdir /mnt/boot
mkfs.fat -F 32 -n boot $DISK-part1
mount $DISK-part1 /mnt/boot/
```

Prepare `swap` partition:

```bash
mkswap -L swap $DISK-part3
swapon $DISK-part3
```

Generate NixOS configuration:

```bash
nixos-generate-config --root /mnt
```

Follow the configuration and installation steps below.

### Raspberry Pis

This section describes the general bootstrap process to provision a Raspberry Pi system for the NixOS install:

This is largely based on the guide from the wiki: [NixOS on ARM/Raspberry Pi 3](https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_3).

The SD-card images already contain an `ext4`-formatted root partition that automatically resizes on first boot.
Custom images can be built with the `0lnix` host configuration in this repository.

For the external hard drive, create a `DISK` variable for convenience:

```bash
DISK=/dev/disk/by-id/...
```

If necessary, delete ZFS labels and zap already exisiting GPT and MBR partitions:

```bash
zpool labelclear $DISK
sgdisk -Z $DISK
```

Partition the disk with the following layout:

| Number  | Size                  | Description            |
| ------- | --------------------- | ---------------------- |
| 1       | RAM size              | Linux swap (optional)  |
| 2       | remaining disk space  | ZFS                    |

```bash
sgdisk      \
 -n 1:0:+8G \
 -N 2       \
 -t 1:8200  \
 -t 2:BF01  \
 $DISK
```

Create ZFS data pool:

```bash
zpool create               \
    -o ashift=12           \
    -o autotrim=on         \
    -O acltype=posixacl    \
    -O canmount=off        \
    -O compression=zstd    \
    -O dnodesize=auto      \
    -O normalization=formD \
    -O relatime=on         \
    -O xattr=sa            \
    -O mountpoint=/data    \
    dpool                  \
    $DISK-part2
```

Create ZFS datasets.
Be sure to adapt the size of the `reserved` dataset appropriately:

```bash
zfs create                     \
 -o mountpoint=none            \
 -o refreservation=64G         \
 dpool/reserved
zfs create                     \
 -o canmount=off               \
 -o mountpoint=none            \
 -o encryption=on              \
 -o keylocation=prompt         \
 -o keyformat=passphrase       \
 dpool/data
zfs create                     \
 -o canmount=on                \
 -o mountpoint=/data           \
 -o com.sun:auto-snapshot=true \
 dpool/data/root
```

Prepare `swap` partition:

```bash
mkswap -L swap $DISK-part1
swapon $DISK-part1
```

Generate NixOS configuration (mainly in order to collect filesystem mounts in `hardware-configuration.nix`):

```bash
nixos-generate-config
```

Follow the configuration steps below.

Afterwards, set `root` password and activate the new configuration.
Important: Be sure not to use `nixos-install` but rather just build the configuration manually.
This is due to the nature of the SD-card image that already deploys a ready-to-go system:

```bash
passwd
nixos-rebuild switch
```

### Configuration

This section describes the process of tweaking the generated configuration in order to prepare the installation of the flake-based configuration from this repository.

- `hardware-configuration.nix`:

  Enable ZFS mounts:

  ```bash
  sed                                                                                \
   -i 's|fsType = "zfs";|fsType = "zfs"; options = [ "zfsutil" "X-mount.mkdir" ];|g' \
   /mnt/etc/nixos/hardware-configuration.nix
  ```

- `extra-configuration.nix`:

  Prepare additional configuration file:

  ```bash
  sed                                                                                           \
   -i "s|./hardware-configuration.nix|./hardware-configuration.nix ./extra-configuration.nix|g" \
   /mnt/etc/nixos/configuration.nix
  tee -a /mnt/etc/nixos/extra-configuration.nix <<EOF
  { config, pkgs, ... }:

  {
  EOF
  ```

  Enable ZFS support:

  ```bash
  tee -a /mnt/etc/nixos/extra-configuration.nix <<EOF
    boot.supportedFilesystems = [ "zfs" ];
    networking.hostId = "$(head -c 8 /etc/machine-id)";
    #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  EOF
  ```

  Enable flakes support:

  ```bash
  tee -a /mnt/etc/nixos/extra-configuration.nix <<EOF
    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  EOF
  ```

  Create user account:

  ```bash
  tee -a /mnt/etc/nixos/extra-configuration.nix <<EOF
    users.users.m00wl = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      initialHashedPassword = "$(mkpasswd -m SHA-512 -s)";
    };
  EOF
  ```

  Finish additional configuration file:

  ```bash
  tee -a /mnt/etc/nixos/extra-configuration.nix <<EOF
  }
  EOF
  ```

- `configuration.nix`:

  Add minimal system information (`networking.hostname`, `time.timezone`, etc.)

### Installation

Install NixOS:

```bash
nixos-install
```

Set `root` password and reboot.

## Install Existing Configuration

Clone git repository:

```bash
git clone git@github.com:m00wl/nixfiles.git ~/nixfiles
```

Symlink `flake.nix`:

```bash
ln -s ~/nixfiles/flake.nix /etc/nixos/
```

Make sure that `networking.hostname` aligns with a valid NixOS configuration in `flake.nix`.
For new hosts, create a folder with matching name and tweak `flake.nix` accordingly.

If necessary, update `hardware-configuration.nix` of this host:

```bash
cp /etc/nixos/hardware-configuration.nix ~/nixfiles/hosts/$(hostname)/
```

If necessary, update `.sops.yaml` to have access to exisiting secrets.

Rebuild the system:

```bash
nixos-rebuild switch
```
