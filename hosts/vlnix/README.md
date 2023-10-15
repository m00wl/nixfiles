# Bootstrap Process

Format disk.

```bash
nix --extra-experimental-features 'nix-command flakes' \
 run github:nix-community/disko --                     \
 --mode disko                                          \
 --flake github:m00wl/nixfiles#<HOSTNAME>
```

Install NixOS.

```bash
nixos-install --flake github:m00wl/nixfiles#<HOSTNAME>
```

Set user password.

```bash
passwd m00wl
```

Reboot machine.

```bash
reboot
```

