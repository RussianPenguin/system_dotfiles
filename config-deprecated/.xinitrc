#!/bin/bash

# set default DE to fetch variables for Qt4/5
#export SAL_GTK_USE_PIXMAPPAINT=1
export XDG_CURRENT_DESKTOP=GNOME
#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#export DESKTOP_SESSION=gnome

# fix XMonad bug with ewmhDesktopsEventHook
export _JAVA_AWT_WM_NONREPARENTING=1

#compton --backend glx --vsync opengl-swc --xrender-sync --xrender-sync-fence --paint-on-overlay --glx-no-rebind-pixmap --glx-no-stencil &
compton &
#xcompmgr -c &
xsetroot -cursor_name left_ptr &
numlockx &
pulseaudio --start &
#stalonetray &
feh --bg-scale ~/.wallpaper.jpg &
# MPD daemon start (if no other user instance exists)

. /etc/X11/xinit/xinitrc
