FROM opensuse:leap
MAINTAINER TTP/ITP <admin@particle.kit.edu>

RUN zypper --gpg-auto-import-keys --non-interactive ref && \
    zypper --gpg-auto-import-keys --non-interactive up && \
    zypper --gpg-auto-import-keys --non-interactive in -l \
    pam_ldap openldap2-client openssl nss_ldap ca-certificates \
    cups cups-filters cups-filters-cups-browsed poppler-tools \
    gutenprint OpenPrintingPPDs-ghostscript OpenPrintingPPDs &&\
    zypper clean --all

# enable ldap user authentification
RUN sed -i 's/^\(passwd\|group\|shadow\):\(.*\)/#\1: \2/gm' /etc/nsswitch.conf &&\
    sed -i '$a passwd: files ldap' /etc/nsswitch.conf &&\
    sed -i '$a group: files ldap' /etc/nsswitch.conf &&\
    sed -i '$a shadow: files ldap' /etc/nsswitch.conf

COPY pam.d/* /etc/pam.d/

VOLUME ["/config", "/ssl","/filter"]

ENV LDAP_SSL=true

EXPOSE 631

ADD init.sh /init.sh
ENTRYPOINT ["/init.sh"]

