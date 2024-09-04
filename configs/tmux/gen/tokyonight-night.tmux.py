#!/usr/bin/env python3

from pathlib import Path


def config() -> str:
    default = "default"
    red = "#f7768e"
    blue = "#7aa2f7"
    blue_dark = "#3b4261"
    yellow = "#e0af68"
    black = "#15161e"
    nodecorator = "nobold,nounderscore,noitalics"
    sep_left = ""
    sep_right = ""

    return f"""
    set -g mode-style "fg={blue},bg={blue_dark}"

    set -g message-style "fg={blue}"
    set -g message-command-style "fg={blue}"

    set -g pane-border-style "fg={blue_dark}"
    set -g pane-active-border-style "fg={blue}"

    set -g status "on"
    set -g status-justify "left"

    set -g status-style "fg={blue}"

    set -g status-left-length "100"
    set -g status-right-length "100"

    set -g status-left "#[bold] #S #[{nodecorator}]{sep_left}"
    set -g status-right "#{{prefix_highlight}} %Y-%m-%d {sep_right} %H:%M {sep_right} #h"

    setw -g window-status-bell-style "fg={red}"
    setw -g window-status-activity-style "fg={yellow}"
    setw -g window-status-separator "{sep_left}"
    setw -g window-status-format " #I #W #F "
    setw -g window-status-current-format " #[bold]#I #W #F#[nobold] "

    set -g menu-style "fg={blue}"
    set -g menu-selected-style "fg={blue},bg={blue_dark}"
    set -g menu-border-style "fg={blue_dark}"

    set -g popup-border-style "fg={blue}"

    set -g copy-mode-match-style "fg={blue},bg={blue_dark}"
    set -g copy-mode-current-match-style "fg={black},bg={blue}"

    # tmux-plugins/tmux-prefix-highlight support
    set -g @prefix_highlight_output_prefix "#[fg={yellow}]#[bg={default}]"\
    """


if __name__ == "__main__":
    c = config()

    dest = Path(__file__).resolve().parent.parent / "tokyonight-night.tmux"

    with open(dest, "w") as f:
        f.write(c)
