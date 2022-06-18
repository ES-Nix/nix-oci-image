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
      bashInteractive
      coreutils
      #chromium
      hello
    ];
    Env = [
      "FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
      "FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts/"
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # :${pkgs.chromium}/bin
      "PATH=${pkgs.coreutils}/bin:${pkgs.hello}/bin"
    ];

    extraCommands = ''
      # echo 'Some message from extraCommands echo.'
      echo "$(pwd)"
      mkdir -pv ./etc/pki/tls/certs
      ln -sv ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ./etc/pki/tls/certs/ca-bundle.crt
    '';

    Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];
  };
}

