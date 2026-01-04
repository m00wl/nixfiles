{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Moritz Lumme";
        email = "46034439+m00wl@users.noreply.github.com";
      };
      core = {
        editor = "vim";
      };
      color = {
        ui = "auto";
      };
      init = {
        defaultBranch = "main";
      };
      diff = {
        tool = "vim -d";
      };
      merge = {
        tool = "vim -d";
      };
    };
  };
}

