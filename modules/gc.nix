{ config, pkgs, ...}:

{
  # Setup periodic garbage collection
  nix.gc {
    automatic = true;
    dates = "weekly";
  };
}
