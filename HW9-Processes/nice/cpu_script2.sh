#!/bin/bash

(time md5sum /root/file.tmp) > /dev/null 2>> cpu_racing.log 
echo "----I'am -19 nice----" >> cpu_racing.log
