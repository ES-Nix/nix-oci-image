#!/usr/bin/env sh


set -e

# Allows the container to be started with `--user=name`
if [ "$(id -u)" = "0" ]; then
  # echo 'Entered'
  # chmod 0755 -R /nix /home/nixuser
  chown nixuser:nixgroup -Rv /nix /home/nixuser

  exec gosu 1234 "$@"
fi


exec "$@"
