{ src ? ./src/2020-09-11.nix, nixpkgs ? <nixpkgs>, system ? builtins.currentSystem }:

let
    inherit (pkgs) dockerTools stdenv buildEnv writeText;
    inherit (native.lib) concatStringsSep genList;

    native = import nixpkgs { inherit system; };
    unstable = native.callPackage src { stdenv = native.stdenvNoCC; };
    pkgs = import unstable { system = "x86_64-linux"; };

    path = buildEnv {
        name = "system-path";
        paths = with pkgs; [
                  bashInteractive
                  coreutils
                  nix
                  commonsCompress
                  gnutar
                  lzma.bin
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
	${user_name}:x:${user_id}:${user_id}::/home/${user_name}:${run_time_bash}
        ${concatStringsSep "\n" (genList (i: "nixbld${toString (i+1)}:x:${toString (i+30001)}:30000::/var/empty:/run/current-system/sw/bin/nologin") 32)}
    '';

    group = ''
        root:x:0:
        wheel:x:1:kvm
        kvm:x:2:kvm
	${user_group}:x:${user_group_id}:${user_name}
        nixbld:x:30000:${concatStringsSep "," (genList (i: "nixbld${toString (i+1)}") 32)}
    '';

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

    contents = stdenv.mkDerivation {
        name = "user-environment";
        phases = [ "installPhase" "fixupPhase" "checkPhase"];

        installPhase = ''
            mkdir --parent $out/run/current-system
            mkdir --parent $out/var

            ln --symbolic /run    $out/var/run
            ln --symbolic ${path} $out/run/current-system/sw

            mkdir --parent $out/bin
            mkdir --parent $out/usr/bin
            mkdir --parent $out/sbin

            ln --symbolic ${pkgs.stdenv.shell}      $out/bin/sh
            ln --symbolic ${pkgs.coreutils}/bin/env $out/usr/bin/env

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

            mkdir --mode=1777 --parent $out/tmp
            mkdir --mode=0755 --parent $out/nix/store/.links
            mkdir --mode=0755 --parent $out/nix/var/nix/temproots
            mkdir --mode=0755 --parent $out/home/${user_name}/.nix-defexpr

            cat '${./flake_requirements.sh}' > $out/home/${user_name}/flake_requirements.sh
            chmod +x $out/home/${user_name}/flake_requirements.sh

            mkdir \
            --mode=755 \
            --parent \
            --verbose \
            $out/home/${user_name}/.cache \
            $out/home/${user_name}/.cache/nix \
            $out/nix/var/nix/db \
            $out/nix/var/nix/gcroots \
            $out/nix/var/nix/gcroots/per-user \
            $out/nix/var/nix/profiles/per-user

            touch \
            $out/nix/var/nix/db/db.sqlite \
            $out/nix/var/nix/db/big-lock \
            $out/nix/var/nix/gc.lock \
            $out/tmp/env-vars
        '';
    };

    user_name = "pedroregispoar";
    user_id = "999";

    user_group = "pedroregispoargroup";
    user_group_id = "88";

    # TODO: check what exactly is this.
    run_time_bash = "/run/current-system/sw/bin/bash";

    MY_HOME = "/home/${user_name}";

    # dockerTools.buildLayeredImage is broken. Needs investigation
    image = dockerTools.buildImage rec {
        name = "nix-oci-dockertools-user-with-sudo-base";
        tag = "0.0.1";
        inherit contents;

        config.Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];

        config.Env = [
            "PATH=/root/.nix-profile/bin:${MY_HOME}/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin"
            "MANPATH=/root/.nix-profile/share/man:${MY_HOME}/.nix-profile/share/man:/run/current-system/sw/share/man"
            "NIX_PAGER=cat"
            "NIX_PATH=nixpkgs=${unstable}"
            "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
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