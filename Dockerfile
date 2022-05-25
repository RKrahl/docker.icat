FROM rkrahl/glassfish:payara-5

USER root

RUN zypper --non-interactive install \
	python \
	python-xml && \
    mkdir -p /srv/ids/storage/data \
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
	https://repo.icatproject.org/repo/org/icatproject/authn.anon/2.0.1/authn.anon-2.0.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.db/2.0.1/authn.db-2.0.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.ldap/2.0.1/authn.ldap-2.0.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.simple/2.0.1/authn.simple-2.0.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.oidc/1.0.0/authn.oidc-1.0.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.server/4.11.1/icat.server-4.11.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.lucene/1.1.2/icat.lucene-1.1.2-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.oaipmh/1.1.1/icat.oaipmh-1.1.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.storage_file/1.4.3/ids.storage_file-1.4.3-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.server/1.12.0/ids.server-1.12.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/topcat/2.4.8/topcat-2.4.8-distro.zip; \
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
	$GLASSFISH_HOME/apps/icat.server/testicat \
	$GLASSFISH_HOME/apps/topcat/topcat_admin && \
    mkdir -p $GLASSFISH_HOME/etc/icat

COPY setup-icat.sh /etc/glassfish/post-install.d/10-setup-icat.sh
