#!/bin/bash

# Set the LAN interface (from the output of ip a)
LAN_INTERFACE="enp10s0"

# Get the LAN connection status
LAN_STATUS=$(nmcli device status | grep -i "$LAN_INTERFACE" | awk '{print $3}')

# Get the current bytes received and transmitted (in bytes)
LAN_RX_PREV=$(cat /sys/class/net/$LAN_INTERFACE/statistics/rx_bytes)
LAN_TX_PREV=$(cat /sys/class/net/$LAN_INTERFACE/statistics/tx_bytes)

# Sleep for a short period to calculate the rate
sleep 1

# Get the current bytes received and transmitted after 1 second
LAN_RX_CURR=$(cat /sys/class/net/$LAN_INTERFACE/statistics/rx_bytes)
LAN_TX_CURR=$(cat /sys/class/net/$LAN_INTERFACE/statistics/tx_bytes)

# Calculate the download and upload speed in MB/s (divide by 1024^2 to convert bytes to MB)
LAN_RX_SPEED=$(echo "scale=2; ($LAN_RX_CURR - $LAN_RX_PREV) / 1024 / 1024" | bc)
LAN_TX_SPEED=$(echo "scale=2; ($LAN_TX_CURR - $LAN_TX_PREV) / 1024 / 1024" | bc)

# Set the appropriate icon based on the connection status
if [[ "$LAN_STATUS" == "connected" ]]; then
    ICON="󰤨 "  # Use Wi-Fi icon for LAN as well
    SPEED="${LAN_RX_SPEED} / ${LAN_TX_SPEED} MB/s"
elif [[ "$LAN_STATUS" == "disconnected" ]]; then
    ICON="󰤭"  # Wi-Fi disconnected icon
    SPEED=""
else
    ICON="󰤭"  # Default disconnected icon
    SPEED=""
fi

# Output the icon and speed
echo "$ICON $SPEED"
