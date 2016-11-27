# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

# fix for soft on raid0
export QSYS_ROOTDIR="/home/.fast${HOME}/.soft/altera_lite/16.0/quartus/sopc_builder/bin"
