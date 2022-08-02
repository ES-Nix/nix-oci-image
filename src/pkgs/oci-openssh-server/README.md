



```bash
podman \
build \
--tag=oci-ubuntu-16-04-with-sshd-and-nixuser \
.
```



```bash
podman \
run \
--detach=true \
--name=oci-ubuntu-16-04-with-sshd-and-nixuser-container \
--privileged=true \
--publish=22000:22 \
--rm=true \
oci-ubuntu-16-04-with-sshd-and-nixuser
```

```bash
podman \
inspect test_sshd_container \
--format \
'{{ .NetworkSettings.IPAddress }} {{ .NetworkSettings.Ports }}'
```

```bash
ssh-keygen -R '[localhost]:22000' \
&& ssh \
    root@localhost \
    -p 22000 \
    -o StrictHostKeyChecking=no \
    -o StrictHostKeyChecking=accept-new
```

```bash
podman \
rm \
--force \
--ignore \
oci-ubuntu-16-04-with-sshd-and-nixuser-container
```


```bash
sudo /bin/sshd -D -e -ddd
```
