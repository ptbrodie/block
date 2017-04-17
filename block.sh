#!/usr/bin/env bash

BLOCK_MARKER="ADDED BY BLOCK"

function strip_www() {
    echo -e $1 | sed 's/www\.//g'
}

function strip_www_read {
    while read host; do
        strip_www $host
    done
}

function remove() {
    set -e
    bare=`strip_www $1`
    touch /etc/tmp_hosts
    regex="$bare.*$BLOCK_MARKER"
    grep -v "$regex" /etc/hosts >> /etc/tmp_hosts
    mv /etc/tmp_hosts /etc/hosts
}

function add() {
    bare=`strip_www $1`
    www="www.$bare"
    echo "127.0.0.1     $bare   # $BLOCK_MARKER" >> /etc/hosts
    echo "127.0.0.1     $www    # $BLOCK_MARKER" >> /etc/hosts
    echo "fe80::1%lo0   $bare   # $BLOCK_MARKER" >> /etc/hosts
    echo "fe80::1%lo0   $www    # $BLOCK_MARKER" >> /etc/hosts
}

function list() {
    grep "$BLOCK_MARKER" /etc/hosts | awk '{print $2}' | strip_www_read | sort | uniq
}

function help() {
    echo "usage: block [add|remove|list] <arg>"
    echo
    echo "To block a website:"
    echo "    $ block add example.com"
    echo
    echo "To unblock a website:"
    echo "    $ block remove example.com"
    echo
    echo "View currently blocked websites:"
    echo "    $ block list"
}

if [ $1 == 'add' ]; then
    add $2
elif [ $1 == 'remove' ]; then
    remove $2
elif [ $1 == 'list' ]; then
    list
elif [ $1 == 'help' ]; then
    help
else
    echo "$1 not recognized."
    echo "More info:"
    echo "    $ block help"
fi
