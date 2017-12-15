#!/bin/bash

CONFIGDIR=$GLASSFISH_HOME/etc/icat
export CONFIGDIR

mkdir -p \
    $DOMAINDIR/data/icat \
    $DOMAINDIR/data/icat/lucene \
    $DOMAINDIR/data/ids \
    $DOMAINDIR/data/lucene
chmod o-rwx $DOMAINDIR/data/icat $DOMAINDIR/data/lucene

# Work around Issue icatproject/icat.server#151
mv $GLASSFISH_HOME/tmp/segments* $DOMAIN_DATA/lucene

applist=$CONFIGDIR/APPS
if test -x $CONFIGDIR/filter.sh; then
    filter=$CONFIGDIR/filter.sh
else
    filter="cp -p"
fi

die() {
    echo "$1"
    exit 1
}

test -d $CONFIGDIR || \
    die "Config directory $CONFIGDIR not found"
test -f $applist || \
    die "Application file $applist not found"

for app in `cat $applist`; do
    appconfig=$CONFIGDIR/$app
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

