FROM rkrahl/glassfish

USER root

RUN mkdir -p /srv/ids/storage && \
    chown -R glassfish:glassfish /srv/ids/storage

USER glassfish

RUN mkdir -p $GLASSFISH_HOME/apps && \
    tmpfile=`mktemp` && \
    for dist in \
	https://repo.icatproject.org/repo/org/icatproject/authn.anon/1.1.1/authn.anon-1.1.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.db/1.2.0/authn.db-1.2.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.ldap/1.2.0/authn.ldap-1.2.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.simple/1.1.0/authn.simple-1.1.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.server/4.8.0/icat.server-4.8.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.storage_file/1.3.3/ids.storage_file-1.3.3-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.server/1.7.0/ids.server-1.7.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/topcat/2.2.0/topcat-2.2.0-distro.zip; \
    do \
	curl --silent --show-error --location --output $tmpfile $dist && \
	unzip -q -d $GLASSFISH_HOME/apps $tmpfile; \
    done && \
    rm -rf $tmpfile && \
    chmod -R go-w $GLASSFISH_HOME/apps && \
    mkdir -p $GLASSFISH_HOME/etc/icat /var/lib/glassfish/icat/lucene && \
    chmod -R 0700 /var/lib/glassfish/icat

COPY setup-icat.sh /etc/glassfish.d
