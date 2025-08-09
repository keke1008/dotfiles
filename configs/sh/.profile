# Avoid recursive loading
if [ -n "${DOTFILES_ORIGINAL_LOADING:-}" ]; then
	return 0
fi

# Bootstrapping
if [ -z "${DOTPATH:-}" ]; then
	if [ -r "$HOME/.dotpath" ] && DOTPATH=$(cat "$HOME/.dotpath"); then
		eval "$("${DOTPATH}/dot" shellenv)"
	else
		echo "Error: Failed to get DOTPATH" >&2
		return 1
	fi
fi

# Load original profile if exists
if [ -r "${DOTFILES_ORIGINAL_HOME}/sh/.profile" ]; then
	DOTFILES_ORIGINAL_LOADING=1 . "${DOTFILES_ORIGINAL_HOME}/sh/.profile"
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

export ENV="${HOME}/.shrc"
. "${DOTFILES_CONFIG_HOME}/sh/tokyonight_night.sh"

for EDITOR in "nvim" "vim" "vi"; do
	if command -v "$EDITOR" >/dev/null; then
		break
	fi
done
export EDITOR="${EDITOR:-vim}"

# if running on WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
	if command -v "wslg.exe" >/dev/null; then
		export DISPLAY=":0"
	elif DISPLAY="$(hostname).mshome.net:0.0"; then
		export DISPLAY
	fi
fi

prepend_path() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*) export PATH="$1${PATH:+:$PATH}" ;;
	esac
}

prepend_path_if_exists() {
	if [ -d "$1" ]; then
		prepend_path "$1"
	fi
}

prepend_path_if_exists "/snap/bin"
prepend_path_if_exists "$HOME/.fly/bin" # fly.io
prepend_path_if_exists "$HOME/.luarocks/bin"
prepend_path_if_exists "$HOME/.tfenv/bin"
prepend_path_if_exists "$HOME/.deno/bin"
prepend_path_if_exists "$HOME/.cargo/bin"
prepend_path_if_exists "$HOME/.claude/local"

prepend_path_if_exists "$HOME/.go/bin"
export GOPATH="$HOME/.go"

export ASDF_GOLANG_MOD_VERSION_ENABLED=true
prepend_path_if_exists "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"

if [ -x "/opt/homebrew/bin/brew" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export AQUA_GLOBAL_CONFIG="${XDG_CONFIG_HOME}/aquaproj-aqua/aqua.yaml"
export AQUA_ROOT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua"
prepend_path_if_exists "${AQUA_ROOT_DIR}/bin"

if [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
	. "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

mkdir -p "$HOME/.local/bin"
prepend_path "$HOME/.local/bin"
prepend_path "$DOTPATH/bin"

# Source local profile
if [ -r "${DOTFILES_LOCAL_HOME}/sh/.profile" ]; then
	. "${DOTFILES_LOCAL_HOME}/sh/.profile"
fi
