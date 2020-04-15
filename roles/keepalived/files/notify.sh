#!/bin/bash
# /etc/keepalived/notify.sh
# Notification Handler

log_file='/var/log/keepalived/notify.log'

readonly type="$1"
readonly name="$2"
readonly state="$3"

log_msg() {
    msg=$1
    date=`date +%Y-%m-%dT%H:%M:%S`
    msg="${date} : ${msg}"
    echo $msg >> $log_file
}

case $state in
        "MASTER") log_msg "host has been assigned the role of master"
                  exit 0
                  ;;
        "BACKUP") log_msg "host has been assigned the role backup"
                  exit 0
                  ;;
        "FAULT")  log_msg "host has been suspended as faulty"
                  exit 0
                  ;;
        *)        echo "unknown state"
                  exit 1
                  ;;
esac
