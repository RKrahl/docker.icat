FROM rkrahl/glassfish:payara-4.1

USER root

RUN mkdir -p /srv/ids/storage && \
    chown -R glassfish:glassfish /srv/ids/storage

USER glassfish

RUN mkdir -p $GLASSFISH_HOME/apps && \
    tmpfile=`mktemp` && \
    for dist in \
	https://repo.icatproject.org/repo/org/icatproject/authn.anon/1.1.2/authn.anon-1.1.2-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.db/2.0.0/authn.db-2.0.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.ldap/1.2.1/authn.ldap-1.2.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.simple/1.2.0/authn.simple-1.2.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.server/4.9.0/icat.server-4.9.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.lucene/1.0.0/icat.lucene-1.0.0-distro.zip; \
    do \
	curl --silent --show-error --location --output $tmpfile $dist && \
	unzip -q -d $GLASSFISH_HOME/apps $tmpfile; \
    done && \
    rm -rf $tmpfile && \
    chmod -R go-w $GLASSFISH_HOME/apps && \
    mkdir -p $GLASSFISH_HOME/etc/icat

COPY setup-icat.sh /etc/glassfish.d
