{ pkgs ? import <nixpkgs> { } }:
let
  nix_wip = import ./nix.nix { inherit pkgs; };
  caBundle = import ./ca-bundle.nix { inherit pkgs; };
  tmp = import ./create-tmp.nix { inherit pkgs; };
in
pkgs.dockerTools.buildImage {
  name = "nix_wip";
  tag = "0.0.1";

  contents = [
    caBundle
    nix_wip
    tmp
  ]
  ++
  (with pkgs; [
    #bashInteractive
    #coreutils
  ]);
  #++ (nonRootShadowSetup { user = "nixuser"; uid = 12345;  group = "nixgroup"; gid = 6789; });

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
