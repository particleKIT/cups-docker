#!/bin/bash

if [ "$1" == "bash" ]; then
    exec $@
fi

if [ "$LDAP_SSL" == "true" ] && [ ! "$(ls -A /config/ssl)" ]; then
   echo "No SSL certificates found,"
   echo -e "dont forget to run:\nchown 76:70 private.pem\nchmod 'og=-rwx' private.pem"
   exit 1
else
    echo "copy public keys to /etc/pki/trust/anchors/ and update trusted certificates"
    cp /config/ssl/*public* /etc/pki/trust/anchors/
    /usr/sbin/update-ca-certificates -f -v
fi

echo "Copy config files"
cp -r /config/cups/* /etc/cups/

/usr/sbin/cupsd -f
