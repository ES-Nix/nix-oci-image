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
  name = "oci-podman-geogebra";
  tag = "latest";
  config = {
    contents = with pkgs; [
      # pkgsStatic.busybox-sandbox-shell

      bashInteractive
      coreutils

      geogebra
      # https://unix.stackexchange.com/questions/545750/fontconfig-issues
      # fontconfig
    ];
    Env = [
      "FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
      "FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts/"
      # "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "PATH=${pkgs.coreutils}/bin:${pkgs.hello}/bin:${pkgs.findutils}/bin"
      # :${pkgs.coreutils}/bin:${pkgs.fontconfig}/bin
      "PATH=/bin:${pkgs.pkgsStatic.busybox-sandbox-shell}/bin:${pkgs.geogebra}/bin"

      # https://access.redhat.com/solutions/409033
      "LC_ALL=C"
    ];

    # Entrypoint = [ "bash" ];
    # Entrypoint = [ "sh" ];

    Cmd = [ "geogebra" ];
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

        mkdir -pv ./home/nixuser/.local/share/fonts
    '';

#    extraCommands = ''
#      ${pkgs.coreutils}/bin/mkdir -pv ./etc/pki/tls/certs
#      ${pkgs.coreutils}/bin/ln -sv ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ./etc/pki/tls/certs
#    '';
}
