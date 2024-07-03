#!/bin/sh

export DISPLAY=:0

function main {
  echo r >> ~/locations.txt
  if [ "$#" -eq 1 ]; then
    option $1
  else
    while read -n1 w; do
      option "$w"
    done
  fi
}

function option {
  if [ "$1" = 3 ]; then
    #for i in $(seq 10); do
    #  xdotool click 1 sleep 0.1
    #done
    echo
    :;
  elif [ "$1" = 5 ]; then
    restart_game
    :;
  elif [ "$1" = r ]; then
    restart_game
    :;
  elif [ "$1" = p ]; then
    prune_game
    sleep 0.1
    prune_game
    sleep 0.1
    :;
  elif [ "$1" = k ]; then
    for i in $(seq 10); do
      prune_game
      sleep 0.1
    done
    :;
  elif [ "$1" = c ]; then
    auto_getlocation
    :;
  fi
}

function prune_game {
  click 621 217 0.2
  click 1091 863 0.3
}

function restart_game {
  click 120 89 1.1
  click 1272 826 2.7
  click 658 682 1.4
  prune_game
  click 619 1146 0.9
  click 2376 1333 5.7
  click 1229 998
}

function click {
  local x=$1
  local y=$2
  local sleep=${3:-0.05}
  local count=${4:-1}
  for i in $(seq $count); do
    xdotool mousemove $1 $2 sleep 0.05 click 1 sleep $sleep
  done
  sleep 0.05
}

main $@
