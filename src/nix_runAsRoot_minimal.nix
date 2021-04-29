{ pkgs ? import <nixpkgs> { } }:
let
  nix_static = import ./nix.nix { inherit pkgs; };
in
pkgs.dockerTools.buildImage {
  name = "nix-run-as-root-minimal";
  tag = "0.0.1";

  contents = [
    nix_static
  ];

  runAsRoot = ''
    ${pkgs.dockerTools.shadowSetup}

    groupadd --gid 12345 nixgroup \
    && useradd \
      --create-home \
      --no-log-init \
      --uid 6789 \
      --gid nixgroup nixuser

    mkdir --mode=1777 /tmp

    mkdir -p /etc/ssl/certs/
    cp ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-bundle.crt

    chown nixuser:nixgroup -R /home/nixuser
    chmod 0755 -R /home/nixuser/
    chmod 0700 /home/nixuser

    # TODO: how?
    #rm -rv /nix
    #/bin/nix \
    #--experimental-features \
    #'nix-command ca-references flakes' \
    #store \
    #gc
  '';

  config = {
    Cmd = [ "/bin" ];
    # Entrypoint = [ entrypoint ];
    Env = [
      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      #"GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      #"NIX_PAGER=cat"
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      "USER=nixuser"
      "PATH=/bin"
      #"NIX_PATH=/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
