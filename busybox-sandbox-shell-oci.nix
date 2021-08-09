{ pkgs ? import <nixpkgs> { } }:
pkgs.dockerTools.buildLayeredImage {
  name = "busybox-sandbox-shell";
  tag = "0.0.1";

  contents = with pkgs; [
              busybox-sandbox-shell
              cacert
              nixFlakes
             ];

  config = {
      Entrypoint = [ "${pkgs.busybox-sandbox-shell}/bin/sh" ];
      Env = with pkgs; [
          "SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bunle.crt"
          "PATH=/root/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${pkgs.busybox-sandbox-shell}/bin:${nixFlakes}/bin:/bin:/sbin:/usr/bin:/usr/sbin"
          "MANPATH=/root/.nix-profile/share/man:/home/nixuser/.nix-profile/share/man:/run/current-system/sw/share/man"
          "NIX_PAGER=cat"
          "NIX_PATH=nixpkgs=${nixFlakes}"
          "NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
          "ENV=/etc/profile"
          "GIT_SSL_CAINFO=${cacert}/etc/ssl/certs/ca-bunle.crt"
          "USER=root"
          "HOME=/root"
          ];
  };
}
