{ self, ... }:
{
  # Configure user homes.
  home-manager.users = {
    m00wl.imports = with self.homeModules; [ m00wl cli ];
    zeus.imports = with self.homeModules; [ zeus cli ];
  };
}
