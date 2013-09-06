alias t='tig --all'
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
