#!/bin/bash

echo "Configuring ldap client"
./init-ldap.sh

if [ "$(ls -A /config)" ]; then
    echo "Copy cups config files"
    cp -fr /config/* /etc/cups/
fi
 
if [ "$(ls -A /filter)" ]; then
    echo "Copy printer filters"
    cp -fr /filter/* /usr/lib/cups/filter/
fi

if [ "$CUPS_PASSWD" != "false" ]; then
    echo "Set cups administration password."
    echo "$CUPS_LOGIN:$CUPS_PASSWD" | chpasswd
fi

echo "Starting CUPS in background..."
/usr/sbin/cupsd -f
