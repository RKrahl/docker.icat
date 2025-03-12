#!/bin/bash

CONFIGDIR=$GLASSFISH_HOME/etc/icat
export CONFIGDIR

mkdir -p \
    $DOMAINDIR/data/icat/search \
    $DOMAINDIR/data/ids \
    $DOMAINDIR/data/search
chmod o-rwx $DOMAINDIR/data/icat $DOMAINDIR/data/search

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
    (cd $appconfig
	for src in `find -type f`; do
	    mkdir -p $appdir/`dirname $src`
	    dest=$appdir/$src
	    $filter $src $dest || \
		die "Error copying application config for $app"
	    chmod --reference=$src $dest
	done)
    echo "Install $app ..."
    ( cd $appdir && ./setup install )
    echo "Install $app ... done"
done

