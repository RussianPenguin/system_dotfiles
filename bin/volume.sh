#!/bin/sh
echo $(amixer -D pulse get Master | awk -F'[]%[]' '/%/ {if ($5 == "off") { print "MM" } else { print $2 "%" }}' | head -n 1)

