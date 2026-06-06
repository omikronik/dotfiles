#!/usr/bin/env fish

set -x STATUS_FILE "$XDG_RUNTIME_DIR/keyboard.status"


function enable_keyboard
    printf "true" >$STATUS_FILE
    notify-send "Built-in Keyboard" "Enabling Keyboard"
    hyprctl eval "hl.device({name='at-translated-set-2-keyboard', enabled=true})"
    pkill -SIGRTMIN+8 waybar
end

function disable_keyboard
    printf "false" >$STATUS_FILE
    notify-send "Built-in Keyboard" "Disabling Keyboard"
    hyprctl eval "hl.device({name='at-translated-set-2-keyboard', enabled=false})"
    pkill -SIGRTMIN+8 waybar
end

if not test -f $STATUS_FILE
    enable_keyboard
else
    set kb_status (cat $STATUS_FILE)
    if test $kb_status = "true"
        disable_keyboard
    else if test $kb_status = "false"
        enable_keyboard
    end
end
