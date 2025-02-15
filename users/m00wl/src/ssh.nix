{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    includes = [ "/home/m00wl/.ssh/home.config" ];
  };
}
