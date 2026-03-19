{
  programs.ssh = {
    enable = true;
    matchBlocks."*" = { forwardAgent = true; };
    includes = [ "/home/m00wl/.ssh/daberg.config" ];
  };
}
