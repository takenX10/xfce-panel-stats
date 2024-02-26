#!/bin/bash

readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

readonly ICON="${DIR}/icons/"

HD=$(df -Hl / | grep / | awk '{printf ("%02d", $5)}'| tr % \ )
HDUSED=$(df -Hl / | grep / | awk '{print $3}' | sed -e 's/G/GB/')
HDSIZE=$(df -Hl /  | grep / | awk '{print $2}'| sed -e 's/G/GB/')
echo -en "<txt>|   <span fgcolor='"
if [[ $(bc <<< "$HD > 70")  == "1" ]]
then
        echo -n "Red"
elif [[ $(bc <<< "$HD > 50") == "1" ]]
then
        echo -n "Yellow"
else
        echo -n "Green"
fi
echo -en "'> DISK: <span font-weight='bold'> $HDUSED / $HDSIZE  ($HD%)</span></span>   |   "

v2=$(free | grep Mem | awk '{printf("%d", $2)}')
v4=$(free | grep Mem | awk '{printf("%d",$3)}')
perc=$(free | grep Mem |  awk '{ printf("%.1f", $3/$2 * 100.0) }' | tr , .)
echo -en "<span fgcolor='"
if [[ $(bc <<< "$perc > 80")  == "1" ]]
then
        echo -n "Red"
elif [[ $(bc <<< "$perc > 55") == "1" ]]
then
        echo -n "Yellow"
else
        echo -n "Green"
fi
echo -en "'> RAM: <span font-weight='bold'>$perc%</span></span>   |    "

perc=`awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) ""; }' <(grep 'cpu ' /proc/stat) <(sleep 0.2;grep 'cpu ' /proc/stat) | tr . ,`
perc=`printf "%.1f" $perc | tr , .`

echo -en "<span fgcolor='"
if [[ $(bc <<< "$perc > 70")  == "1" ]]
then
        echo -n "Red"
elif [[ $(bc <<< "$perc > 40") == "1" ]]
then
        echo -n "Yellow"
else
        echo -n "Green"
fi
echo -en "'>CPU: <span font-weight='bold'>$perc%</span></span>   </txt>"
