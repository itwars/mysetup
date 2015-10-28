# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\ ☢ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\  Ω '
else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\ ☢ '
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\ \[\033[01;32m\]Ω \[\033[0m\]'
 fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export TERM=screen-256color

# some more ls aliases
alias ll='ls -GFalh'
alias la='ls -A'
alias l='ls -CF'
alias jekyllold='/var/lib/gems/1.9.1/gems/jekyll-0.12.1/bin/jekyll'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export EDITOR=nvim
export TERM=xterm
export LESS="-RS#3NM~g"
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias vi='/usr/bin/nvim'
alias pro='cd ~/Documents/projects'
alias UP='sudo apt-get update;sudo apt-get dist-upgrade'
alias c='chromium-browser > /dev/null 2>&1'
alias scpr='rsync --rsh=ssh -av --progress --partial'
alias web='sudo python -m SimpleHTTPServer 80'
alias vup='vagrant up'
alias vssh='vagrant ssh'
alias vha='vagrant halt'
alias umountdcard='diskutil unmountDisk /dev/disk1'
alias listdisk='diskutil list'
alias subl='/Applications/Sublime\ Text.app/Contents/MacOS/Sublime\ Text'


. ~/z.sh

# Test de completion GEM
alias gemdir='gem env gemdir'
function _gem_list {
  COMPREPLY=($(compgen -W "$(ls `gemdir`/gems)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
function cdgem {
  cd `gemdir`/gems
  cd `ls | grep $1 | sort | tail -1`
}
complete -F _gem_list cdgem

#complete -o default -W "$(ls ~/Documents/projects)" pp

shopt -s no_empty_cmd_completion
###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if complete &>/dev/null; then
  _npm_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _npm_completion npm
elif compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

export PATH=$PATH:~/scripts:/Users/vrabah/gocode/bin/
export PATH=/usr/local/sbin:$PATH

#export PROMPT_COMMAND='echo -ne "\033]2;${USER}@${HOSTNAME}: ${PWD}\007\033k${USER}@${HOSTNAME}\033\\"'
settitle() {
    printf "\033k$1\033\\"
}
ssh() {
    settitle "$*"
    command ssh "$@"
    settitle "bash"
}

mp3() { 
   youtube-dl $1 --extract-audio --title --audio-format mp3 --audio-quality 0 
}

# npm node without sudo
NPM_PACKAGES="~/.npm-packages"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export PATH=$PATH:$NPM_PACKAGES/bin
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

export TERM=xterm-256color

if [ "$PS1" != "" -a "${STARTED_TMUX:-x}" = x -a "${SSH_TTY:-x}" != x ]
then
    STARTED_TMUX=1; export STARTED_TMUX
    sleep 1
    ( (tmux -2 has-session -t remote && tmux -2 attach-session -t remote) || (tmux -2 new-session -s remote) ) && exit 0
        echo "tmux failed to start"
    fi

export PATH=/usr/local/bin:$PATH:/usr/texbin
export HOMEBREWCASKOPTS="--appdir=/Applications"


alias irc='weechat irc://itwars@irc.freenode.net/#node.js,#go-nuts'

export GOPATH=/Users/vrabah/gocode/
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#   if [ $1 = 'up' ]; then
#      bUpdate=$(command brew update)
#      if [ "$bUpdate" != "Already up-to-date." ]; then
#         caskList=( $(brew cask list) )
#         caskUpdate=()
#         for i in "${caskList[@]}"; do
#            info=( $(brew cask info $i) )
#            if [[ " ${info[*]} " == *"Not installed"* ]]; then
#               cask += ${info[0]%?}
#            fi
#         done
#         echo ${info[*]}
#      else
#         echo $bUpdate
#         echo 'Brew has nothing to update.'
#      fi
#   else
#      command brew $1
#   fi
#}
