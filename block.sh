#!/usr/bin/env bash

BLOCK_MARKER="ADDED BY BLOCK"

function _unblock() {
    set -e
    COMMAND="touch /etc/tmp_hosts; sed -i '' '/$1/ s/^.*$BLOCK_MARKER//' /etc/hosts >> /etc/tmp_hosts; mv /etc/tmp_hosts /etc/hosts"
    sudo sh -c "$COMMAND"
}

function _block() {
    echo "127.0.0.1    $1    # $BLOCK_MARKER" >> /etc/hosts
}

if [ $1 == 'block' ]; then
    _block $2
elif [ $1 == 'unblock' ]; then
    _unblock $2
fi
