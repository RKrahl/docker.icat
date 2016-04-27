#!/bin/bash

configdir=$GLASSFISH_HOME/etc/icat
applist=$configdir/APPS
storagedir=/srv/ids/storage
if test -x $configdir/filter.sh; then
    filter=$configdir/filter.sh
else
    filter="cp -p"
fi

die() {
    echo "$1"
    exit 1
}

mkdir -p $storagedir/{data,archive,cache}
chmod 0700 $storagedir/{data,archive,cache}

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
    echo "Install $app"
    ( cd $appdir && ./setup install )
done

