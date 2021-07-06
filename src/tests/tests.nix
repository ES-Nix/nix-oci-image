{ pkgs ? import <nixpkgs> { }}:
let
  toybox_id = ''
    toybox id
  '';

  nix_shell_bash_interactive_coreutils = ''
    nix shell nixpkgs#bashInteractive nixpkgs#coreutils --command id
  '';

  nix_shell_xclock_toybox_timeout = ''
    nix shell nixpkgs#xorg.xclock --command toybox timeout 2 xclock
  '';

  nix_shell_xclock_timeout = ''
    nix shell nixpkgs#xorg.xclock --command timeout 2 xclock
  '';

  ftt = { arg }: ''
    toybox ${arg}
  '';

  t = ''
    toybox mkdir /nix
    toybox chmod 0755 -R /home/nixuser/ /nix
    toybox chmod 0700 /home/nixuser
    toybox chmod 1777 /tmp
    toybox chown nixuser:nixgroup -R /home/nixuser /nix
  '';

  t2 = ''
    chmod 0755 -R /home/nixuser/ /nix
    chmod 0700 /home/nixuser
    chmod 1777 /tmp
    chown nixuser:nixgroup -R /home/nixuser /nix
  '';

  kvm_build_and_run = ''
    echo 'Running test'
    nix build github:ES-Nix/nix-qemu-kvm/dev#qemu.prepare
    echo 'Build finished, now trying to run the VM'
    timeout 90 result/runVM || ( [[ $? -eq 124 ]] && echo 'Timeout reached, but that is OK' ) && exit 0
  '';

  kvm_build_and_run_toybox = ''
    toybox echo 'Running test'
    nix build github:ES-Nix/nix-qemu-kvm/dev#qemu.prepare
    toybox echo 'Build finished, now trying to run the VM'
    toybox timeout 90 $(toybox readlink -f result/runVM)
  '';

  build_and_load = { attr }: ''
    rm -rf oci.tar.gz

    if ! nix flake show; then
      nix build github:ES-Nix/nix-oci-image/nix-static-unpriviliged#${attr} --out-link oci.tar.gz
    else
      nix build .#${attr} --out-link oci.tar.gz
    fi

    podman load < oci.tar.gz
    rm -rf oci.tar.gz
  '';

  build_and_load_remote = { attr }: ''
    rm -rf oci.tar.gz
    nix build github:ES-Nix/nix-oci-image/nix-static-unpriviliged#${attr} --out-link oci.tar.gz
    podman load < oci.tar.gz
    rm -rf oci.tar.gz
  '';

  run_as_root = { base_image, container_name, commited_image_name, attr, commands }: ''
      #!${pkgs.stdenv.shell}
      set -euo pipefail

      ${toString ( build_and_load { attr = attr;} )}

      podman rm --force --ignore ${container_name}

      podman \
      run \
      --interactive=true \
      --name=${container_name} \
      --tty=false \
      --rm=false \
      --user='0' \
      ${base_image} \
      << COMMANDS
        ${commands}
      COMMANDS

      podman \
      commit \
      ${container_name} \
      ${commited_image_name}

      podman rm --force --ignore ${container_name}
  '';

  home = { user }: if user == "0" then "/root" else "/home/${user}";

  display = ''
    "\${DISPLAY:-:0.0}"
  '';

  base = { commands, image, user ? "0" }: ''

        if set | grep '^DISPLAY=' >/dev/null;then
            echo "The DISPLAY has value" "\$DISPLAY"
        else
          DISPLAY='0.0'
        fi

        podman \
        run \
        --env=DISPLAY=\$DISPLAY \
        --env=USER=${user} \
        --env=HOME=${toString (home {user = user; })} \
        --interactive=true \
        --privileged=true \
        --tty=false \
        --rm=true \
        --user=${user} \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
        --workdir='/home/nixuser' \
        ${image} \
        << COMMANDS
          ${commands}
        COMMANDS
  '';

  oci_with_kvm = { commands, image , user ? "0"}: ''
        podman \
        run \
        --env='DISPLAY=:0.0' \
        --interactive=true \
        --privileged=true \
        --tty=false \
        --rm=true \
        --user=${user} \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
        ${image} \
        << COMMANDS
          ${commands}
        COMMANDS
  '';

in
pkgs.runCommand "oci-nix-toybox-test"
    { buildInputs = with pkgs; [ podman ]; }
    ''

      mkdir $out

      cat <<WRAP > $out/build_load
      ${toString
        (run_as_root
          {
            base_image="localhost/nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp:0.0.1";
            container_name="container-to-be-commited";
            commited_image_name="nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1";
            attr="oci.nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp";
            commands=t;
            }
        )
      }
      WRAP
      chmod +x $out/build_load

      cat <<WRAP > $out/build_load-nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp
      ${toString
        (run_as_root
          {
            base_image="localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp:0.0.1";
            container_name="container-to-be-commited";
            commited_image_name="nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1";
            attr="oci.nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp";
            commands=t2;
            }
        )
      }
      WRAP
      chmod +x $out/build_load-nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp

      #
      cat <<WRAP > $out/tests
      #!${pkgs.stdenv.shell}
      set -euo pipefail
      xhost +
      ${toString ( base {commands = let
            cmds = ''
            ${toybox_id}
            nix shell nixpkgs#xorg.xclock --command toybox timeout 2 xclock
            ${nix_shell_bash_interactive_coreutils}
            ''; in cmds;
            image = "localhost/nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1";
            })}
      xhost -
      WRAP
      chmod +x $out/tests

      cat <<WRAP > $out/test_kvm_nix-flakes
      #!${pkgs.stdenv.shell}
      set -euo pipefail
        xhost +
          ${toString ( oci_with_kvm {commands = let
                cmds = ''
                ${kvm_build_and_run}
                ''; in cmds;
                image = "docker.io/nixpkgs/nix-flakes";
                })}
      xhost -
      WRAP
      chmod +x $out/test_kvm_nix-flakes

      #
      cat <<WRAP > $out/test_kvm-nix-static-toybox-static
      #!${pkgs.stdenv.shell}
      set -euo pipefail
        xhost +
          ${toString
            (
              base
                {
                  commands = let
                    cmds = ''
                      ${kvm_build_and_run_toybox}
                    '';
                    in
                    cmds;
                  image = "localhost/nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1";
                })}
      xhost -
      WRAP
      chmod +x $out/test_kvm-nix-static-toybox-static

      #
      cat <<WRAP > $out/test_kvm-nix-static-coreutils-bash-unpriviliged
      #!${pkgs.stdenv.shell}
      set -euo pipefail
        xhost +
          ${toString
            (
              base
                {
                  commands = let
                    cmds = ''
                      ${kvm_build_and_run}
                    '';
                    in
                    cmds;
                  image = "localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1";
                  user = "nixuser";
                })}
      xhost -
      WRAP
      chmod +x $out/test_kvm-nix-static-coreutils-bash-unpriviliged

      #
      cat <<WRAP > $out/test_xclock-nix-static-coreutils-bash-unpriviliged
      #!${pkgs.stdenv.shell}
      set -euo pipefail
        xhost +
          ${toString
            (
              base
                {
                  commands = let
                    cmds = ''
                      ${nix_shell_xclock_timeout}
                    '';
                    in
                    cmds;
                  image = "localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1";
                  user = "nixuser";
                })}
      xhost -
      WRAP
      chmod +x $out/test_xclock-nix-static-coreutils-bash-unpriviliged

      #
      cat <<WRAP > $out/runOCI
      #!${pkgs.stdenv.shell}
      set -euo pipefail

      if ! set | grep '^DISPLAY=' >/dev/null;then
      #  echo "The DISPLAY has value" \$DISPLAY
      # else
        DISPLAY='0.0'
      fi

      IMAGE='nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1'
      if ! podman image exists "\$IMAGE"; then
        echo 'FFFFFF'
        $out/build_load-nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp
      fi

      podman \
      run \
      --env=DISPLAY=\$DISPLAY \
      --env='USER=nixuser' \
      --env='HOME=/home/nixuser' \
      --interactive=true \
      --privileged=true \
      --tty=true \
      --rm=true \
      --user='nixuser' \
      --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
      --workdir='/home/nixuser' \
      localhost/nix-static-coreutils-bash-interactive-ca-bundle-etc-passwd-etc-group-tmp-unpriviliged:0.0.1

      WRAP
      chmod +x $out/runOCI

    ''
