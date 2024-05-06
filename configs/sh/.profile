if [ -r "$HOME/.dotpath" ]; then
	export DOTPATH=$(cat "$HOME/.dotpath")
fi

export GPG_TTY=$(tty)
export XDG_CONFIG_HOME="$HOME/.config"
export GTK_THEME=Adwaita:dark
export QT_QPA_PLATFORMTHEME=qt5ct

append_path() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*)
		export PATH="${PATH:+$PATH:}$1"
		;;
	esac
}

append_path_if_exists() {
    if [ -d "$1" ]; then
        append_path "$1"
    fi
}

if [ ! -d "$HOME/.local/bin" ]; then
    mkdir -p "$HOME/.local/bin"
fi
append_path "$HOME/.local/bin"
append_path_if_exists "$HOME/.cargo/bin"
append_path_if_exists "$HOME/.deno/bin"
append_path_if_exists "$HOME/.luarocks/bin"
append_path_if_exists "$HOME/.go/bin"
append_path_if_exists "$HOME/.fly/bin" # fly.io
append_path_if_exists "/snap/bin"

export GOPATH="$HOME/.go"

export ASDF_GOLANG_MOD_VERSION_ENABLED=true
if [ -r "$HOME/.asdf/asdf.sh" ]; then
    . "$HOME/.asdf/asdf.sh"
elif [ -r "/opt/asdf-vm/asdf.sh" ]; then # installed by pacman
    . "/opt/asdf-vm/asdf.sh"
fi

# Editor
if command -v "nvim" > /dev/null; then
    export EDITOR="nvim"
else
    export EDITOR="vim"
fi

 # if running on WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    append_path "$DOTPATH/bin/wsl/"

    if command -v "wslg.exe" > /dev/null; then
        export DISPLAY=":0"
    else
        export DISPLAY="$(hostname).mshome.net:0.0"
    fi
fi

# Source local profile
LOCAL_PROFILE="$DOTPATH/configs/sh/local.sh"
if [ -r "$LOCAL_PROFILE" ]; then
    . "$LOCAL_PROFILE"
fi
