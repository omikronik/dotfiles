#!/usr/bin/env fish

set LAPTOP_KB "at-translated-set-2-keyboard"
set STATUS_FILE "/tmp/laptop-kb-disabled"

if test -f $STATUS_FILE
    # enable it
    hyprctl keyword "device:$LAPTOP_KB:enabled" true
    rm $STATUS_FILE
    notify-send "Laptop Keyboard" "enabled" -t 2000
else
    # disable it
    hyprctl keyword "device:$LAPTOP_KB:enabled" false
    touch $STATUS_FILE
    notify-send "Laptop Keyboard" "disabled" -t 2000
end
