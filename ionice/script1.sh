#!/bin/bash

var1=`dd if=/dev/zero of=/root/first bs=1M count=10240 2>&1 |tail -n 1 | awk '{print $6,$7}' `
echo "Used time script1 (-c1): $var1"
rm /root/first -f 
