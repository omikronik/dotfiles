#!/usr/bin/env fish

set STATUS_FILE "$XDG_RUNTIME_DIR/keyboard.status"

if test -f $STATUS_FILE
    set kb_status (cat $STATUS_FILE)
    if test $kb_status = "true"
        echo "ON"
    else
        echo "OFF"
    end
else
    echo "ON"  # Default state if file doesn't exist
end
