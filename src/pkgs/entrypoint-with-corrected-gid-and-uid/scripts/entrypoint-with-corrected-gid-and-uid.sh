#!/bin/bash

if [ "$(id -u)" = "0" ]; then
    echo "Running the change-gid-and-or-uid-if-different-of-given-path script."
    change-gid-and-or-uid-if-different-of-given-path -r -u nixuser -g nixgroup /home/nixuser/code

    echo "Running: exec gosu nixuser "$@""
    exec gosu nixuser "$@"
fi

exec "$@"
