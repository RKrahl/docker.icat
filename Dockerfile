FROM rkrahl/glassfish:4.0

USER root

RUN mkdir -p /srv/ids/storage && \
    chown -R glassfish:glassfish /srv/ids/storage

USER glassfish

RUN mkdir -p $GLASSFISH_HOME/apps && \
    tmpfile=`mktemp` && \
    for dist in \
	https://repo.icatproject.org/repo/org/icatproject/authn_anon/1.0.2/authn_anon-1.0.2-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn_db/1.1.2/authn_db-1.1.2-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn_ldap/1.1.0/authn_ldap-1.1.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn_simple/1.0.1/authn_simple-1.0.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.server/4.5.1/icat.server-4.5.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.storage_file/1.3.2/ids.storage_file-1.3.2-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.server/1.5.0/ids.server-1.5.0-distro.zip; do \
	curl --silent --show-error --location --output $tmpfile $dist && \
	unzip -q -d $GLASSFISH_HOME/apps $tmpfile; \
    done && \
    rm -rf $tmpfile && \
    chmod -R go-w $GLASSFISH_HOME/apps && \
    mkdir -p $GLASSFISH_HOME/etc/icat

COPY setup-icat.sh /etc/glassfish.d
