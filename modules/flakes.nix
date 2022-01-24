{ config, pkgs, ... }:

{
  # Enable flakes support
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
