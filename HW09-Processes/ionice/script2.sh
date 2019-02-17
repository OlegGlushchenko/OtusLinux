#!/bin/bash

var2=`dd if=/dev/zero of=/root/second bs=1M count=10240 2>&1 |tail -n 1 | awk '{print $6,$7}' `
echo "Used time script2(-c3): $var2"
rm /root/second -f 
