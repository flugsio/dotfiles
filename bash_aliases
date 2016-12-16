alias t='tig --all'
alias ra='ranger'
alias g='git'
alias i='invoker'
alias ir='invoker reload'
alias il='invoker list'
alias iclear='pkill -f "^tail.*.invoker/invoker.log"'
alias ilog='while true; do clear; tmux clear-history; tail -n0 -F ~/.invoker/invoker.log; done'
alias be='bundle exec'
alias cpu_temp='sensors | grep temp2 | cut -d "+" -f 2 | cut -d "." -f 1'
alias cpu_fan1_alarm='sensors | grep alarm | wc -l'
alias cpu_temp_warning='[ "$(cpu_temp)" -ge "60" ] && notify-send "CPU TEMPERATURE TOO HIGH" '
alias cpu_fan1_warning='[ "$(cpu_fan1_alarm)" -ge "1" ] && notify-send "CPU FAN1 IS DEAD! MANUAL POKE IS NEEDED!" '
alias hexa_clock_text='echo "scale=20;obase=16;a=($(date +'%s')+3600*2)/(86400/16^3);scale=0;a/1" | bc | sed "s/\(.\{3\}\)$/_\1/" '
alias awesome_set_clock_text='echo "hexaclock:set_markup(\"`cpu_temp` `hexa_clock_text`\") " | awesome-client '
alias awesome_loop='while true; do awesome_set_clock_text ; cpu_temp_warning ; cpu_fan1_warning ; sleep 5; done'
alias engage="play -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14"
alias surf_go='xprop -id ${surfwid:=$(xdotool selectwindow)} -f _SURF_GO 8s -set _SURF_GO '
alias surf_poll='sleep 0.3; until curl $SURL --fail 2>/dev/null; do echo "$(date -Is) [Debug]" Not up; sleep 0.3; done; surf_go $SURL'
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
alias ran='EDITOR="tmux_editor" ranger --cmd="map J chain move down=1 ; move right=1" --cmd="map K chain move up=1 ; move right=1" --cmd="set preview_files false" --cmd="set display_size_in_main_column false"'
alias rep='cd ~/code/ansible/repos'
alias windows='rdesktop 192.168.1.189 -u Administrator -k sv -g 2555x1400 -r sound:off'
alias windows2='rdesktop 192.168.1.188 -u Avidity -k sv -g 2550x1380 -r sound:off'
alias mkbunlinks='if [ -f "Gemfile" ]; then mkdir -p bunlinks && find bunlinks -type l -delete && cd bunlinks && bundle show --paths | xargs -L1 ln -s; cd .. ; else echo "not in Gemfile directory"; fi'
alias perrbit='cd ~/code/promote && xsel > errbit_error.txt && vim errbit_error.txt -c "%s/\v([^-]*-\d\.)/site\/bunlinks\/\1/e | %s/\v^([^(site\/bunlinks|\/opt)].)/site\/\1/e | %s/\v^\/opt\/promote\/releases\/\d+T\d+\///e | w | set errorformat=%f:%l→%m | cbuffer | copen" && rm errbit_error.txt'
alias rgdb='gdb $(rbenv which ruby) $(pgrep -f "jobs:work" | head -n1)'
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
elif [ `hostname` = "zdani" ]; then
  alias wine_steam='WINEDEBUG=-all WINEPREFIX=~/.wine_steam wine ~/.wine_steam/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-dwrite'
  alias wine_steam32='WINEDEBUG=-all WINEPREFIX=~/.wine_steam32 wine ~/.wine_steam32/drive_c/Program\ Files/Steam/Steam.exe -no-dwrite'
  alias copy_terminfo_dimea="infocmp st-256color | ssh dimea 'mkdir -p .terminfo && cat >/tmp/ti && tic /tmp/ti'"
  alias wine_ql='cd ~/.wine_ql/drive_c/Program\ Files/Quake\ Live/ && WINEPREFIX=~/.wine_ql taskset 0x01 wine Launcher.exe'
  #alias mount_ql_demos='cd ~/.wine_ql/drive_c/users/flugsio/Application\ Data/id\ Software/quakelive/home/baseq3 && sudo mount -t tmpfs -o size=512M,noatime tmpfs ./demos'
  alias mount_ql_demos='cd ~/.wine_steam/drive_c/Program\ Files\ \(x86\)/Steam/SteamApps/common/Quake\ Live/76561197995130505/baseq3 && sudo mount -t tmpfs -o size=512M,noatime tmpfs ./demos'
  alias move_ql_demos='cd ~/.wine_steam/drive_c/Program\ Files\ \(x86\)/Steam/SteamApps/common/Quake\ Live/76561197995130505/baseq3 && mv -v ./demos/* ./demos_saved/'
fi
alias watch_feedback='watch -n 60 -g "curl -s http://en.lichess.org/forum | grep Feedback -A 3 | tail -n1" && notify-send -u critical "New Lichess Feedback topic"'
alias deleted_files_in_use="lsof +c 0 | grep 'DEL.*lib' | awk '1 { print $1 \": \" $NF }' | sort -u"
alias windows_downtime="ruby -e \"require 'date'; puts (DateTime.now-Date.parse('2013-09-26')).to_i\""
#alias mount_ql_demos='cd ~/.wine_ql/drive_c/users/flugsio/Application\ Data/id\ Software/quakelive/home/baseq3 && sudo mount -t tmpfs -o size=512M,noatime tmpfs ./demos'
alias mount_donjon='sudo mount -t tmpfs -o size=64M,noatime tmpfs ~/donjon && cd ~/donjon && git clone donjon: .'
alias mkchangelog='surf -x -t hgmd.css | read HDSURFXID & (while read; do hoedown CHANGELOG.md > changelog.html; echo xprop -id $HDSURFXID -f _SURF_GO 8s -set _SURF_GO "file://$(pwd)/changelog.html" ; done; rm changelog.html)'
function active_branch {
  echo ${branch:-$(git_current_branch | tr -d "[[:space:]]")}
}
alias openpr='firefox "$(git remote get-url --push origin | sed -r "s/^(git@github.com|hub):/https:\/\github.com\//; s/.git$//")/compare/$(active_branch)?expand=1"'
alias openci='firefox "https://ci.avidity.se/project.html?projectId=Promote&tab=projectOverview&branch_Promote=$(active_branch)"'
alias swatch='(start=$(date +"%s"); echo "00:00"; typeset -Z2 minutes seconds; while true; do sleep 1; total=$(($(date +"%s")-$start)); minutes=$(($total/60)); seconds=$(($total%60)); echo "\e[1A$minutes:$seconds" ; done)'
