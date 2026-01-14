#!/usr/bin/env fish

set STATUS_FILE "/tmp/laptop-kb-disabled"

if test -f $STATUS_FILE
    echo "OFF"
else
    echo "ON"
end
