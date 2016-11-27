#!/bin/bash
# export scripts for work
# https://github.com/mcandre/svn-prompt
# https://github.com/jimeh/git-aware-prompt

# git prompt
# source "${HOME}/.bash/git-prompt/main.sh"
. "/usr/share/git-core/contrib/completion/git-prompt.sh"
# svn prompt
. "${HOME}/.bash/svn-prompt/svn-prompt.sh"

# configure git-prompt options
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
# Explicitly unset color (default anyhow). Use 1 to set it.
#GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git"

# right arrow \u25b6

RIGHT_ARROW="\342\226\266"

# time
TIME_PROMPT=" \A "

# hostname prompt
HOSTNAME_PROMPT="[\u@\h] "

PATH_PROMPT=" \w "


# functions
get_dir() {
    printf "%s" $(pwd | sed "s:$HOME:~:")
}

get_sha() {
    git rev-parse --short HEAD 2>/dev/null
}

scm_ps1() {
    local exit=$?
    local s=
    if [[ -d ".svn" ]] ; then
        s=\(svn:$(svn info | sed -n -e '/^Revision: \([0-9]*\).*$/s//\1/p' )\)
        s="$(parse_svn_url)$(parse_svn_branch) $s"
    else
        s=$(__git_ps1 "(git: %s $(get_sha))")
    fi
    echo " $s "
    return $exit
}

prompt_function() {

	PS1="\[\e[0;37;44m\]$HOSTNAME_PROMPT\[\e[0;34;40m\]$RIGHT_ARROW\[\e[0;37;40m\]$PATH_PROMPT\[\e[0;30;46m\]$RIGHT_ARROW\[\e[1;30;46m\]$(scm_ps1)\[\e[0;36m\]$RIGHT_ARROW\n\[\e[8;37;40m\]$TIME_PROMPT\[\e[0;30m\]$RIGHT_ARROW\[\e[0m\] \$ "

}

export PROMPT_COMMAND=prompt_function
