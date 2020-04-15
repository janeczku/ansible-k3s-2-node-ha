#!/bin/bash
# /etc/keepalived/check_port_available.sh
# check if postgresql port is available

LOG_FILE='/var/log/keepalived/checks.log'
PSQL_PORT="5432"

check_listen_port() {
	local _res=`netstat -tulpn | grep :${1}`
	[[ $? -le 0 ]] && [[ -n "${_res}" ]] && return 0
	return 1
}

check_listen_port "${PSQL_PORT}" || exit 1

exit 0