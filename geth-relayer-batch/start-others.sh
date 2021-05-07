#!/bin/bash
source $1

nohup run-batch-submitter.js >> /app/log/t_batch.log &
nohup run.js >> /app/log/t_msgrelay.log &
