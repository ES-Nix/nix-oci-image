{ pkgs ? import <nixpkgs> { } }:
let
  nonRootShadowSetup = { user, uid, group, gid }: with pkgs; [
    (
      writeTextDir "etc/shadow" ''
        ${user}:!:::::::
      ''
    )
    (
      writeTextDir "etc/passwd" ''
        ${user}:x:${toString uid}:${toString gid}::/home/${user}:${runtimeShell}
      ''
    )
    (
      writeTextDir "etc/group" ''
        ${group}:x:${toString gid}:
      ''
    )
    (
      writeTextDir "etc/gshadow" ''
        ${group}:x::
      ''
    )
  ];

  nix = import ./nix.nix { inherit pkgs; };
  caBundle = import ./ca-bundle.nix { inherit pkgs; };
  tmp = import ./create-tmp.nix { inherit pkgs; };

in
pkgs.dockerTools.buildImage {
  name = "nix-unpriviliged";
  tag = "0.0.1";

  contents = [
    caBundle
    nix
    pkgs.busybox
    #pkgs.toybox
    tmp
    (nonRootShadowSetup { user = "nixuser"; uid = 12345; group = "nixgroup"; gid = 6789; })
  ];

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
