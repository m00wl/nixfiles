{
  # Configure home-manager settings.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Configure user homes with:
  # home-manager.users.<username>.imports = [ self.homeModules.<module> ];
}
