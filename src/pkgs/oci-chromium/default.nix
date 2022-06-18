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
      chromium
      hello
      (import ../utils/create-symbolic-link-to-ca-bundle.nix { inherit pkgs; })
    ];
    Env = [
      "FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
      "FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts/"
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "PATH=${pkgs.coreutils}/bin:${pkgs.hello}/bin:${pkgs.chromium}/bin"
    ];

    Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];
  };
}

