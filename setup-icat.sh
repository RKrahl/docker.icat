#!/bin/bash

mkdir -p $DOMAIN_DATA/icat $DOMAIN_DATA/lucene
chmod o-rwx $DOMAIN_DATA/icat $DOMAIN_DATA/lucene

# Work around Issue icatproject/icat.server#151
mv $GLASSFISH_HOME/tmp/segments* $DOMAIN_DATA/lucene

configdir=$GLASSFISH_HOME/etc/icat
applist=$configdir/APPS
if test -x $configdir/filter.sh; then
    filter=$configdir/filter.sh
else
    filter="cp -p"
fi

die() {
    echo "$1"
    exit 1
}

test -d $configdir || \
    die "Config directory $configdir not found"
test -f $applist || \
    die "Application file $applist not found"

for app in `cat $applist`; do
    appconfig=$configdir/$app
    appdir=$GLASSFISH_HOME/apps/$app
    test -d $appconfig || \
	die "Application configuration $appconfig not found"
    test -d $appdir || \
	die "Application directory $appdir not found"
    for src in $appconfig/*; do
	dest=$appdir/`basename $src`
	$filter $src $dest || \
	    die "Error copying application config for $app"
	chmod --reference=$src $dest
    done
    echo "Install $app ..."
    ( cd $appdir && ./setup install )
    echo "Install $app ... done"
done

