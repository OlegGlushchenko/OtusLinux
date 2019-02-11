#!/bin/bash

dd if=/dev/zero of=/root/file.tmp  bs=100M count=10 2> /dev/null

echo "--------racing-with-different-nice-----" >> cpu_racing.log
nice -n 19  ./cpu_script1.sh &
nice -n -19 ./cpu_script2.sh &

rm /root/file.tmp -f 
