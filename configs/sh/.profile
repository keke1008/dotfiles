# Bootstrap
if [ -r "$HOME/.dotpath" ] && DOTPATH=$(cat "$HOME/.dotpath"); then
	export DOTPATH
else
	echo "Error: Failed to get DOTPATH" >&2
	return 1
fi
eval "$("${DOTPATH}/dot" shellenv)"

# Avoid recursive loading
if [ -n "${DOTFILES_DOT_PROFILE_LOADING:-}" ]; then
	return 0
fi

# Load original profile if exists
if [ -r "${DOTFILES_ORIGINAL_HOME}/sh/.profile" ]; then
	export DOTFILES_DOT_PROFILE_LOADING=1
	. "${DOTFILES_ORIGINAL_HOME}/sh/.profile"
	unset DOTFILES_DOT_PROFILE_LOADING
fi

if GPG_TTY=$(tty); then
	export GPG_TTY
fi
export XMODIFIERS=@im=fcitx
# https://qiita.com/aratetsu_sp2/items/6bd89e5959ba54ede391
export GTK_IM_MODULE=fcitx
export GTK_THEME=Adwaita:dark
export QT_IM_MODULE=fcitx
export QT_QPA_PLATFORMTHEME=qt5ct

# https://www.electronjs.org/docs/latest/api/environment-variables#electron_ozone_platform_hint-linux
# Selects the preferred platform backend used on Linux. The default one is x11. auto selects Wayland if possible, X11 otherwise.
export ELECTRON_OZONE_PLATFORM_HINT=auto

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

append_path "$DOTPATH/bin"
mkdir -p "$HOME/.local/bin"
append_path "$HOME/.local/bin"
append_path_if_exists "$HOME/.cargo/bin"
append_path_if_exists "$HOME/.deno/bin"
append_path_if_exists "$HOME/.luarocks/bin"
append_path_if_exists "$HOME/.go/bin"
append_path_if_exists "$HOME/.tfenv/bin"
append_path_if_exists "$HOME/.fly/bin" # fly.io
append_path_if_exists "/snap/bin"

export GOPATH="$HOME/.go"

export ASDF_GOLANG_MOD_VERSION_ENABLED=true
if [ -r "$HOME/.asdf/asdf.sh" ]; then
	. "$HOME/.asdf/asdf.sh"
elif [ -r "/opt/asdf-vm/asdf.sh" ]; then # installed by pacman
	. "/opt/asdf-vm/asdf.sh"
fi

if [ -x "/opt/homebrew/bin/brew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Editor
if command -v "nvim" >/dev/null; then
	export EDITOR="nvim"
else
	export EDITOR="vim"
fi

# if running on WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
	append_path "$DOTPATH/bin/wsl/"

	if command -v "wslg.exe" >/dev/null; then
		export DISPLAY=":0"
	else
		if DISPLAY="$(hostname).mshome.net:0.0"; then
			export DISPLAY
		fi
	fi
fi

# Source local profile
LOCAL_PROFILE="${DOTFILES_LOCAL_HOME}/sh/local_profile.sh"
if [ -r "$LOCAL_PROFILE" ]; then
	. "$LOCAL_PROFILE"
fi
