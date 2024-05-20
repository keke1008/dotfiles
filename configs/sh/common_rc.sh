# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

if command -v "tmux" >/dev/null && [ -z "$TMUX" ]; then
	tmux
fi

if command -v "fish" >/dev/null; then
	exec fish
fi

alias v='${EDITOR}'
alias g='git'
alias c='cargo'
alias d='docker'
alias dc='docker compose'
alias kc='kubectl'
alias be='bundle exec'
alias bi='bundle install'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if ! command -v "vim" >/dev/null 2>&1; then
	alias vim='vi'
fi
if command -v "bat" >/dev/null; then
	alias cat="bat"
elif command -v "batcat" >/dev/null; then
	alias cat="batcat"
fi
if command -v "trash-put" >/dev/null; then
	alias rm="trash-put"
else
	alias rm="rm -i"
fi

dots=".."
cd_command="cd .."
for _ in $(seq 1 9); do
	dots="$dots."
	cd_command="$cd_command/.."
	# shellcheck disable=SC2139
	alias "$dots"="$cd_command"
done

local_rc="${DOTFILES_LOCAL_HOME}/sh/local_rc.sh"
if [ -r "$local_rc" ]; then
	. "$local_rc"
fi
