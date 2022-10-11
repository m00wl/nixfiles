# Transitory Machine for SD-Images

This is a placeholder configuration from which images can be build.

The `configuration.nix` is filled with a useful set of presets that can be altered to the specific image's needs.
Note that the main focus here is on cross-compilation.

Configure the image with targets from `nixos-generators` and build it with the output `images.<target>` of the top-level flake, e.g.:

```bash
nix build .#images.install-iso
```
