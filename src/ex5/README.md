

```bash
./src/ex5/test.sh
```


```bash
podman \
run \
--log-level=error \
--privileged=true \
--device=/dev/fuse \
--device=/dev/kvm \
--env="DISPLAY=${DISPLAY:-:0.0}" \
--interactive=true \
--mount=type=volume,source=nix-volume,target=/nix-volume \
--network=host \
--tty=true \
--rm=true \
--user=nixuser \
localhost/nix-static-busybox-sandbox-shell-ca-bundle-etc-passwd-etc-group-tmp:0.0.1
```


