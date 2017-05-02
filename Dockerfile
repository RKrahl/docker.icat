FROM rkrahl/glassfish:payara-4.1

USER root

RUN mkdir -p /srv/ids/storage && \
    chown -R glassfish:glassfish /srv/ids/storage

USER glassfish

RUN mkdir -p $GLASSFISH_HOME/apps && \
    tmpfile=`mktemp` && \
    for dist in \
	https://repo.icatproject.org/repo/org/icatproject/authn.anon/1.1.2-SNAPSHOT/authn.anon-1.1.2-20170315.152836-1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.db/2.0.0-SNAPSHOT/authn.db-2.0.0-20170315.153423-1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.ldap/1.2.1-SNAPSHOT/authn.ldap-1.2.1-20170315.154118-1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.simple/1.2.0-SNAPSHOT/authn.simple-1.2.0-20170315.154833-1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.server/4.9.0-SNAPSHOT/icat.server-4.9.0-20170315.162136-3-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.lucene/1.0.0-SNAPSHOT/icat.lucene-1.0.0-20170315.160747-2-distro.zip; \
    do \
	curl --silent --show-error --location --output $tmpfile $dist && \
	unzip -q -d $GLASSFISH_HOME/apps $tmpfile; \
    done && \
    rm -rf $tmpfile && \
    chmod -R go-w $GLASSFISH_HOME/apps && \
    mkdir -p $GLASSFISH_HOME/etc/icat /var/lib/glassfish/icat/lucene && \
    chmod -R 0700 /var/lib/glassfish/icat

COPY setup-icat.sh /etc/glassfish.d
