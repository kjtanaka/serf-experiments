#!/bin/bash

read line
ADDRESS=$(echo $line | awk '{print $2}')
HOSTNAME=$(echo $line | awk '{print $1}')
LOGFILE=/var/log/serf.log

grep ^"$ADDRESS $HOSTNAME" /etc/hosts
if [[ $? == 0 ]]; then
  sed -i -e "/$ADDRESS $HOSTNAME/d" /etc/hosts
fi

echo "    $(date +%Y/%m/%d %H:%M:%S) [INFO] leave.sh: Deleted $ADDRESS $HOSTNAME from /etc/hosts" >> $LOGFILE
