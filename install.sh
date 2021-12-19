#!/bin/bash

# save the absolute path to this repository
DOTPATH=$(cd $(dirname $0); pwd)
echo "$DOTPATH" > $HOME/.dotpath


# link files
create_link() {
  from_dir=$1
  to_dir=$2
  ls -A1 $from_dir | xargs -I {} ln -snfv $from_dir/{} $to_dir
}
create_link $DOTPATH/home $HOME
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
create_link $DOTPATH/xdg_config_home $XDG_CONFIG_HOME


# download in lib
mkdir -p $DOTPATH/lib/autoload

# download git-prompt.sh (__git_ps1)
GIT_PROMPT_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
curl -o $DOTPATH/lib/autoload/git-prompt.sh $GIT_PROMPT_URL

# download git-completion.bash
GIT_COMPLETION_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash"
curl -o $DOTPATH/lib/autoload/git-completion.bash $GIT_COMPLETION_URL
