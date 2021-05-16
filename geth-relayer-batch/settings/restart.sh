#!/bin/bash
while IFS== read -r key value; do
    export $key=$value
done < $1
#IP
#HOST=`hostname`
#HOST='http://127.0.0.1'
#IP="$HOST:$RPC_PORT"
#export L2_NODE_WEB3_URL=$IP

#kill all
ps -ef | grep geth | grep verbosity | grep -v grep | awk '{print $2}' | xargs kill # -9
ps -ef | grep run-batch-submitter.js | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep run.js | grep -v grep | awk '{print $2}' | xargs kill

#start all
t1=$(($(date +%s%N)/1000000))
echo "starting at $t1 .."

echo "/bin/wait-for-l1.sh /bin/start-geth.sh $1">>/app/log/t_supervisord.log
/bin/wait-for-l1.sh /bin/start-geth.sh $1

t2=$(($(date +%s%N)/1000000))
echo "l2 started at $t2 ..">>/app/log/t_supervisord.log
takes=`expr $t2 - $t1`
echo "l2 takes $takes ms">>/app/log/t_supervisord.log

echo "/bin/wait-for-l1-and-l2.sh /bin/start-others.sh $1">>/app/log/t_supervisord.log
/bin/wait-for-l1-and-l2.sh /bin/start-others.sh $1

t2=$(($(date +%s%N)/1000000))
echo "end at $t2 ..">>/app/log/t_supervisord.log
takes=`expr $t2 - $t1`
echo "restart takes $takes ms">>/app/log/t_supervisord.log
