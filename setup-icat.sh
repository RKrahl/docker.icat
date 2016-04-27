#!/bin/bash

configdir=$GLASSFISH_HOME/etc/icat
applist=$configdir/APPS

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
    cp -p $appconfig/* $appdir || \
	die "Error copying application config for $app"
    echo "Install $app"
    ( cd $appdir && ./setup install )
done

