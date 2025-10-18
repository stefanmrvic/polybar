#!/bin/bash

X_OFFSET=1170
BAR_HEIGHT=35

if pgrep -x "stalonetray" > /dev/null; then
    killall stalonetray
else
    stalonetray --geometry 1x1+"$X_OFFSET"-"$BAR_HEIGHT" &
fi

# Trigger polybar to update the module
polybar-msg action "#tray-toggle.hook.0" &>/dev/null