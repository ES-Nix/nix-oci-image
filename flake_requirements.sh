#!/usr/bin/env sh


echo 'Start ------------'


export HOME=/home/pedroregispoar
export PATH="$HOME"/.nix-profile/bin:$PATH


#sudo --preserve-env --set-home \
#nix-shell \
#-I nixpkgs=channel:nixos-20.09 \
#--packages nixFlakes \
#--run 'nix shell nixpkgs#hello --command hello'


export HOME=/home/pedroregispoar
sudo --preserve-env --set-home \
mkdir \
--mode=755 \
--parent \
"$HOME"/.cache \
/nix/var/nix/db \
/nix/var/nix/profiles/per-user \
/nix/var/nix/gcroots/per-user


sudo --preserve-env --set-home \
touch \
/nix/var/nix/db/db.sqlite \
/nix/var/nix/db/big-lock \
/nix/var/nix/gc.lock \
/tmp/env-vars

sudo --preserve-env --set-home \
chown pedroregispoar:pedroregispoargroup \
  /tmp \
  /nix/var/nix \
  /nix/var/nix/profiles \
  /nix/var/nix/temproots \
  "$HOME"/ \
  "$HOME"/.cache \
  /nix/store \
  /nix/var/nix/db \
  /nix/var/nix/db/big-lock \
  /nix/var/nix/db/db.sqlite \
  /nix/var/nix/gc.lock \
  /nix/var/nix/gcroots \
  /nix/var/nix/gcroots/per-user \
  /nix/var/nix/profiles/per-user \
  /tmp/env-vars \
  --verbose

sudo chmod 755 /nix/store
sudo chmod 755 /nix/var/nix
sudo chmod 755 /nix/var
sudo chmod 755 /nix/var/nix/temproots
sudo chmod 755 /tmp
sudo chmod 755 "$HOME"
sudo chmod 755 /nix/var/nix/db/db.sqlite

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

echo 'End of flake_requirements.sh'


#sudo --preserve-env --set-home nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix flake show github:GNU-ES/hello'
# It relies on uid and gid to be correct (equal your host user and group) at this point
#sudo chown --recursive pedroregispoar:pedroregispoargroup /tmp/.X11-unix
#nix-store --init && nix-store --load-db < /.reginfo
#nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix flake show github:GNU-ES/hello'


