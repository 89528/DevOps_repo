#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

export HOMEBREW_NO_ANALYTICS=1
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export GPG_TTY=$(tty)
export EDITOR=vim

if [[ -s "${ZDOTDIR:-$HOME}/.bash_aliases" ]]; then
  # shellcheck source=./bash_aliases.sh
  source "${ZDOTDIR:-$HOME}/.bash_aliases"
fi
