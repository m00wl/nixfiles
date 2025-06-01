# Host Configurations

## Structure

This folder contains the configurations for each host.
It has the following structure:

```bash
.
├── hostname
│   ├── hardware.nix
│   ├── configuration.nix
│   ├── home.nix
│   ├── README.md   # special bootstrap steps
│   # additional host-specific config (backup, initrd, virt-install, etc.)
# additional hosts
```

## Bootstrap Process

### Local

Format disks.

```bash
nix --extra-experimental-features 'nix-command flakes' \
 run github:nix-community/disko --                     \
 --mode destroy,format,mount                           \
 --flake github:m00wl/nixfiles#<HOSTNAME>
```

Install NixOS.

```bash
nixos-install --flake github:m00wl/nixfiles#<HOSTNAME>
```

Reboot machine.

```bash
reboot
```

<details>

<summary> Optional steps. </summary>

Set password.

```bash
passwd m00wl
```

Set configuration.

```bash
git clone git@github.com:m00wl/nixfiles.git /home/m00wl/nixfiles
ln -s /home/m00wl/nixfiles/flake.nix /etc/nixos/flake.nix
```

</details>

### Remote

Install to a remote host that has little memory:

```bash
nix run github:nix-community/nixos-anywhere -- \
 --no-disko-deps                               \
 --flake github:m00wl/nixfiles#<HOSTNAME>      \
 --target-host root@<IP-ADDRESS>
```
