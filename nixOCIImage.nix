{ pkgs ? import <nixpkgs> { } }:
let
  nixOCIImage = import ./nix.nix { inherit pkgs; };

  nonRootShadowSetup = { user, uid, gid ? uid }: with pkgs; [
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
        ${user}:x:${toString gid}:
      ''
    )
    (
      writeTextDir "etc/gshadow" ''
        ${user}:x::
      ''
    )
  ];

in
pkgs.dockerTools.buildLayeredImage {
  name = "nix";
  tag = "0.0.1";

  contents = [ nixOCIImage ] ++ (nonRootShadowSetup { uid = 999; user = "somebody"; });

  #  config = {
  #Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];

  #    Entrypoint = [ entrypoint ];
  #    Env = [
  #        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bunle.crt"
  #    ];
  #  };
}
