{
  programs.ssh = {
    enable = true;
    # TODO: remove once default:
    enableDefaultConfig = false;
    settings."*" = {
      ForwardAgent = true;
    };
  };
}
