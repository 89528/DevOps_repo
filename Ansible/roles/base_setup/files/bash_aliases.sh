export HOMEBREW_NO_ANALYTICS=1

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

alias man="PAGER=most man"

# user
# https://unix.stackexchange.com/questions/652097/how-to-switch-systemd-user-shell-on-remote-server-without-logging-in-again-via-s
alias switch_to_user="sudo machinectl shell --uid"
alias app_user="switch_to_user app"
alias user_app="app_user"
alias app="app_user"

# file navigation
alias ..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias 2..="cd ../.."
alias 3..="cd ../../.."
alias 4..="cd ../../../.."
alias 5..="cd ../../../.."
alias 'cd-'="cd -"

# misspellings
alias dri=dir
alias dior=dir
alias du="du -kh"
alias shs="ssh"
alias mkdit="mkdir"
alias vmi="vim"
alias pstree="pstree -Uul"
alias df="df -kTh"
alias sudi=sudo
alias sido=sudo
alias aptitide=aptitude
alias less="less -R"
alias grep='GREP_COLOR="1;37;41" LANG=C grep --color=auto -n'
alias bat=batcat

# ls
alias sl="ls"
alias ll='ls -alFh'
alias la='ls -A'
alias ks="ls"
alias l='ls -CF'
alias s='ls -CF'
alias ös='ls'
alias lös='ls'
alias lh="ls -lha"

# Git
alias gti="git"
alias gut="git"
alias gtu="git"
alias igt="git"
alias egit="git"
alias gir="git"
alias gt="git"
alias gi="git"
alias ggit="git"
alias got="git"
alias giot="git"
alias goit="git"
alias giit="git"
alias gtit="git"
alias ögti="git"
alias gitz="git"
alias guit="git"
alias gitr="git"
alias tgit="git"
alias tgti="git"
alias gtis="git"
alias gtt="git"
alias it="git"
alias tgi="git"
alias gitbr="git branch"
alias dit="git"
alias giti="git"
alias 'ǵit'="git"
alias ',git'="git"
alias 'g9t'="git"
alias 'giut'="git"
alias 'ghit'="git"
alias 'gits'="git"
alias 'hiy'="git"
alias undo_git_commit="git reset HEAD^1"
alias commit="git commit"
alias st="git status"
alias gitst="git status"
alias ögit="git"
alias gigit="git"
alias gitco="git co"
alias fir=git
alias ig=git
alias fgit=git
alias gu="git"
alias gto="git"
alias such=git
alias very=git
alias wow='git status'
alias gtui=git

if [[ -s "${ZDOTDIR:-$HOME}/.app_bash_aliases" ]]; then
  # shellcheck source=./app_bash_aliases.sh
  source "${ZDOTDIR:-$HOME}/.app_bash_aliases"
fi
