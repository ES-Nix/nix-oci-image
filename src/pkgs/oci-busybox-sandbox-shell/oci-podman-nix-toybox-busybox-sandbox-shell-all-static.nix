{ pkgs ? import <nixpkgs> { }, podman-rootless }:
pkgs.stdenv.mkDerivation rec {
  name = "oci-podman-nix-toybox-busybox-sandbox-shell-all-static";
  buildInputs = with pkgs; [ stdenv ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedNativeBuildInputs = with pkgs; [
    bash
    coreutils

    podman-rootless
  ];

  src = builtins.path { path = ./.; inherit name; };
  phases = [ "installPhase" ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin

    cp -r "${src}"/* $out

    install \
    -m0755 \
    $out/scripts/${name}.sh \
    -D \
    $out/bin/${name}

    patchShebangs $out/bin/${name}

    substituteInPlace \
      $out/bin/${name} \
      --replace Containerfile $out/Containerfile

    wrapProgram $out/bin/${name} \
      --prefix PATH : "${pkgs.lib.makeBinPath propagatedNativeBuildInputs }"
  '';

}
