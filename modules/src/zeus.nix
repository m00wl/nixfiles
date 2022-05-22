{ config, pkgs, ... }:

{
  # Create zeus user account
  users.users.zeus = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8XiwX7LarmKUVpd/ZuyGLX5H4gHzj8dVXyPdtT2n7D tl (EdDSA)"
    ];
  };
}
