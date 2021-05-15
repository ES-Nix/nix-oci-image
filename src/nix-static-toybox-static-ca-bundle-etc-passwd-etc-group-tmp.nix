{ pkgs ? import <nixpkgs> { } }:
let
  ca-bundle-etc-passwd-etc-group = import ./ca-bundle-etc-passwd-etc-group.nix { inherit pkgs; };
  nix = import ./nix.nix { inherit pkgs; };
  tmp = import ./create-tmp.nix { inherit pkgs; };
  toybox-static = import ./toybox-static.nix { inherit pkgs; };

in
pkgs.dockerTools.buildImage {
  name = "nix-static-toybox-static-ca-bundle-etc-passwd-etc-group-tmp";
  tag = "0.0.1";

  contents = [
    ca-bundle-etc-passwd-etc-group
    nix
    tmp
    toybox-static
  ]
  ++
  (with pkgs; [
    #bashInteractive
    #coreutils
  ]);

  config = {
    Cmd = [ "sh" ];
    Entrypoint = [ "/home/nixuser/bin/toybox" ];
    Env = [
      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      #"GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      #"NIX_PAGER=cat"
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      "USER=nixuser"
      "PATH=/home/nixuser/bin:/bin"
      #"NIX_PATH=/nix/var/nix/profiles/per-user/root/channels"
      "TMPDIR=/home/nixuser/tmp"
    ];
  };
}
