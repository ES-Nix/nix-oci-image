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
  name = "oci-podman-chromium";
  tag = "latest";
  config = {
    contents = with pkgs; [
      busybox-sandbox-shell
      # bashInteractive
      # coreutils

      # TODO: Why it is not working, I mean, not adding it to $PATH?
      # chromium
    ];
    Env = [
      "FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
      "FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts/"
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "PATH=${pkgs.coreutils}/bin:${pkgs.hello}/bin:${pkgs.findutils}/bin:${pkgs.chromium}/bin"
      "PATH=${pkgs.chromium}/bin"
    ];

    Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];

    Cmd = [ "chromium" "--no-sandbox" ];
  };

    #runAsRoot = ''
    #  echo 'Some message from runAsRoot echo.'
    #  echo "$(pwd)"
    #
    #  mkdir ./abcde
    #  id > ./abcde/my-id-output.txt
    #'';

    extraCommands = ''
       ${pkgs.coreutils}/bin/mkdir -pv ./etc/pki/tls/certs
       ${pkgs.coreutils}/bin/ln -sv ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ./etc/pki/tls/certs
       # ${pkgs.hello}/bin/hello > ./out-hello.txt
    '';
}

