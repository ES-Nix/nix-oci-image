#!/usr/bin/env sh


set -e

# Allows the container to be started with `--user=name`
if [ "$(id -u)" = "0" ]; then
  # echo 'Entered'
  chmod 0755 -R /nix /home/nixuser
  chown 1234:6789 -R /nix /home/nixuser

  exec gosu 1234 "$@"
fi


exec "$@"
