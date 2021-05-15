{ pkgs ? import <nixpkgs> { } }:
let
  nix = pkgs.fetchurl {
    url = "https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist";
    hash = "sha256-LH1wAS+bzaIap4NqeavAWX7Yj/zzqj5feYv2rhAXhT4=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "nix-static";
  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir --parent $out/bin
    cp ${nix} $out/bin/nix
    chmod +x $out/bin/nix
  '';
}
