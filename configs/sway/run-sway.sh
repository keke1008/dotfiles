#!/usr/bin/sh
# Use in /usr/share/wayland-sessions/sway.desktop

export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx

# https://qiita.com/aratetsu_sp2/items/6bd89e5959ba54ede391#fn-2
export GTK_IM_MODULE=fcitx

exec sway
