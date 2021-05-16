#!/bin/bash
echo "run-batch-submitter.js start init..." >> /app/log/t_batch.log
nohup run-batch-submitter.js >> /app/log/t_batch.log &
echo "run-batch-submitter.js start is ok..." >> /app/log/t_batch.log

echo "run.js start init..." >> /app/log/t_msgrelay.log
nohup run.js >> /app/log/t_msgrelay.log &
echo "run.js start is ok..." >> /app/log/t_msgrelay.log