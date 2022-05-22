#!/bin/bash


echo $0 started!

SHELL_TO_EXEC=bash

if [ "$(id -u)" = "0" ]; then
    echo "Running the change-gid-and-or-uid-if-different-of-given-path script."
    change-gid-and-or-uid-if-different-of-given-path -r -u nixuser -g nixgroup

    echo "Running: exec gosu nixuser "$@""
    exec gosu nixuser "$@" "${SHELL_TO_EXEC}"
fi

echo 'You are not root.'
exec "$@" "${SHELL_TO_EXEC}"
