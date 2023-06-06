#!/bin/sh

water="1165 608"
camp="1163 838"
arrow="1426 732"
waitsleep="1277 1089"
sleepbtn="1473 1082"
n="1282 570"
ne="1387 604"

function main {
  spaceup
  while read -n1 w; do
    if [ $w = w ]; then
      water
    elif [ $w = e ]; then
      eat
    elif [ $w = f ]; then
      wait_8
    elif [ $w = x ]; then
      sleep_12
    elif [ $w = b ]; then
      cycle
    elif [ $w = m ]; then
      for i in $(seq 7); do
        cycle
      done
    fi
  done
  # wait_8
  # sleep_12
  # cycle
}

function water {
  sleep=0.05
  xdotool click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep
  click 1575 967
  click 2090 1356
}

function spacedown {
  xdotool keydown space sleep 0.2
}

function spaceup {
  xdotool keyup space
}

function cycle {
  eat
  sleep_12
  wait_8
  wait_8
  wait_4
}

function drink {
  spacedown
  click $water
  click $n
  spaceup
  sleep 5
}

function eat {
  xdotool type i
  sleep 0.3
  click 688 409
  sleep 0.3
  click 1661 1196
  xdotool sleep 5 key Escape
  # xdotool sleep 1.03 key Escape sleep 1.0 key Escape
  sleep 1
}

function wait_8 {
  drink
  spacedown
  click $camp
  click $water
  spaceup
  click $arrow 7
  click $waitsleep
  # sleep 28 # sleep9
  sleep 24 # sleep8
  #sleep 37
  echo done wait
}

function wait_4 {
  drink
  spacedown
  click $camp
  click $water
  spaceup
  click $arrow 3
  click $waitsleep
  sleep 13 # sleep4
  #sleep 37
  echo done wait
}

function sleep_12 {
  drink
  xdotool click 1 sleep 0.3
  # spacedown
  # click $camp
  # click $n
  # spaceup
  click $arrow 12
  click $sleepbtn
  sleep 11
  echo done wait
}

function click {
  local x=$1
  local y=$2
  local count=${3:-1}
  local sleep=0.05
  for i in $(seq $count); do
    xdotool mousemove $1 $2 sleep $sleep click 1 sleep $sleep
  done
  sleep 0.3
}

function click12 {
  sleep=0.05
  xdotool click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep click 1 sleep $sleep
}

main
