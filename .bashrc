
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
    xterm-color|*-256color) color_prompt=yes;;
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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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

##############################
###### FROM HERE CUSTOM ######
##############################

# Add env var for aws-vault
export AWS_VAULT_BACKEND="pass"

# This will make the aws-vault work
export GPG_TTY=$(tty)

# Reload bashrc setting
alias bash::reload='source ~/.bashrc && echo done'

# Alias npm
alias npmr='npm run'

# Aliases folders
alias cd::projects='cd /home/simone/lecab/projects/'
alias cd::webservice='cd /home/simone/lecab/projects/webservice/'
alias cd::cabcom='cd /home/simone/lecab/projects/cabcom/'
alias cd::id='cd /home/simone/lecab/projects/id/'
alias cd::privapi='cd /home/simone/lecab/projects/privapi'

# Aliases aws
alias aws::prod='aws-vault exec spanebianco --duration 6h'
alias aws::staging='aws-vault exec spanebianco-staging --duration 6h'
alias aws::artifact='aws codeartifact login --tool npm --domain snapcar --domain-owner 381841675619 --repository lecab'

# Aliases tunnels
alias tunnel::mysql='ssh -fNL 3307:data-rds-api.le.cab:3306 spanebianco@gw.le.cab'
alias tunnel::mysql::temp='ssh -fNL 3308:lestaging.cdj6dh21azlb.eu-west-1.rds.amazonaws.com:3306 spanebianco@gw.le.cab'
alias tunnel::id::mysql::production='ssh -fNL 3310:id-clone.cnojkoxc94tb.eu-west-1.rds.amazonaws.com:3306 spanebianco@gw.lecab.fr'
alias tunnel::core::mysql::production='ssh -fNL 3311:core-ro.cnojkoxc94tb.eu-west-1.rds.amazonaws.com:3306 spanebianco@gw.lecab.fr'
alias tunnel::redis='ssh -fNL 6380:data-cache-id.le.cab:6379 spanebianco@gw.le.cab'
alias tunnel::check='lsof -i -n | grep ssh'

# Add nodenv
export PATH=$PATH:/home/simone/.nodenv/bin
eval "$(nodenv init -)"
export PATH=$PATH:/home/simone/.nodenv/shims

# Alias git
alias commit::diff='_diff_commit() { git log $1..$2 --oneline --no-decorate ;}; _diff_commit'
alias commit::diff::lcv='_diff_commit_lcv() { git log $1..$2 --oneline --no-decorate | grep -oP "LCV1-[0-9]{4}" | sort -u; }; _diff_commit_lcv'
alias commit::diff::nomerge='_diff_commit() { git log $1..$2 --no-merges --oneline --no-decorate ;}; _diff_commit'

# Open Explorer on the current folder
alias explorer='explorer.exe `wslpath -w "$PWD"`'
