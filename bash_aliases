alias t='tig --all'
alias ta='tig --all'
alias ra='ranger'
alias g='git'
alias cpu_temp='sensors | grep temp2 | cut -d "+" -f 2 | cut -d "." -f 1'
alias cpu_fan1_alarm='sensors | grep alarm | wc -l'
alias cpu_temp_warning='[ "$(cpu_temp)" -ge "60" ] && notify-send "CPU TEMPERATURE TOO HIGH" '
alias cpu_fan1_warning='[ "$(cpu_fan1_alarm)" -ge "1" ] && notify-send "CPU FAN1 IS DEAD! MANUAL POKE IS NEEDED!" '
alias hexa_clock_text='echo "scale=20;obase=16;a=($(date +'%s')+3600*2)/(86400/16^3);scale=0;a/1" | bc | sed "s/\(.\{3\}\)$/_\1/" '
alias awesome_set_clock_text='echo "hexaclock:set_markup(\"`cpu_temp` `hexa_clock_text`\") " | awesome-client '
alias awesome_loop='while true; do awesome_set_clock_text ; cpu_temp_warning ; cpu_fan1_warning ; sleep 5; done'
alias teag='(notify-send "Starting 2 min tea timer."; sleep 2m; notify-send "Your green tea is ready." -u critical)&'
alias teab='(notify-send "Starting 4 min tea timer."; sleep 4m; notify-send "Your black tea is ready." -u critical)&'
alias teaegh='(notify-send "Starting 3.5 min earl gray tea timer."; sleep 3.5m; notify-send "Your hot earl gray tea is ready, captain." -u critical)&'
alias engage="play -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14"
alias mstsc_laura='rdesktop 192.168.2.40 -u Administrator -k sv -g 1675x1024 -r sound:off'
alias surf_go='xprop -id ${surfwid:=$(xdotool selectwindow)} -f _SURF_GO 8s -set _SURF_GO '
alias xkcd='curl http://xkcd.com -sL | grep -o "http://imgs.*" | feh -'
alias rdb='bundle exec rails db'
alias brow='surf -x $url 2> /dev/null & firefox $url & chromium $url &'
alias bun='(cd site 2> /dev/null; cd .. && for a in admin admin_core base site; do (cd $a && bundle) done)'
alias mig='(cd site 2> /dev/null; cd .. && for a in site; do (cd $a && bundle exec rake db:migrate) done)'
alias i18='(cd site 2> /dev/null; cd .. && cd site; bundle exec rake i18nlite:sync)'
alias tes='(cd site 2> /dev/null; i18 && bundle exec rake db:migrate RAILS_ENV=test)'
alias aup='bun && mig && i18'
alias wha='echo bun, mig, i18, aup=after update, tes=after update for tests, ran=vit ranger'
alias vit='DISPLAY=:0 \vim --servername $(tmux display-message -p "#S")'
alias ran='EDITOR="tmux_editor" ranger'
alias rep='cd ~/code/ansible/repos'
alias windows='rdesktop 192.168.1.189 -u Administrator -k sv -g 2555x1400 -r sound:off'
alias mkbunlinks='if [ -f "Gemfile" ]; then mkdir -p bunlinks && find bunlinks -type l -delete && cd bunlinks && bundle show --paths | xargs -L1 ln -s; cd .. ; else echo "not in Gemfile directory"; fi'
alias perrbit='cd ~/code/promote && xsel > errbit_error.txt && vim errbit_error.txt -c "%s/\v([^-]*-\d\.)/site\/bunlinks\/\1/e | %s/\v^([^(site\/bunlinks|\/opt)].)/site\/\1/e | %s/\v^\/opt\/promote\/releases\/\d+T\d+\///e | w | set errorformat=%f:%l→%m | cbuffer | copen" && rm errbit_error.txt'
alias rgdb='gdb $(rbenv which ruby) $(pgrep -f "jobs:work" | head -n1)'
alias vup='[ ! -z "$VAGRANT" ] && vagrant up $VAGRANT'
alias vssh='vagrant ssh $VAGRANT'
alias glujc='gluj -m | egrep --color "[A-Z]|$"'
alias lichobile='chromium --user-data-dir=$HOME/.config/chromium_dev --disable-web-security ~/code/lichobile/project/www/index.html'
alias record_test='ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s 1680x1050 -r 25 -i :0.0 -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0
-threads 0 ~/output-$(date +%s).mkv 2>&1'
alias record='ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s 1680x1050 -r 25 -i :0.0 -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1'
if [ `hostname` = "ranmi" ]; then
  #alias wine_ql='cd ~/.wine-ql/drive_c/Program\ Files/Quake\ Live/ && WINEPREFIX=~/.wine-ql taskset 0x01 wine Launcher.exe'
  alias wine_steam='WINEPREFIX=~/.wine-steam wine /home/flugsio/.wine-steam/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-dwrite'
  alias wine_ql='wine_steam steam://run/282440'
  #alias wine_steam='WINEPREFIX=~/.wine-steam wine /home/flugsio/.wine-steam/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-dwrite steam://run/282440'
  alias wine_steam32='WINEPREFIX=~/.wine-steam32 WINEARCH=win32 /home/flugsio/.wine-steam32/drive_c/Program\ Files/Steam/Steam.exe'
fi
alias mount_ql_demos='cd ~/.wine_ql/drive_c/users/flugsio/Application\ Data/id\ Software/quakelive/home/baseq3 && sudo mount -t tmpfs -o size=512M,noatime tmpfs ./demos'
alias mount_donjon='sudo mount -t tmpfs -o size=64M,noatime tmpfs ~/donjon && cd ~/donjon && git clone donjon: .'
alias hubpr='firefox "$(git remote get-url --push origin | sed -r "s/^(git@github.com|hub):/https:\/\github.com\//; s/.git$//")/compare/${branch:-$(git_current_branch | tr -d "[[:space:]]")}?expand=1"'
