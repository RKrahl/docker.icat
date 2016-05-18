FROM rkrahl/glassfish

USER root

RUN mkdir -p /srv/ids/storage && \
    chown -R glassfish:glassfish /srv/ids/storage

USER glassfish

RUN mkdir -p $GLASSFISH_HOME/apps && \
    tmpfile=`mktemp` && \
    for dist in \
	https://www.icatproject.org/mvn/repo/org/icatproject/authn_anon/1.0.2/authn_anon-1.0.2-distro.zip \
	https://www.icatproject.org/mvn/repo/org/icatproject/authn_db/1.1.2/authn_db-1.1.2-distro.zip \
	https://www.icatproject.org/mvn/repo/org/icatproject/authn_ldap/1.1.0/authn_ldap-1.1.0-distro.zip \
	https://www.icatproject.org/mvn/repo/org/icatproject/authn_simple/1.0.1/authn_simple-1.0.1-distro.zip \
	https://www.icatproject.org/mvn/repo/org/icatproject/icat.server/4.4.0/icat.server-4.4.0-distro.zip \
	https://www.icatproject.org/mvn/repo/org/icatproject/ids.storage_file/1.3.1/ids.storage_file-1.3.1-distro.zip \
	https://www.icatproject.org/mvn/repo/org/icatproject/ids.server/1.3.1/ids.server-1.3.1-distro.zip; do \
	curl --silent --show-error --location --output $tmpfile $dist && \
	unzip -q -d $GLASSFISH_HOME/apps $tmpfile; \
    done && \
    rm -rf $tmpfile && \
    chmod -R go-w $GLASSFISH_HOME/apps && \
    chmod a+x $GLASSFISH_HOME/apps/*/setup && \
    mkdir -p $GLASSFISH_HOME/etc/icat /var/lib/glassfish/icat/lucene && \
    chmod -R 0700 /var/lib/glassfish/icat

COPY setup-icat.sh /etc/glassfish.d

# Work around Issue icatproject/icat.server#151
COPY segments* /var/lib/glassfish/icat/lucene/
