{ pkgs ? import <nixpkgs> { } }:
let
  ca-bundle-etc-passwd-etc-group = import ./ca-bundle-etc-passwd-etc-group.nix { inherit pkgs; };
  nix = import ./nix.nix { inherit pkgs; };
  tmp = import ./create-tmp.nix { inherit pkgs; };
in
pkgs.dockerTools.buildImage {
  name = "nix-static-ca-bundle-etc-passwd-etc-group-tmp";
  tag = "0.0.1";

#    runAsRoot = ''
#      #!${pkgs.stdenv}
#      ${pkgs.dockerTools.shadowSetup}
#      chown -R nixuser:nixgroup /nix
#    '';

#  extraCommands = ''
#      #!${pkgs.stdenv}
#      ${pkgs.dockerTools.shadowSetup}
#      chown -R nixuser:nixgroup /nix
#    '';

  contents = [
    ca-bundle-etc-passwd-etc-group
    tmp
    nix
  ]
  ++
  (with pkgs; [
#    busybox-sandbox-shell
#    coreutils
  ]);

  config = {
    #Cmd = [ "/bin" ];
    Entrypoint = [ "${pkgs.busybox-sandbox-shell}/bin/sh" ];
    Env = [
      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      #"GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      #"NIX_PAGER=cat"
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      "USER=nixuser"
      "HOME=/home/nixuser"
      "PATH=/nix/var/nix/profiles/per-user/nixuser/profile/bin:/bin:/home/nixuser/bin"
      #"NIX_PATH=/nix/var/nix/profiles/per-user/root/channels"
      "TMPDIR=/home/nixuser/tmp"
    ];
  };
}
