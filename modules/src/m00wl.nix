{ config, ... }:
{
  # Create 'm00wl' user account.
  users.users.m00wl = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/9QLlB+fy5eSjqEQvIznnPxZETamnnKLWBoXpZeLLG me@moritz.lumme.de"
    ];
  };
}
