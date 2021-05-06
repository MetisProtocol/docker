#!/bin/bash
source $1

#kill all
ps -ef | grep geth | grep verbosity | grep -v grep | awk '{print $2}' | xargs kill # -9
ps -ef | grep run-batch-submitter.js | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep run.js | grep -v grep | awk '{print $2}' | xargs kill

#start all
t1=$(($(date +%s%N)/1000000))
echo "starting at $t1 .."

/bin/wait-for-l1.sh

/bin/start-geth.sh &

/opt/wait-for-l1-and-l2.sh

t2=$(($(date +%s%N)/1000000))
echo "l2 started at $t2 .."
takes=`expr $t2 - $t1`
echo "l2 takes $takes ms"

/bin/start-others.sh &

t2=$(($(date +%s%N)/1000000))
echo "end at $t2 .."
takes=`expr $t2 - $t1`
echo "restart takes $takes ms"

env