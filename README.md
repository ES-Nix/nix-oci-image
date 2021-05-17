# nix-oci-image


```bash
git clone https://github.com/ES-Nix/nix-oci-image.git
cd nix-oci-image
git checkout nix-oci-image-dockerTools
```

```bash
nix build .#tests.tests \
&& result/build_load-nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp \
&& result/test_xclock-nix-static-coreutils-bash-unpriviliged
```

```bash
nix build .#tests.tests \
&& result/runOCI
```

```bash
nix \
build \
github:ES-Nix/nix-oci-image/nix-static-unpriviliged#tests.tests
```

```bash
nix \
build \
github:ES-Nix/nix-oci-image/nix-static-unpriviliged#oci.nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp \
--out-link \
oci.tar.gz
```


nix \
shell \
nixpkgs#python3Minimal \
--command \
python \
-c \
'import unittest'


nix store gc
nix store optimise
nix build nixpkgs#blender
nix build nixpkgs#debianutils
nix shell nixpkgs#toybox --command toybox
nix path-info --derivation nixpkgs#hello

nix \
path-info \
--human-readable \
--closure-size \
nixpkgs#hello

nix \
path-info \
--human-readable \
--closure-size \
github:NixOS/nix#nix-static

nix \
--experimental-features \
'nix-command ca-references flakes' \
path-info \
--human-readable \
--closure-size \
nixpkgs#python3Minimal




##

```
nix \
build \
github:ES-Nix/nix-oci-image/nix-static-unpriviliged#oci.nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp
```

```bash

nix \
develop \
github:ES-Nix/nix-oci-image/nix-static-unpriviliged

podman load < result

podman \
run \
--env=HOME=/root \
--env=USER=root \
--interactive=true \
--tty=false \
--rm=true \
--user='0' \
--workdir=/root \
localhost/nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp:0.0.1 \
sh \
<< COMMANDS
nix build nixpkgs#hello
./result/bin/hello
COMMANDS
```

nix build nixpkgs#hello
nix build nixpkgs#qemu
nix build nixpkgs#qgis
nix build nixpkgs#blender


About the docker commit: https://docs.docker.com/engine/reference/commandline/commit/

TODO: create another repo?
About the action https://github.com/cachix/install-nix-action/pull/62



#stat --format "uid=%u uname=%U gid=%g gname=%G %a %A" /tmp \
#&& stat --format "uid=%u uname=%U gid=%g gname=%G %a %A" /nix/var/nix \
#&& stat --format "uid=%u uname=%U gid=%g gname=%G %a %A" /nix/var/nix/profiles \
#&& stat --format "uid=%u uname=%U gid=%g gname=%G %a %A" /nix/var/nix/temproots \
#&& stat --format "uid=%u uname=%U gid=%g gname=%G %a %A" /home/pedroregispoar/.cache/var \
#&& stat --format "uid=%u uname=%U gid=%g gname=%G %a %A" /home/pedroregispoar/.cache/nix/


CONTAINER='nix-oci-dockertools-user-with-sudo-base-container-to-commit'
DOCKER_OR_PODMAN=podman
NIX_BASE_IMAGE='nix-oci-dockertools-user-with-sudo-base:0.0.1'

"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"


"$DOCKER_OR_PODMAN" \
run \
--cap-add=ALL \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--env=USER=pedroregispoar \
--env=HOME=/home/pedroregispoar \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=false \
--user=pedroregispoar \
--workdir=/code \
--volume="$(pwd)":/code \
"$NIX_BASE_IMAGE" \
bash \
<< COMMANDS
./flake_requirements.sh
COMMANDS

ID=$("$DOCKER_OR_PODMAN" \
commit \
"$CONTAINER" \
nix-oci-dockertools-user-with-sudo:0.0.1)

"$DOCKER_OR_PODMAN" rm --force --ignore "$CONTAINER"


su pedroregispoar \
<< COMMAND
nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'nix shell nixpkgs#hello --command hello'
nix-collect-garbage --delete-old
COMMAND

nix-env --install --attr nixpkgs.commonsCompress nixpkgs.gnutar nixpkgs.lzma.bin nixpkgs.git

du --human-readable --max-depth=1 /nix/
nix build github:NixOS/nix#nix-static
cp --no-dereference --recursive --verbose $(nix-store --query --requisites result) output

nixpkgs/nix-flakes

podman volume create nix_shadow
podman volume rm nix_shadow

podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=nix_shadow:/root/shadow \
docker.io/nixpkgs/nix-flakes \
bash \
-c 'nix build nixpkgs#shadow && cp --no-dereference --recursive --verbose $(nix-store --query --requisites result) /root/shadow/'

podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=nix_shadow:/root/shadow \
docker.io/nixpkgs/nix-flakes \
bash \
-c 'ls -al /root/shadow'



podman volume create nix_coreutils
podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=nix_coreutils:/root/coreutils \
docker.io/nixpkgs/nix-flakes \
bash \
-c 'nix build nixpkgs#coreutils && cp --no-dereference --recursive --verbose $(nix-store --query --requisites result) /root/coreutils/'

podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=nix_coreutils:/root/coreutils \
docker.io/nixpkgs/nix-flakes \
bash \
-c 'ls -al /root/coreutils'


podman volume create nix_bash_interactive
podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=nix_bash_interactive:/root/bash_interactive \
docker.io/nixpkgs/nix-flakes \
bash \
-c 'nix build nixpkgs#bashInteractive && cp --no-dereference --recursive --verbose $(nix-store --query --requisites result) /root/bash_interactive/'

podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=nix_bash_interactive:/root/bash_interactive \
docker.io/nixpkgs/nix-flakes \
bash \
-c 'ls -al /root/bash_interactive'



podman volume create nix_cowsay
podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=nix_cowsay:/root/cowsay \
docker.io/nixpkgs/nix-flakes \
bash \
-c 'nix build nixpkgs#cowsay && cp --no-dereference --recursive --verbose $(nix-store --query --requisites result) /root/cowsay/'

podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=nix_cowsay:/root/cowsay \
docker.io/nixpkgs/nix-flakes \
bash \
-c 'ls -ahl /root/cowsay'

podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=nix_cowsay:/root/cowsay \
docker.io/nixpkgs/nix-flakes \
bash 



export PATH=$(echo /root/shadow/*-shadow*/bin):$PATH:$(echo /root/coreutils/*-coreutils*/bin)
export PATH=$(echo /root/bash_interactive/*-shadow*/bin):$PATH






flake

nix \
develop \
github:ES-Nix/nix-flakes-shellHook-writeShellScriptBin-defaultPackage/65e9e5a64e3cc9096c78c452b51cc234aa36c24f

podman volume create copy_nix_static

podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=copy_nix_static:/root/copy_nix_static \
docker.io/nixpkgs/nix-flakes \
bash \
-c 'nix build github:NixOS/nix#nix-static && cp /nix/store/*-nix-2.4*-x86_64-unknown-linux-musl/bin/nix /root/copy_nix_static'


podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=copy_nix_static:/root/copy_nix_static \
docker.io/library/alpine:3.13.0 \
sh -c 'cp /root/copy_nix_static/nix /usr/bin/ && nix --experimental-features 'nix-command ca-references flakes' build github:NixOS/nix#nix-static '


du builded-hello/bin/nix


podman \
 run \
--interactive=true \
--name=nix-static \
--tty=true \
--rm=true \
--user='0' \
--volume=copy_nix_static:/root/copy_nix_static \
docker.io/library/alpine:3.13.0 \
sh -c 'cp /root/copy_nix_static/nix /usr/bin/ && nix --experimental-features 'nix-command ca-references flakes' build github:NixOS/nix#nix-static'

podman \
 run \
--interactive=true \
--name=nix-static \
--tty=false \
--rm=true \
--user='0' \
--volume=copy_nix_static:/root/copy_nix_static \
docker.io/library/alpine:3.13.0 \
sh \
<< COMMANDS
apk add --no-cache curl
curl -L https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > nix

sha256sum nix
chmod +x ./nix
mv nix /usr/bin/nix

sha256sum /usr/bin/nix

nix --experimental-features 'nix-command ca-references flakes' build github:NixOS/nix#nix-static

sha256sum result/bin/nix

cp /root/copy_nix_static/nix /usr/bin/
sha256sum /usr/bin/nix
COMMANDS


podman \
 run \
--interactive=true \
--name=nix-static \
--tty=false \
--rm=true \
--user='0' \
docker.io/library/alpine:3.13.0 \
sh \
<< COMMANDS
apk add --no-cache curl
curl -L https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > nix

sha256sum nix
chmod +x ./nix
mv nix /usr/bin/nix

sha256sum /usr/bin/nix

nix --experimental-features 'nix-command ca-references flakes' build github:NixOS/nix#nix-static
mv /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca2-certificates.crt

sha256sum result/bin/nix
COMMANDS


### 


https://www.youtube.com/watch?v=VE7iDdGdDtM


podman \
 run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
docker.io/library/alpine:3.13.0 \
sh 

mkdir --mode=0700 /home/nixuser
apk add --no-cache curl
curl -L https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > nix
sha256sum nix
chmod +x ./nix
cp nix /home/nixuser/nix
mv nix /usr/bin/nix


nix \
--experimental-features 'nix-command ca-references flakes' \
shell \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
nixpkgs#which \
nixpkgs#file \
nixpkgs#findutils

rm -r /lib /media /mnt /opt /sbin /srv /usr /var /bin

mkdir -p /usr/bin
mv /home/nixuser/nix /usr/bin/nix

nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay && result/bin/cowsay 'Hi!'
nix --experimental-features 'nix-command ca-references flakes' store gc

rm -rf /etc/{ca-certificates.conf,ca-certificates,mtab,alpine-release,apk,conf.d,crontabs,fstab,group,hostname,hosts,init.d,inittab,issue,logrotate.d,modprobe.d,modules,modules-load.d,motd,network,opt,os-release,passwd,periodic,profile,profile.d,protocols,resolv.conf,securetty,services,shadow,shells,sysctl.conf,sysctl.d,udhcpd.conf}

#cp /etc/ssl/certs/ca-certificates.crt /ca-certificates.crt
#mkdir -p /etc/ssl/certs
#cp /ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

cp /etc/ssl/certs/ca-certificates.crt /ca-certificates.crt
rm -r /etc/ssl
mkdir -p /etc/ssl/certs
cp /ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

export USER=root

nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay && result/bin/cowsay 'Hi!'
rm result
nix --experimental-features 'nix-command ca-references flakes' store gc

ls -al /etc
stat /tmp
du -h /etc/ssl/certs/ca-certificates.crt


```
podman volume create volume_ca_certificate

podman \
run \
--interactive=true \
--tty=false \
--rm=false \
--volume=volume_ca_certificate:/code \
--user='0' \
docker.io/library/alpine:3.13.0 \
sh \
-c \
'cp /etc/ssl/certs/ca-certificates.crt /code/ca-certificates.crt'
```

podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_ca_certificate:/etc/ssl/certs:ro \
localhost/nix:0.0.1 \
nix \
--experimental-features 'nix-command ca-references flakes' \
shell \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
nixpkgs#which \
nixpkgs#file \
nixpkgs#findutils

podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_ca_certificate:/etc/ssl/certs/ca-certificates.crt:ro \
localhost/nix:0.0.1 \
bash

mkdir -p /etc/ssl/certs
cp ca-certificates.crt /etc/ssl/certs/

mkdir \
--mode=1777 \
/tmp
nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay && result/bin/cowsay 'Hi!'


## 


curl -L https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > nix
sha256sum nix
chmod +x ./nix
sudo mv nix /usr/bin/nix
sha256sum /usr/bin/nix


### 


sudo su
mkdir -p /home/nix_user
cd /home/nix_user

cat << 'EOF' >> /etc/passwd
nix_user:x:6789:12345::/home/nix_user:/bin/bash
nixbld1:x:122:30000:Nix build user 1:/var/empty:/sbin/nologin
nixbld2:x:121:30000:Nix build user 2:/var/empty:/sbin/nologin
nixbld3:x:120:30000:Nix build user 3:/var/empty:/sbin/nologin
nixbld4:x:119:30000:Nix build user 4:/var/empty:/sbin/nologin
nixbld5:x:118:30000:Nix build user 5:/var/empty:/sbin/nologin
nixbld6:x:117:30000:Nix build user 6:/var/empty:/sbin/nologin
nixbld7:x:116:30000:Nix build user 7:/var/empty:/sbin/nologin
nixbld8:x:115:30000:Nix build user 8:/var/empty:/sbin/nologin
nixbld9:x:114:30000:Nix build user 9:/var/empty:/sbin/nologin
nixbld10:x:113:30000:Nix build user 10:/var/empty:/sbin/nologin
nixbld11:x:112:30000:Nix build user 11:/var/empty:/sbin/nologin
nixbld12:x:111:30000:Nix build user 12:/var/empty:/sbin/nologin
nixbld13:x:110:30000:Nix build user 13:/var/empty:/sbin/nologin
nixbld14:x:109:30000:Nix build user 14:/var/empty:/sbin/nologin
nixbld15:x:108:30000:Nix build user 15:/var/empty:/sbin/nologin
nixbld16:x:107:30000:Nix build user 16:/var/empty:/sbin/nologin
nixbld17:x:106:30000:Nix build user 17:/var/empty:/sbin/nologin
nixbld18:x:105:30000:Nix build user 18:/var/empty:/sbin/nologin
nixbld19:x:104:30000:Nix build user 19:/var/empty:/sbin/nologin
nixbld20:x:103:30000:Nix build user 20:/var/empty:/sbin/nologin
nixbld21:x:102:30000:Nix build user 21:/var/empty:/sbin/nologin
nixbld22:x:101:30000:Nix build user 22:/var/empty:/sbin/nologin
nixbld23:x:999:30000:Nix build user 23:/var/empty:/sbin/nologin
nixbld24:x:998:30000:Nix build user 24:/var/empty:/sbin/nologin
nixbld25:x:997:30000:Nix build user 25:/var/empty:/sbin/nologin
nixbld26:x:996:30000:Nix build user 26:/var/empty:/sbin/nologin
nixbld27:x:995:30000:Nix build user 27:/var/empty:/sbin/nologin
nixbld28:x:994:30000:Nix build user 28:/var/empty:/sbin/nologin
nixbld29:x:993:30000:Nix build user 29:/var/empty:/sbin/nologin
nixbld30:x:992:30000:Nix build user 30:/var/empty:/sbin/nologin
nixbld31:x:991:30000:Nix build user 31:/var/empty:/sbin/nologin
nixbld32:x:990:30000:Nix build user 32:/var/empty:/sbin/nologin
EOF

cat << 'EOF' >> /etc/group
nix_group:x:12345:
nixbld:x:30000:nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10,nixbld11,nixbld12,nixbld13,nixbld14,nixbld15,nixbld16,nixbld17,nixbld18,nixbld19,nixbld20,nixbld21,nixbld22,nixbld23,nixbld24,nixbld25,nixbld26,nixbld27,nixbld28,nixbld29,nixbld30,nixbld31,nixbld32
EOF

echo "nix_user:123" | chpasswd


mkdir -p /home/nix_user/nix/var/nix/profiles/per-user
mkdir -p /home/nix_user/nix/var/nix/temproots
mkdir -p /home/nix_user/nix/var/nix/gcroots
mkdir -p /home/nix_user/nix/var/nix/db
mkdir -p /home/nix_user/nix/store
mkdir -p /home/nix_user/nix/store/.links
mkdir -p /home/nix_user/bin

cd /home/nix_user/bin
curl -L https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > nix
sha256sum nix
chmod +x ./nix
sha256sum /home/nix_user/bin/nix

chown \
   -R \
   nix_user:nix_group \
   /home/nix_user \
   /tmp \
   /home/nix_user/bin/nix \
   /nix

chmod --recursive 0755 /home/nix_user
su nix_user
cd /home/nix_user

export PATH=/home/nix_user/bin:"$PATH"

nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nix_user/ \
build \
github:NixOS/nix#nix-static

nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nix_user/ \
build \
nixpkgs#blender

nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nix_user/ \
path-info \
--human-readable \
--closure-size \
nixpkgs#blender


nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nix_user/ \
build \
nixpkgs#qgis

nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nix_user/ \
path-info \
--human-readable \
--closure-size \
nixpkgs#qgis

nix \
--experimental-features \
'nix-command ca-references flakes' \
shell \
github:NixOS/nix#nix-static


nix \
--experimental-features \
'nix-command ca-references flakes' \
path-info \
--human-readable \
--closure-size \
github:NixOS/nix#nix-static


nix \
--experimental-features \
'nix-command ca-references flakes' \
shell \
nixpkgs#qgis


nix \
--experimental-features \
'nix-command ca-references flakes' \
path-info \
--human-readable \
--closure-size \
nixpkgs#qgis




nix \
--experimental-features \
'nix-command ca-references flakes' \
build \
nixpkgs#hello

###


nix build .#nix_runAsRoot \
&& podman load < result \
&& podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user=0 \
localhost/nix:0.0.1 \
bash \
<< COMMANDS
nix \
--experimental-features \
'nix-command ca-references flakes' \
store \
gc

nix \
--experimental-features \
'nix-command ca-references flakes' \
store \
optimise
COMMANDS



nix build .#nix_runAsRoot \
&& podman load < result
podman \
run \
--interactive=true \
--tty=false \
--rm=true \
--user=0 \
localhost/nix:0.0.1 \
bash \
<< COMMANDS
mkdir /tmp
nix \
--experimental-features \
'nix-command ca-references flakes' \
shell \
nixpkgs#{bashInteractive,coreutils} --command bash
COMMANDS



###

nix build .#nix_runAsRoot
podman load < result

podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='nixuser' \
localhost/nix:0.0.1 \
bash \
-c \
'id'



CONTAINER=jujo
podman \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=true \
--rm=false \
--user='nixuser' \
localhost/nix:0.0.1 \
/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nixuser \
shell \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
--command \
bash \
<< COMMAND
id
exit 0
COMMAND

podman \
start \
--attach=true \
--interactive=true \
"$CONTAINER" \
nix \
--experimental-features \
'nix-command ca-references flakes' \
--store /home/nixuser \
store \
gc

rm -f nix_container_diff.txt
podman diff "$CONTAINER" > nix_container_diff.txt

nix store gc
nix build nixpkgs#blender
nix build nixpkgs#debianutils


python -m unittest

nix \
--experimental-features \
'nix-command ca-references flakes' \
shell \
nixpkgs#python3Minimal \
--command \
python --version


nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#toybox --command toybox ls

podman \                    
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_tmp:/tmp/:rw \
localhost/nix-unpriviliged:0.0.1 \
nix \
--experimental-features \
'nix-command ca-references flakes' \
shell \
nixpkgs#toybox ls


###


CONTAINER=foo
NIX_IMAGE=nix-unpriviliged-commited:0.0.1

nix build .#nix-unpriviliged
podman load < result

podman rm --force --ignore "$CONTAINER"
podman \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=false \
--user='0' \
localhost/nix-unpriviliged:0.0.1 \
busybox \
sh \
<< COMMAND

mkdir -p $out/home/nixuser/tmp

chown \
nixuser:nixgroup \
-R \
/home/nixuser

chmod 0755 -R /home/nixuser/
chmod 0700 /home/nixuser
COMMAND

rm -f oci_diff.txt
podman diff "$CONTAINER" > oci_diff.txt

ID=$(
  podman \
  commit \
  "$CONTAINER" \
  "$NIX_IMAGE"
)

podman rm --force --ignore "$CONTAINER"


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='nixuser' \
"$NIX_IMAGE" \
busybox \
sh \
<< COMMAND
export TMPDIR=/home/nixuser/tmp
nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nixuser \
shell \
nixpkgs#python3Minimal \
--command \
python \
--version
COMMAND




podman volume rm --force volume_nix_static
podman volume create volume_nix_static

podman volume rm --force volume_etc
podman volume create volume_etc


podman \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=false \
--rm=false \
--user='0' \
--volume=volume_nix_static:/code/home/nixuser/bin \
--volume=volume_etc:/code/etc \
"$NIX_IMAGE" \
busybox \
sh \
<< COMMAND
cp /bin/nix /code/home/nixuser/bin/nix

chmod +x /code/home/nixuser/bin/nix

chown \
nixuser:nixgroup \
-R \
/code/home/nixuser/bin/nix


cp -r /etc/ssl /code/ssl
cp -r /etc/shadow /code/shadow
cp -r /etc/passwd /code/passwd
cp -r /etc/group /code/group
cp -r /etc/gshadow /code/gshadow

COMMAND

rm -f oci_diff.txt
podman diff "$CONTAINER" > oci_diff.txt

ID=$(
  podman \
  commit \
  "$CONTAINER" \
  "$NIX_IMAGE"
)

podman rm --force --ignore "$CONTAINER"


nix build .#empty
podman load < result

podman \
run \
--env=TMPDIR=/home/nixuser/tmp \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_nix_static:/home/nixuser/bin:ro \
--volume=volume_etc:/etc:ro \
localhost/empty-image-zero-size:0.0.1 \
/home/nixuser/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nixuser \
shell \
nixpkgs#python3Minimal \
--command \
python \
--version


podman \
run \
--env=TMPDIR=/home/nixuser/tmp \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_nix_static:/home/nixuser/bin:ro \
--volume=volume_etc:/etc:ro \
docker.io/tianon/toybox:0.8.4 \
/home/nixuser/bin/nix \
--experimental-features \
'nix-command ca-references flakes' \
--store \
/home/nixuser \
shell \
nixpkgs#python3Minimal \
--command \
python \
--version

###



nix build .#build-environment-to-build-toybox-staticaly

podman load < result


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
localhost/build-environment-to-build-toybox-staticaly:0.0.1

mkdir /toybox
cd /toybox

TOYBOX_VERSION=0.8.4
wget --no-check-certificate -O toybox.tgz "https://landley.net/toybox/downloads/toybox-$TOYBOX_VERSION.tar.gz"
tar -xf toybox.tgz --strip-components=1
rm toybox.tgz
make root BUILTIN=1

    cp -r $out/toybox/root/host/fs/bin $out/bin
    cp ${toybox-static} $out/bin/toybox
    chmod +x $out/bin/toybox

nix \
shell \
nixpkgs#{\
bashInteractive,\
binutils,\
coreutils,\
gcc,\
glibc,\
glibc.dev,\
gzip,\
linuxHeaders,\
gnumake,\
musl,\
musl.dev,\
gnutar,\
stdenv,\
wget\
}


###






podman \
run \
--entrypoint=/home/bin/toybox \
--env=PATH/nix \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=volume_toybox:/home:ro \
--volume=volume_nix_static:/code/nix:ro \
--volume=volume_tmp:/tmp/:rw \
docker.io/library/alpine:3.13.5 \
sh
/code/nix --experimental-features 'nix-command ca-references flakes' --store /home/nixuser store gc
/code/nix --experimental-features 'nix-command ca-references flakes' --store /home/nixuser build nixpkgs#cowsay 



CONTAINER='nix-oci-dockertools-user-with-sudo-base-container-to-commit'
DOCKER_OR_PODMAN=podman
NIX_BASE_IMAGE='localhost/nix-run-as-root:0.0.1'
NIX_STAGE_1='localhost/stage-1'
NIX_IMAGE='localhost/nix-post-processed:0.0.1'


podman \                           
run \
--entrypoint=/home/bin/toybox \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=false \
--user='0' \
--volume=volume_toybox:/home:ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
localhost/nix_wip:0.0.1  \
echo "bar" > /etc/foo

rm -f oci_diff.txt
podman diff "$CONTAINER" > oci_diff.txt

ID=$(
  "$DOCKER_OR_PODMAN" \
  commit \
  "$CONTAINER" \
  "$NIX_IMAGE"
)


podman \
run \
--env=USER=nixuser \
--interactive=true \
--tty=true \
--rm=false \
--user='0' \
--volume=volume_toybox:/home:ro \
--volume=volume_nix_static:/code:ro \
--volume=volume_tmp:/tmp/:rw \
localhost/nix_wip:0.0.1 \
/home/bin/toybox ls


test -d ~/.config/nix || mkdir --parent --mode=755 ~/.config/nix && touch ~/.config/nix/nix.conf
echo 'experimental-features = nix-command flakes ca-references' >> ~/.config/nix/nix.conf
nix flake show github:GNU-ES/hello

nix shell nixpkgs/7138a338b58713e0dea22ddab6a6785abec7376a#{gcc10,gcc6,gfortran10,gfortran6,julia,nodejs,poetry,python39,rustc,yarn}

nix shell nixpkgs#xorg.xclock --command xclock
nix shell nixpkgs#bottom --command btm

nix shell nixpkgs#xorg.xclock --command timeout 10 xclock 

cp -r /home/nixuser/code/src/play-latex/ /home/nixuser/play
cd /home/nixuser/play
nix shell nixpkgs#{texlive.combined.scheme-basic,pandoc}

pdflatex hello.tex
pandoc hello.tex -o hello.pdf


###

docker \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0}" \
--interactive=true \
--tty=false \
--rm=true \
--user='0' \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
docker.io/nixpkgs/nix-flakes
<< COMMANDS
nix build github:ES-Nix/nix-qemu-kvm/51c7b855f579d806969bef8d93b3ff96830ff294#qemu.prepare
timeout 50 result/runVM
COMMANDS




podman \
run \
--cap-add ALL \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0}" \
--interactive=true \
--tty=false \
--rm=true \
--user='nixuser' \
--workdir=/home/nixuser \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
localhost/nix-static-toybox-bash-interactive-coreutils:0.0.1 \
<< COMMANDS
nix build github:ES-Nix/nix-qemu-kvm/51c7b855f579d806969bef8d93b3ff96830ff294#qemu.prepare
COMMANDS


podman \
run \
--cap-add ALL \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0}" \
--interactive=true \
--tty=false \
--rm=true \
--user='nixuser' \
--workdir=/home/nixuser \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
--volume=/proc:/proc:ro \
localhost/nix-static-toybox-bash-interactive-coreutils:0.0.1 \
<< COMMANDS
nix build github:ES-Nix/nix-qemu-kvm/51c7b855f579d806969bef8d93b3ff96830ff294#qemu.prepare
COMMANDS



podman \
run \
--cap-add ALL \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0}" \
--interactive=true \
--privileged=true \
--tty=true \
--rm=true \
--user='nixuser' \
--workdir=/home/nixuser \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
localhost/nix-static-toybox-bash-interactive-coreutils:0.0.1


podman \
run \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0}" \
--interactive=true \
--tty=true \
--rm=true \
--user='0' \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
docker.io/nixpkgs/nix-flakes

--cap-add ALL \
--privileged=true \
nix build github:ES-Nix/nix-qemu-kvm/51c7b855f579d806969bef8d93b3ff96830ff294#qemu.prepare


podman \
run \
--cap-add ALL \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0}" \
--interactive=true \
--tty=false \
--rm=true \
--user='0' \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
docker.io/nixpkgs/nix-flakes \
<< COMMANDS
echo 'Building VM'
nix --experimental-features 'nix-command ca-references flakes' build github:ES-Nix/nix-qemu-kvm/51c7b855f579d806969bef8d93b3ff96830ff294#qemu.prepare
echo 'Build finished!'
echo 'Trying to run the VM!'
timeout 50 result/runVM
echo 'It seens to have worked!'
COMMANDS


podman \
run \
--cap-add ALL \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0}" \
--interactive=true \
--tty=false \
--rm=true \
--user='nixuser' \
--workdir=/home/nixuser \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
localhost/nix-static-toybox-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp:0.0.1 \
<< COMMANDS
echo 'Building VM'

timeout 1 sleep 1000

COMMANDS


nix shell nixpkgs#bashInteractive

nix shell nixpkgs#{\
gcc10,\
gcc6,\
gfortran10,\
gfortran6,\
nodejs,\
poetry,\
python39,\
rustc,\
yarn\
}

nix shell nixpkgs#julia
nix shell nixpkgs#geogebra


podman \
run \
--cap-add ALL \
--device=/dev/kvm \
--env="DISPLAY=:0" \
--interactive=true \
--tty=false \
--rm=true \
--user='0' \
--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
docker.io/lnl7/nix:2.3.6 \
<< COMMAND
timeout 1 sleep 200 || ( [[ $? -eq 124 ]] && echo "Timeout reached, but that's OK" )
COMMAND

### 

TODO: 
- use this http://docs.podman.io/en/latest/markdown/podman-volume-create.1.html#examples
  to reproduce the error about the no exec in tmp.
  


### Good ideas

TODO: reproduce
https://github.com/NixOS/nix/issues/4458

https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-profile-install.html

`nix develop --help`


       · Start a shell with the build environment of GNU Hello:

       # nix develop nixpkgs#hello

       · Record a build environment in a profile:

       # nix develop --profile /tmp/my-build-env nixpkgs#hello

       · Use a build environment previously recorded in a profile:

       # nix develop /tmp/my-build-env

       · Replace all occurences of the store path corresponding to glibc.dev with a writable directory:

       # nix develop --redirect nixpkgs#glibc.dev ~/my-glibc/outputs/dev

              Note that this is useful if you're running a nix develop shell for nixpkgs#glibc in ~/my-glibc and want to compile another package against it.


          /home/nixuser/bin/toybox stat /proc
          /bin/nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#xorg.xclock --command /home/nixuser/bin/toybox timeout 2 xclock




> It's good enough to build Linux from scratch. 
[Embedded Linux Conference 2013 - Toybox: Writing a New Command Line From Scratch](https://www.youtube.com/embed/SGmtP5Lg_t0?start=15&end=17&version=3) 


we need good support for Linux containers although this is mostly transparent from within so it's possible
that if we don't have time you know the upstream LXC project if they get that working on android the correct response 
maybe just okay use that and then run toybox in the containers it doesn't have to be integrated it should be a drop-in 
replacement for android 


I do know what the constraints are that will prevent it from being upstream so we need a BSD license command line
implementation that has to be simple readable security audible and minimize the attack surface but provide more than
Android toolbox does now by a couple orders of magnitude (one order and a half). The simpler and more readable it is
the easier it is to security audit. 
[Embedded Linux Conference 2013 - Toybox: Writing a New Command Line From Scratch](https://www.youtube.com/embed/SGmtP5Lg_t0?start=1372&end=1399&version=3)


> Minimizing your build dependencies minimizing your environmental dependencies is actually a good thing
and these are lessons from raw busybox, I maintained the busybox project for a couple years, I
>  put out the 1.0.1 through 1.0.2 releases you probably already knew that. 
[Embedded Linux Conference 2013 - Toybox: Writing a New Command Line From Scratch](https://www.youtube.com/embed/SGmtP5Lg_t0?start=1464&end=1482&version=3)


> If people start doing online banking through through this thing you don't want anybody installing 
key loggers and packet sniffers and stuff like that it is an enormous issue and the way to deal with security is is
make it so everybody can understand exactly what the code is doing at first glance spot single point of truth means
you only need to change it once. 
[Embedded Linux Conference 2013 - Toybox: Writing a New Command Line From Scratch](https://www.youtube.com/embed/SGmtP5Lg_t0?start=1406&end=1423&version=3)


It should be sufficient for self hosting a development environment remember a significant part of the point of the
exercise is so that the smartphone can be independent of the PC so that it can replace the PC so that we can actually
use smartphones as workstations if it can't rebuild the OS that's on the phone itself your development environment is
not real it should be standards compliant it should have no external dependencies I mentioned not even incur 
tsa's in Z Lib to avoid the code reuse that isn't actually reuse because there's no readers just use it should
probably be a multi call binary that can be statically linked and dropped on a system.
[Embedded Linux Conference 2013 - Toybox: Writing a New Command Line From Scratch](https://www.youtube.com/embed/SGmtP5Lg_t0?start=1536&end=1564&version=3)


It should be sufficient for self hosting a development environment, remember a significant part of the point of the
exercise is so that the smartphone can be independent of the PC so that it can replace the PC so that we can actually
use smartphones as workstations. If it can't rebuild the OS that's on the phone itself your development environment is
not real it should be standards compliant it should have no external dependencies I mentioned not even incur 
tsa's in Z Lib to avoid the code reuse that isn't actually reuse because there's no readers just use it should
probably be a multi call binary that can be statically linked and dropped on a system.
[Embedded Linux Conference 2013 - Toybox: Writing a New Command Line From Scratch](https://www.youtube.com/embed/SGmtP5Lg_t0?start=1536&end=1564&version=3)


It should be sufficient for self hosting a development environment, remember a significant part of the point of the
exercise is so that the smartphone can be independent of the PC so that it can replace the PC so that we can actually
use smartphones as workstations. If it can't rebuild the OS that's on the phone itself your development environment
is not real. [Embedded Linux Conference 2013 - Toybox: Writing a New Command Line From Scratch](https://www.youtube.com/embed/SGmtP5Lg_t0?start=1541&end=1564&version=3)


It should be standards compliant it should have no external dependencies I mentioned not even ncurses and zlib 
to avoid the code reuse that isn't actually reuse because there's no "re" just "use". 
[Embedded Linux Conference 2013 - Toybox: Writing a New Command Line From Scratch](https://www.youtube.com/embed/SGmtP5Lg_t0?start=1566&end=1581&version=3)


It should probably be a multi call binary that can be statically linked and be dropped on a system in
part this basically just allows you to add it more easily to a system that doesn't have it it's 
generally a nice thing to have you can multi call binary versus non multi.
[Embedded Linux Conference 2013 - Toybox: Writing a New Command Line From Scratch](https://www.youtube.com/embed/SGmtP5Lg_t0?start=1566&end=1581&version=3)




[The reboot of the Harwell Dekatron / WITCH computer, the world's oldest working computer](https://www.youtube.com/watch?v=SYpPPIsxq64)

TODO: it should be provided both versions, i mean, another one without no subtitles in portguese? 
Add a usefull transcript of this [Revolution OS - Documentário sobre Linux - Português](https://youtu.be/plMxWpXhqig?t=3211)

[The Future of Data Storage](https://www.youtube.com/watch?v=nyUcCnqXMKE)

[Why Build Colossus? (Bill Tutte) - Computerphile](https://www.youtube.com/embed/1f82-aTYNb8?start=118&end=241&version=3)


The heart of all these electronic systems has been the vacuum tube. But the Bell Telephone Laboratories have added
an entirely new and different heart to modern communication systems. The transistor. Operating on a new and different 
principle arising from basic research on solid substances and how the electrons inside them behave. How did
it all come about? Well, Doctors Shockley, Bardeen and Brattain, and their associates at the Bell Telephone Laboratories, 
were working on a problem in pure research, investigating the surface properties of germanium, a substance known 
to be a semiconductor of electricity. Their studies suggested a way to amplify an electric current within a solid 
without a vacuum or a heating element. And after months of calculations, experiments, tests, the transistor was born. 
The transistor - a new name, a new device that can do many of the jobs done by the vacuum tube, and many the tube can't do.
[The Transistor: a 1953 documentary, anticipating its coming impact on technology](https://www.youtube.com/embed/V9xUQWo4vN0?start=228&end=283&version=3)


[Packaging with Nix](https://www.youtube.com/watch?v=Ndn5xM1FgrY)
https://nixos.org/manual/nixpkgs/stable/#sec-stdenv-phases

https://github.com/landley/toybox
https://en.wikipedia.org/wiki/Toybox

https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/misc/toybox/default.nix

https://github.com/tianon/dockerfiles/blob/master/toybox/Dockerfile


https://discourse.nixos.org/t/tweag-nix-dev-update-6/11195

https://discourse.nixos.org/t/tweag-nix-dev-update-5/10560/3

[NYLUG Presents: Sneaking in Nix - Building Production Containers with Nix](https://youtu.be/pfIDYQ36X0k?t=1492)
