set -g @default     "default"
set -g @red         "#f7768e"
set -g @blue        "#7aa2f7"
set -g @blue_dark   "#3b4261"
set -g @yellow      "#e0af68"
set -g @black       "#15161e"
set -g @nodecorator "nobold,nounderscore,noitalics"


set -g mode-style "fg=#{@blue},bg=#{@blue_dark}"

set -g message-style "fg=#{@blue}"
set -g message-command-style "fg=#{@blue}"

set -g pane-border-style "fg=#{@blue_dark}"
set -g pane-active-border-style "fg=#{@blue}"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=#{@blue},bg=#{@default}"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left "#[bold] #S #[#{@nodecorator}]"
set -g status-right "#{prefix_highlight} %Y-%m-%d  %H:%M  #h"

setw -g window-status-current-style "fg=#{@blue},bg=#{@default}"
setw -g window-status-bell-style "fg=#{@red}"
setw -g window-status-activity-style "fg=#{@yellow}"
setw -g window-status-separator ""
setw -g window-status-format " #I #W #F "
setw -g window-status-current-format " #[bold]#I #W #F#[nobold] "
 
set -g menu-style "fg=#{@blue}"
set -g menu-selected-style "fg=#{@blue},bg=#{@blue_dark}"
set -g menu-border-style "fg=#{@blue}"

set -g popup-border-style "fg=#{@blue}"

set -g copy-mode-match-style "fg=#{@blue},bg=#{@blue_dark}"
set -g copy-mode-current-match-style "fg=#{@black},bg=#{@blue}"

set -g @prefix_highlight_output_prefix "#[fg=#{@yellow}]#[bg=#{@default}]"
set -g @prefix_highlight_prefix_prompt 'PREFIX'
