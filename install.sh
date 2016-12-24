#!/bin/bash
usage() {
	echo "${0} /test/directory"
	echo "if no argument __DEST__ set to \$HOME/bin"
}

__DIR__=`pwd ${0}`
__BIN_DIR__="${__DIR__}/bin"
__DOT_DIR__="${__DIR__}/config"
__DEST__=${HOME}

if [ $# -eq 1 ]; then
	if [ -d ${1} ]; then
		__DEST__=${1}
		echo "test mode: __DEST__ set to ${__DEST__}"
	else
		usage
		exit
	fi
fi

if [ ! -d $__DEST__/bin ]; then
	mkdir $__DEST__/bin
fi

echo "Install binary files"
for file in ${__BIN_DIR__}/*; do
	__BASENAME__=$(basename $file)
	echo "Install ${__BASENAME__}"
	cp $file "${__DEST__}/bin"
	chmod 700 "${__DEST__}/bin/${__BASENAME__}"
done

echo "Install config files"
for file in ${__DOT_DIR__}/.[^.]*; do
	__BASENAME__=$(basename $file)
	echo $file
	if [ -f $file ]; then
		if [ -L ${__DEST__}/${__BASENAME__} ]; then
			rm ${__DEST__}/${__BASENAME__}
		fi
		cp $file "${__DEST__}"
	elif [ -d $file ]; then
		if [ -L "${__DEST__}/${__BASENAME__}" ]; then
			# destination is symlink or simple file
			rm "${__DEST__}/${__BASENAME__}"
		fi
		cp -R $file "${__DEST__}"
	fi
done

#echo "Install and build xmonad"
#if [ ! -d "${__DEST__}/.xmonad" ]; then
#	mkdir "${__DEST__}/.xmonad"
#fi

#cp -R ${__DIR__}/xmonad/* "${__DEST__}/.xmonad" 
#xmonad --recompile

#echo "Restart xmonad"
#xmonad --restart



