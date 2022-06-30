{ pkgs ? import <nixpkgs> { } }:
let
  troubleshootPackages = with pkgs; [
    curl
    file
    findutils
    # gnutar
    # gzip
    hello
    htop
    iproute
    nano
    netcat
    ripgrep
    strace
    # wget
    which
  ];
in
pkgs.dockerTools.buildImage {
  # https://github.com/NixOS/nixpkgs/issues/176081
  name = "oci-podman-xorg-pkgsstatic-xclock";
  tag = "latest";
  config = {
    contents = with pkgs; [
      pkgsStatic.busybox-sandbox-shell

      # bashInteractive
      # coreutils

      xorg.xclock
      # https://unix.stackexchange.com/questions/545750/fontconfig-issues
      # fontconfig
    ];
    Env = [
      "FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
      "FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts/"
      # "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "PATH=${pkgs.coreutils}/bin:${pkgs.hello}/bin:${pkgs.findutils}/bin"
      # :${pkgs.coreutils}/bin:${pkgs.fontconfig}/bin
      "PATH=/bin:${pkgs.pkgsStatic.busybox-sandbox-shell}/bin:${pkgs.xorg.xclock}/bin"

      # https://access.redhat.com/solutions/409033
      # https://github.com/nix-community/home-manager/issues/703#issuecomment-489470035
      # https://bbs.archlinux.org/viewtopic.php?pid=1805678#p1805678
      "LC_ALL=C"
    ];

    # Entrypoint = [ "bash" ];
    # Entrypoint = [ "sh" ];

    Cmd = [ "xclock" ];
  };

    #runAsRoot = ''
    #  echo 'Some message from runAsRoot echo.'
    #  echo "$(pwd)"
    #
    #  mkdir ./abcde
    #  id > ./abcde/my-id-output.txt
    #'';
    runAsRoot = ''
        #!${pkgs.stdenv}
        ${pkgs.dockerTools.shadowSetup}
        groupadd --gid 56789 nixgroup
        useradd --no-log-init --uid 12345 --gid nixgroup nixuser

        mkdir -pv ./home/nixuser
        chmod 0700 ./home/nixuser
        chown 12345:56789 -R ./home/nixuser

        # https://www.reddit.com/r/ManjaroLinux/comments/sdkrb1/comment/hue3gnp/?utm_source=reddit&utm_medium=web2x&context=3
        mkdir -pv ./home/nixuser/.local/share/fonts
    '';

#    extraCommands = ''
#      ${pkgs.coreutils}/bin/mkdir -pv ./etc/pki/tls/certs
#      ${pkgs.coreutils}/bin/ln -sv ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ./etc/pki/tls/certs
#    '';
}
