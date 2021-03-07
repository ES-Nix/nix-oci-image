{ src ? ./src/2020-09-11.nix, nixpkgs ? <nixpkgs>, system ? builtins.currentSystem }:

let
    inherit (pkgs) dockerTools stdenv buildEnv writeText;
    inherit (pkgs) bashInteractive cacert commonsCompress coreutils findutils git gnutar gzip nix neovim man man-db qemu su which;

    inherit (native.lib) concatStringsSep genList;

    pkgs = import unstable { system = "x86_64-linux"; };

    native = import nixpkgs { inherit system; };
    unstable = native.callPackage src { stdenv = native.stdenvNoCC; };

    shadow = pkgs.shadow.override { pam = null; };

    sudo = pkgs.sudo.override { pam = null; };

    path = buildEnv {
        name = "system-path";
        paths = [ bashInteractive
                  cacert
                  commonsCompress
                  coreutils
                  findutils
                  git
                  gnutar
                  gzip
                  pkgs.lzma.bin
                  neovim
                  nix
                  man
                  man-db
                  shadow
                  su
                  sudo
                  which
                ];
    };

    nixconf = ''
        build-users-group = nixbld
        sandbox = false
	system-features = kvm nixos-test
	experimental-features = nix-command flakes ca-references
    '';

    passwd = ''
        root:x:0:0::/root:${run_time_bash}
	${user_name}:x:${user_id}:${user_id}::/home/${user_name}/${run_time_bash}
        ${concatStringsSep "\n" (genList (i: "nixbld${toString (i+1)}:x:${toString (i+30001)}:30000::/var/empty:/run/current-system/sw/bin/nologin") 32)}
    '';
#        ${user_name}:x:${user_id}:${user_group_id}::/home/${user_name}:${run_time_bash}

    group = ''
        root:x:0:
        wheel:x:1:${user_name},kvm
        kvm:x:2:kvm
	${user_group}:x:${user_group_id}:${user_name}
        nixbld:x:30000:${concatStringsSep "," (genList (i: "nixbld${toString (i+1)}") 32)}
    '';
#${user_group}:x:${user_group_id}:${user_name}
    sudoconf = ''
        Set disable_coredump false
    '';

    etcsudoers = ''
            ${toString "root ALL=(ALL) ALL"}
            ${toString " %wheel ALL=(ALL) ALL"}
            ${toString " %wheel ALL=(ALL) NOPASSWD: ALL"}
       '';

    # Sorry free software
    nixconfig = ''
             ${toString "{ allowUnfree = true; }"}
        '';

    bashrc = ''
       ${toString "alias flake=\'nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes\'"}
	   ${toString "alias nd=\'nix-collect-garbage --delete-old\'"}
	'';

	correctPermissions = ''
        #!${pkgs.stdenv.shell}
        ${pkgs.dockerTools.shadowSetup}
	    sudo --preserve-env --set-home nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'id'

        sudo --preserve-env --set-home chown ${user_name}:${user_group} ${MY_HOME}
        sudo --preserve-env --set-home chmod 755 ${MY_HOME}
        sudo --preserve-env --set-home chown --recursive ${user_name}:${user_group} \
          /tmp \
          /nix/var/nix \
          /nix/var/nix/profiles \
          /nix/var/nix/temproots \
          ${MY_HOME}/ \
            --verbose

        sudo chmod 755 /nix/store
        sudo chmod 755 /nix/var/nix
        sudo chmod 755 /nix/var
        sudo chmod 755 /nix/var/nix/temproots
        sudo chmod 755 /tmp
        sudo chmod 755 ${MY_HOME}

        cd /nix/store \
        && sudo find /nix/store ! -path '*sudo*' -exec chown ${user_name}:${user_group} {} --verbose \; \
        && cd -

        cd ${MY_HOME} \
        && sudo find ${MY_HOME} ! -path '*sudo*' -exec chown ${user_name}:${user_group} {} --verbose \; \
        && cd -

        sudo --preserve-env --set-home mkdir --mode=755 --parent /nix/var/nix/profiles/per-user
        sudo chown ${user_name}:${user_group} /nix/var/nix/profiles/per-user
        sudo chown ${user_name}:${user_group} /nix/var/nix/gcroots/per-user
        sudo chown ${user_name}:${user_group} /nix/var/nix/gcroots
        sudo chown ${user_name}:${user_group} /nix/var/nix/db/big-lock
        sudo chown ${user_name}:${user_group} /nix/var/nix/db
        sudo chown ${user_name}:${user_group} /nix/var/nix/gc.lock
        sudo chown ${user_name}:${user_group} /nix/store
        sudo chown ${user_name}:${user_group} /nix/var/nix/db/db.sqlite
        sudo chown ${user_name}:${user_group} /tmp/env-vars

        sudo --preserve-env --set-home chown ${user_name}:${user_group} ${MY_HOME}
        sudo --preserve-env --set-home chmod 755 ${MY_HOME}

        sudo chmod 755 /nix/var/nix/db/db.sqlite

        sudo --preserve-env --set-home mkdir --mode=755 ${MY_HOME}/.cache
        sudo --preserve-env --set-home chown --recursive pedroregispoar:pedroregispoargroup ${MY_HOME}/.cache

        export PATH=${MY_HOME}/.nix-profile/bin:$PATH

        nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes --run 'id'
	'';
    #echo '${correctPermissions}' > $out/home/${user_name}/correct_permissions.sh

    contents = stdenv.mkDerivation {
        name = "user-environment";
        phases = [ "installPhase" "fixupPhase" "checkPhase"];

        exportReferencesGraph =
            map (drv: [("closure-" + baseNameOf drv) drv]) [ path unstable ];

        installPhase = ''
            mkdir --parent $out/run/current-system
            mkdir --parent $out/var

            ln --symbolic /run    $out/var/run
            ln --symbolic ${path} $out/run/current-system/sw

            mkdir --parent $out/bin
            mkdir --parent $out/usr/bin
            mkdir --parent $out/sbin

            ln --symbolic ${stdenv.shell}      $out/bin/sh
            ln --symbolic ${coreutils}/bin/env $out/usr/bin/env

            mkdir --parent $out/etc/nix
            echo '${nixconf}' > $out/etc/nix/nix.conf
            echo '${passwd}' > $out/etc/passwd
            echo '${group}' > $out/etc/group
            echo '${sudoconf}' > $out/etc/sudo.conf
            echo '${etcsudoers}' > $out/etc/sudoers

            mkdir --parent $out/home/${user_name}
	        echo '${bashrc}' >> $out/home/${user_name}/.bashrc

            mkdir --parent $out/root/.config/nixpkgs
            echo '${nixconfig}' > $out/root/.config/nixpkgs/config.nix

            mkdir --parent $out/home/${user_name}/.config/nixpkgs
            echo '${nixconfig}' > $out/home/${user_name}/.config/nixpkgs/config.nix

            printRegistration=1 ${pkgs.perl}/bin/perl ${pkgs.pathsFromGraph} closure-* > $out/.reginfo

            mkdir --mode=1777 --parent $out/tmp

            mkdir --mode=0755 --parent $out/nix/store/.links
            mkdir --mode=0755 --parent $out/nix/var/nix/temproots
            mkdir --mode=0755 --parent $out/home/${user_name}/.nix-defexpr

            mkdir --mode=0755 --parent $out/home/${user_name}/test


            cat '${./flake_requirements.sh}' > $out/home/${user_name}/flake_requirements.sh
            chmod +x $out/home/${user_name}/flake_requirements.sh
        '';
    };

    user_name = "pedroregispoar";
    user_id = "999";

    user_group = "pedroregispoargroup";
    user_group_id = "88";

    volume_and_workdir = "/code";

    # TODO: check what exactly is this.
    run_time_bash = "/run/current-system/sw/bin/bash";

    MY_HOME = "/home/${user_name}";


    entrypoint = pkgs.writeScript "entrypoin-file.sh" ''
        #!${pkgs.stdenv.shell}
        ${pkgs.dockerTools.shadowSetup}

        #echo 'Runnung the config.Entrypoint script!'
        #chmod 4755 $out/run/current-system/sw/bin/sudo
        #chmod 4755  ${pkgs.sudo}/bin/
        #chmod 4755 /nix/store/pan38n758f87hxj2ngmmsd3x4ld6s4m5-user-environment/run/current-system/sw/bin/sudo
        #chmod 4755 $(readlink $(which su)) 2> /dev/null
        chmod 4755 $(readlink $(which sudo)) 2> /dev/null

        chmod 755 --recursive /tmp 2> /dev/null
        chown --recursive pedroregispoar:wheel /tmp 2> /dev/null


        set -e

        # allow the container to be started with `--user`
        if [ "$(${pkgs.coreutils}/bin/id --user)" = "0" ]; then

            NEW_USER_NAME=${user_name}
            NEW_GROUP_NAME=${user_group}
            VOLUME_AND_WORKDIR=${volume_and_workdir}
            exec "$@"
            #exec ${pkgs.gosu}/bin/gosu "$NEW_USER_NAME":${user_group} "$BASH_SOURCE" "$@"
        fi
        exec "$@"
    '';
    
    # dockerTools.buildLayeredImage is broken because runAsRoot!!? Needs investigation
    image = dockerTools.buildImage rec {
        name = "nix-oci-dockertools-user-with-sudo-base";
        tag = "0.0.1";
        inherit contents;
        runAsRoot = ''
        '';


        extraCommands = ''
            mkdir --parent $out/nix/var/nix/gcroots
            mkdir --mode=0755 --parent $out/nix/var/nix/profiles/per-user/root
            mkdir --parent $out/root/.nix-defexpr
            mkdir --parent $out/var/empty

            ln --symbolic ${path} $out/nix/var/nix/gcroots/booted-system
            ln --symbolic $out/nix/var/nix/profiles/per-user/root/profile $out/root/.nix-profile
            ln --symbolic ${unstable} $out/root/.nix-defexpr/nixos
            ln --symbolic ${unstable} $out/root/.nix-defexpr/nixpkgs
        '';

        config.Entrypoint = [ entrypoint ];

        config.Cmd = [ "${bashInteractive}/bin/bash" ];

        config.Env = [ "PATH=/root/.nix-profile/bin:${MY_HOME}/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin"
            "MANPATH=/root/.nix-profile/share/man:/home/pedroregispoar/.nix-profile/share/man:/run/current-system/sw/share/man"
            "NIX_PAGER=cat"
            "NIX_PATH=nixpkgs=${unstable}"
            "NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
            "ENV=/etc/profile"
            "USER=${user_name}"
        ];
    };
in

{
  inherit image;
}
/*

echo 'Start' \
&& NIX_BASE_IMAGE='nix-oci-dockertools:0.0.1' \
&& NIX_CACHE_VOLUME='nix-cache-volume' \
&& NIX_CACHE_VOLUME_TMP='nix-cache-volume-tmp' \
&& docker run \
--cap-add ALL \
--cpus='0.99' \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive \
--mount source="$NIX_CACHE_VOLUME",target=/nix \
--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.cache/ \
--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.config/nix/ \
--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.nix-defexpr/ \
--mount source="$NIX_CACHE_VOLUME_TMP",target=/tmp/ \
--net=host \
--privileged=true \
--tty \
--rm \
--workdir /code \
--volume="$(pwd)":/code \
--volume="$XAUTHORITY":/root/.Xauthority \
--volume=/sys/fs/cgroup/:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix \
--volume=/var/run/docker.sock:/var/run/docker.sock \
"$NIX_BASE_IMAGE" bash -c 'chmod +x home/pedroregispoar/flake_requirements.sh && ./home/pedroregispoar/flake_requirements.sh' \
&& echo 'End'



echo 'Start' \
&& NIX_BASE_IMAGE='nix-oci-dockertools:0.0.1' \
&& NIX_CACHE_VOLUME='nix-cache-volume' \
&& NIX_CACHE_VOLUME_TMP='nix-cache-volume-tmp' \
&& docker run \
--cap-add ALL \
--cpus='0.99' \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive \
--mount source="$NIX_CACHE_VOLUME",target=/nix \
--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.cache/ \
--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.config/nix/ \
--mount source="$NIX_CACHE_VOLUME",target=/home/pedroregispoar/.nix-defexpr/ \
--mount source="$NIX_CACHE_VOLUME_TMP",target=/tmp/ \
--net=host \
--privileged=true \
--tty \
--rm \
--workdir /code \
--volume="$(pwd)":/code \
--volume="$XAUTHORITY":/root/.Xauthority \
--volume=/sys/fs/cgroup/:/sys/fs/cgroup:ro \
--volume=/tmp/.X11-unix:/tmp/.X11-unix \
--volume=/var/run/docker.sock:/var/run/docker.sock \
"$NIX_BASE_IMAGE" bash -c 'chmod +x home/pedroregispoar/flake_requirements.sh && ./home/pedroregispoar/flake_requirements.sh' \
&& echo 'End'

nix-build --attr image
docker load < result
echo 'Start' \
&& NIX_BASE_IMAGE='nix-oci-dockertools:0.0.1' \
&& NIX_CACHE_VOLUME='nix-cache-volume' \
&& NIX_CACHE_VOLUME_TMP='nix-cache-volume-tmp' \
&& docker run -it "$NIX_BASE_IMAGE" bash -c 'chmod +x home/pedroregispoar/flake_requirements.sh && ./home/pedroregispoar/flake_requirements.sh'

*/