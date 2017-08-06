alias dot='cd ~/code/dotfiles'
alias rep='cd ~/code/ansible/repos'
alias t='tig --all'
alias ra='ranger'
alias g='git'
alias gr='git $(git root)'
alias iw='alias i{r,l,s,a,clear,log}; echo iA=run interactively'
alias i='invoker'
alias il='invoker list'
function ir { for s in ${*:-$DEFAULT_RELOAD}; do echo reload $s; invoker reload $s; done }
function is { for s in ${*:-$DEFAULT_RELOAD}; do echo remove $s; invoker remove $s; done }
function ia { for s in ${*:-$DEFAULT_RELOAD}; do echo add $s; invoker add $s; done }
function iA { eval $(sed -n "/\[$1\]/,/^\[/p" ~/code/promote.ini | grep -Po "(?<=command = ).*"); }
alias iclear='pkill -f "^tail.*.invoker/invoker.log"'
alias ilog='while true; do clear; tmux clear-history; tail -n0 -F ~/.invoker/invoker.log; done'
function rv {
  # TODO: fix quotes/params
  if [ -z "$*" ]; then
    ssh -t $VAGRANT_MACHINE "cd $VAGRANT_DIR; bash -l"
  else
    ssh $VAGRANT_MACHINE "cd $VAGRANT_DIR; bash -lc '$*'"
  fi
}
function rb {
  ssh -t $VAGRANT_MACHINE "cd $VAGRANT_DIR; bash -lc 'bundle exec $@'"
}
alias be='bundle exec'
alias ber='bundle exec rake'
alias datei='date -u +"%Y%m%dT%H%M%SZ"'
alias hexa_clock_text='echo "scale=20;obase=16;a=($(date +'%s')+3600*2)/(86400/16^3);scale=0;a/1" | bc | sed "s/\(.\{3\}\)$/_\1/" '
alias engage="play -n -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14"
alias surf_go='xprop -id ${surfwid:=$(xdotool selectwindow)} -f _SURF_GO 8s -set _SURF_GO '
alias surf_poll='sleep 0.3; until curl $SURL --fail 2>/dev/null; do echo "$(date -Is) [Debug]" Not up; sleep 0.3; done; surf_go $SURL'
function xkcd {
  feh $(curl -sL https://xkcd.com/$1/info.0.json | jq -r '.img') --info \
    "curl -sL https://xkcd.com/$1/info.0.json | jq -r '(.num | tostring) + \": \" + .title, .alt'"
}
alias bed='bundle exec rails db'
alias bec='bundle exec rails console'
alias brow='surf -x $url 2> /dev/null & firefox $url & chromium $url &'
alias bun='(cd webapp 2> /dev/null; cd .. && for a in $(ls -d */); do (cd $a && bundle && mkbunlinks) done)'
alias mig='(cd webapp 2> /dev/null; cd .. && for a in $(ls -d */); do (cd $a && bundle exec rake db:migrate) done)'
alias i18='(cd webapp 2> /dev/null; cd .. && for a in $(ls -d */); do (cd $a && bundle exec rake i18nlite:sync)'
alias tes='(cd webapp 2> /dev/null; i18 && bundle exec rake db:migrate RAILS_ENV=test)'
alias aap='bun && mig && i18'
alias aup='bundle && mkbunlinks; ber db:migrate; ber i18nlite:sync; ber db:migrate RAILS_ENV=test'
alias wha='echo bun, mig, i18, aup=after update, aap=after all update, tes=after update for tests, ran=vit ranger'
alias vit='DISPLAY=:0 \vim --servername $(tmux display-message -p "#S")'
alias ran='EDITOR="tmux_editor" ranger --cmd="map J chain move down=1 ; move right=1" --cmd="map K chain move up=1 ; move right=1" --cmd="set preview_files false" --cmd="set display_size_in_main_column false"'
alias view_shots='ranger --cmd="set column_ratios 1,5" --cmd="set display_size_in_main_column false" ~/shots'
alias mux='tmuxinator'
alias windows='rdesktop 192.168.1.189 -u Administrator -k sv -g 2555x1400 -r sound:off'
alias windows2='rdesktop 192.168.1.188 -u Avidity -k sv -g 2550x1380 -r sound:off'
alias mkbunlinks='if [ -f "Gemfile" ]; then mkdir -p bunlinks && find bunlinks -type l -delete && cd bunlinks && bundle show --paths | xargs -L1 ln -s; cd .. ; else echo "not in Gemfile directory"; fi'
alias perrbit='cd ~/code/promote3 && xsel > errbit_error.txt && vim errbit_error.txt -c "%s/\v([^-]*-\d\.)/site\/bunlinks\/\1/e | %s/\v^([^(site\/bunlinks|\/opt)].)/site\/\1/e | %s/\v^\/opt\/promote\/releases\/\d+T\d+\///e | w | set errorformat=%f:%l→%m | cbuffer | copen" && rm errbit_error.txt'
alias rgdb='gdb $(rbenv which ruby) $(pgrep -f "jobs:work" | head -n1)'
alias glujc='gluj -m | egrep --color "[A-Z]|$"'
alias lichobile='chromium --user-data-dir=$HOME/.config/chromium_dev --disable-web-security ~/code/lichobile/project/www/index.html'
alias record_area='(eval $(xdotool selectwindow getmouselocation --shell | grep "[XY]=" | sed "s/^/A/"; xdotool selectwindow getmouselocation --shell | grep "[XY]=" | sed "s/^/B/"); sleep 0.5 && ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s $(($BX-$AX))x$(($BY-$AY)) -r 30 -i :0.0+$AX,$AY -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1)'
alias record='sleep 0.5 && ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s 1680x1050 -r 30 -i :0.0 -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1'
alias record='sleep 0.5 && ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s 1440x900 -r 30 -i :0.0 -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1'
alias wine_scrolls=WINEPREFIX='~/.wine_scrolls wine ~/.wine_scrolls/drive_c/Program\ Files\ \(x86\)/Scrolls/ScrollsLauncher.exe'
if [ `hostname` = "ranmi" ]; then
  #alias wine_ql='cd ~/.wine-ql/drive_c/Program\ Files/Quake\ Live/ && WINEPREFIX=~/.wine-ql taskset 0x01 wine Launcher.exe'
  alias wine_steam='WINEPREFIX=~/.wine-steam wine /home/flugsio/.wine-steam/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-dwrite'
  #alias wine_steam='WINEPREFIX=~/.wine-steam wine /home/flugsio/.wine-steam/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-dwrite steam://run/282440'
  #alias wine_steam32='WINEPREFIX=~/.wine-steam32 WINEARCH=win32 /home/flugsio/.wine-steam32/drive_c/Program\ Files/Steam/Steam.exe'
  #alias mount_ql_demos='cd ~/.wine_steam/drive_c/Program\ Files\ \(x86\)/Steam/SteamApps/common/Quake\ Live/76561197995130505/baseq3 && sudo mount -t tmpfs -o size=512M,noatime tmpfs ./demos'
  #alias move_ql_demos='cd ~/.wine_steam/drive_c/Program\ Files\ \(x86\)/Steam/SteamApps/common/Quake\ Live/76561197995130505/baseq3 && mv -v ./demos/* ./demos_saved/'

  alias wine_ql='wine_steam steam://run/282440'
  alias mount_ql_demos='cd /home/flugsio/.wine-steam/drive_c/Program\ Files\ \(x86\)/Steam/steamapps/common/Quake\ Live/76561197995130505/baseq3 && sudo mount -t tmpfs -o size=512M,noatime tmpfs ./demos'
  alias move_ql_demos='cd /home/flugsio/.wine-steam/drive_c/Program\ Files\ \(x86\)/Steam/steamapps/common/Quake\ Live/76561197995130505/baseq3 && mv -v ./demos/* ./demos_saved/'
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
alias swatch_start='start=$(date +"%s"); typeset -Z2 minutes seconds'
alias swatch_status='total=$(($(date +"%s")-$start)); minutes=$(($total/60)); seconds=$(($total%60)); echo "$minutes:$seconds"'
alias swatch2='swatch_start; while true; do sleep 1; swatch_status ; done)'
alias stopw='(stop=$(date +"%s" -d "$at"); echo "-00:00"; typeset -Z2 minutes seconds; while [ $minutes -gt 0 -o $seconds -gt 0 ]; do sleep 1; total=$(($stop-$(date +"%s"))); minutes=$(($total/60)); seconds=$(($total%60)); echo "-$minutes:$seconds\e[1A" ; done)'
alias ptfinished='jq ".data.stories.stories[] | \" - [\" + (.id | tostring + \"](\") + .url + \") \" + .name" -r'
alias bat='grep -hoP "(?<=CAPACITY=)\d+" /sys/class/power_supply/BAT*/uevent'
