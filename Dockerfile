FROM rkrahl/glassfish:glassfish-4.0

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
	https://repo.icatproject.org/repo/org/icatproject/authn.anon/1.1.1/authn.anon-1.1.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.db/1.2.0/authn.db-1.2.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.ldap/1.2.0/authn.ldap-1.2.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/authn.simple/1.1.0/authn.simple-1.1.0-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/icat.server/4.6.1/icat.server-4.6.1-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.storage_file/1.3.2/ids.storage_file-1.3.2-distro.zip \
	https://repo.icatproject.org/repo/org/icatproject/ids.server/1.5.0/ids.server-1.5.0-distro.zip; do \
	(curl --silent --show-error --location --output $tmpfile $dist && \
	 unzip -q -d $GLASSFISH_HOME/apps $tmpfile) || exit 1; \
    done && \
    rm -rf $tmpfile && \
    chmod -R go-w $GLASSFISH_HOME/apps && \
    mkdir -p $GLASSFISH_HOME/etc/icat

COPY setup-icat.sh /etc/glassfish/post-install.d/10-setup-icat.sh
