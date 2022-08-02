{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "fmt-nix-fix-and-check";
  buildInputs = with pkgs; [ stdenv ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedNativeBuildInputs = with pkgs; [
    bashInteractive
    coreutils

    (import ./fmt-nix-check.nix { inherit pkgs; })
    (import ./fmt-nix-fix.nix { inherit pkgs; })
  ];

  src = builtins.path { path = ./.; inherit name; };
  phases = [ "installPhase" ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin

    cp -r "${src}/scripts/fmt-nix-check.sh" $out
    cp -r "${src}/scripts/fmt-nix-fix.sh" $out
    cp -r "${src}/scripts/${name}.sh" $out

    install \
    -m0755 \
    $out/${name}.sh \
    -D \
    $out/bin/${name}

    patchShebangs $out/bin/${name}

    substituteInPlace \
      $out/bin/${name} \
      --replace ./fmt-nix-fix.sh $out/fmt-nix-fix.sh \
      --replace ./fmt-nix-check.sh $out/fmt-nix-check.sh \

    wrapProgram $out/bin/${name} \
      --prefix PATH : "${pkgs.lib.makeBinPath propagatedNativeBuildInputs }"
  '';

}
