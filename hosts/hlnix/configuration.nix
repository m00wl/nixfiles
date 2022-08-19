{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/core.nix
      ../../modules/src/rpi.nix
      ../../modules/src/wifi.nix
    ];

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = false;
    raspberryPi = {
      enable = true;
      version = 4;
      #firmwareConfig = ''
      #
      #'';
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  networking = {
    hostName = "hlnix";
    hostId = "795a8675";
    wireless = {
      networks."@SSID_DEV@".psk = "@PSK_DEV@";
      networks."@SSID_HOME@".psk = "@PSK_HOME@";
      networks."@SSID_WG@".psk = "@PSK_WG@";
    };
  };

  system.stateVersion = "22.05";
}

