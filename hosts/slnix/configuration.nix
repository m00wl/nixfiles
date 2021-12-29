{ config, pkgs, ... }:

{
  # Enable flakes support
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable zfs support
  boot.supportedFilesystems = [ "zfs" ];

  # Define hostname
  networking.hostName = "slnix";
  networking.hostId = "75875b34";

  # Set time zone
  time.timeZone = "Europe/Amsterdam";

  # Enable DHCP 
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Create user account 
  users.users.ml = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # Enable zfs services
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  system.stateVersion = "21.11";
}
