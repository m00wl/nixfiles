{
  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" ];
    initExtra = ''
      # vi-style line editing interface.
      set -o vi

      # display vi-mode in front of prompt.
      bind 'set show-mode-in-prompt on'
      if [ "$TERM" != "dumb" ]; then
        bind 'set vi-cmd-mode-string "\1\e[1;31m\2:\1\e[0m\2"'
        bind 'set vi-ins-mode-string "\1\e[1;32m\2+\1\e[0m\2"'
      fi
    '';
  };
}
