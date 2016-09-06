#!/usr/bin/env bash

usage(){
    echo "brightness.sh [up | down]"
    exit 1
}

if [ $# != 1 ]; then
    usage
fi

case "$1" in
    up)
       xbacklight -inc 10
    ;;
    down)
        xbacklight -dec 10
    ;;
esac

