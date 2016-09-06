#!/usr/bin/env bash

usage(){
    echo "volume.sh [up | down | mute]"
    pt=`which pactl`
    pd=`which pacmd`
    if [ -z "$pt" ] || [ -z "$pd" ] ; then
        echo "pactl or pacmd (pulseaudio) not found. script may not work"
    fi
    exit
}

if [ $# != 1 ]; then
    usage
fi

default_sink=$(pactl info | grep -i "default sink" | awk '{print $3}')
current_volume=$(pacmd dump | grep -i "set-sink-volume $default_sink" | awk '{print $3}')
current_volume=$(python2 -c "print int($current_volume)")
max_vol_start=$(python2 -c "print int(0x10000)")
max_vol_end=$(python2 -c "print int(0xf500)")
#${current_volume:2}
volume_delta=5
change=""

is_mute=$(pacmd dump | grep -i "set-sink-mute $default_sink" | awk '{print $3}')
mute_delta='no'
if [ "$is_mute" == 'no' ]; then
    mute_delta='yes'
fi

case "$1" in 
    up)
        if [ $current_volume -ge $max_vol_end ] || 
           [ $current_volume -ge $max_vol_start ] ; then
            `pactl set-sink-volume "$default_sink" 0x10000`
            change=""
        else
            change="+"
        fi
    ;;
    down)
        if [ $current_volume -eq 0 ]; then
            change=""
        else
            change="-"
        fi
    ;;
    mute)
        `pactl set-sink-mute "$default_sink" $mute_delta`
    ;;
esac

if [ -n "$change" ]; then
    `pactl set-sink-volume "$default_sink" $change$volume_delta%`
fi

