# NixOS System Configurations

This repository contains my NixOS system configurations.

## Structure

The repository adheres to the following structure:

- `hosts/`: system/hardware configuration + bootstrap process for each machine

- `users/`: home-manager configuration + dotfiles for each user

- `modules/`: modular, reusable nix expressions

- `flake.nix`: top-level nix flake containing system configurations

- `flake.lock`: lock file of top-level nix flake
