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

  # Use systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable zfs support
  boot.supportedFilesystems = [ "zfs" ];

  # Define hostname.
  networking.hostName = "vlnix";
  networking.hostId = "65809531";

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # Enable DHCP
  networking.interfaces.enp0s3.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable X11 server + gdm + gnome
  services.xserver = {
    enable = true;
    layout = "de";
    libinput.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Create user account
  users.users.m00wl = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Enable OpenSSH daemon.
  services.openssh.enable = true;

  # Enable zfs services
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  system.stateVersion = "21.11";
}
