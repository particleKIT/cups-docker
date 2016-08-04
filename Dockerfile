FROM opensuse:42.1
MAINTAINER TTP/ITP <admin@particle.kit.edu>

RUN zypper --gpg-auto-import-keys --non-interactive ref && \
    zypper --gpg-auto-import-keys --non-interactive up && \
    zypper --gpg-auto-import-keys --non-interactive in -l \
    pam_ldap openldap2-client openssl nss_ldap ca-certificates \
    cups cups-filters cups-filters-cups-browsed poppler-tools \
    gutenprint OpenPrintingPPDs-ghostscript OpenPrintingPPDs timezone &&\
    zypper clean --all

# enable ldap user authentification
RUN sed -i 's/^\(passwd\|group\|shadow\):\(.*\)/#\1: \2/gm' /etc/nsswitch.conf &&\
    sed -i '$a passwd: files ldap' /etc/nsswitch.conf &&\
    sed -i '$a group: files ldap' /etc/nsswitch.conf &&\
    sed -i '$a shadow: files ldap' /etc/nsswitch.conf &&\
    # set timezone
    ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

COPY pam.d/* /etc/pam.d/

VOLUME ["/config", "/ssl","/filter"]

ENV LDAP_SSL=true \
    CUPS_PASSWD=false \ 
    CUPS_LOGIN=root

EXPOSE 631

ADD init.sh /init.sh
ENTRYPOINT ["/init.sh"]

