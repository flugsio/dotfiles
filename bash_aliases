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
  elif [ "$1" = "l" ]; then
    ls ~/Sync/h
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
function ci {
  local job=$(ci_parse_job "$2")
  local build=${3:-lastBuild}
  if [ "$1" = "log" ]; then
    if [[ "$2" == $CI_URL* ]]; then
      # target
      # job=/job/upkeep/job/promote-testrun
      # build=58390
      if [[ "$2" == */blue/organizations* ]]; then
        # from https://ci.promoteapp.net/blue/organizations/jenkins/upkeep%2Fpromote-testrun/detail/promote-testrun/58390/pipeline
        job=$(echo "$2" | sed "s#$CI_URL/blue/organizations/jenkins/#/job/#" | sed "s#/detail/.*##" | sed "s#%2F#/job/#")
        build=$(echo "$2" | grep -Po "\d*(?=\/pipeline)" )
      else
        # from https://ci.promoteapp.net/job/upkeep/job/promote-testrun/58390/"
        job=$(echo "$2" | sed "s#$CI_URL##" | sed -E "s#/[[:digit:]]+/\$##")
        # 58390
        build=$(echo "$2" | grep -Po "\d*(?=\/$)" )
      fi
    fi
    #local url="${CI_URL}${job}/$build/logText/progressiveText"
    #curl -LIs ${url}?start=308000 -L --user $JENKINS_USERTOKEN
    curl -Ls ${CI_URL}${job}/$build/logText/progressiveText?start=0 -L --user $JENKINS_USERTOKEN
    #curl -s ${CI_URL}${job}/$build/logText/$MODE -L --user $JENKINS_USERTOKEN
  elif [ "$1" = "api" ]; then
    curl -s ${CI_URL}/$2/api/json -L --user $JENKINS_USERTOKEN
  elif [ "$1" = "build" ]; then
    set -x
    build="build"
    curl -XPOST -s ${CI_URL}${job}/$build -L --user $JENKINS_USERTOKEN
  elif [ "$1" = "buildparam" ]; then
    curl -XPOST -s ${CI_URL}${job}/buildWithParameters -L --user $JENKINS_USERTOKEN \
      -F "$build"
  elif [ "$1" = "fail" ]; then
    shift
    ci log $@ | grep -Po "(?<=^rspec ).*?(?= #)" | sort | uniq
  elif [ "$1" = "failures.txt" ]; then
    curl -Ls ${CI_URL}${job}/$build/artifact/failures.txt -L --user $JENKINS_USERTOKEN | sort | uniq
  elif [ "$1" = "error" ]; then # for vim
    shift
    ci log $@ | grep -Po "(?<=^rspec ).*" | sort | uniq
  elif [ "$1" = "errors" ]; then # for vim
    shift
    ci log $@ | grep -Po "(?<=^rspec ).*" | sort | uniq -c
  else
    echo "no such command"
  fi
}

function ci_parse_job {
  if [ -n "$1" ] && [ "$1" != "." ]; then
    echo "/job/${1//\///job/}"
  else
    echo "/job/${CI_PROJECTS[$(hubname)]//\%2F//job/}/job/$(active_branch)"
  fi
}

function pt {
  # wrap pt, to reuse the same .pt file
  (cd ~/code && command pt $@)
}

function mo {
  local prefix=''
  # for mmonit 3.7.1+
  #local prefix='/api/1'
  if [ -z "$1" ]; then
    curl -sb "$MONIT_COOKIE" "${MONIT_URL}${prefix}/status/hosts/list" | \
      jq '.records[] | select(.led != 2) | [(.hostname | sub(".promoteapp.net"; "")), .led, .statusid, .status] | @csv' -r | \
      column -s, -t
  elif [ "$1" = "list" ]; then
    curl -sb "$MONIT_COOKIE" "${MONIT_URL}${prefix}/status/hosts/list"
  elif [ "$1" = "login" ]; then
    curl -sc "$MONIT_COOKIE" "${MONIT_URL}/index.csp"
    curl -sb "$MONIT_COOKIE" \
      -d z_username="$MONIT_USERNAME" \
      -d z_password="$(pass $MONIT_PASS_NAME | head -n1)" \
      -d z_csrf_protection=off \
      -d z_remember_me=on \
      "${MONIT_URL}/z_security_check"
  else
    echo "no such command"
  fi
}

function err {
  errb re $@
}
function erp {
  errb prod $@
}
function errb {
  target=$1
  action=$2
  if [ "$target" = "remote" ]; then
    token=$REMOTE_ERRBIT_TOKEN
    url=$REMOTE_ERRBIT_URL
  elif [ "$target" = "prod" ]; then
    token=$PROD_ERRBIT_TOKEN
    url=$PROD_ERRBIT_URL
  else
    echo "no such target"
    return 1
  fi

  if [ "$action" = "show" ]; then
    # TODO:
    curl -G -d "auth_token=$token" \
      "$url/apps/5d8258c14c851100075f6c9f/problems/5fc76bebb674770007b4acbc"
  elif [ "$action" = "createapp" ]; then
    local name="$3"
    local repo="$4"
    local api_key="$5"
    local service_url="$6"
    local service_type="$7"
    if [ -n "$service_url" ] && [ -z "$service_type" ]; then
      service_type="NotificationServices::SlackService"
    fi
    # TODO:
    #curl -G -d "auth_token=$token" \
    #  -d "app[name]=$name" \
    #  -d "app[github_repo]=$repo" \
    #  -d "app[api_key]=$api_key" \
    #  "https://errbit.promoteapp.net/apps/search"
    #return
    curl -XPOST -d "auth_token=$token" \
      -d "app[name]=$name" \
      -d "app[github_repo]=$repo" \
      -d "app[api_key]=$api_key" \
      -d "app[notification_service_attributes][type]=$service_type" \
      -d "app[notification_service_attributes][service_url]=$service_url" \
      "$url/apps"
  fi
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
function gmain {
  # origin/HEAD might not exist if remote was added instead of cloning
  # git remote set-head origin -a
  git symbolic-ref refs/remotes/origin/HEAD | sed 's#.*/##'
}
function gp {
  git checkout $(gmain)
  git pull -p
  cleanup
}
function gf {
  git fetch
  cleanup
}
function cleanup {
  local branch
  for branch in $(git branch --merged | grep -Pv "^(master|main|$(gmain))$" | grep -v "^\*"); do
    git branch -d $branch
  done
}

# invoker aliases
function i {
  if command -v frum >/dev/null 2>&1; then
    (frum local 3.3.2; invoker $@)
  else
    (rbenv shell 3.3.2; invoker $@)
  fi
}
alias istart='i start all -d'
alias iw='alias i{r,l,s,a,clear,log}; echo iA=run interactively'
alias il='i list'
alias ill='i list -r | grep -Po "(?<=Name |PID : ).*" | sed "/: /{N;s/\n/, /}" | column | ack --passthru Not'
# These work on the argument list, or DEFAULT_RELOAD if set, or fallbacks to current directories processes
function ir {
  for s in ${*:-${DEFAULT_RELOAD:-$(ihere)}}; do echo reload $s; i reload $s; done
}
function is {
  for s in ${*:-${DEFAULT_RELOAD:-$(ihere)}}; do echo remove $s; i remove $s; done
}
function ia {
  for s in ${*:-${DEFAULT_RELOAD:-$(ihere)}}; do echo add $s; i add $s; done
}
function icom {
  sed -n "/\[$1\]/,/^\[/p" ~/.invoker/all.ini | grep -Po "(?<=^command = ).*";
}
function iA {
  is $1; eval " $(icom $1)";
}
alias iclear='pkill -f "^tail.*.invoker/invoker.log"'
alias ilog='tmux move-window -t9; while true; do clear; tmux clear-history; tail -n0 -F ~/.invoker/invoker.log; done'
alias ilist="cat ~/.invoker/all.ini | sed -rn '/^\[/{N;s/\[([^]]*)\]\ndirectory = (.*)$/\1 \2/;p}'"
# List of all processes in invoker's all.ini, filtered by the current directory name
function ihere {
  local p=$(pwd | sed "s#$HOME#~#")
  ilist | grep -E "$p($|\/)" | cut -f1 -d' ' | xargs echo
}

# docker aliases
function phere {
  case "$PWD" in
    *control-center)
      echo cc
      ;;
    *promote)
      echo promote
      ;;
    *promote-gud)
      echo gud
      ;;
    *promote-mimir)
      echo mimir
      ;;
    *fetch)
      echo fetch
      ;;
    *)
      echo promote
      ;;
  esac
}
function doco {
  (
    if [[ $PWD != *promote-docker* ]]; then
      cd ~/code/promote-docker
    fi
    docker-compose $@
  )
}
# docker start
alias dos='doco up -d $(phere)'
# TODO: project name
alias dor='doco run -T --rm --no-deps $(phere)-base '
alias dobe='dor bundle exec '
alias dop='doco run --rm --no-deps --env="PGPASSWORD=$(phere)" $(phere)-db psql -h $(phere)-db -U $(phere) $(phere)_dev'
function dol {
  doco logs --tail 200 --follow; sleep 1; dol
}
function dorsi {
  xhost +local:root
  docker-compose run --rm --no-deps \
    --env="DISPLAY" --env="SHOW_BROWSER=1" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    promote-base bundle exec rspec $@
  xhost -local:root
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
  if command -v i3-msg >/dev/null 2>&1; then
    i3-msg move workspace $name, workspace $name || true
  fi
  vim log.md
}
# workaround frum with cd .
function be {
  cd .;  bundle exec $@
}
function ber {
  cd .; bundle exec rake $@
}
function bb {
  cd .; bundle exec rspec $(ack byebug\$ spec --output=:: | sed s/::://) $@
}
function berci {
  cd .; bundle exec rspec $(ci fail | xargs) $@
}
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
function bed {
  cd .; bundle exec rails db $@
}
function bec {
  cd .; bundle exec rails console $@
}
alias brow='surf -x $url 2> /dev/null & firefox $url & chromium $url &'
alias tag='([ -f tags ] && echo "Preparing tags" && ctags -R --exclude="@.gitignore" --exclude="@$HOME/.gitignore" || true)'
alias bun='cd .; (bundle check || bundle install); mkbunlinks'
alias yar='([ -f yarn.lock ] && yarn install --check-files || true)'
alias mig='ber db:migrate'
alias unmig='ber db:rollback'
alias i18='ber i18nlite:sync i18nlite:clear_cache'
alias tes='ber db:migrate RAILS_ENV=test'
alias dbdiff='git --no-pager diff db/schema.rb'
alias remig='ber db:migrate && dbdiff && unmig && dbdiff && ber db:migrate && dbdiff'
alias revert_schema='dbdiff && git checkout db/schema.rb'
alias aup='bun; yar; ber db:migrate; ber i18nlite:sync; ber db:migrate RAILS_ENV=test; revert_schema; tag &'
alias gpar='gp; aup; ir'
alias wha='echo bun, mig, i18, aup=after update, remig=rerun migration, tes=after update for tests, gpar=git pull aup and restart, ran=vimt ranger'
alias vimt='DISPLAY=:0 \vim --servername $(tmux display-message -p "#S")'
alias ran='EDITOR="tmux_editor" ranger --cmd="map J chain move down=1 ; move right=1" --cmd="map K chain move up=1 ; move right=1" --cmd="set preview_files false" --cmd="set display_size_in_main_column false"'
alias view_shots='ranger --cmd="set column_ratios 1,5" --cmd="set display_size_in_main_column false" ~/shots'
alias mux='tmuxinator'
alias windows='rdesktop 192.168.1.189 -u Administrator -k sv -g 2555x1400 -r sound:off'
alias windows2='rdesktop 192.168.1.188 -u Avidity -k sv -g 2550x1380 -r sound:off'
alias mkbunlinks='if [ -f "Gemfile" ]; then mkdir -p bunlinks && find bunlinks -type l -delete && cd bunlinks && bundle list --paths | xargs -L1 ln -s; cd .. ; else echo "not in Gemfile directory"; fi'
alias perrbit='cd ~/code/promote3 && xsel > errbit_error.txt && vim errbit_error.txt -c "%s/\v^(.*gems.*gems\/)?([^(-)]*-\d\.)/bunlinks\/\2/e | %s/\v^([^(bunlinks|\/opt)].)/\1/e | %s/\v^\/opt\/promote\/releases\/\d+T\d+\///e | w | set errorformat=%f:%l%m | cbuffer | copen" && rm errbit_error.txt'
alias cop='bun && be rubocop > rubocop_error.txt; vim rubocop_error.txt -c "set errorformat=%f:%l%m | cbuffer | copen" && rm rubocop_error.txt'
function failvim {
  if [ $# = 0 ]; then
    ci failures.txt
  else
    for build in $@; do
      ci failures.txt "" $build
    done
  fi | sort | uniq | vim - -c "set errorformat=%f:%l%m | cbuffer! | bd! 1 | copen"
}
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
    i3-msg floating enable border none resize set $size
    echo "click on window again to start recording"
  fi
  local audio=${2:-audio} # audio, noaudio
  local frames=${3:-30}

  if [ "$what" = "area" ]; then
    local potatoes=$(eval $(xdotool selectwindow getmouselocation --shell | grep "[XY]=" | sed "s/^/A/"; xdotool selectwindow getmouselocation --shell | grep "[XY]=" | sed "s/^/B/"); echo "-s $(($BX-$AX))x$(($BY-$AY)) -r $frames -i :0.0+$AX,$AY")
  elif [ "$what" = "window" ]; then
    local potatoes=$(eval $(xdotool selectwindow getwindowgeometry --shell); echo "-s ${WIDTH}x${HEIGHT} -r $frames -i :0.0+nomouse+$X,$Y")
  else
    local potatoes="-s $what -r $frames -i :0.0"
  fi

  if [ "$audio" = "audio" ]; then
    local sauce="-f pulse -i alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_3__sink.monitor"
    local sauce="-f pulse -i alsa_output.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.iec958-stereo.monitor"
  elif [ "$audio" = "noaudio" ]; then
    local sauce=""
  else
    echo "wrong syntax: area/window/size/(resize+size) audio/noaudio [frames]"
    exit 1
  fi
  local extra="-acodec ac3 -vcodec libx264 -preset ultrafast -crf 24 -threads 0"
  local filename="output-$(date +%s)"
  local output="/tmp/${filename}.mov"
  local compressed="$HOME/${filename}c.mov"
  echo "executing in 1 second ffmpeg $sauce -f x11grab $potatoes $extra $output 2>&1"
  sleep 1
  eval "ffmpeg $sauce -f x11grab $potatoes $extra $output"
  echo "start compressing? (ctrl-c to cancel)"
  read i
  if [ "$audio" = "audio" ]; then
    #ffmpeg -i "$output" -c copy -vcodec libx264 -crf 24 -max_muxing_queue_size 4096 ${compressed}
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
alias mount_donjon='mkdir ~/donjon; sudo mount -t tmpfs -o size=256M,noatime tmpfs ~/donjon && cd ~/donjon && git clone git@github.com:promoteinternational/donjon .'
alias mkchangelog='surf -x -t hgmd.css | read HDSURFXID & (while read; do hoedown CHANGELOG.md > changelog.html; echo xprop -id $HDSURFXID -f _SURF_GO 8s -set _SURF_GO "file://$(pwd)/changelog.html" ; done; rm changelog.html)'
function active_branch {
  if [ -z "$B" ]; then
    echo $(git_current_branch | tr -d "[[:space:]]")
  else
    echo "$B"
  fi
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
function graft_log_release {
  local branch=${1:-$(active_branch_cleaned)}
  local release_log="/home/promote/apps/promote-release/tmp/branch-${branch}.log"
  ssh grafter "cat $release_log"
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
function sus() {
  sort | uniq -c | sort $@
}
alias giturl='git remote get-url --push origin | sed -r "s/^(git@github.com|hub):/https:\/\/github.com\//; s/.git$//"'
alias hubname='git remote get-url --push origin | sed -r "s/^(git@github.com|hub)://; s/.git$//"'
alias openall='openpr; openci; opengrafter'
alias openpr='browse "$(giturl)/compare/$(active_branch)?expand=1"'
alias opengrafter='browse "https://$(active_branch_cleaned).$GRAFTER_DOMAIN"'
function openpt {
  browse http://www.pivotaltracker.com/story/show/$(task export active | jq -r '.[0].pivotalid // ""')
}
# openci requires a translation dictionary like this, store somewhere and load from your bashrc/zshrc like this
# [[ -e ~/.api_keys ]] && . ~/.api_keys
# typeset -A CI_PROJECTS=(
#     avidity/errbit apps%2Ferrbit
#     key value)
alias openci='browse "$CI_URL/blue/organizations/jenkins/${CI_PROJECTS[$(hubname)]}/activity?branch=$(active_branch)"'
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

function measure_downtime {
  echo "Starting uptime clock"
  local url=$1
  local interval=${2:-1}
  swatch_start
  while curl "$url" -k -IL -f -s &>/dev/null; do
    sleep $interval
    swatch_status
  done
  echo "Going down after waiting:"
  swatch_status
  echo "Starting downtime clock"
  swatch_start
  sleep 1 # some padding
  while curl "$url" -k -IL -f >&/dev/null; test $? -ne 0; do
    sleep $interval
    swatch_status
  done
  echo "Service recovered after:"
  swatch_status
}
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

function update_gluj {
  curl https://scout-32.remote4.promoteapp.net/api/v1/entries.json?count=100 | jq '.[] | (select(.type == "sgv") | [.sysTime, (.sgv/18*10|round/10)]), (select(.type == "mbg") | [.sysTime, (.mbg/18*10|round/10)]) | @csv' -r | sponge ~/.glucose
}
function watch_gluj {
  source ~/.bash_aliases
  while sleep 1; do
    update_gluj;
    sleep 1m;
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
  local opts="$2"
  echo "gbc: add changes"
  git add -p

  echo "======="
  echo "STAGED:"
  echo "======="
  git diff --cached

  if [ -z "$id" ]; then
    local id="$(task export active | jq -r '.[0].pivotalid // ""')"
  fi
  if [ -n "$id" ] && [ "$id" != - ]; then
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
    local branch="je-$(echo $message | lowercase | sed 's/[^a-z]/-/g;s/-\+/-/g;s/\(^-\|-$\)//g')"
    if [ "$opts" = "skip" ]; then
      branch="$branch-skip-ui-grafter"
    elif [ "$opts" = "skip-ui" ]; then
      branch="$branch-skip-ui"
    elif [ "$opts" = "skip-grafter" ]; then
      branch="$branch-skip-grafter"
    fi
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
      #openpr &&
      (gh pr create -f || true)
         # &&
      #git checkout master &&
      #git branch -D "$branch"
      #while sleep 4; do
      #  gh pr checks | grep pass && break || echo not yet
      #done
    #echo "To notify slack, use `makepr NR`"
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
# taskwarrior gtd
# https://cs-syd.eu/posts/2015-06-14-gtd-with-taskwarrior-part-1-intro.html
alias tin='task add +in rc.context:none'
alias tin_count='task +in +PENDING count'
function tickle () {
  deadline=$1
  shift
  tin +tickle wait:$deadline $@
}
alias tick=tickle
# for yes/no questions
alias think='tickle +1d'
function task_property {
  local id=$1
  local property=$2
  task export $id | jq ".[] .$property" -r
}
function story_start_task {
  set -x
  local pt_id="$1"
  if [ -z "$pt_id" ]; then
    echo "no pt id specified"
    return
  fi

  local task_id=$(task pivotalid:$pt_id export | jq 'first | .id')
  if [ "$task_id" = 0 ]; then
    echo "task story exist but is completed"
    return
  fi
  if [ "$task_id" = null ]; then
    # create new task
    local pt_story=$(pt_get_story $pt_id)
    local pt_name=$(echo -E "$pt_story" | jq -r .name)
    local pt_description=$(echo -E "$pt_story" | jq -r .description)
    if [ "$pt_name" = null ]; then
      echo "missing name or description"
      return
    elif [ -n "$pt_name" ] && [ -n "$pt_description" ]; then
      task add pivotalid:$pt_id $pt_name
      task_id=$(task +LATEST ids)
      if [ -n "$task_id" ]; then
        if [ "$pt_description" != null ]; then
          task annotate $task_id $pt_description
        fi
        task start $task_id
      fi
    else
      echo "no such pt story"
      return
    fi
  else
    task start $task_id
  fi
  #pt start $pt_id
}

function pt_get_story {
  local story_id="$1"
  curl -X GET -H "X-TrackerToken: $PT_TOKEN" \
    -H "Content-Type: application/json" \
    "https://www.pivotaltracker.com/services/v5/projects/$PT_PROJECT_ID/stories/$story_id"
}

function convert_accucheck {
  grep '^[0-9]' D*.csv | \
    sed -r 's/;HI;/;33.3;/;s/;LOW;/;0.0;/;s/([0-9]+).([0-9]+).([0-9]+);([0-9]+:[0-9]+);([^;]*).*/\3-\2-\1T\4:00+0200, \5/'
}

alias test_stuff="xdotool selectwindow windowfocus --sync key F11 sleep 0.1; i3-msg floating enable, fullscreen disable, resize set 500px 1060px, move position 1420px 20px"
alias speedtest="speedtest-cli --secure --simple | awk 'ORS=\", \"' | head -c -2"
alias cam="mpv --demuxer-lavf-o-set='input_format=mjpeg' /dev/video0"
function ffmpeg_to_mov {
  local input="$1"
  ffmpeg -i "$input" -c copy -vcodec libx264 -crf 24 "$(basename $input).mov"
}
function hi {
  source-highlight -s html -f esc
}
function perf {
  watch -n 0.5 'cat /sys/firmware/acpi/platform_profile; (cat /proc/acpi/ibm/fan | grep speed -A1); cat /proc/acpi/ibm/thermal; (cat /proc/cpuinfo | grep MHz)'
}
alias bell='echo -e "\a"'
function slack_delete {
  echo "timestamp?"
  read ts
  echo "which channel?"
  channel=$(echo -e "main\nstatus\nnotifications" | fzf)
  if [ "$channel" = main ]; then
    recipient=$SLACK_MAIN_FLOW
  elif [ "$channel" = status ]; then
    recipient=$SLACK_DEVSTATUS
  else
    recipient=$SLACK_DEVNOTI
  fi

  echo "which account?"
  account=$(echo -e "own\njenkins" | fzf)
  if [ "$account" = jenkins ]; then
    token=$SLACK_PROMOTEINT_JENKINS_TOKEN
  else
    token=$SLACK_PROMOTEINT_TOKEN
  fi
  curl -d "token=${token}" -d "channel=$recipient" -d ts="$ts" https://slack.com/api/chat.delete
}
