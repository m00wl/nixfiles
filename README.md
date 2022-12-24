# NixOS System Configurations

This repository contains my NixOS system configurations.

## Structure

The repository adheres to the following structure:

```bash
.
├── flake.lock  # nix flake.
├── flake.nix   # nix flake lock file.
├── hosts       # host configuration and documentation (system, hardware, bootstrap, etc.).
├── LICENSE.md  # license.
├── modules     # reusable nix expressions (host-agnostic).
├── README.md   # readme.
└── users       # user configuration (home-manager, dotfiles, etc.).
```
