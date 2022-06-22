{ pkgs ? import <nixpkgs> { } }:
let
  troubleshoot-packages = with pkgs; [
    hello
    file
    findutils
    ripgrep
    nano
    which
    strace
  ];
in
pkgs.dockerTools.buildImage {
  name = "oci-nix-toybox-busybox-sandbox-shell-all-static";
  tag = "0.0.1";

  contents = (with pkgs.pkgsStatic; [
    busybox-sandbox-shell
    nix
    toybox
  ])
  # ++ troubleshoot-packages
  ++
  (with pkgs; [
    # bashInteractive
    # coreutils
    # uutils-coreutils
  ]
  );

  config = {
    #Cmd = [ "/bin" ];
    # Entrypoint = [ "${pkgs.pkgsStatic.busybox-sandbox-shell}/bin/sh" ];
    Entrypoint = [ "${pkgs.bashInteractive}/bin/bash" ];

    Env = [
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      # "NIX_PAGER=cat"
      # A user is required by nix
      # https://github.com/NixOS/nix/blob/9348f9291e5d9e4ba3c4347ea1b235640f54fd79/src/libutil/util.cc#L478
      #"USER=nixuser"
      "USER=root"
      # "HOME=/home/nixuser"
      # "PATH=/bin:/home/nixuser/bin"
      "PATH=/root/.nix-profile/bin:/home/nixuser/.nix-profile/bin:/etc/profiles/per-user/nixuser/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      # "NIX_PATH=/nix/var/nix/profiles/per-user/root/channels"
      # "TMPDIR=/home/nixuser/tmp"
    ];
  };

  extraCommands = ''
    #!${pkgs.runtimeShell}
    PATH+="''${PATH}":${pkgs.busybox}/bin

    test -d ~/.config/nix || mkdir -p -m 0755 ~/.config/nix \
    && grep 'nixos' ~/.config/nix/nix.conf 1> /dev/null 2> /dev/null || echo 'system-features = benchmark big-parallel kvm nixos-test' >> ~/.config/nix/nix.conf \
    && grep 'flakes' ~/.config/nix/nix.conf 1> /dev/null 2> /dev/null || echo 'experimental-features = nix-command flakes ca-references' >> ~/.config/nix/nix.conf \
    && grep 'trace' ~/.config/nix/nix.conf 1> /dev/null 2> /dev/null || echo 'show-trace = true' >> ~/.config/nix/nix.conf \
    && test -d ~/.config/nixpkgs || mkdir -p -m 0755 ~/.config/nixpkgs \
    && grep 'allowUnfree' ~/.config/nixpkgs/config.nix 1> /dev/null 2> /dev/null || echo '{ allowUnfree = true; android_sdk.accept_license = true; }' >> ~/.config/nixpkgs/config.nix
  '';

  runAsRoot = ''
    #!${pkgs.runtimeShell}
    mkdir -pv -m1777 ./tmp
  '';
}
