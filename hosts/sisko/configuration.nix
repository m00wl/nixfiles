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
    interfaces.eno1 = {
      ipv4.addresses = [
        {
          address = "192.168.0.2";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.0.1";
      interface = "eno1";
    };
    nameservers = [ "192.168.0.1" ];

    firewall.allowedTCPPorts = [ 53 ];
    firewall.allowedUDPPorts = [ 53 67 ];
  };

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile.
  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim wget; };

  system.stateVersion = "25.05";

  services = {
    thermald.enable = true;
    fail2ban.enable = true;
    ddclient = {
      enable = true;
      server = "dyndns.strato.com/nic/update";
      username = "lum.me";
      passwordFile = "/root/ddclient/pass";
      usev4 = "webv4, webv4=ipify-ipv4";
      usev6 = "disabled";
      domains = [ "hq.lum.me" ];
      interval = "10min";
    };
    dnsmasq = {
      enable = true;
      settings = {
        dhcp-range = [ "192.168.0.100,192.168.0.200,8d" ];
        dhcp-option= [ "option:router,192.168.0.1" ];
        expand-hosts = true;
        domain = "home.lum.me";
        no-hosts = true;
        domain-needed = true;
        local = [ "/home.lum.me/" ];
        address = [ "/sisko.home.lum.me/192.168.0.2" ];
      };
    };
  };
}
