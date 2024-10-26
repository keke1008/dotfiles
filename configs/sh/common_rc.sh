# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

check_command_exists() {
	command -v "$1" >/dev/null
}

alias_if_exists() {
	if check_command_exists "$1"; then
		alias "$2"="${3:-1}"
	fi
}

alias_if_exists_or_else() {
	if check_command_exists "$1"; then
		alias "$2"="$3"
	else
		alias "$2"="$4"
	fi
}

unset_all() {
	unset -f \
		check_command_exists \
		alias_if_exists \
		alias_if_exists_or_else \
		unset_all
}

if check_command_exists tmux && [ -z "$TMUX" ]; then
	tmux new-session -A
fi

if [ -z "$DISABLE_EXEC_SHELL" ] && check_command_exists fish; then
	exec fish
fi

alias l="ls"
alias v='${EDITOR}'
alias g='git'
alias c='cargo'
alias d='docker'
alias dc='docker compose'
alias kc='kubectl'
alias be='bundle exec'
alias bi='bundle install'
alias tf='terraform'
alias grep='grep --color=auto'

alias_if_exists_or_else exa ls "exa" "ls --color=auto"
alias_if_exists_or_else exa ll "exa -lh" "ls -lh"
alias_if_exists_or_else exa la "exa -a" "ls -A"

alias_if_exists bat cat
alias_if_exists batcat cat
alias_if_exists_or_else trash-put rm "trash-put" "rm -i"

alias "..."="cd ../.."
alias "...."="cd ../../.."
alias "....."="cd ../../../.."

unset_all

local_rc="${DOTFILES_LOCAL_HOME}/sh/local_rc.sh"
if [ -r "$local_rc" ]; then
	. "$local_rc"
fi
