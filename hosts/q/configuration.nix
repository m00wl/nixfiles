{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./home.nix
    #./initrd.nix
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

  # UEFI firmware support in libvirt.
  systemd.tmpfiles.rules = [
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
  ];

  system.stateVersion = "25.05";

  services.thermald.enable = true;
}
