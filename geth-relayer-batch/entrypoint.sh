#!/bin/bash
echo "supervisord starting..."
nohup supervisord -c /etc/supervisor/conf.d/supervisord.conf>/app/log/t_supervisord.log &
echo "log tail..."
tail -f /app/log/t_*.log