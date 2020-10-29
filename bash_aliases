# vim:ft=zsh ts=2 sw=2 sts=2

# this is a tiny helper thingy
# the purpose is to provide contextual help
# recommended tmux keybind: M-a h
function h {
  if [ "$1" = "w" ]; then
    local cache_time=2
    local last_modified=0
    # watch processes
    while sleep 1; do
      local c=$(h_cmd)
      if [ -n "$c"  ]; then
        # allow editing and previewing result
        if [ "$c" = "h" ]; then
          c=$last
        fi
        local f="$HOME/Sync/h/${c}.wofl"

        local modified=$(stat $f -c %Y 2>/dev/null || echo 0)
        if [ "$c" != "$last" -o "$(expr $modified - $last_modified)" -gt $cache_time ]; then
          local last=$c
          local last_modified=$(stat $f -c %Y 2>/dev/null || echo 0)
          clear
          cat $f 2>/dev/null || echo "Empty: $c"
          echo
          #man $c | head
      fi
      fi
    done
  elif [ "$1" = "e" ]; then
    # edit, TODO: this does not use focus, but latest started
    $EDITOR ~/Sync/h/${2:-$(cat $(ls -t1 ~/.cache/h/* | head -n2 | tail -n1))}.wofl
  fi
}

function h_cmd {
  local pid=$(tmux list-panes -F "#{pane_active} #{pane_pid}" | grep "^1 " | cut -d" " -f2)
  if [ -n "$pid" ]; then
    cat ~/.cache/h/$pid 2>/dev/null
  fi
}

function pt {
  # wrap pt, to reuse the same .pt file
  (cd ~/code && command pt $@)
}
alias dot='cd ~/code/dotfiles'
alias syn='cd ~/Sync'
alias rep='cd ~/code/ansible/repos'
alias t='tig --all'
alias ra='ranger'
alias g='git'
alias gr='git $(git root)'
# list remote branches with author
alias gbr='for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ai %ar by %an" $branch | head -n 1` \\t$branch; done | sort -r'
# lists git tags
function gt {
  git for-each-ref refs/tags/ --format '%(objecttype) %(refname:short)' |
    while read ty name; do
      if [ $ty = commit ]; then
        echo "$name (lightweight)"
      elif [ $ty = tag ]; then
        echo "$name (full tag)"
      fi
    done
}
function browse {
  echo $@
  if [ -n "$DISPLAY" ]; then
    if command -v chromium >/dev/null 2>&1; then
      chromium --new-window $@
    elif command -v firefox >/dev/null 2>&1; then
      firefox --new-window $@
    fi
  fi
}
function random_word {
  shuf -n1 /usr/share/dict/american-english | sed "s/'//" | lowercase
}
# first parameter is deadline, 3 seconds default
function has_network {
  local deadline=${1:-3}
  ping 8.8.8.8 -c 1 -w $deadline &>/dev/null
}
# git create a branch from latest origin/master
function gb {
  # todo, create a random tempname
  local name=$1
  if [ -z "$name" ]; then
    name=$(random_word)-$(random_word)
    echo "Created a random branch name: $name"
    echo "Use 'g r <name>' to rename"
  fi
  # only fetch if there's 'fast' network available
  has_network 1 && git fetch origin
  # this doesn't set --track
  # do that when pushing instead, for renames
  git checkout -b $name origin/master
}
function gp {
  git checkout master
  git pull -p
  cleanup
}
function gf {
  git fetch
  cleanup
}
function cleanup {
  local branch
  for branch in $(git branch --merged | grep -v master | grep -v "^\*"); do
    git branch -d $branch
  done
}
alias istart='invoker start all -d'
alias iw='alias i{r,l,s,a,clear,log}; echo iA=run interactively'
alias i='invoker'
alias il='invoker list'
alias ill='invoker list -r | grep -Po "(?<=Name |PID : ).*" | sed "/: /{N;s/\n/, /}" | column | ack --passthru Not'
# These work on the argument list, or DEFAULT_RELOAD if set, or fallbacks to current directories processes
function ir { for s in ${*:-${DEFAULT_RELOAD:-$(ihere)}}; do echo reload $s; invoker reload $s; done }
function is { for s in ${*:-${DEFAULT_RELOAD:-$(ihere)}}; do echo remove $s; invoker remove $s; done }
function ia { for s in ${*:-${DEFAULT_RELOAD:-$(ihere)}}; do echo add $s; invoker add $s; done }
function iA { eval $(sed -n "/\[$1\]/,/^\[/p" ~/.invoker/all.ini | grep -Po "(?<=command = ).*"); }
alias iclear='pkill -f "^tail.*.invoker/invoker.log"'
alias ilog='while true; do clear; tmux clear-history; tail -n0 -F ~/.invoker/invoker.log; done'
alias ilist="cat ~/.invoker/all.ini | sed -rn '/^\[/{N;s/\[([^]]*)\]\ndirectory = (.*)$/\1 \2/;p}'"
# List of all processes in invoker's all.ini, filtered by the current directory name
function ihere {
  local p=$(pwd | sed "s#$HOME#~#")
  ilist | grep -E "$p($|\/)" | cut -f1 -d' ' | xargs echo
}
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
function mkde {
  local name=$(echo "$@" | lowercase | sed 's/[^A-Za-z0-9]/_/g')
  local pathname=$HOME/debug/$(date -u +"%Y%m%d")_"$name"
  mkdir "$pathname"
  ln -fns "$pathname" $HOME/debug/latest
  cd "$pathname"
  i3-msg move workspace $name, workspace $name
  vim log.md
}
alias be='bundle exec'
alias ber='bundle exec rake'
alias bb='bundle exec rspec $(ack byebug\$ spec --output=:: | sed s/::://)'
alias datei='date -u +"%Y%m%dT%H%M%SZ"'
alias dts='date -u +"%Y%m%d"'
alias dta='date -u +"%Y%m%d %H%M"'
alias dtz='date -u +"%Y%m%dT%H%M%SZ"'
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
alias tag='([ -f tags ] && echo "Preparing tags" && ctags -R || true)'
alias bun='rbenv install --skip-existing; bundle check; bundle install; mkbunlinks'
alias yar='([ -f yarn.lock ] && yarn install --check-files || true)'
alias mig='ber db:migrate'
alias unmig='ber db:rollback'
alias i18='ber i18nlite:sync'
alias tes='ber db:migrate RAILS_ENV=test'
alias dbdiff='git --no-pager diff db/schema.rb'
alias remig='ber db:migrate && dbdiff && unmig && dbdiff && ber db:migrate && dbdiff'
alias revert_schema='dbdiff && git checkout db/schema.rb'
alias aup='bun; yar; ber db:migrate; ber i18nlite:sync; ber db:migrate RAILS_ENV=test; revert_schema; tag &'
alias wha='echo bun, mig, i18, aup=after update, remig=rerun migration, tes=after update for tests, ran=vit ranger'
alias vit='DISPLAY=:0 \vim --servername $(tmux display-message -p "#S")'
alias ran='EDITOR="tmux_editor" ranger --cmd="map J chain move down=1 ; move right=1" --cmd="map K chain move up=1 ; move right=1" --cmd="set preview_files false" --cmd="set display_size_in_main_column false"'
alias view_shots='ranger --cmd="set column_ratios 1,5" --cmd="set display_size_in_main_column false" ~/shots'
alias mux='tmuxinator'
alias windows='rdesktop 192.168.1.189 -u Administrator -k sv -g 2555x1400 -r sound:off'
alias windows2='rdesktop 192.168.1.188 -u Avidity -k sv -g 2550x1380 -r sound:off'
alias mkbunlinks='if [ -f "Gemfile" ]; then mkdir -p bunlinks && find bunlinks -type l -delete && cd bunlinks && bundle show --paths | xargs -L1 ln -s; cd .. ; else echo "not in Gemfile directory"; fi'
alias perrbit='cd ~/code/promote3 && xsel > errbit_error.txt && vim errbit_error.txt -c "%s/\v^(.*gems.*gems\/)?([^(-)]*-\d\.)/bunlinks\/\2/e | %s/\v^([^(bunlinks|\/opt)].)/\1/e | %s/\v^\/opt\/promote\/releases\/\d+T\d+\///e | w | set errorformat=%f:%l%m | cbuffer | copen" && rm errbit_error.txt'
alias textgraph="sort | uniq -c | sort -rn | perl -ane 'printf \"%30s %s\\n\", \$F[1], \"=\"x\$F[0];'"
alias rgdb='gdb $(rbenv which ruby) $(pgrep -f "jobs:work" | head -n1)'
alias glujc='gluj -m | egrep --color "[A-Z]|$"'
alias lichobile='chromium --user-data-dir=$HOME/.config/chromium_dev --disable-web-security ~/code/lichobile/project/www/index.html'
alias record_area='(eval $(xdotool selectwindow getmouselocation --shell | grep "[XY]=" | sed "s/^/A/"; xdotool selectwindow getmouselocation --shell | grep "[XY]=" | sed "s/^/B/"); sleep 0.5 && ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s $(($BX-$AX))x$(($BY-$AY)) -r 30 -i :0.0+$AX,$AY -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1)'
#alias record='sleep 0.5 && ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s 1680x1050 -r 30 -i :0.0 -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1'
#alias record='sleep 0.5 && ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s 1440x900 -r 30 -i :0.0 -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1'
alias record2='sleep 0.5 && ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s 1440x900 -r 30 -i :0.0 -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1'
alias record3='sleep 1.5 && ffmpeg -f pulse -name a -channels 2 -fragment_size 1024 -i default -f x11grab -s 1920x1080 -r 90 -i :0.0 -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 /mnt/big/record/output-$(date +%s).mkv 2>&1'
alias record4='sleep 1.5 && ffmpeg -f pulse -name a -channels 1 -fragment_size 1024 -i default -f x11grab -s 1920x1080 -r 60 -i :0.0 -ac 1 -acodec ac3 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1'
alias record5='sleep 1.5 && ffmpeg -f x11grab -s 1920x1080 -r 60 -i :0.0 -vcodec libx264 -preset ultrafast -crf 0 -threads 0 ~/output-$(date +%s).mkv 2>&1'
function record {
  # for example
  # record 1920x1080 noaudio
  local what=${1:-resize} # area, window, 1920x1080 (a size), resize 1920px1080px (uses i3 to set the size)
  if [ "$what" = "resize" ]; then
    local what="window"
    shift
    local size=${1:-1920px1080px}
    echo "resizing to $size, click on window"
    xdotool selectwindow windowfocus --sync
    i3-msg floating enable resize set $size
    echo "click on window again to start recording"
  fi
  local audio=${2:-audio} # audio, noaudio
  local frames=${3:-30}

  if [ "$what" = "area" ]; then
    local potatoes=$(eval $(xdotool selectwindow getmouselocation --shell | grep "[XY]=" | sed "s/^/A/"; xdotool selectwindow getmouselocation --shell | grep "[XY]=" | sed "s/^/B/"); echo "-s $(($BX-$AX))x$(($BY-$AY)) -r $frames -i :0.0+$AX,$AY")
  elif [ "$what" = "window" ]; then
    local potatoes=$(eval $(xdotool selectwindow getwindowgeometry --shell); echo "-s ${WIDTH}x${HEIGHT} -r $frames -i :0.0+$X,$Y")
  else
    local potatoes="-s $what -r $frames -i :0.0"
  fi

  if [ "$audio" = "audio" ]; then
    local sauce="-f pulse -name a -channels 2 -fragment_size 1024 -i default"
  elif [ "$audio" = "noaudio" ]; then
    local sauce=""
  else
    echo "wrong syntax: area/window/size/(resize+size) audio/noaudio [frames]"
    exit 1
  fi
  local extra="-acodec ac3 -vcodec libx264 -preset ultrafast -crf 24 -threads 0"
  local filename="output-$(date +%s)"
  local output="/tmp/${filename}.mkv"
  local compressed="$HOME/${filename}c.mkv"
  echo "executing in 1 second ffmpeg $sauce -f x11grab $potatoes $extra $output 2>&1"
  sleep 1
  eval "ffmpeg $sauce -f x11grab $potatoes $extra $output"
  echo "start compressing? (ctrl-c to cancel)"
  read i
  if [ "$audio" = "audio" ]; then
    ffmpeg -i "$output" -c copy -vcodec libx264 -crf 24 ${compressed}
    echo "delete original? (ctrl-c to cancel)"
    read y
    rm "$output"
  else
    ffmpeg -i "$output" -c copy -an -vcodec libx264 -crf 24 ${compressed}
    echo "delete original? (ctrl-c to cancel)"
    read y
    rm "$output"
  fi
}
alias wine_callersbane='WINEPREFIX=~/.wine_callersbane wine ~/.wine_callersbane/drive_c/CallersBane/CallersBane.exe'
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
  alias wine_steam_cfg='WINEDEBUG=-all WINEPREFIX=~/.wine_steam winecfg'
  alias wine_steam32='WINEDEBUG=-all WINEPREFIX=~/.wine_steam32 wine ~/.wine_steam32/drive_c/Program\ Files/Steam/Steam.exe -no-dwrite'
  alias copy_terminfo_dimea="infocmp st-256color | ssh dimea 'mkdir -p .terminfo && cat >/tmp/ti && tic /tmp/ti'"
  alias wine_ql='cd ~/.wine_ql/drive_c/Program\ Files/Quake\ Live/ && WINEPREFIX=~/.wine_ql taskset 0x01 wine Launcher.exe'
  #alias mount_ql_demos='cd ~/.wine_ql/drive_c/users/flugsio/Application\ Data/id\ Software/quakelive/home/baseq3 && sudo mount -t tmpfs -o size=512M,noatime tmpfs ./demos'
  alias mount_ql_demos='cd ~/.wine_steam/drive_c/Program\ Files\ \(x86\)/Steam/SteamApps/common/Quake\ Live/76561197995130505/baseq3 && sudo mount -t tmpfs -o size=512M,noatime tmpfs ./demos'
  alias move_ql_demos='cd ~/.wine_steam/drive_c/Program\ Files\ \(x86\)/Steam/SteamApps/common/Quake\ Live/76561197995130505/baseq3 && mv -v ./demos/* ./demos_saved/'
elif [ `hostname` = "toldi" ]; then
  alias wine_steam='WINEDEBUG=-all WINEPREFIX=~/.wine_steam wine ~/.wine_steam/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-dwrite'
  alias wine_steam_cfg='WINEDEBUG=-all WINEPREFIX=~/.wine_steam winecfg'
fi
alias watch_feedback='watch -n 60 -g "curl -s http://en.lichess.org/forum | grep Feedback -A 3 | tail -n1" && notify-send -u critical "New Lichess Feedback topic"'
alias deleted_files_in_use="lsof +c 0 | grep 'DEL.*lib' | awk '1 { print $1 \": \" $NF }' | sort -u"
alias windows_downtime="ruby -e \"require 'date'; puts (DateTime.now-Date.parse('2013-09-26')).to_i\""
alias ltra="rbenv shell 2.3.5; ruby -e \"require 'date'; require 'time'; require 'active_support/all'; puts ((DateTime.parse('2018-02-15 18:30:00')-DateTime.parse('2017-08-17 23:30:00')).to_f)\""
#alias mount_ql_demos='cd ~/.wine_ql/drive_c/users/flugsio/Application\ Data/id\ Software/quakelive/home/baseq3 && sudo mount -t tmpfs -o size=512M,noatime tmpfs ./demos'
alias mount_donjon='mkdir ~/donjon; sudo mount -t tmpfs -o size=64M,noatime tmpfs ~/donjon && cd ~/donjon && git clone donjon: .'
alias mkchangelog='surf -x -t hgmd.css | read HDSURFXID & (while read; do hoedown CHANGELOG.md > changelog.html; echo xprop -id $HDSURFXID -f _SURF_GO 8s -set _SURF_GO "file://$(pwd)/changelog.html" ; done; rm changelog.html)'
function active_branch {
  echo $(git_current_branch | tr -d "[[:space:]]")
}
function lowercase {
  tr "[:upper:]" "[:lower:]"
}
function active_branch_cleaned {
  echo $(git_current_branch | lowercase | sed "s/[^0-9a-z_-]//g")
}
function graft_branch {
  local branch=${1:-$(active_branch_cleaned)}
  curl --fail -H "Api-Token: $(pass grafter_token)" "http://grafter.dev.promoteapp.net:1414/${branch}"
}
function graft_tail {
  local branch=${1:-$(active_branch_cleaned)}
  local grafter="/home/promote/apps/grafter/release_branch.log"
  local branch_log="/home/promote/apps/promote-release/tmp/branch-${branch}.log /opt/promote/${branch}/shared/log/\*.log"
  ssh grafter "tail -n 100 -F $grafter $branch_log"
}
function graft_flag {
  local branch=${1:-$(active_branch_cleaned)}
  vim scp://grafter//opt/promote/${branch}/shared/config/features_${branch}.yaml

  graft_restart $branch
}
function graft_conf {
  local branch=${1:-$(active_branch_cleaned)}
  vim scp://grafter//opt/promote/${branch}/shared/config/production_${branch}.yaml

  graft_restart $branch
}
function graft_restart {
  local branch=${1:-$(active_branch_cleaned)}
  ssh grafter -t "sudo -u root bash -ilc '/etc/init.d/unicorn_init_${branch} stop; sleep 5; /etc/init.d/unicorn_init_${branch} start; /etc/init.d/delayed_job_${branch} restart; /etc/init.d/sidekiq-${branch} stop; sleep 2; /etc/init.d/sidekiq-${branch} start;'"
}
function vagdestroy {
  local vag=$1
  if [ "$1" = "-h" ]; then echo "Usage: either pass machine name as first argument (noconfirm) or select from list"; fi
  if [ -z "$vag" ]; then
    v=$(cat ~/code/ansible/Vagrantfile | grep define | sed -r 's/^[^"]+"//;s/"[^"]+$//' | fzf)
    echo "Do you want to destroy and rebuild $vag? [Y/n]"
    read a
    if [ -z "$a" -o "$a" = "y" ]; then
      vag=$v
    else
      echo "aborted"
    fi
  fi

  if [ -n "$vag" ]; then
    vagrant halt $vag; vagrant destroy -f $vag; vagrant up $vag
  fi
}
alias giturl='git remote get-url --push origin | sed -r "s/^(git@github.com|hub):/https:\/\/github.com\//; s/.git$//"'
alias hubname='git remote get-url --push origin | sed -r "s/^(git@github.com|hub)://; s/.git$//"'
alias openall='openpr; openci; opengrafter'
alias openpr='browse "$(giturl)/compare/$(active_branch)?expand=1"'
alias opengrafter='browse "https://$(active_branch_cleaned).$GRAFTER_DOMAIN"'
# openci requires a translation dictionary like this, store somewhere and load from your bashrc/zshrc like this
# [[ -e ~/.api_keys ]] && . ~/.api_keys
# typeset -A CI_PROJECTS=(
#     avidity/errbit apps%2Ferrbit
#     key value)
alias openci='browse "https://ci.promoteapp.net/blue/organizations/jenkins/${CI_PROJECTS[$(hubname)]}/activity?branch=$(active_branch)"'
function opendocs {
    browse "https://docs.promoteapp.net/?search=$@"
}
function opencii {
  name=$(printf '%s\n' "$ALL_CI_PROJECTS[@]" | fzf)
  name=${name/\//%2F}
  if [ -n "$name" ]; then
    browse "https://ci.promoteapp.net/blue/organizations/jenkins/$name/activity"
  fi
}
function openwiki {
  browse "$(git remote get-url --push origin | sed -r "s/^(git@github.com|hub):/https:\/\github.com\//; s/(.wiki)?(.git)?$//")/wiki/${1%.md}"
}
alias swatch='(start=$(date +"%s"); echo "00:00"; typeset -Z2 minutes seconds; while true; do sleep 1; total=$(($(date +"%s")-$start)); minutes=$(($total/60)); seconds=$(($total%60)); echo "\e[1A$minutes:$seconds" ; done)'
alias swatch_start='start=$(date +"%s"); typeset -Z2 minutes seconds'
alias swatch_status='total=$(($(date +"%s")-$start)); minutes=$(($total/60)); seconds=$(($total%60)); echo "$minutes:$seconds"'
alias swatch2='swatch_start; while true; do sleep 1; swatch_status ; done)'
alias stopw='(stop=$(date +"%s" -d "$at"); echo "-00:00"; typeset -Z2 minutes seconds; while [ $minutes -gt 0 -o $seconds -gt 0 ]; do sleep 1; total=$(($stop-$(date +"%s"))); minutes=$(($total/60)); seconds=$(($total%60)); echo "-$minutes:$seconds\e[1A" ; done)'
alias ptfinished='jq ".data.stories.stories[] | \" - [\" + (.id | tostring + \"](\") + .url + \") \" + .name" -r'
alias bat='grep CAPACITY= /sys/class/power_supply/BAT*/uevent | cut -d= -f2'
alias batall='cat /sys/class/power_supply/BAT*/uevent'
alias pkgcachesize='(cd /var/cache/pacman/pkg && ls -1 . | sed "s/lib32-/lib32_/" | cut -d"-" -f1 | sed "s/lib32_/lib32-/" | sort -u | while read f; do du -cah $f-* | tail -n1 | sed "s/total/$f/" ; done | sort -h)'
alias rfcsync='rsync -avz --delete ftp.rfc-editor.org::rfcs-text-only ~/code/rfc'
alias pong='while sleep 1 && ! ping 8.8.8.8 -c 1 -w 3; do :; done'
# TODO: this is slightly broken
alias docker-local-docs='docker run -p 4123:4000 docs/docker.github.io:v18.03 &;browse http://0.0.0.0:4123'
alias gbmod='git diff origin/master...HEAD --name-only --diff-filter=DMR | xargs'
#alias i="(cd ~/code/ansible && (pgrep invoker || bundle exec invoker start vagrant.ini -d) && bundle exec invoker"
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))"'

function remote_syncthing {
  remote $1 -L localhost:83$1:localhost:8384
  echo http://localhost:83$1
}
function remote_num {
  printf "6%.3d" $1
}
function remote_help {
  echo "REMOTE SCREENSHOTS"
  echo "  To watch screenshots from 32"
  echo "  remote_sshfs 32"
  echo "  feh ~/remote/32/screenshot.png &"
  echo "  remote_watch 32 (keep running)"
  echo "  remote_listen 32 (keep running)"
  echo "  on server: (can be used as byebug display expression)"
  echo "  save_screenshot('~/code/screenshot.png')"
}
function remote_sshfs {
  if [ -z "$REMOTEIP" ]; then
    local REMOTEIP=$(curl -Ls ipinfo.io | jq -r .ip)
    local d=echo
  fi
  n=$1
  shift
  num=$(remote_num $n)
  $d mkdir -p ~/remote/$n
  $d sshfs vagrant@$REMOTEIP:/home/vagrant/code ~/remote/$n -p ${num}0 $@
}
function remote_watch {
  n=$1
  shift
  num=$(remote_num $n)
  ssh vagrant@$REMOTEIP -p ${num}0 $@ -R 127.0.0.1:7722:127.0.0.1:77$n zsh -ilc remote_watcher
}
function remote_watcher {
  while sleep 0.2; do
    inotifywait -e modify ~/code/screenshot.png && echo reload_feh | nc -c localhost 7722
  done
}
function remote_listen {
  while sleep 0.2; do
    remote_command $(nc -l -p 77$1);
  done
}
function remote_command {
  if [ "$1" == "reload_feh" ]; then
    # reload twice to force reload through sshfs
    xdotool search --name feh sleep 0.5 key r sleep 0.5 key r
  fi
}
function remote {
  if [ -z "$REMOTEIP" ]; then
    local REMOTEIP=$(curl -Ls ipinfo.io | jq -r .ip)
    local d=echo
    set -x
  fi
  # If first argument is a number, connect to guest, otherwise the host
  if [ "$1" -gt 0 ] 2>/dev/null; then
    num=$(remote_num $1)
    shift
    if [ "$#" -eq 0 ]; then
      $d mosh vagrant@$REMOTEIP -p ${num}0:${num}9 --ssh="ssh -p ${num}0" -- tmux new-session -A -s m
    elif [ "$1" == "weechat" ]; then
      export TERM=screen-256color 
      $d mosh vagrant@$REMOTEIP -p ${num}0:${num}9 --ssh="ssh -p ${num}0" -- tmux -L tmux_weechat -f .tmux.weechat.conf new-session -A -s w weechat
    else
      echo "WARNING: using ssh due to arguments, useful with -A"
      $d ssh vagrant@$REMOTEIP -p ${num}0 $@
    fi
  else
    if [ "$#" -eq 0 ]; then
      $d ssh -A $REMOTEIP
    else
      $d ssh -t $REMOTEIP "cd ~/code/remote; $@"
    fi
  fi
}
function remote_save_history {
  remote_pull $1 /home/vagrant/.histfile ~/debug/history/$(dtz)_$1.sh
  cd ~/debug/history
}
function remote_copyid {
  num=$(remote_num $1)
  ssh-copy-id vagrant@$REMOTEIP -p ${num}0
}
function remote_push {
  num=$(remote_num $1)
  scp -r $2 scp://vagrant@$REMOTEIP:${num}0/$3
}
function remote_pull {
  num=$(remote_num $1)
  scp scp://vagrant@$REMOTEIP:${num}0/$2 $3
}
function remote_sync {
  # source
  num1=$(remote_num $1)
  # target
  num2=$(remote_num $2)
  fingerprint=$(ssh-keygen -q -F [$REMOTEIP]:${num2}0)
  ssh -A ssh://vagrant@$REMOTEIP:${num1}0 "(grep -F \"$fingerprint\" ~/.ssh/known_hosts -q || echo \"$fingerprint\" >> ~/.ssh/known_hosts); rsync -ar $3 vagrant@$REMOTEIP:$3 -e \"ssh -p ${num2}0\""
}
function remote_sync_weechat {
  remote_sync $1 $2 .weechat/
}
function print_location {
  printf "\033[0;33m=== $(pwd) @ $(active_branch) | $(git describe 2>/dev/null)\033[0m\n"
}
function all {
  for d in $(cd ~/code/; find ./* -maxdepth 0 -type d); do
    (
      cd ~/code/$d
      print_location
      eval $@
    )
  done
}
# changed repos
function chs {
  for d in $(cd ~/code/; find ./* -maxdepth 0 -type d); do
    (
      cd ~/code/$d
      git diff --cached --exit-code > /dev/null 2>&1 || (
      print_location
      eval $@
    )
  )
  done
}
function ch {
  for d in $(cd ~/code/; find ./* -maxdepth 0 -type d); do
    (
      cd ~/code/$d
      git diff --exit-code > /dev/null 2>&1 || (
      print_location
      eval $@
    )
  )
  done
}

function v {
  local url=${1:-$(xsel)}
  youtube-dl -F "$url"

  mpv "$url" --ytdl-format="248+bestaudio/247+bestaudio"
}

# git branch commit, pushes a simple change as a new pr
# $1: PT story id
function gbc {
  local id="$1"
  echo "gbc: add changes"
  git add -p

  echo "======="
  echo "STAGED:"
  echo "======="
  git diff --cached

  if [ -n "$id" ]; then
    local message=$(story_get $id)
  fi
  if type 'vared' 2>/dev/null | grep -q 'shell builtin'; then
    vared -cp "gbc commit message: " message
  else
    read -p "gbc: commit message" -i "$message" -e message
  fi
  echo "gbc: commit body (ctrl-D to finish)"
  body=$(cat)
  if [ -n "$message" ]; then
    local branch="$(echo $message | lowercase | sed 's/[^a-z]/-/g;s/-\+/-/g;s/\(^-\|-$\)//g')"
    # cleans the branch name
    # replaces everything which isn't a-z, and then removes extra dashes
    git checkout -b "$branch"
    if [ -n "$body" ]; then
      git commit -v -m "$message
      
$body"
    else
      git commit -v -m "$message"
    fi

    git push -u &&
      openpr &&
      (gh pr create -f || true) &&
      git checkout master &&
      git branch -D "$branch"
    echo "To notify slack, use `makepr NR`"
  fi
}
function fast_chromium {
  (
    set -e
    if pgrep chromium; then
      echo "stop chromium first"
      exit 1
    fi
    if [ ! -e ~/.config/chromium_real ]; then
      mv ~/.config/chromium ~/.config/chromium_real
    fi
    if [ ! -e ~/.config/chromium ]; then
      # check required size dynamically?
      mkdir ~/.config/chromium
      sudo mount -t tmpfs -o size=1G,noatime tmpfs ~/.config/chromium
      rsync -a ~/.config/chromium_real/ ~/.config/chromium || true
      du -sh ~/.config/chromium*
    else
      echo "Already mounted"
    fi
  )
}
function fast_chromium_stop {
  (
    set -e
    if pgrep chromium; then
      echo "stop chromium first"
      exit 1
    fi
    if [ -e ~/.config/chromium_real ]; then
      rsync -a ~/.config/chromium/ ~/.config/chromium_real
      sync
      sleep 1
      sudo umount ~/.config/chromium
      rmdir ~/.config/chromium
      mv ~/.config/chromium_real ~/.config/chromium 
    fi
  )
}

function convert_accucheck {
  grep '^[0-9]' D*.csv | \
    sed -r 's/;HI;/;33.3;/;s/;LOW;/;0.0;/;s/([0-9]+).([0-9]+).([0-9]+);([0-9]+:[0-9]+);([^;]*).*/\3-\2-\1T\4:00+0200, \5/'
}

alias test_stuff="xdotool selectwindow windowfocus --sync key F11 sleep 0.1; i3-msg floating enable, fullscreen disable, resize set 500px 1060px, move position 1420px 20px"
alias speedtest="speedtest-cli --secure --simple | awk 'ORS=\", \"' | head -c -2"
