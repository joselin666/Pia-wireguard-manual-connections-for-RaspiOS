#/bin/bash
#configurarpuerto.sh
SCRIPT=$(readlink -f $0);
DIRBASE=`dirname $SCRIPT`;
cd $DIRBASE
echo "$DIRBASE"

echo "
#######################################
    activeportforward.sh
#######################################
"

PORTFILE=$DIRBASE/pf/port
PORT="$(cat $PORTFILE)"
echo "Puerto: $PORT"

cmd="iptables"
if ! command -v $cmd &>/dev/null
then
    echo "$cmd could not be found."
else
 # Delete previos nat
    sudo iptables -F -t nat
 # Add nat with new Pia port
    sudo iptables -t nat -A PREROUTING -p tcp --dport $PORT -j DNAT --to-destination $TO_IP_PORT
 # Show Nat configuration
    sudo iptables -L -t nat
fi