#!/bin/sh
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setxkbmap -layout se
xmodmap ~/.Xmodmap
xset r rate 200 33
xset m 1/1 4
xset -b

xrdb -merge .Xresources

export PATH=$PATH:~/bin/:~/.scripts/

exec i3
