{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation rec {
  name = "ca-bundle-etc-passwd-etc-group-sudo-su";
  phases = [ "installPhase" "fixupPhase" ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  propagatedBuildInputs = with pkgs; [
    hello
    su
    sudo
    # (sudo.override { pam = null; })
    ];
  installPhase = ''
    mkdir --parent $out/etc/ssl/certs
    mkdir --parent $out/home/nixuser/bin

    cp ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt $out/etc/ssl/certs/ca-bundle.crt

    echo 'nixuser:x:12345:6789::/home/nixuser:/bin/sh' > $out/etc/passwd
    echo 'nixgroup:x:6789:' > $out/etc/group

    echo 'root:x:0:0:root:/root:/bin/sh' >> $out/etc/passwd
    echo 'root:x:0:' >> $out/etc/group

    mkdir --parent $out/home/nixuser/.config/nix
    echo 'experimental-features = nix-command flakes' > $out/home/nixuser/.config/nix/nix.conf

    mkdir -p $out/root/.config/nix
    echo 'experimental-features = nix-command flakes' > $out/root/.config/nix/nix.conf

    cat << 'EOF' >> $out/etc/group
    nixbld:x:30000:nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10,nixbld11,nixbld12,nixbld13,nixbld14,nixbld15,nixbld16,nixbld17,nixbld18,nixbld19,nixbld20,nixbld21,nixbld22,nixbld23,nixbld24,nixbld25,nixbld26,nixbld27,nixbld28,nixbld29,nixbld30,nixbld31,nixbld32
    sudo:x:3:nixuser,kvm
    wheel:x:1:nixuser,kvm
    kvm:x:2:kvm
EOF

    cat << 'EOF' >> $out/etc/passwd
    nixbld1:x:122:30000:Nix build user 1:/var/empty:/sbin/nologin
    nixbld2:x:121:30000:Nix build user 2:/var/empty:/sbin/nologin
    nixbld3:x:120:30000:Nix build user 3:/var/empty:/sbin/nologin
    nixbld4:x:119:30000:Nix build user 4:/var/empty:/sbin/nologin
    nixbld5:x:118:30000:Nix build user 5:/var/empty:/sbin/nologin
    nixbld6:x:117:30000:Nix build user 6:/var/empty:/sbin/nologin
    nixbld7:x:116:30000:Nix build user 7:/var/empty:/sbin/nologin
    nixbld8:x:115:30000:Nix build user 8:/var/empty:/sbin/nologin
    nixbld9:x:114:30000:Nix build user 9:/var/empty:/sbin/nologin
    nixbld10:x:113:30000:Nix build user 10:/var/empty:/sbin/nologin
    nixbld11:x:112:30000:Nix build user 11:/var/empty:/sbin/nologin
    nixbld12:x:111:30000:Nix build user 12:/var/empty:/sbin/nologin
    nixbld13:x:110:30000:Nix build user 13:/var/empty:/sbin/nologin
    nixbld14:x:109:30000:Nix build user 14:/var/empty:/sbin/nologin
    nixbld15:x:108:30000:Nix build user 15:/var/empty:/sbin/nologin
    nixbld16:x:107:30000:Nix build user 16:/var/empty:/sbin/nologin
    nixbld17:x:106:30000:Nix build user 17:/var/empty:/sbin/nologin
    nixbld18:x:105:30000:Nix build user 18:/var/empty:/sbin/nologin
    nixbld19:x:104:30000:Nix build user 19:/var/empty:/sbin/nologin
    nixbld20:x:103:30000:Nix build user 20:/var/empty:/sbin/nologin
    nixbld21:x:102:30000:Nix build user 21:/var/empty:/sbin/nologin
    nixbld22:x:101:30000:Nix build user 22:/var/empty:/sbin/nologin
    nixbld23:x:999:30000:Nix build user 23:/var/empty:/sbin/nologin
    nixbld24:x:998:30000:Nix build user 24:/var/empty:/sbin/nologin
    nixbld25:x:997:30000:Nix build user 25:/var/empty:/sbin/nologin
    nixbld26:x:996:30000:Nix build user 26:/var/empty:/sbin/nologin
    nixbld27:x:995:30000:Nix build user 27:/var/empty:/sbin/nologin
    nixbld28:x:994:30000:Nix build user 28:/var/empty:/sbin/nologin
    nixbld29:x:993:30000:Nix build user 29:/var/empty:/sbin/nologin
    nixbld30:x:992:30000:Nix build user 30:/var/empty:/sbin/nologin
    nixbld31:x:991:30000:Nix build user 31:/var/empty:/sbin/nologin
    nixbld32:x:990:30000:Nix build user 32:/var/empty:/sbin/nologin
EOF

    ln -s $out/etc/passwd $out/etc/shadow


    echo 'Set disable_coredump false' > $out/etc/sudo.conf

    mkdir -p $out/etc/sudoers.d
    mkdir -p $out/etc/xpto


    cat << 'EOF' >> $out/etc/sudoers
    #
    # This file MUST be edited with the 'visudo' command as root.
    #
    # Please consider adding local content in /etc/sudoers.d/ instead of
    # directly modifying this file.
    #
    # See the man page for details on how to write a sudoers file.
    #
    Defaults        env_reset
    Defaults        mail_badpass
    Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

    # Host alias specification

    # User alias specification

    # Cmnd alias specification

    # User privilege specification
    root    ALL=(ALL:ALL) ALL

    # Members of the admin group may gain root privileges
    %admin ALL=(ALL) ALL

    # Allow members of group sudo to execute any command
    sudo   ALL=(ALL:ALL) ALL

    # See sudoers(5) for more information on "#include" directives:

    #includedir /etc/sudoers.d
    nixuser ALL=(ALL) NOPASSWD:ALL
EOF

  '';

#  shellHook = ''
#    export PATH=${pkgs.lib.makeBinPath propagatedNativeBuildInputs }:$PATH
#  '';
}
