
    set -g mode-style "fg=#7aa2f7,bg=#3b4261"

    set -g message-style "fg=#7aa2f7"
    set -g message-command-style "fg=#7aa2f7"

    set -g pane-border-style "fg=#3b4261"
    set -g pane-active-border-style "fg=#7aa2f7"

    set -g status "on"
    set -g status-justify "left"

    set -g status-style "fg=#7aa2f7"

    set -g status-left-length "100"
    set -g status-right-length "100"

    set -g status-left "#[bold] #S #[nobold,nounderscore,noitalics]"
    set -g status-right "#{prefix_highlight} %Y-%m-%d  %H:%M  #h"

    setw -g window-status-bell-style "fg=#f7768e"
    setw -g window-status-activity-style "fg=#e0af68"
    setw -g window-status-separator ""
    setw -g window-status-format " #I #W #F "
    setw -g window-status-current-format " #[bold]#I #W #F#[nobold] "

    set -g menu-style "fg=#7aa2f7"
    set -g menu-selected-style "fg=#7aa2f7,bg=#3b4261"
    set -g menu-border-style "fg=#3b4261"

    set -g popup-border-style "fg=#7aa2f7"

    set -g copy-mode-match-style "fg=#7aa2f7,bg=#3b4261"
    set -g copy-mode-current-match-style "fg=#15161e,bg=#7aa2f7"

    # tmux-plugins/tmux-prefix-highlight support
    set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=default]"    