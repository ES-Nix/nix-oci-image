FROM alpine:3.14.0 AS cache


RUN \
 echo \
 && echo 'nixbld1:x:122:30000:Nix build user 1:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld2:x:121:30000:Nix build user 2:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld3:x:120:30000:Nix build user 3:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld4:x:119:30000:Nix build user 4:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld5:x:118:30000:Nix build user 5:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld6:x:117:30000:Nix build user 6:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld7:x:116:30000:Nix build user 7:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld8:x:115:30000:Nix build user 8:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld9:x:114:30000:Nix build user 9:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld10:x:113:30000:Nix build user 10:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld11:x:112:30000:Nix build user 11:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld12:x:111:30000:Nix build user 12:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld13:x:110:30000:Nix build user 13:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld14:x:109:30000:Nix build user 14:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld15:x:108:30000:Nix build user 15:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld16:x:107:30000:Nix build user 16:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld17:x:106:30000:Nix build user 17:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld18:x:105:30000:Nix build user 18:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld19:x:104:30000:Nix build user 19:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld20:x:103:30000:Nix build user 20:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld21:x:102:30000:Nix build user 21:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld22:x:101:30000:Nix build user 22:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld23:x:999:30000:Nix build user 23:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld24:x:998:30000:Nix build user 24:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld25:x:997:30000:Nix build user 25:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld26:x:996:30000:Nix build user 26:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld27:x:995:30000:Nix build user 27:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld28:x:994:30000:Nix build user 28:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld29:x:993:30000:Nix build user 29:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld30:x:992:30000:Nix build user 30:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld31:x:991:30000:Nix build user 31:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld32:x:990:30000:Nix build user 32:/var/empty:/sbin/nologin' >> /etc_passwd_with_only_nixblders \
 && echo 'nixbld:x:30000:nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10,nixbld11,nixbld12,nixbld13,nixbld14,nixbld15,nixbld16,nixbld17,nixbld18,nixbld19,nixbld20,nixbld21,nixbld22,nixbld23,nixbld24,nixbld25,nixbld26,nixbld27,nixbld28,nixbld29,nixbld30,nixbld31,nixbld32' >> /etc_group_with_only_nixblders

RUN \
 echo \
 && echo 'root:x:0:0:root:/root:/bin/sh' >> /etc_passwd \
 && echo 'nixuser:x:12345:6789:Nixuser:/home/nixuser:/bin/sh' >> /etc_passwd \
 && cat /etc_passwd_with_only_nixblders >> /etc_passwd \
 && echo 'nobody:x:65534:65534:nobody:/proc/self:/dev/null' >> /etc_passwd \
 && echo \
 && echo 'root:x:0:' >> /etc_group \
 && echo 'nixgroup:x:6789:nixuser' >> /etc_group \
 && cat /etc_group_with_only_nixblders >> /etc_group \
 && echo 'nobody:x:65534:' >> /etc_group

RUN \
 echo \
 && mkdir --parent --mode=0755 /root/.config/nix \
 && touch /root/.config/nix/nix.conf \
 && echo 'system-features = kvm nixos-test' >> /root/.config/nix/nix.conf \
 && echo 'experimental-features = nix-command flakes ca-references ca-derivations' >> ~/.config/nix/nix.conf \
 && echo 'show-trace = true' >> /root/.config/nix/nix.conf \
 && mkdir --parent --mode=0755 /root/.config/nixpkgs && touch /root/.config/nixpkgs/config.nix \
 && echo '{ allowUnfree = true; }' >> /root/.config/nixpkgs/config.nix



FROM localhost/busybox-sandbox-shell-nix-flakes:0.0.1 AS busybox-sandbox-shell-nix-flake-patch

COPY --from=cache /etc_passwd /etc/passwd
COPY --from=cache /etc_group /etc/group

COPY --from=cache /root/.config/nix/nix.conf /root/.config/nix/nix.conf
COPY --from=cache /root/.config/nix /root/.config/nix

# COPY --from=cache --chown=nixuser:nixgroup /root/.config/nix/nix.conf /home/nixuser/.config/nix/nix.conf
# COPY --from=cache --chown=nixuser:nixgroup /root/.config/nix /home/nixuser/.config/nix

COPY --from=cache /root/.config/nix/nix.conf /home/nixuser/.config/nix/nix.conf
COPY --from=cache /root/.config/nix /home/nixuser/.config/nix

COPY --from=cache /tmp /tmp

# COPY --from=cache --chown=nixuser:nixgroup /tmp /home/nixuse/tmp
COPY --from=cache /tmp /home/nixuser/tmp

RUN nix shell nixpkgs#bash nixpkgs#coreutils --command chown nixuser:nixgroup -R /nix /home/nixuser



# FROM localhost/empty:0.0.1 AS nix-flake
#
# COPY --from=0 /output/store /nix/store
# COPY --from=0 /root/.nix-profile /usr/local/
# COPY --from=0 /root/.bashrc /root/.bashrc
#
# COPY --from=cache /etc_passwd_with_only_nixblders /etc/passwd
# COPY --from=cache /etc_group_with_only_nixblders /etc/group
#
# COPY --from=base /root/.config/nix /root/.config/nix



FROM busybox-sandbox-shell-nix-flake-patch AS test

RUN nix flake --version

RUN nix --experimental-features 'nix-command ca-references ca-derivations flakes' profile install nixpkgs#bashInteractive nixpkgs#coreutils
# RUN nix shell nixpkgs#nix-info --command nix-info --markdown
# RUN nix show-config
RUN nix profile install nixpkgs#jq
RUN nix show-config --json | jq .

RUN nix flake metadata nixpkgs
RUN nix profile install nixpkgs#jq
RUN nix flake metadata nixpkgs --json | jq .
RUN nix shell nixpkgs#neofetch --command neofetch

RUN nix flake show nixpkgs
RUN nix flake show github:nixos/nixpkgs
RUN nix flake show github:nixos/nixpkgs/nixpkgs-unstable

RUN nix flake metadata nixpkgs
RUN nix flake metadata github:nixos/nixpkgs
RUN nix flake metadata github:nixos/nixpkgs/nixpkgs-unstable



# FROM docker.nix-community.org/nixpkgs/nix-flakes AS base
#
#
# RUN mkdir -p -m 0755 ~/.config/nix \
#  && touch ~/.config/nix/nix.conf \
#  && echo 'system-features = kvm nixos-test' >> ~/.config/nix/nix.conf \
#  && echo 'experimental-features = nix-command flakes ca-references ca-derivations' >> ~/.config/nix/nix.conf \
#  && nix flake --version \
#  && nix flake metadata nixpkgs \
#  && nix-collect-garbage --delete-old \
#  && nix store gc \
#  && nix store optimise \
#  && nix store gc \
#  && echo
#
# RUN nix profile install nixpkgs#nixFlakes nixpkgs#cacert --profile "$HOME"/.nix-profile \
#  && mkdir --parent --mode=0755 /output/store \
#  && cp \
#     --no-dereference \
#     --recursive \
#     --verbose \
#     $(nix-store --query --requisites "$HOME"/.nix-profile) \
#     /output/store



# FROM alpine:3.14.0
#
#
# COPY --from=base /output/store /nix/store
# COPY --from=base /root/.nix-profile /usr/local/
# COPY --from=base /root/.bashrc /root/.bashrc
#
#
#
# FROM tianon/toybox
#
#
# COPY --from=0 /output/store /nix/store
# COPY --from=0 /root/.nix-profile /usr/local/
# COPY --from=0 /root/.bashrc /root/.bashrc
