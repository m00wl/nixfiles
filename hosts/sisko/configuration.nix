{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./home.nix
  ];

  # Use systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Configure networking.
  networking = {
    hostName = "sisko";
    networkmanager.enable = true;
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  system.stateVersion = "25.05";

  services.ddclient = {
    enable = true;
    server = "dyndns.strato.com/nic/update";
    username = "lum.me";
    passwordFile = "/root/ddclient/pass";
    usev4 = "webv4, webv4=ipify-ipv4";
    usev6 = "disabled";
    domains = [ "hq.lum.me" ];
    interval = "10min";
  };

  services.fail2ban.enable = true;
}
