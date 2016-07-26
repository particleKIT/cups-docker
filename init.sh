#!/bin/bash

if [ "$1" == "bash" ]; then
    exec $@
fi

if [ "$LDAP_SSL" == "true" ]; then
    if [ ! "$(ls -A /ssl)" ]; then
        echo "No SSL certificates found,"
        echo -e "dont forget to run:\nchown 76:70 private.pem\nchmod 'og=-rwx' private.pem"
        exit 1
    fi
    echo "copy public keys to /etc/pki/trust/anchors/ and update trusted certificates"
    cp /ssl/*public* /etc/pki/trust/anchors/
    /usr/sbin/update-ca-certificates -f -v
fi

if [ "$(ls -A /config)" ]; then
    echo "Copy config files"
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

 echo "Starting CUPS..."
/usr/sbin/cupsd -f
