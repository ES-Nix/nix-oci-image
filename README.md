# nix-oci-image



git clone https://github.com/ES-Nix/nix-oci-image.git
cd nix-oci-image
git checkout nix-oci-image-dockerTools


docker run \
--interactive \
--rm \
--tty=true \
--workdir /code \
--volume="$(pwd)":/code \
nix-oci-dockertools:0.0.1 bash



About the docker commit: https://docs.docker.com/engine/reference/commandline/commit/

TODO: create another repo?
About the action https://github.com/cachix/install-nix-action/pull/62


```
cat '${./flake_requirements.sh}' > $out/home/${user_name}/flake_requirements.sh
chmod +x $out/home/${user_name}/flake_requirements.sh
#cat ${./default.nix} > $out/home/${user_name}/default.nix
#echo '${correctPermissions}' > $out/home/${user_name}/correct_permissions.sh
#cat '${./flake_requirements.sh}' > $out/home/${user_name}/flake_requirements.sh
#chmod +x $out/home/${user_name}/flake_requirements.sh
```

        #!${pkgs.stdenv.shell}
        ${pkgs.dockerTools.shadowSetup}        
          mkdir --parent $out/nix/var/nix/gcroots
          chown pedroregispoar:pedroregispoargroup

#docker run \
#--interactive \
#--rm \
#lnl7/nix:2.3.7 bash -c 'nix-env --install --attr nixpkgs.curl && curl -fsSL https://raw.githubusercontent.com/ES-Nix/get-nix/e47ab707cfd099a6669e7a2e47aeebd36e1c101d/install-lnl7-oci.sh | sh && . ~/.bashrc && flake'


#sudo --preserve-env nix-env --file "<nixpkgs>" --install --attr \
#commonsCompress \
#gnutar \
#lzma.bin \
#git


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


nix \
--experimental-features 'nix-command ca-references flakes' \
shell nixpkgs#python3Minimal \
--command \
python \
-c \
'import unittest'

nix \
--experimental-features \
'nix-command ca-references flakes' \
build \
nixpkgs#qemu




nix \
--experimental-features \
'nix-command ca-references flakes' \
develop \
github:ES-Nix/podman-rootless/74fc79fc29d1b4ef5c9e13033bf48a188d1f024a

nix \
--experimental-features 'nix-command ca-references flakes' \
develop \
github:ES-Nix/nix-flakes-shellHook-writeShellScriptBin-defaultPackage/65e9e5a64e3cc9096c78c452b51cc234aa36c24f


nix --experimental-features 'nix-command ca-references flakes' store gc

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
--experimental-features 'nix-command ca-references flakes' \
shell \
nixpkgs#python3Minimal \
--command \
python \
-c \
'import unittest'


nix \
--experimental-features \
'nix-command ca-references flakes' \
path-info \
--human-readable \
--closure-size \
nixpkgs#python3Minimal 



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


nix path-info --derivation nixpkgs#hello


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


### :rocket:

"$DOCKER_OR_PODMAN" \
run \
--interactive=true \
--name="$CONTAINER" \
--tty=true \
--rm=true \
--user=nix_user \
--volume=volume_ca_certificate:/etc/ssl/certs:ro \
"$NIX_BASE_IMAGE" \
bash


podman \
run \
--interactive=true \
--tty=true \
--rm=true \
--volume=volume_nix_static:/home/adauser/bin:ro \
--volume=volume_etc:/etc \
--user='0' \
docker.io/library/alpine:3.13.0 \
sh -c 'ls -al /etc/ && sh'



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


nix build nixpkgs#debianutils --no-link


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