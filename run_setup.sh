#!/bin/bash

# Copyright (C) 2020 Private Internet Access, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Only allow script to run as root
SCRIPT=$(readlink -f $0);
DIRBASE=`dirname $SCRIPT`;
cd $DIRBASE
echo "$DIRBASE"
now="$(date)"

echo "
################################
    run_setup.sh
################################

Starting script at $now
"

if [ "$(whoami)" != "root" ]; then
  echo "This script needs to be run as root. Try again with 'sudo $0'"
  exit 1
fi

# Hardcoding all the settings to make testing (and using!) easier

# Fetching credentials from local pass.txt file
# just so they don't show on github
# Username on first line, password on second
declare -a CONFIG
CONFIG="$(cat $DIRBASE/config/pia_config.json)"

PIA_USER="$(echo $CONFIG | jq -r .pia_user)"
PIA_PASS="$(echo $CONFIG | jq -r .pia_pass)"
export PIA_USER
export PIA_PASS

PIA_AUTOCONNECT=wireguard
export PIA_AUTOCONNECT

PIA_GEO="$(echo $CONFIG | jq -r .ignore_geo_regions)"
export PIA_GEO
PIA_DNS="$(echo $CONFIG | jq -r .pia_dns)"
export PIA_DNS

PIA_PF="$(echo $CONFIG | jq -r .port_forward)"
export PIA_PF
TO_IP_PORT="$(echo $CONFIG | jq -r .to_ip_port)"
export TO_IP_PORT

MAX_LATENCY="$(echo $CONFIG | jq -r .latency)"
export MAX_LATENCY

echo "*** Retrieved config ***"
echo "pia_user: $PIA_USER"
echo "pia_pass: XXXXXXXXXX"
echo "ignore_geo_regions: $PIA_GEO"
echo "pia_dns: $PIA_DNS"
echo "port_forward: $PIA_PF"
echo "to_ip_port: $TO_IP_PORT"
echo "latency: $MAX_LATENCY"

echo "Waiting for internet connection"
CONEXION=0
while [ $CONEXION -lt 1 ]
do
	date
	ping -c1 1.1.1.1 > /dev/null
	if [ $?  = 0 ]
	then
		CONEXION=1
	else
		sleep 5
	fi

	ping -c1 8.8.8.8 > /dev/null
	if [ $?  = 0 ]
	then
		CONEXION=1
	else
		sleep 5
	fi

	ping -c1 9.9.9.9 > /dev/null
	if [ $?  = 0 ]
	then
		CONEXION=1
	else
		sleep 5
	fi
done
date
echo "
Let's go. Internet is OK.
"
./get_region_and_token.sh
