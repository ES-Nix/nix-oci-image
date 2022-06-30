{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
      name = "es";
      buildInputs = with pkgs; [ stdenv ];
      nativeBuildInputs = with pkgs; [ makeWrapper ];
      propagatedNativeBuildInputs = with pkgs; [
        bashInteractive
        coreutils
        # busybox
        pkgsStatic.gosu
      ];

      src = builtins.path { path = ./.; inherit name; };
      phases = [ "installPhase" ];

      unpackPhase = ":";

      installPhase = ''
        mkdir -p $out/bin

        cp "${src}"/scripts/"${name}".sh $out

        install \
        -m0755 \
        $out/${name}.sh \
        -D \
        $out/bin/${name}

        patchShebangs $out/bin/${name}

        wrapProgram $out/bin/${name} \
          --prefix PATH : "${pkgs.lib.makeBinPath propagatedNativeBuildInputs }"
      '';
    }