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

sudo iptables -t nat -A PREROUTING -p tcp --dport $PORT -j DNAT --to-destination $TO_IP_PORT

sudo iptables -L -t nat