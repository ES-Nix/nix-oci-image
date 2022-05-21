#!/bin/sh


echo 'Build started"'

nix \
    --option sandbox false \
    build \
    --expr \
    '
    (
      (
        (
          builtins.getFlake "github:NixOS/nixpkgs/b283b64580d1872333a99af2b4cef91bb84580cf"
        ).lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ "${toString (builtins.getFlake "github:NixOS/nixpkgs/b283b64580d1872333a99af2b4cef91bb84580cf")}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" ];
        }
      ).config.system.build.isoImage
    )
    '

echo 'Build ended!'
