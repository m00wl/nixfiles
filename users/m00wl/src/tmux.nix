{ pkgs, config, ... }:

{
  home.sessionVariables = {
    TMUX_ACC_CLR = ''
      $(
        function calc_accent_colour() {
          local hash=$(hostname)
          while :; do
            hash=$(hash_string $hash)
            if ! (( hash == 0 \
                  || (16 <= hash && hash <= 21) \
                  || hash == 52 \
                  || (232 <= hash && hash <= 244) )); \
                  then
              break;
            fi
          done
          echo $hash
        }

        function hash_string() {
          hash_value=$(printf "%s" "$1" \
                      | md5sum \
                      | sed -e 's/[^[:alnum:]]\+//g' \
                      | tr "a-f" "A-F" \
                      )
          echo "$(((0x$hash_value) % 255))" | tr -d "-"
        }

        calc_accent_colour
      )'';
  };

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    #prefix = "C-a";
    shortcut = "a";
    #reverseSplit = true;
    extraConfig = ''
      # enable mouse mode
      set -g mouse on

      # set automatic titles
      set -g set-titles on

      # sync tmux buffer with terminal clipboard
      set -g set-clipboard on

      # renumber windows
      set -g renumber-windows on

      # indicate window activity in status bar
      setw -g monitor-activity on
      # indicate window activity as tmux message
      #set -g visual-activity on

      # update vital ENV variables on reattach
      set -g update-environment "TERM"
      set -g update-environment "SSH_CONNECTION SSH_TTY SSH_ASKPASS"
      set -g update-environment "SSH_AGENT_PID SSH_AUTH_SOCK"
      set -g update-environment "DISPLAY WINDOWID XAUTHORITY"

      # split windows like vim (keep cwd)
      # vim's definition of a horizontal/vertical split is reversed from tmux's
      bind "s" split-window -v -c "#{pane_current_path}"
      bind "v" split-window -h -c "#{pane_current_path}"

      # move around panes with "hjkl"
      bind "h" select-pane -L
      bind "j" select-pane -D
      bind "k" select-pane -U
      bind "l" select-pane -R

      # resize panes like vim
      # feel free to change the "1" to however many lines you want to resize by
      # only one at a time can be slow
      bind -r "<" resize-pane -L 1
      bind -r ">" resize-pane -R 1
      bind -r "-" resize-pane -D 1
      bind -r "+" resize-pane -U 1

      # use "c" to create new window (keep cwd)
      bind "c" new-window -c "#{pane_current_path}"

      # use "C" to create new session (keep cwd)
      bind "C" new-session -c "#{pane_current_path}"

      # switch '"' over to selecting windows
      unbind '"'
      bind '"' choose-window

      # use "'" to switch between sessions
      bind "'" choose-session

      # join pane from the specified window/pane with "prefix+ctrl+j"
      # move pane to the specified window/pane with "prefix+ctrl+m"
      # notation is: window.pane_id
      # display pane_id with prefix+q
      bind "q" display-panes
      bind "C-j" command-prompt -p "Join pane from (w.p):" "join-pane -s '%%'"
      bind "C-m" command-prompt -p "Move pane to (w.p):" "join-pane -t '%%'"

      # confirm before killing window, session or the server
      bind "x" confirm kill-window
      bind "C-x" confirm kill-session
      bind "X" confirm kill-server

      # use vim keybindings in copy mode
      setw -g mode-keys vi
      bind -T copy-mode-vi "v" send-keys -X begin-selection
      bind -T copy-mode-vi "y" send-keys -X copy-selection-and-cancel

      # activate copy mode on mouse scroll
      bind -n WheelUpPane \
          if -Ft= "#{?pane_in_mode,1,#{mouse_button_flag}}" \
              "send-keys -M" \
              "if-shell -Ft= '#{alternate_on}' \
                  'send-keys Up Up Up' \
                  'copy-mode'"

      bind -n WheelDownPane \
          if -Ft= "#{?pane_in_mode,1,#{mouse_button_flag}}" \
              "send-keys -M" \
              "send-keys Down Down Down"

      # use "R" to set correct terminal size
      # super useful when connected over serial
      bind "R" run "echo \"stty columns $(tmux display -p \
        \#{pane_width}); stty rows $(tmux display -p \#{pane_height})\" \
                    | tmux load-buffer - ; tmux paste-buffer"

      # apply theme from TMUX_ACC_CLR
      set -g status-style bg=colour"$TMUX_ACC_CLR"
      set -g message-command-style bg=colour"$TMUX_ACC_CLR"
      set -g message-style bg=colour"$TMUX_ACC_CLR"
      set -g mode-style bg=colour"$TMUX_ACC_CLR"
      set -g pane-active-border-style fg=colour"$TMUX_ACC_CLR"
    '';

  };
}
