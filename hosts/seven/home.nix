{ self, ... }:
{
  # Configure user homes.
  home-manager.users.m00wl.imports = builtins.attrValues {
    inherit (self.homeModules) m00wl cli;
  };
}
