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
    hostName = "queen";
    useDHCP = false;
    dhcpcd.enable = false;
    domain = "lum.me";
    enableIPv6 = false;
    vlans = {
      vlan11 = {
        id = 11;
        interface = "enp2s0";
      };
    };
    interfaces.vlan11.ipv4.addresses = [
      { address = "192.168.11.20"; prefixLength = 24; }
    ];
    defaultGateway = "192.168.11.1";
    nameservers = [
      "192.168.11.1"
    ];
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  powerManagement.powertop.enable = true;

  services = {
    fail2ban.enable = true;
    borgbackup.repos = {
      data = {
        path = "/var/lib/borgbackup/data";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFu/ue4b5j+1wi7ksbWda3WbL18OuhG3HpPMwLtwEbuR borg-nextcloud@queen"
        ];
      };
      troi = {
        path = "/var/lib/borgbackup/troi";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUeIQXawOwH1++jF4047eIr/XnKUrO1lHR8hKH0e7QG borg-vaultwarden@queen"
        ];
      };
    };
  };

  nix = {
    gc.options = "--delete-older-than 32d";
    optimise = {
      automatic = true;
      dates = "Tue 05:30";
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "Tue 05:00";
      flake = "github:m00wl/nixfiles";
      randomizedDelaySec = "900";
      runGarbageCollection = true;
    };
    stateVersion = "26.05";
  };
}
