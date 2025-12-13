{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./home.nix
  ];

  # Use systemd-boot EFI boot loader.
  boot = {
    kernelParams = [
      "vga=0x317"
      "nomodeset"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      };
  };

  # Configure networking.
  networking = {
    hostName = "troi";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 8000 ];
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  services = {
    qemuGuest.enable = true;
    vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
      config = {
        DOMAIN = "https://vw.lum.me";
        SIGNUPS_ALLOWED = false;
        #ROCKET_ADDRESS = "::1";
        #ROCKET_PORT = 8000;
      };
    };
  };

  system.stateVersion = "25.05";
}
