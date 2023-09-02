# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home-configuration.nix
    ./openvz.nix
    ./backup.nix
  ];

  networking.hostName = "blnix";

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  networking.useNetworkd = true;
  systemd.network.networks.venet0 = {
    name = "venet0";
    address = [ "85.214.58.198/32" ];
    networkConfig = {
      DHCP = "no";
      DefaultRouteOnDevice = "yes";
      ConfigureWithoutCarrier = "yes";
    };
  };
  services.resolved.enable = false;
  networking.resolvconf.extraConfig = ''
    prepend_nameservers="8.8.8.8"
  '';

  system.stateVersion = "22.05";
}

