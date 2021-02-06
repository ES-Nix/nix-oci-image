# nix-oci-image



git clone https://github.com/ES-Nix/nix-oci-image.git
cd nix-oci-image
git checkout nix-oci-image-dockerTools


docker run \
--interactive \
--rm \
--tty=true \
--workdir /code \
--volume="$(pwd)":/code \
nix-oci-dockertools:0.0.1 bash