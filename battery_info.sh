#/bin/sh
battery_dir="/sys/class/power_supply/BAT0"
[ -d "$battery_dir" ] && percent=$(cat "$battery_dir/capacity") || percent=100
echo "$percent%"
