#!/usr/bin/env sh


set -e

# Allows the container to be started with `--user=name`
if [ "$(id -u)" = "0" ]; then
  # echo 'Entered'
  # chmod 0755 -R /nix /home/nixuser
  chown "${INJECTED_UID}":"${INJECTED_GID}" -R /nix
  chown "${INJECTED_UID}":"${INJECTED_GID}" -Rv /home/nixuser

  exec gosu "${INJECTED_UID}" "$@"
fi


exec "$@"
