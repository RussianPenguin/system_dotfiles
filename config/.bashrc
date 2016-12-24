# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
 . ~/.bash_aliases
fi

# setup mc wrapper
if [ -f /usr/libexec/mc/mc.sh ]; then
 . /usr/libexec/mc/mc.sh
fi

# добавляем опции автоматического перехода в папки
shopt -s autocd

# устанавливаем ширину табов в 2 вместо 8
tabs 2

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export EDITOR=/usr/bin/vi

# less with syntax highlight
export LESS="-R"
export LESSOPEN="|pygmentize -g -O encoding=utf8 %s"

# nvm
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# python virtualenv
export WORKON_HOME=~/.envs
source ${HOME}/.local/bin/virtualenvwrapper.sh

# auto activate virtualenv
#source ~/.soft/autoenv/activate.sh

source ${HOME}/.bash.d/ps1.sh

# javafix for matlab
export MATLAB_JAVA=/usr/lib/jvm/jre

export QSYS_ROOTDIR="/home/.fast${HOME}/.soft/altera_lite/16.0/quartus/sopc_builder/bin"
export LYNX_LSS="$HOME/.lynx.lss"
