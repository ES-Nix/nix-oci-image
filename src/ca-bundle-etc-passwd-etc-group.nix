{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
      name = "ca-bundle-etc-passwd-etc-group";
      phases = [ "installPhase" "fixupPhase" ];

      installPhase = ''
        mkdir --parent $out/etc/ssl/certs
        mkdir --parent $out/home/nixuser/bin

        cp ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/certs/ca-bundle.crt

        echo 'nixuser:x:12345:6789::/home/nixuser:/home/nixuser/bin/toybox' > $out/etc/passwd
        echo 'nixgroup:x:6789:' > $out/etc/group
      '';
    }
