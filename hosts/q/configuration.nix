{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./home.nix
    ./initrd.nix
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
    bridges.br0.interfaces = [ "eno1" ];
    interfaces = {
      br0 = {
        virtual = true;
        useDHCP = true;
      };
      eno1.useDHCP = true;
    };
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
    vim
    wget
    virt-manager;
  };

  system.stateVersion = "25.05";

  hardware.ksm.enable = true;

  # UEFI firmware support in libvirt.
  systemd.tmpfiles.rules = [
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
  ];

  services.thermald.enable = true;
}
