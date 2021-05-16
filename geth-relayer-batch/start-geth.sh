#!/bin/bash
echo "geth start init..." >> /app/log/t_geth.log
# geth --verbosity=10 &
ROLLUP_STATEDUMP="https://metis-us-east-2-json.s3.us-east-2.amazonaws.com/contracts.dump.json"
VERBOSITY="10"
cmd="geth --verbosity=$VERBOSITY"
if [ ! -z "$ROLLUP_STATEDUMP" ]; then
    cmd="$cmd --rollup.statedumppath=$ROLLUP_STATEDUMP"
fi
echo $cmd
nohup $cmd >> /app/log/t_geth.log &
echo "geth start is ok..." >> /app/log/t_geth.log