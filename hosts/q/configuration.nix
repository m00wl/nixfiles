{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./home.nix
    ../../modules/src/libvirtd.nix
  ];

  # Use systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Configure networking.
  networking = {
    hostName = "q";
    networkmanager.enable = true;
    bridges.br0.interfaces = [ "enp0s3" ];
    interfaces = {
      br0 = {
        virtual = true;
        useDHCP = true;
      };
      enp0s3.useDHCP = true;
    };
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    virt-manager
  ];

  hardware.ksm.enable = true;

  system.stateVersion = "24.11";
}
