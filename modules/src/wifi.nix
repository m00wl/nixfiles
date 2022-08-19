{ config, pkgs, ... }:

{
  sops.secrets."wifi/wireless.env" = {};

  networking.networkmanager.enable = false;
  networking.wireless = {
    enable = true;
    environmentFile = "/run/secrets/wifi/wireless.env";
  };

  # Configure wifi networks that should be available via:
  # networking.wireless.networks
  # Access secrets from the environment file with "@ENV_VAR@"
}
