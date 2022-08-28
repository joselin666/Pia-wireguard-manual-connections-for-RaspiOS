#!/bin/bash
SCRIPT=$(readlink -f $0);
DIRBASE=`dirname $SCRIPT`;
cd $DIRBASE
echo "$DIRBASE"

printf "
#############################
    refresh_pia_port.sh
############################# \n\n"

# Retrieve variables
pf_filepath=$DIRBASE/pf
PF_HOSTNAME="$( cat $pf_filepath/PF_HOSTNAME )"
PF_GATEWAY="$( cat $pf_filepath/PF_GATEWAY )"
payload="$( cat $pf_filepath/payload )"
signature="$( cat $pf_filepath/signature )"
port="$( cat $pf_filepath/port )"
expires_at="$( cat $pf_filepath/expires_at )"

echo PF_HOSTNAME: $PF_HOSTNAME
echo PF_GATEWAY: $PF_GATEWAY
echo payload: $payload
echo signature: $signature
echo port: $port
echo expires_at: $expires_at

printf "\nTrying to bind the port . . . \n"

# Now we have all required data to create a request to bind the port.
# Set a cron job to run this script every 15 minutes, to keep the port
# alive. The servers have no mechanism to track your activity, so they
# will just delete the port forwarding if you don't send keepalives.

bind_port_response="$(curl -Gs -m 5 \
  --connect-to "$PF_HOSTNAME::$PF_GATEWAY:" \
  --cacert "ca.rsa.4096.crt" \
  --data-urlencode "payload=${payload}" \
  --data-urlencode "signature=${signature}" \
  "https://${PF_HOSTNAME}:19999/bindPort")"

echo "$bind_port_response"

# If port did not bind, just exit the script.
# This script will exit in 2 months, since the port will expire.
export bind_port_response
if [ "$(echo "$bind_port_response" | jq -r '.status')" != "OK" ]; then
  echo "The API did not return OK when trying to bind port."
  echo "Ports expire after two months; maybe that's why.  Exiting."
  exit 1
fi

echo Port $port refreshed on $(date). This port will expire $expires_at