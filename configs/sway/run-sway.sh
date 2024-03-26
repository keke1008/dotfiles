#!/usr/bin/sh
# Use in /usr/share/wayland-sessions/sway.desktop

export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=wayland
export QT_IM_MODULE=fcitx

fcitx5 -d

exec sway
