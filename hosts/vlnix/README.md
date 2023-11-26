# Bootstrap Process

Format disks.

```bash
nix --extra-experimental-features 'nix-command flakes' \
 run github:nix-community/disko --                     \
 --mode disko                                          \
 --flake github:m00wl/nixfiles#<HOSTNAME>
```

Generate keys.

```bash
mkdir -p /mnt/etc/secrets/initrd
ssh-keygen -t ed25519 -N "" -f /mnt/etc/secrets/initrd/ssh_host_ed25519_key
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

