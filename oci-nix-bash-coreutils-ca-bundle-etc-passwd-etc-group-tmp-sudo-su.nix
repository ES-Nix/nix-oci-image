{ pkgs ? import <nixpkgs> { } }:
let
  ca-bundle-etc-passwd-etc-group-sudo-su = import ./ca-bundle-etc-passwd-etc-group-sudo-su.nix { inherit pkgs; };
  tmp = import ./create-tmp.nix { inherit pkgs; };
in
pkgs.dockerTools.buildImage {
  name = "nix-bash-coreutils-ca-bundle-etc-passwd-etc-group-tmp-sudo-su";
  tag = "0.0.1";

  contents = [
    ca-bundle-etc-passwd-etc-group-sudo-su
    tmp
  ]
  ++
  (with pkgs; [
    # busybox-sandbox-shell
    bashInteractive
    coreutils
    nix
    su
    # sudo
    (sudo.override { pam = null; })
    (shadow.override { pam = null; })
  ]
  ++
  [
     hello
     file
     findutils
     ripgrep
  ]

  );

  config = {
    #Cmd = [ "/bin" ];
    Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];
    Env = [
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      #"GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      #"NIX_PAGER=cat"
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      "USER=nixuser"
      "HOME=/home/nixuser"
      # "PATH=/bin:/home/nixuser/bin"
      #"NIX_PATH=/nix/var/nix/profiles/per-user/root/channels"
      "TMPDIR=/home/nixuser/tmp"
    ];
  };
}
