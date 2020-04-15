#!/bin/bash
# /etc/keepalived/check_primary_running.sh
# check if node is primary running

node_name="${1:-localhost}"
primary="unknown"

cluster_detail=`repmgr -f /etc/repmgrd.conf cluster show`
if [[ $cluster_detail == *"running as primary"* ]]; then
  echo "Old Master fenced"
  exit 1
fi

cluster_csv=`repmgr -f /etc/repmgrd.conf cluster show --csv`
while read line
do
    node_id="`echo $line | cut -f1 -d,`"
    availability="`echo $line | cut -f2 -d,`"
    state="`echo $line | cut -f3 -d,`"
    if [ "$availability" -eq 0 -a "$state" -eq 0 ]; then
    	primary=`echo "$cluster_detail" | grep "^ $node_id " |  cut -f2 -d\| | sed s/' '//g | tr -d '\n'`
    fi
done <<< "$(echo -e "$cluster_csv")"

if [[ $primary == $node_name ]]; then
  echo "Running as the master"
  exit 0
fi

echo "Not the master"
exit 1
