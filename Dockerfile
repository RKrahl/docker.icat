FROM rkrahl/glassfish:payara-6

USER root

RUN mkdir -p /srv/ids/storage/data \
             /srv/ids/storage/archive \
             /srv/ids/storage/cache && \
    chown -R glassfish:glassfish /srv/ids/storage && \
    chmod 0700 /srv/ids/storage/data \
               /srv/ids/storage/archive \
               /srv/ids/storage/cache && \
    ln -sf ../usr/share/zoneinfo/Europe/Berlin /etc/localtime

USER glassfish

RUN mkdir -p $GLASSFISH_HOME/apps && \
    tmpfile=`mktemp` && \
    for dist in \
	https://repo.icatproject.org/repo/org/icatproject/authn.anon/3.0.0/authn.anon-3.0.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.db/3.0.0/authn.db-3.0.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.ldap/3.0.0/authn.ldap-3.0.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.simple/3.0.0/authn.simple-3.0.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.oidc/2.0.0-SNAPSHOT/authn.oidc-2.0.0-20230815.150019-4-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.server/6.0.0/icat.server-6.0.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.lucene/2.0.2/icat.lucene-2.0.2-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.oaipmh/2.0.0-SNAPSHOT/icat.oaipmh-2.0.0-20230815.150227-3-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.storage_file/1.4.4/ids.storage_file-1.4.4-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.server/2.0.0-SNAPSHOT/ids.server-2.0.0-20230817.131903-5-distro.zip; \
    do \
	(curl --silent --show-error --location --output $tmpfile $dist && \
	 unzip -q -d $GLASSFISH_HOME/apps $tmpfile) || exit 1; \
    done && \
    rm -rf $tmpfile && \
    chmod -R go-w $GLASSFISH_HOME/apps && \
    find $GLASSFISH_HOME/apps -type f | xargs chmod a-x && \
    chmod a+x \
	$GLASSFISH_HOME/apps/*/setup \
	$GLASSFISH_HOME/apps/icat.server/icatadmin \
	$GLASSFISH_HOME/apps/icat.server/testicat && \
    mkdir -p $GLASSFISH_HOME/etc/icat

COPY setup-icat.sh /etc/glassfish/post-install.d/10-setup-icat.sh
