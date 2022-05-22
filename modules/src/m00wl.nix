{ config, pkgs, ... }:

{
  # Create m00wl user account 
  users.users.m00wl = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/9QLlB+fy5eSjqEQvIznnPxZETamnnKLWBoXpZeLLG me@moritz.lumme.de"
    ];
  };

  sops.secrets."openssh.service/home.lumme.de" = {
    owner = config.users.users.m00wl.name;
    group = config.users.users.m00wl.group;
  };
  sops.secrets."openssh.service/git.lumme.de" = {
    owner = config.users.users.m00wl.name;
    group = config.users.users.m00wl.group;
  };
}
