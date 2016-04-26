#!/bin/bash

configdir=$GLASSFISH_HOME/etc/icat

die() {
    echo "$1"
    exit 1
}

test -d $configdir || \
    die "Config directory $configdir not found"

for app in `ls $configdir`; do
    appconfig=$configdir/$app
    appdir=$GLASSFISH_HOME/apps/$app
    test -d $appconfig || \
	continue
    test -d $appdir || \
	die "Application directory $appdir not found"
    cp -p $appconfig/* $appdir || \
	die "Error copying application config for $app"
    echo "Install $app"
    ( cd $appdir && ./setup install )
done

