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