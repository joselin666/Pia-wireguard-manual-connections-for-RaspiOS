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
DIRBASE="/opt/pia"
cd $DIRBASE

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
declare -a creds # an array
readarray -t creds < config/pia_config.txt
PIA_USER="${creds[1]}"
PIA_PASS="${creds[2]}"
echo "Retrieved credentials"
export PIA_USER
export PIA_PASS

PIA_AUTOCONNECT=wireguard
export PIA_AUTOCONNECT

PIA_GEO="${creds[3]}"
export PIA_GEO
PIA_DNS="${creds[4]}"
export PIA_DNS
PIA_PF="${creds[5]}"
export PIA_PF

MAX_LATENCY="${creds[6]}"
export MAX_LATENCY

./get_region_and_token.sh
