#!/bin/sh
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrdb -merge .Xresources
xrandr --dpi 96
xset r rate 200 33

export PATH=$PATH:~/bin/:~/code/scripts/

if command -v pasystray >/dev/null 2>&1; then
  pasystray &
fi
if command -v cbatticon >/dev/null 2>&1; then
  cbatticon -i symbolic -c "notify-send -u critical 'low battery'" &
fi
exec i3
