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
force_color_prompt=yes

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
    PS1='$?: ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='$?: ${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -alhrt'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ungrep='grep -v'
alias R='R --no-save'
alias emacs='vim'
alias nano='vim'

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

#CUSTOM
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

alias pylint='pylint -E'
alias bigres='xrandr -s 1920x1080'
alias smallres='xrandr -s 1360x768'
alias updatebash='source ~/.bashrc'
alias tar='tar --owner=9999 --group=9999'
alias restart-dns='sudo service systemd-resolved restart'
alias rot_normal='xrandr --output eDP-1 --rotate normal'
alias rot_down='xrandr --output eDP-1 --rotate inverted'
alias rot_left='xrandr --output eDP-1 --rotate left'
alias rot_right='xrandr --output eDP-1 --rotate right'

ds(){
    if [ "$#" -eq 0 ]; then
        du -sch * 2> /dev/null;
        return;
    fi;
    du -sch $@ 2> /dev/null;
}

py2pdf(){
    if [ "$#" -ne 2 ]; then
        echo "Invalid parameter count!";
        return;
    fi;
    echo "Converting $1 to $2"; 
    enscript --color=1 -Epython -q -Z -p - -f Courier10 $1 | ps2pdf - $2;
}

txt2pdf(){
    if [ "$#" -ne 2 ]; then
        echo "Invalid parameter count!";
        return;
    fi;
    echo "Converting $1 to $2"; 
    enscript -q -Z -p - -f Courier14 --word-wrap $1 | ps2pdf - $2;
}

deepcompare()
{
    if [ "$#" -ne 1 ]; then
        echo "Invalid parameter count!";
        return;
    fi;
    
    curr_dir=$(pwd);
    thing_to_find="$1";
    if [ -d "$1" ];
        then
            cd $1;
            thing_to_find="";
    fi;
    
    find $thing_to_find -print0 |
    while IFS= read -r -d $'\0' i; 
        do stat --printf='%n|%#03a|%F|%G|%U|%s|' "$i"; 
            if [ -f "$i" ]; 
                then 
                    md5sum "$i" | awk '{print $1}'; 
                else
                    echo ""; 
            fi; 
        done
    
    cd $curr_dir;
}

iptables_clear()
{
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -t nat -F
    iptables -t mangle -F
    iptables -F
    iptables -X
}

kill-docker-containers()
{
    if [ `docker container ls -a | wc -l` -gt 1 ]; then
        docker container rm -f $(docker container ls -a | awk 'NR>1{print $1}' );
    else
        echo "Nothing is running. Nothing to kill."
    fi
}
pepcat()
{
    autopep8 -i $1 && cat $1
}

alias python='/usr/bin/python3.9'
alias pylint='/usr/bin/pylint3'
alias pip='/usr/local/bin/pip3.6'
alias please='sudo $(fc -ln -1)'
alias dnsflush='sudo /etc/init.d/networking restart'
alias df='df -hx"squashfs"'
#alias parallel='parallel --citation'

alias random_android_id='openssl rand -hex 8'
alias mitmweb='mitmweb -q'
export PYTHONSTARTUP=$HOME/.pythonstartup
