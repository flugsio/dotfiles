#!/bin/sh

water="1165 608"
camp="1163 838"
arrow="1426 732"
waitsleep="1277 1089"
sleepbtn="1473 1082"
n="1282 570"
ne="1387 604"

b1="1072 1040"
b2="2279 424"
b3="2066 1068"

function main {
  #spaceup
  echo f = froth
  echo i = fill
  echo e = empty
  while read -n1 w; do
    if [ $w = f ]; then
      froth
    elif [ $w = r ]; then
      r
    elif [ $w = i ]; then
      fill
    elif [ $w = e ]; then
      empty
    elif [ $w = b ]; then
      cycle
    elif [ $w = m ]; then
      for i in $(seq 7); do
        cycle
      done
    elif [ $w = y ]; then
      for i in $(seq 100); do
        # click $b1
        # sleep 0.1
        # click $b2
        # sleep 0.1
        # click $b3
        # sleep 0.1
        xdotool click 1 sleep 0.1
        # xdotool sleep 0.1 key Escape
      done
    fi
  done
  # wait_8
  # sleep_12
  # cycle
}

function cycle {
  fill
  froth
  empty
}

function set_down {
  #down_little
  xdotool click 1 sleep 0.5
  #up_little
}

function right {
  xdotool mousemove_relative --sync 80 0 sleep 0.2
}

function left {
  xdotool mousemove_relative --sync -- -80 0 sleep 0.2
}

function down {
  xdotool mousemove_relative --sync 0 250 sleep 0.2
}

function down_little {
  xdotool mousemove_relative --sync 0 20 sleep 0.2
}

function up_little {
  xdotool mousemove_relative --sync 0 -20 sleep 0.2
}

function r {
  xdotool keydown r sleep 1.4 keyup r
}

function fill {
  right
  r
  left
  r
  right
  set_down
  left
}

function froth {
  r
  sleep=0.10
  xdotool type f
  for i in $(seq 14); do
    xdotool sleep $sleep type e
  done
  sleep 0.1
  down
  sleep 0.1
}

function empty {
  left
  r
  r
  right
  set_down
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

function oldcycle {
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
