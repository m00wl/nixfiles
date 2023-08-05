# NixOS System Configurations

This repository contains my NixOS system configurations.

## Structure

The repository adheres to the following structure:

```bash
.
├── hosts       # host configurations (system, hardware, bootstrap, etc.).
├── modules     # reusable nix expressions (mostly host-agnostic).
├── packages    # self-packaged software.
├── users       # user configuration (home-manager, dotfiles, etc.).
├── flake.nix   # nix flake.
├── flake.lock  # nix flake lock file.
├── LICENSE.md  # license.
└── README.md   # readme.
```

## Dotfiles

It is possible to reuse the user-specific application configuration in this repository on other non-NixOS machines.
To this end, this flake exposes `cli` and `gui` homeConfigurations in its outputs.

1. [Install nix](https://nixos.org/download.html).

2. Pick a homeConfiguration (e.g. `cli`) and run the following command:

   ```bash
   nix --extra-experimental-features "nix-command flakes" run           \
    github:nix-community/home-manager --                                \
    --extra-experimental-features "nix-command flakes" switch -b backup \
    --flake github:m00wl/nixos-config#cli
   ```
