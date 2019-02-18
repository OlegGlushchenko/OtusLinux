#!/bin/bash
echo "--------racing-with-different-ionice-----" >> io_racing.log
ionice -c1 -n0 ./script1.sh >> io_racing.log &
ionice -c3 ./script2.sh >> io_racing.log &
