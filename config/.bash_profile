if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export EDITOR=/usr/bin/vi

# less with syntax highlight
export LESS="-R"
export LESSOPEN="|pygmentize -g -O encoding=utf8 %s"

# python virtualenv
if [ -f ${HOME}/.local/bin/virtualenvwrapper.sh ]; then
	export WORKON_HOME=~/.envs
	source ${HOME}/.local/bin/virtualenvwrapper.sh
fi

# auto activate virtualenv
#source ~/.soft/autoenv/activate.sh

# javafix for matlab
export MATLAB_JAVA=/usr/lib/jvm/jre

export LYNX_LSS="$HOME/.lynx.lss"

# User specific environment and startup programs
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# add global composer bin folder if exists
if [ -d $HOME/.config/composer/vendor/bin/ ]; then
	export PATH=$PATH:$HOME/.config/composer/vendor/bin/
fi

# fix for soft on raid0
export QSYS_ROOTDIR="/home/.fast${HOME}/.soft/altera_lite/16.0/quartus/sopc_builder/bin"
export VAGRANT_DEFAULT_PROVIDER=virtualbox

export TERMINAL="urxvt-ml"

export XSECURELOCK_BLANK_DPMS_STATE=off 
export XSECURELOCK_BLANK_TIMEOUT=15
