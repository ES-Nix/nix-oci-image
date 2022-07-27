{ pkgs ? import <nixpkgs> { } }:
let
  troubleshootPackages = with pkgs; [
    curl
    file
    findutils
    # gnutar
    # gzip
    hello
    bpytop
    iproute
    ldd
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
  name = "oci-podman-chromium";
  tag = "latest";
  config = {
    contents = with pkgs; [
      # busybox-sandbox-shell
      bashInteractive
      coreutils

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
#    runAsRoot = ''
#        #!${pkgs.stdenv}
#        ${pkgs.dockerTools.shadowSetup}
#        groupadd --gid 56789 nixgroup
#        useradd --no-log-init --uid 12345 --gid nixgroup nixuser
#    '';

    # https://discourse.nixos.org/t/certificate-validation-broken-in-all-electron-chromium-apps-and-browsers/15962/7
    extraCommands = ''
      ${pkgs.coreutils}/bin/mkdir -pv ./etc/pki/tls/certs
      ${pkgs.coreutils}/bin/ln -sv ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ./etc/pki/tls/certs
    '';
}
