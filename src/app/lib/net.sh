#!/bin/bash

net::bridge_ip(){
	echo $HORDE_IP
}

net::default_dns() {
	local dns=8.8.8.8

	if [ ! -z "$HORDE_DNS" ]; then
		dns="$HORDE_DNS"
	fi

	echo $dns
}

net::configure_hosts() {
	local hosts=("$@")
	local ip=$(net::bridge_ip)

	for host in "${hosts[@]}"; do
		hostOnly=$(echo $host | awk -F/ '{print $1}')
		if ! hostess has $hostOnly > /dev/null ; then
			if [ ! -z "$HORDE_DEBUG" ]; then
				io::err "sudo hostess add $hostOnly $ip"
			fi
			if ! sudo hostess add $hostOnly $ip > /dev/null ; then
				io::err "problem configuring hostname '${host}'"
				return 1
			fi
		fi
	done
}
