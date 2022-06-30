{ pkgs ? import <nixpkgs> { } }:
let
  # ca-bundle-etc-passwd-etc-group-sudo-su = import ../../../ca-bundle-etc-passwd-etc-group-sudo-su.nix { inherit pkgs; };
  # create-tmp = import ../utils/create-tmp.nix { inherit pkgs; };
  # create-tmp = import ../utils/create-tmp.nix { inherit pkgs; };

  entrypoint = import ../entrypoint-fixes { inherit pkgs; };

  troubleshoot-packages = with pkgs; [
    file
    findutils
    # gzip
    hello
    htop
    iproute
    nano
    netcat
    ripgrep
    strace
    # gnutar
    wget
    which
  ];

  customSudo = (pkgs.pkgsStatic.sudo.override { pam = null; });
  customSu = (pkgs.pkgsStatic.shadow.override { pam = null; }).su;

  userName = "nixuser";
  userGroup = "nixgroup";
in
pkgs.dockerTools.buildImage {
  name = "nix-sudo-su";
  tag = "0.0.1";

  contents = [
    # ca-bundle-etc-passwd-etc-group-sudo-su
    # create-tmp
  ]
  ++
  (with pkgs; [
    # pkgsStatic.busybox-sandbox-shell
    bashInteractive
    coreutils
    # busybox

    pkgsStatic.nix

    customSu
    customSudo
    entrypoint
  ]
    # ++ troubleshoot-packages
  );

  config = {
    # Cmd = [ "/bin" ];
    # Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];
    Entrypoint = [ "es" ];
    # Entrypoint = [ "${pkgs.busybox-sandbox-shell}/bin/sh" ];
    # Entrypoint = [ "${pkgs.coreutils}/bin/stat" ];
    Env = [
      # "FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
      # "FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts/"
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "NIX_PAGER=cat"
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      "USER=${userName}"
      "HOME=/home/${userName}"
      # "PATH=/bin:/home/${userName}/bin"
      # "NIX_PATH=/nix/var/nix/profiles/per-user/root/channels"
      "TMPDIR=/home/${userName}/tmp"
    ];
  };

  # sudo chown "$(id -u)":"$(id -g)" -R /nix
  # chmod 0655 /nix
  # nix flake metadata nixpkgs
  #
  # sudo mkdir -pv /nix/var/nix/profiles
  # sudo chown "$(id -u)":"$(id -g)" -R /nix/var/nix/profiles
  #
  #
  # sudo mkdir -pv "${HOME}"/.cache
  # sudo chown "$(id -u)":"$(id -g)" -R "${HOME}"/.cache
  #
  # sudo chmod 0755 -R /nix
  # sudo chown "$(id -u)":"$(id -g)" -R /nix
  #
  # nix flake metadata nixpkgs
  #
  # chmod 0755 -R ./nix
  # chown nixuser:nixgroup -R ./nix
  runAsRoot = ''
    #!${pkgs.stdenv}
    ${pkgs.dockerTools.shadowSetup}

    echo 'Some message from runAsRoot echo.'

    groupadd --gid 6789 nixgroup
    useradd --no-log-init --uid 1234 --gid nixgroup ${userName}


    groupadd --gid 302 kvm
    usermod --append --groups kvm ${userName}

    chown 0:0 ./sbin/sudo
    chmod 4755 ./sbin/sudo

    test -d ./etc/sudoers.d || mkdir -pv ./etc/sudoers.d
    echo 'nixuser ALL=(ALL) NOPASSWD: ALL' > ./etc/sudoers.d/nixuser

    # Is it ugly or beautiful?
    test -d ./tmp || mkdir -pv ./tmp
    chmod 1777 ./tmp

    test -d ./home/nixuser/tmp || mkdir -pv ./home/nixuser/tmp
    chmod 1777 ./home/nixuser/tmp

    test -d ./home/nixuser/.cache || mkdir -pv ./home/nixuser/.cache
    chown nixuser:nixgroup -R ./home/nixuser/.cache

    test -d ./root/.config/nix || mkdir -pv ./root/.config/nix
    echo 'experimental-features = nix-command flakes' > /root/.config/nix/nix.conf

    # mkdir -pv ./nix/store/.links
    # chown 1234:6789 ./nix
    # chown 1234:6789 ./nix/store
    # chown 1234:6789 ./nix/store/.links
  '';

  extraCommands = ''
    #!${pkgs.stdenv}

    test -d ./home/nixuser/.config/nix || mkdir -pv ./home/nixuser/.config/nix
    echo 'experimental-features = nix-command flakes' > ./home/nixuser/.config/nix/nix.conf
  '';

}
