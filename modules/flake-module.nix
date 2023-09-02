{ self, ... }:
{
  flake.nixosModules = {
    default = self.nixosModules.base;
    base = { imports = [ ./base.nix ]; };
    gui = { imports = [ ./gui.nix ]; };
  };
}
