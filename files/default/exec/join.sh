#!/bin/bash

read line
ADDRESS=$(echo $line | awk '{print $2}')
HOSTNAME=$(echo $line | awk '{print $1}')
LOGFILE=/var/log/serf.log

grep ^"$ADDRESS $HOSTNAME" /etc/hosts
if [[ $? != 0 ]]; then
  echo "$ADDRESS $HOSTNAME" >> /etc/hosts
fi

echo "    $(date +%Y/%m/%d %H:%M:%S) [INFO] join.sh: Added $ADDRESS $HOSTNAME on /etc/hosts" >> $LOGFILE
