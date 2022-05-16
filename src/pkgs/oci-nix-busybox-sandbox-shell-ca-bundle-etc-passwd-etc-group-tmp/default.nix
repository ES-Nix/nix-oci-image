{ pkgs ? import <nixpkgs> { } }:
let

  ca-bundle-etc-passwd-etc-group-sudo-su = import ../../../ca-bundle-etc-passwd-etc-group-sudo-su.nix { inherit pkgs; };
  create-tmp = import ../utils/create-tmp.nix { inherit pkgs; };

  troubleshoot-packages = with pkgs; [
       hello
       file
       findutils
       ripgrep
       nano
       which
       strace
    ];
in
pkgs.dockerTools.buildImage {
  name = "nix-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp";
  tag = "0.0.1";

  contents = [
    create-tmp
  ]
  ++
  (with pkgs; [
    bashInteractive
    # pkgsStatic.busybox-sandbox-shell
    pkgsStatic.nix
    coreutils
  ]
  # ++ troubleshoot-packages
  );

  config = {
    #Cmd = [ "/bin" ];
    Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];
    Env = [
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "NIX_PAGER=cat"
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      "USER=nixuser"
      "HOME=/home/nixuser"
      # "PATH=/bin:/home/nixuser/bin"
      # "NIX_PATH=/nix/var/nix/profiles/per-user/root/channels"
      "TMPDIR=/home/nixuser/tmp"
    ];
  };
}
