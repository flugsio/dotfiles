xset r rate 200 33

gnome-keyring-daemon &
gnome-settings-daemon &
sparkleshare start &
xrdb -merge .Xresources

exec awesome
