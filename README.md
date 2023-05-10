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
