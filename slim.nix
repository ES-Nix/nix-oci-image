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

  caBundle = pkgs.stdenv.mkDerivation {
      name = "ca-bundle";
      phases = [ "installPhase" "fixupPhase" ];

      installPhase = ''
        mkdir --parent $out/etc/ssl/certs
        cp ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/certs/ca-bundle.crt
        mkdir $out/etc/foo-bar.txt
      '';
    };
in
pkgs.dockerTools.buildImage {
    name = "empty-image-zero-size";
    tag = "0.0.1";

    contents = [
      caBundle
      (nonRootShadowSetup { user = "nixuser"; uid = 12345;  group = "nixgroup"; gid = 6789; })
    ];
}
