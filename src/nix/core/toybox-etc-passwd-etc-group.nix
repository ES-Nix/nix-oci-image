{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "toybox-etc-passwd-etc-group";
  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir $out

    mkdir --parent $out/home/guest/bin

    mkdir --parent $out/etc
    echo 'root:x:0:0:root:/root:/bin/sh' >> $out/etc/passwd
    echo 'guest:x:500:500:guest:/home/guest:/bin/sh' >> $out/etc/passwd
    echo 'nobody:x:65534:65534:nobody:/proc/self:/dev/null' >> $out/etc/passwd

    echo 'root:x:0:' >> $out/etc/group
    echo 'guest:x:500:' >> $out/etc/group
    echo 'nobody:x:65534:' >> $out/etc/group
  '';
}
