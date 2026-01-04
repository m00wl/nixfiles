{
  programs.ssh = {
    enable = true;
    matchBlocks."*" = { forwardAgent = true; };
  };
}
