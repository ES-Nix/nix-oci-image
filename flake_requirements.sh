#!/usr/bin/env sh
# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

echo 'Start ------------'

export HOME=/home/pedroregispoar
export PATH="$HOME"/.nix-profile/bin:$PATH

#sudo --preserve-env --set-home \
#touch \
#/nix/var/nix/db/db.sqlite \
#/nix/var/nix/db/big-lock \
#/nix/var/nix/gc.lock \
#/tmp/env-vars

sudo --preserve-env --set-home \
chown pedroregispoar:pedroregispoargroup \
  "$HOME"/ \
  "$HOME"/.cache \
  /nix/store \
  /nix/var/nix \
  /nix/var/nix/db \
  /nix/var/nix/db/big-lock \
  /nix/var/nix/db/db.sqlite \
  /nix/var/nix/gc.lock \
  /nix/var/nix/gcroots \
  /nix/var/nix/gcroots/per-user \
  /nix/var/nix/profiles \
  /nix/var/nix/profiles/per-user \
  /nix/var/nix/temproots \
  /tmp \
  /tmp/env-vars \
  --verbose

sudo \
chmod \
0755 \
--verbose \
"$HOME" \
/home/pedroregispoar/.cache \
/nix/store \
/nix/var \
/nix/var/nix \
/nix/var/nix/db \
/nix/var/nix/db/big-lock \
/nix/var/nix/db/db.sqlite \
/nix/var/nix/db/db.sqlite \
/nix/var/nix/gc.lock \
/nix/var/nix/profiles/per-user \
/nix/var/nix/temproots \
/tmp \
/tmp/env-vars

sudo chmod --recursive --verbose 0777 \
"$HOME"/.cache \
/nix/var/nix/gcroots

echo 'End of flake_requirements.sh'


#cd /nix/store \
#&& sudo find /nix/store ! -path '*sudo*' -exec chown pedroregispoar:pedroregispoargroup {} --verbose \; \
#&& cd -
#
#cd "$HOME" \
#&& sudo find "$HOME" ! -path '*sudo*' -exec chown pedroregispoar:pedroregispoargroup {} --verbose \; \
#&& cd -
#sudo --preserve-env --set-home nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'id'

#nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix shell nixpkgs#hello --command hello'
#nix-collect-garbage --delete-old

#sudo --preserve-env --set-home \
#chown --recursive pedroregispoar:pedroregispoargroup \
#/nix

#sudo --preserve-env --set-home nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix flake show github:GNU-ES/hello'
# It relies on uid and gid to be correct (equal your host user and group) at this point
#sudo chown --recursive pedroregispoar:pedroregispoargroup /tmp/.X11-unix
#nix-store --init && nix-store --load-db < /.reginfo
#nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix flake show github:GNU-ES/hello'
