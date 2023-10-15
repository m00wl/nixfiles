# `nixfiles`

These files contain the configurations for my NixOS systems, as well as other UNIX-based systems running home-manager.

## Structure

The repository has the following structure:

```bash
.
├── hosts       # host configurations (bootstrap, hardware, secrets, etc.).
├── modules     # nixOS modules (mostly host-agnostic).
├── packages    # self-packaged software.
├── users       # user configurations (home configurations, home modules, etc.).
├── flake.nix   # nix flake.
├── flake.lock  # nix flake lock file.
├── LICENSE.md  # license.
└── README.md   # readme.
```

## Dotfiles

The `homeConfigurations` flake output exposes the common denominator of home configurations across my machines. 
It is possible to reuse these user-specific application configurations (aka dotfiles) on other non-NixOS machines.

1. [Install nix](https://nixos.org/download.html).

2. Pick a homeConfiguration (e.g. `cli`) and run the following command:

   ```bash
   nix --extra-experimental-features "nix-command flakes"               \
    run github:nix-community/home-manager --                            \
    --extra-experimental-features "nix-command flakes" switch -b backup \
    --flake github:m00wl/nixfiles#cli
   ```
